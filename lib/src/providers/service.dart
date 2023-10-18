import 'package:dantex/src/data/bookdownload/book_downloader.dart';
import 'package:dantex/src/data/bookdownload/default_book_downloader.dart';
import 'package:dantex/src/data/bookdownload/entity/book_suggestion.dart';
import 'package:dantex/src/data/isbn/barcode_isbn_scanner_service.dart';
import 'package:dantex/src/data/isbn/isbn_scanner_service.dart';
import 'package:dantex/src/data/logging/firebase_log_output.dart';
import 'package:dantex/src/providers/api.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

part 'service.g.dart';

@riverpod
BookDownloader bookDownloader(BookDownloaderRef ref) => DefaultBookDownloader(
      ref.read(booksApiProvider),
    );

@riverpod
IsbnScannerService isbnScannerService(IsbnScannerServiceRef ref) =>
    BarcodeIsbnScannerService();

@riverpod
Future<BookSuggestion> downloadBook(DownloadBookRef ref, String query) {
  return ref.read(bookDownloaderProvider).downloadBook(query);
}

@riverpod
SharedPreferences sharedPreferences(SharedPreferencesRef ref) =>
    throw UnimplementedError();


@riverpod
Logger logger(LoggerRef ref) =>
    Logger(
      filter: DevelopmentFilter(),
      printer: PrettyPrinter(
          printTime: true,
      ),
      //
      output: kDebugMode ? ConsoleOutput() : FirebaseLogOutput(),
    );