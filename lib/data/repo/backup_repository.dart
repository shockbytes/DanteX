import 'dart:convert';
import 'dart:developer';

import 'package:dantex/data/book/book.dart';
import 'package:dantex/data/book/book_label.dart';
import 'package:dantex/data/book/book_state.dart';
import 'package:dantex/data/google/backup_data.dart';
import 'package:googleapis/drive/v3.dart';

class BackupRepository {
  const BackupRepository({required DriveApi driveApi}) : _driveApi = driveApi;

  final DriveApi _driveApi;

  Future<List<BackupData>> listGoogleDriveBackups() async {
    final response = await _driveApi.files.list(
      spaces: 'appDataFolder',
      q: "mimeType = 'application/json'",
    );

    final files = response.files;
    if (files == null) {
      return [];
    }

    return files.map((file) {
      final fileName = file.name;
      final data =
          fileName?.split(RegExp('_')).where((it) => it.isNotEmpty).toList();

      final device = (data != null && data.length > 4 && fileName != null)
          ? fileName.substring(
              fileName.indexOf(data[4]),
              fileName.lastIndexOf('.'),
            )
          : null;

      final oldTimeStamp = int.tryParse(data?[2] ?? '0') ?? 0;
      var timeStamp = DateTime.now();
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
    }).toList();
  }

  Future<List<Book>> fetchBackup(String id) async {
    final response = await _driveApi.files.get(
      id,
      downloadOptions: DownloadOptions.fullMedia,
    );

    if (response is! Media) {
      log('Got invalid backup type: ${response.runtimeType}');
      return [];
    }

    final backupJson = await utf8.decodeStream(response.stream);
    final backupData = jsonDecode(backupJson) as Map<String, dynamic>;
    final booksList = backupData['books'] as List<dynamic>;
    final legacyBooks = booksList.cast<Map<String, dynamic>>();

    return legacyBooks.map(_convertLegacyBook).toList();
  }
}

Book _convertLegacyBook(Map<String, dynamic> legacyBook) {
  final labelsList = legacyBook['labels'] as List<dynamic>;
  final labelsData = labelsList.cast<Map<String, dynamic>>();
  final labels = labelsData.map(_convertLegacyBookLabel).toList();

  return Book(
    // This ID comes from Firebase, so for now can just use -1 as placeholder.
    id: '-1',
    title: legacyBook['title'] as String,
    subTitle: legacyBook['subTitle'] as String,
    author: legacyBook['author'] as String,
    state: _convertLegacyBookState(legacyBook['state'] as String),
    pageCount: legacyBook['pageCount'] as int,
    currentPage: legacyBook['currentPage'] as int,
    publishedDate: legacyBook['publishedDate'] as String,
    position: legacyBook['position'] as int,
    isbn: legacyBook['isbn'] as String,
    thumbnailAddress: legacyBook['thumbnailAddress'] as String?,
    startDate:
        DateTime.fromMicrosecondsSinceEpoch(legacyBook['startDate'] as int),
    endDate: DateTime.fromMicrosecondsSinceEpoch(legacyBook['endDate'] as int),
    forLaterDate: DateTime.fromMicrosecondsSinceEpoch(
      legacyBook['wishlistDate'] as int,
    ),
    language: legacyBook['language'] as String,
    rating: legacyBook['rating'] as int,
    notes: legacyBook['notes'] as String?,
    summary: legacyBook['summary'] as String?,
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
    hexColor: legacyLabel['hexColor'] as String,
    title: legacyLabel['title'] as String,
  );
}
