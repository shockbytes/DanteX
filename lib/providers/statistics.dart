import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_state.dart';
import 'package:dantex/models/dante_language.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/util/book_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'statistics.g.dart';

const zeroBookCount = (readLaterCount: 0, readingCount: 0, readCount: 0);

@riverpod
({int readLaterCount, int readingCount, int readCount}) bookCounts(Ref ref) {
  final books = ref.watch(allBooksProvider);

  return books.when(
    data: (books) {
      final readLaterCount =
          books.where((book) => book.state == BookState.readLater).length;
      final readingCount =
          books.where((book) => book.state == BookState.reading).length;
      final readCount =
          books.where((book) => book.state == BookState.read).length;

      return (
        readLaterCount: readLaterCount,
        readingCount: readingCount,
        readCount: readCount
      );
    },
    error: (e, s) => zeroBookCount,
    loading: () => zeroBookCount,
  );
}

const zeroPageCount = (pagesWaiting: 0, pagesRead: 0);

@riverpod
({int pagesWaiting, int pagesRead}) pageCounts(Ref ref) {
  final books = ref.watch(allBooksProvider);

  return books.when(
    data: (books) {
      final pagesWaiting = books
          .where((book) => book.state == BookState.readLater)
          .map((book) => book.pageCount)
          .fold<int>(0, (prev, pages) => prev + pages);
      final pagesRead = books
          .where((book) => book.state == BookState.read)
          .map((book) => book.pageCount)
          .fold<int>(0, (prev, pages) => prev + pages);
      return (pagesWaiting: pagesWaiting, pagesRead: pagesRead);
    },
    error: (e, s) => zeroPageCount,
    loading: () => zeroPageCount,
  );
}

typedef BooksPerMonthStats = Map<DateTime, int>;

@riverpod
BooksPerMonthStats booksPerMonthStats(Ref ref) {
  final books = ref.watch(booksForStateProvider(BookState.read));

  return books.when(
    data: (books) {
      final stats = BooksPerMonthStats();
      for (final book in books) {
        final endDate = book.endDate;
        if (endDate == null) {
          continue;
        }

        final month = DateTime(endDate.year, endDate.month);
        stats.update(month, (count) => count + 1, ifAbsent: () => 1);
      }

      return SplayTreeMap.from(stats);
    },
    error: (e, s) => {},
    loading: () => {},
  );
}

typedef PagesPerMonthStats = Map<DateTime, int>;

@riverpod
PagesPerMonthStats pagesPerMonthStats(Ref ref) {
  final books = ref.watch(booksForStateProvider(BookState.read));

  return books.when(
    data: (books) {
      final stats = PagesPerMonthStats();
      for (final book in books) {
        final endDate = book.endDate;
        if (endDate == null) {
          continue;
        }

        final month = DateTime(endDate.year, endDate.month);
        stats.update(
          month,
          (count) => count + book.pageCount,
          ifAbsent: () => book.pageCount,
        );
      }

      return SplayTreeMap.from(stats);
    },
    error: (e, s) => {},
    loading: () => {},
  );
}

typedef BooksPerYearStats = Map<DateTime, int>;

@riverpod
BooksPerYearStats booksPerYearStats(Ref ref) {
  final books = ref.watch(booksForStateProvider(BookState.read));

  return books.when(
    data: (books) {
      final stats = BooksPerYearStats();
      for (final book in books) {
        final endDate = book.endDate;
        if (endDate == null) {
          continue;
        }

        final month = DateTime(endDate.year);
        stats.update(month, (count) => count + 1, ifAbsent: () => 1);
      }

      return SplayTreeMap.from(stats);
    },
    error: (e, s) => {},
    loading: () => {},
  );
}

@riverpod
({Book? fastestBook, Book? slowestBook}) readingTimeStats(Ref ref) {
  final books = ref.watch(allBooksProvider);

  return books.when(
    data: (books) {
      books = books
          .where(
            (book) =>
                book.state == BookState.read &&
                book.startDate != null &&
                book.endDate != null,
          )
          .sorted(
            (a, b) => (a.endDate!)
                .difference(a.startDate ?? DateTime.now())
                .compareTo(
                  (b.endDate ?? DateTime.now())
                      .difference(b.startDate ?? DateTime.now()),
                ),
          );

      if (books.isEmpty) {
        return (fastestBook: null, slowestBook: null);
      }
      final fastestBook = books.first;
      if (books.length == 1) {
        return (fastestBook: fastestBook, slowestBook: null);
      }
      final slowestBook = books.last;
      return (fastestBook: fastestBook, slowestBook: slowestBook);
    },
    error: (e, s) => (fastestBook: null, slowestBook: null),
    loading: () => (fastestBook: null, slowestBook: null),
  );
}

@riverpod
List<Book> favoriteAuthorBooks(Ref ref) {
  final books = ref.watch(allBooksProvider);

  return books.when(
    data: (books) {
      return books
              .groupListsBy((e) => e.author)
              .entries
              .sorted((a, b) => b.value.length - a.value.length)
              .firstOrNull
              ?.value ??
          [];
    },
    error: (e, s) => [],
    loading: () => [],
  );
}

@riverpod
Book? firstFiveStarBook(Ref ref) {
  final books = ref.watch(allBooksProvider);

  return books.when(
    data: (books) {
      return books
          .where((book) => book.rating == 5 && book.startDate != null)
          .sortedByStartDate()
          .firstOrNull;
    },
    error: (e, s) => null,
    loading: () => null,
  );
}

@riverpod
Map<DanteLanguage, int> languageStats(Ref ref) {
  final books = ref.watch(allBooksProvider);

  return books.when(
    data: (books) {
      return books.groupListsBy((e) => e.language).map(
            (key, value) => MapEntry(key, value.length),
          );
    },
    error: (e, s) => {},
    loading: () => {},
  );
}

@riverpod
({DateTime month, int count})? mostActiveMonthStat(Ref ref) {
  final books = ref.watch(allBooksProvider);

  return books.when(
    data: (books) {
      final stats = <DateTime, int>{};
      for (final book in books) {
        final endDate = book.endDate;
        if (endDate == null) {
          continue;
        }

        final month = DateTime(endDate.year, endDate.month);
        stats.update(month, (count) => count + 1, ifAbsent: () => 1);
      }

      final mostActiveMonth =
          stats.entries.sorted((a, b) => b.value - a.value).firstOrNull;
      if (mostActiveMonth == null) {
        return null;
      }

      return (month: mostActiveMonth.key, count: mostActiveMonth.value);
    },
    error: (e, s) => null,
    loading: () => null,
  );
}

@riverpod
double? averageRatingStat(Ref ref) {
  final books = ref.watch(allBooksProvider);

  return books.when(
    data: (books) {
      final ratings =
          books.map((book) => book.rating).where((rating) => rating != 0);
      if (ratings.isEmpty) {
        return null;
      }
      return ratings.average;
    },
    error: (e, s) => null,
    loading: () => null,
  );
}

@riverpod
double averageBooksPerMonth(Ref ref) {
  final booksPerMonth = ref.watch(booksPerMonthStatsProvider);

  if (booksPerMonth.isEmpty) {
    return 0;
  }

  return booksPerMonth.values.average;
}
