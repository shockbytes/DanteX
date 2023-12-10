import 'package:dantex/src/data/book/entity/book.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stats_item.freezed.dart';

class ItemDesktopSize {
  final int width;
  final int height;

  ItemDesktopSize({
    required this.width,
    required this.height,
  });
}

sealed class StatsItem {
  String get titleKey;

  /// The cross- and main axis size this item should occupy on desktop devices.
  ItemDesktopSize get desktopSize;
}

class BooksAndPagesStatsItem extends StatsItem {
  final BooksAndPagesDataState dataState;

  BooksAndPagesStatsItem(this.dataState);

  @override
  String get titleKey => 'stats.books-and-pages.title';

  @override
  ItemDesktopSize get desktopSize => ItemDesktopSize(width: 2, height: 1);
}

sealed class BooksAndPagesDataState {}

class EmptyBooksAndPagesData extends BooksAndPagesDataState {}

class BooksAndPagesData extends BooksAndPagesDataState {
  final int booksWaiting;
  final int booksReading;
  final int booksRead;
  final int pagesRead;
  final int pagesWaiting;

  BooksAndPagesData({
    required this.booksWaiting,
    required this.booksReading,
    required this.booksRead,
    required this.pagesRead,
    required this.pagesWaiting,
  });
}

class ReadingTimeStatsItem extends StatsItem {
  final ReadingTimeDataState dataState;

  ReadingTimeStatsItem(this.dataState);

  @override
  String get titleKey => 'stats.reading-time.title';

  @override
  ItemDesktopSize get desktopSize => ItemDesktopSize(width: 1, height: 1);
}

sealed class ReadingTimeDataState {}

class EmptyReadingTimeData extends ReadingTimeDataState {}

class ReadingTimeData extends ReadingTimeDataState {
  final Book fastestBook;
  final Book slowestBook;

  ReadingTimeData({
    required this.slowestBook,
    required this.fastestBook,
  });
}

class LanguageStatsItem extends StatsItem {
  final LanguageDataState dataState;

  LanguageStatsItem(this.dataState);

  @override
  ItemDesktopSize get desktopSize => ItemDesktopSize(width: 1, height: 1);

  @override
  String get titleKey => 'stats.language.title';
}

sealed class LanguageDataState {}

class EmptyLanguageData extends LanguageDataState {}

class LanguageData extends LanguageDataState {
  final Map<String, int> languageDistribution;

  LanguageData({
    required this.languageDistribution,
  });
}

class LabelStatsItem extends StatsItem {
  final LabelDataState dataState;

  LabelStatsItem(this.dataState);

  @override
  ItemDesktopSize get desktopSize => ItemDesktopSize(width: 1, height: 1);

  @override
  String get titleKey => 'stats.label.title';
}

sealed class LabelDataState {}

class EmptyLabelData extends LabelDataState {}

class LabelData extends LabelDataState {
  final Map<String, int> labelDistribution;

  LabelData({
    required this.labelDistribution,
  });
}

class FavoritesStatsItem extends StatsItem {
  final FavoritesDataState dataState;

  FavoritesStatsItem(this.dataState);

  @override
  ItemDesktopSize get desktopSize => ItemDesktopSize(width: 2, height: 1);

  @override
  String get titleKey => 'stats.favorites.title';
}

sealed class FavoritesDataState {}

class EmptyFavoritesData extends FavoritesDataState {}

@Freezed()
class FavoritesData extends FavoritesDataState with _$FavoritesData {

  const factory FavoritesData({
    required List<Book> favoriteAuthor,
    required Book? firstFiveStarBook,
  }) = _FavoritesData;
}

class MiscStatsItem extends StatsItem {
  final MiscDataState dataState;

  MiscStatsItem(this.dataState);

  @override
  ItemDesktopSize get desktopSize => ItemDesktopSize(width: 1, height: 1);

  @override
  String get titleKey => 'stats.misc.title';
}

sealed class MiscDataState {}

class EmptyMiscData extends MiscDataState {}

@Freezed()
class MiscData extends MiscDataState with _$MiscData {
  const factory MiscData({
    required double averageBooksPerMonth,
    required MostActiveMonth? mostActiveMonth,
  }) = _MiscData;
}

@Freezed()
class MostActiveMonth with _$MostActiveMonth {

  MostActiveMonth._();

  factory MostActiveMonth({
    required DateTime month,
    required List<Book> books,
  }) = _MostActiveMonth;

  String get formattedMonth => DateFormat('MMM yyyy').format(month);

  int get bookCount => books.length;
}

class PagesPerMonthStatsItem extends StatsItem {
  @override
  ItemDesktopSize get desktopSize => ItemDesktopSize(width: 3, height: 1);

  @override
  String get titleKey => 'stats.pages-per-month.title';
}

class BooksPerYearStatsItem extends StatsItem {
  final BooksPerYearDataState dataState;

  BooksPerYearStatsItem(this.dataState);

  @override
  ItemDesktopSize get desktopSize => ItemDesktopSize(width: 2, height: 1);

  @override
  String get titleKey => 'stats.books-per-year.title';
}

sealed class BooksPerYearDataState {}

class EmptyBooksPerYearData extends BooksPerYearDataState {}

class BooksPerYearData extends BooksPerYearDataState {
  // Map contains Map<Year, Amount of books>
  final Map<int, int> booksPerYearDistribution;

  BooksPerYearData({
    required this.booksPerYearDistribution,
  });
}
