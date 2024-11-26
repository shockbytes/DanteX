import 'dart:convert';

import 'package:dantex/models/backup_data.dart';
import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_label.dart';
import 'package:dantex/models/book_state.dart';
import 'package:device_marketing_names/device_marketing_names.dart';
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
      String? deviceName;
      var isLegacyBackup = true;
      var timeStamp = DateTime.now();
      var bookCount = 0;

      if (fileName != null) {
        final data = fileName
            .split(RegExp('_'))
            .where(
              (it) => it.isNotEmpty,
            )
            .toList();

        // We have a legacy backup.
        if (data.length == 5) {
          deviceName = fileName.substring(
            fileName.indexOf(data[4]),
            fileName.lastIndexOf('.'),
          );
          isLegacyBackup = true;
        } else {
          // We have a new backup.
          deviceName = fileName.substring(
            fileName.indexOf(data[4]),
            fileName.lastIndexOf('_'),
          );
          isLegacyBackup = false;
        }

        final oldTimeStamp = int.tryParse(data[2]) ?? 0;
        if (oldTimeStamp > 0) {
          timeStamp = DateTime.fromMillisecondsSinceEpoch(oldTimeStamp);
        }

        bookCount = int.tryParse(data[3]) ?? 0;
      }

      return BackupData(
        id: file.id ?? 'missing-id',
        device: deviceName ?? 'missing-device',
        fileName: fileName ?? 'missing-file-name',
        bookCount: bookCount,
        timeStamp: timeStamp,
        isLegacyBackup: isLegacyBackup,
      );
    }).toList();
  }

  Future<List<Book>> fetchBackup(
    String id, {
    bool isLegacyBackup = true,
  }) async {
    final response = await _driveApi.files.get(
      id,
      downloadOptions: DownloadOptions.fullMedia,
    );

    if (response is! Media) {
      return [];
    }

    final backupJson = await utf8.decodeStream(response.stream);
    final backupData = jsonDecode(backupJson) as Map<String, dynamic>;
    final booksList = backupData['books'] as List<dynamic>;
    final books = booksList.cast<Map<String, dynamic>>();

    if (isLegacyBackup) {
      return books.map(_convertLegacyBook).toList();
    } else {
      return books.map(Book.fromJson).toList();
    }
  }

  Future<void> delete(String id) async {
    await _driveApi.files.delete(id);
  }

  Future<void> createBackup(List<Book> books) async {
    final backupData = {
      'books': books.map((book) => book.toJson()).toList(),
    };

    final backupJson = jsonEncode(backupData);
    final utf8EncodedBackupJson = utf8.encode(backupJson);
    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    final deviceNames = DeviceMarketingNames();
    final deviceName = await deviceNames.getSingleName();
    final fileName =
        'google-drive_man_${timeStamp}_${books.length}_${deviceName}_dantex.json';

    await _driveApi.files.create(
      File.fromJson({
        'name': fileName,
        'mimeType': 'application/json',
        'parents': ['appDataFolder'],
      }),
      uploadMedia: Media(
        Stream.value(utf8EncodedBackupJson),
        utf8EncodedBackupJson.length,
      ),
    );
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
    case 'WISHLIST':
      return BookState.wishlist;
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
