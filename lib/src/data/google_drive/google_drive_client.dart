import 'dart:convert';

import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_label.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/data/google_drive/backup_client.dart';
import 'package:dantex/src/data/google_drive/entity/backup_data.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

class GoogleDriveClient extends BackupClient {
  final GoogleSignIn googleSignIn;

  GoogleDriveClient({required this.googleSignIn});

  Future<DriveApi> _getDriveApi() async {
    if (kIsWeb && googleSignIn.currentUser == null) {
      await googleSignIn.signIn();
    }

    final user = await googleSignIn.signInSilently();
    if (user == null) {
      await googleSignIn.signIn();
    }

    final httpClient = (await googleSignIn.authenticatedClient())!;

    return DriveApi(httpClient);
  }

  @override
  Future<List<BackupData>> listBackups() async {
    final driveApi = await _getDriveApi();
    final response = await driveApi.files.list(
      spaces: 'appDataFolder',
      q: "mimeType = 'application/json'",
    );

    return response.files?.map((file) {
          final fileName = file.name;
          final data = fileName
              ?.split(RegExp(r'_'))
              .where((it) => it.isNotEmpty)
              .toList();

          final device = fileName?.substring(
            fileName.indexOf(data![4]),
            fileName.lastIndexOf('.'),
          );

          final oldTimeStamp = int.tryParse(data?[2] ?? '0') ?? 0;
          DateTime timeStamp = DateTime.now();
          if (oldTimeStamp > 0) {
            timeStamp = DateTime.fromMillisecondsSinceEpoch(oldTimeStamp);
          }
          final bookCount = int.parse(data?[3] ?? '0');

          return BackupData(
            id: file.id ?? 'missing-id',
            device: device ?? 'missing-device',
            fileName: fileName ?? 'missing-file-name',
            bookCount: bookCount,
            timeStamp: timeStamp,
          );
        }).toList() ??
        [];
  }

  @override
  Future<void> deleteBackup(String id) async {
    final driveApi = await _getDriveApi();

    return driveApi.files.delete(id);
  }

  @override
  Future<List<Book>> fetchBackup(String id) async {
    final driveApi = await _getDriveApi();

    final response = await driveApi.files.get(
      id,
      downloadOptions: DownloadOptions.fullMedia,
    );
    if (response is! Media) throw Exception('invalid response');
    final backupJson = await utf8.decodeStream(response.stream);
    final Map<String, dynamic> backupData = jsonDecode(backupJson);
    final List<Map<String, dynamic>> booksData =
        backupData['books'].cast<Map<String, dynamic>>();

    return booksData.map((book) => _convertLegacyBook(book)).toList();
  }
}

Book _convertLegacyBook(Map<String, dynamic> legacyBook) {
  final List<Map<String, dynamic>> labelsData =
      legacyBook['labels'].cast<Map<String, dynamic>>();

  final labels =
      labelsData.map((label) => _convertLegacyBookLabel(label)).toList();

  return Book(
    // This ID comes from Firebase, so for now can just use -1 as placeholder.
    id: '-1',
    title: legacyBook['title'],
    subTitle: legacyBook['subTitle'],
    author: legacyBook['author'],
    state: _convertLegacyBookState(legacyBook['state']),
    pageCount: legacyBook['pageCount'],
    currentPage: legacyBook['currentPage'],
    publishedDate: legacyBook['publishedDate'],
    position: legacyBook['position'],
    isbn: legacyBook['isbn'],
    thumbnailAddress: legacyBook['thumbnailAddress'],
    startDate: DateTime.fromMicrosecondsSinceEpoch(legacyBook['startDate']),
    endDate: DateTime.fromMicrosecondsSinceEpoch(legacyBook['endDate']),
    forLaterDate: DateTime.fromMicrosecondsSinceEpoch(
      legacyBook['wishlistDate'],
    ),
    language: legacyBook['language'],
    rating: legacyBook['rating'],
    notes: legacyBook['notes'],
    summary: legacyBook['summary'],
    labels: labels,
  );
}

BookState _convertLegacyBookState(String legacyState) {
  switch (legacyState) {
    case 'READ_LATER':
      return BookState.readLater;
    case 'READING':
      return BookState.reading;
    case 'READ':
      return BookState.read;
    default:
      return BookState.readLater;
  }
}

BookLabel _convertLegacyBookLabel(Map<String, dynamic> legacyLabel) {
  return BookLabel(
    // This ID comes from Firebase, so for now can just use -1 as placeholder.
    id: '-1',
    hexColor: legacyLabel['hexColor'],
    title: legacyLabel['title'],
  );
}
