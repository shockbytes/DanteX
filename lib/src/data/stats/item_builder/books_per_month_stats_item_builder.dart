import 'package:collection/collection.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/stats/item_builder/stats_item_builder.dart';
import 'package:dantex/src/data/stats/stats_item.dart';
import 'package:dantex/src/util/extensions.dart';

class BooksPerMonthStatsItemBuilder
    extends StatsItemBuilder<BooksPerMonthStatsItem> {
  @override
  BooksPerMonthStatsItem buildStatsItem(List<Book> books) {
    final List<Book> readBooks = books.filterReadBooks();

    final BooksPerMonthDataState dataState = readBooks.isEmpty
        ? EmptyBooksPerMonthData()
        : _buildBooksPerMonthData(readBooks);

    return BooksPerMonthStatsItem(dataState);
  }

  BooksPerMonthData _buildBooksPerMonthData(final List<Book> books) {
    final Map<DateTime, int> booksPerMonthDistribution = Map.fromEntries(
      books
          .groupListsBy(
            (book) {
              final DateTime endTime = book.endDate!;
              return DateTime(endTime.year, endTime.month);
            },
          )
          .entries
          .sorted((a, b) => a.key.difference(b.key).inDays)
          .map(
            (e) => MapEntry(e.key, e.value.length),
          ),
    );

    return BooksPerMonthData(
      booksPerMonthDistribution: booksPerMonthDistribution,
    );
  }
}
