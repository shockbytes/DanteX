import 'package:dantex/src/data/bookdownload/book_downloader.dart';
import 'package:dantex/src/data/bookdownload/default_book_downloader.dart';
import 'package:dantex/src/data/bookdownload/entity/book_suggestion.dart';
import 'package:dantex/src/data/isbn/barcode_isbn_scanner_service.dart';
import 'package:dantex/src/data/isbn/isbn_scanner_service.dart';
import 'package:dantex/src/data/logging/error_only_filter.dart';
import 'package:dantex/src/data/logging/firebase_log_output.dart';
import 'package:dantex/src/providers/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'service.g.dart';

@riverpod
BookDownloader bookDownloader(BookDownloaderRef ref) => DefaultBookDownloader(
      ref.watch(booksApiProvider),
    );

@riverpod
IsbnScannerService isbnScannerService(IsbnScannerServiceRef ref) =>
    BarcodeIsbnScannerService();

@riverpod
Future<String> scanIsbn(ScanIsbnRef ref, BuildContext context) {
  return ref.watch(isbnScannerServiceProvider).scanIsbn(context);
}

@riverpod
Future<BookSuggestion> downloadBook(DownloadBookRef ref, String query) {
  return ref.watch(bookDownloaderProvider).downloadBook(query);
}

@riverpod
SharedPreferences sharedPreferences(SharedPreferencesRef ref) =>
    throw UnimplementedError();

@riverpod
Logger logger(LoggerRef ref) => Logger(
      filter: kDebugMode ? DevelopmentFilter() : ErrorOnlyFilter(),
      printer: PrettyPrinter(
        printTime: true,
      ),
      // Use Firebase logging only for production
      output: kDebugMode ? ConsoleOutput() : FirebaseLogOutput(),
    );
