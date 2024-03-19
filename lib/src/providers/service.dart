import 'package:dantex/src/data/bookdownload/book_downloader.dart';
import 'package:dantex/src/data/bookdownload/default_book_downloader.dart';
import 'package:dantex/src/data/bookdownload/entity/book_suggestion.dart';
import 'package:dantex/src/data/isbn/barcode_isbn_scanner_service.dart';
import 'package:dantex/src/data/isbn/isbn_scanner_service.dart';
import 'package:dantex/src/data/logging/debug_logger.dart';
import 'package:dantex/src/data/logging/firebase_logger.dart';
import 'package:dantex/src/data/logging/logger.dart';
import 'package:dantex/src/data/recommendations/book_recommendation.dart';
import 'package:dantex/src/data/recommendations/recommendations.dart';
import 'package:dantex/src/data/search/search.dart';
import 'package:dantex/src/data/stats/default_stats_builder.dart';
import 'package:dantex/src/data/stats/item_builder/books_and_pages_stats_item_builder.dart';
import 'package:dantex/src/data/stats/item_builder/books_per_month_stats_item_builder.dart';
import 'package:dantex/src/data/stats/item_builder/books_per_year_stats_item_builder.dart';
import 'package:dantex/src/data/stats/item_builder/favorites_stats_item_builder.dart';
import 'package:dantex/src/data/stats/item_builder/label_stats_item_builder.dart';
import 'package:dantex/src/data/stats/item_builder/language_stats_item_builder.dart';
import 'package:dantex/src/data/stats/item_builder/misc_stats_item_builder.dart';
import 'package:dantex/src/data/stats/item_builder/reading_time_stats_item_builder.dart';
import 'package:dantex/src/data/stats/item_builder/stats_item_builder.dart';
import 'package:dantex/src/data/stats/stats_builder.dart';
import 'package:dantex/src/data/stats/stats_item.dart';
import 'package:dantex/src/data/timeline/timeline.dart';
import 'package:dantex/src/providers/api.dart';
import 'package:dantex/src/providers/repository.dart';
import 'package:flutter/foundation.dart';
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
Future<String> scanIsbn(ScanIsbnRef ref) {
  return ref.watch(isbnScannerServiceProvider).scanIsbn();
}

@riverpod
Future<BookSuggestion> downloadBook(DownloadBookRef ref, String query) {
  return ref.watch(bookDownloaderProvider).downloadBook(query);
}

@riverpod
Search search(SearchRef ref) {
  return Search(
    ref.read(bookRepositoryProvider),
    ref.read(bookDownloaderProvider),
  );
}

@riverpod
Timeline timeline(TimelineRef ref) {
  return Timeline(
    ref.read(settingsRepositoryProvider),
    ref.read(bookRepositoryProvider),
  );
}

@riverpod
SharedPreferences sharedPreferences(SharedPreferencesRef ref) =>
    throw UnimplementedError();

@riverpod
DanteLogger logger(LoggerRef ref) {
  // If we are in dev mode, return debug tracker.
  if (kDebugMode) {
    return DebugLogger();
  }
  return FirebaseLogger();
}

@riverpod
Recommendations recommendations(RecommendationsRef ref) {
  return Recommendations(
    ref.read(recommendationsRepositoryProvider),
    ref.read(bookRepositoryProvider),
  );
}

@riverpod
Stream<List<BookRecommendation>> bookRecommendations(
  BookRecommendationsRef ref,
) {
  return ref.watch(recommendationsProvider).recommendedBooks;
}

@riverpod
Stream<RecommendationEvent> bookRecommendationEvents(
  BookRecommendationEventsRef ref,
) {
  return ref.watch(recommendationsProvider).events;
}

@riverpod
StatsBuilder statsBuilder(StatsBuilderRef ref) {
  return DefaultStatsBuilder(
    ref.read(bookRepositoryProvider),
    _provideStatsItemBuilders(),
  );
}

List<StatsItemBuilder> _provideStatsItemBuilders() {
  return [
    BooksAndPagesStatsItemBuilder(),
    ReadingTimeStatsItemBuilder(),
    LanguageStatsItemBuilder(),
    LabelStatsItemBuilder(),
    // PagesPerMonthStatsItemBuilder(),
    BooksPerMonthStatsItemBuilder(),
    MiscStatsItemBuilder(DateTime.now()),
    FavoritesStatsItemBuilder(),
    BooksPerYearStatsItemBuilder(),
  ];
}

@riverpod
Stream<List<StatsItem>> statsBuilderItems(
  StatsBuilderItemsRef ref,
) {
  return ref.watch(statsBuilderProvider).buildStats();
}
