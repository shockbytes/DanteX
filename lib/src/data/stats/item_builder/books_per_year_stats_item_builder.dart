import 'package:collection/collection.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/stats/item_builder/stats_item_builder.dart';
import 'package:dantex/src/data/stats/stats_item.dart';
import 'package:dantex/src/util/extensions.dart';

class BooksPerYearStatsItemBuilder
    extends StatsItemBuilder<BooksPerYearStatsItem> {
  @override
  BooksPerYearStatsItem buildStatsItem(List<Book> books) {
    final List<Book> readBooks = books.filterReadBooks();

    final BooksPerYearDataState dataState = readBooks.isEmpty
        ? EmptyBooksPerYearData()
        : _buildBooksPerYearData(readBooks);

    return BooksPerYearStatsItem(dataState);
  }

  BooksPerYearData _buildBooksPerYearData(final List<Book> books) {
    final Map<int, int> booksPerYearDistribution = Map.fromEntries(
      books
          .groupListsBy((book) => book.endDate!.year)
          .entries
          .sorted((a, b) => a.key - b.key)
          .map(
            (e) => MapEntry(e.key, e.value.length),
          ),
    );

    return BooksPerYearData(booksPerYearDistribution: booksPerYearDistribution);
  }
}
