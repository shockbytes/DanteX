import 'package:collection/collection.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/data/stats/item_builder/stats_item_builder.dart';
import 'package:dantex/src/data/stats/stats_item.dart';

class ReadingTimeStatsItemBuilder
    implements StatsItemBuilder<ReadingTimeStatsItem> {
  @override
  ReadingTimeStatsItem buildStatsItem(List<Book> books) {
    final ReadingTimeDataState dataState;
    if (books.isEmpty) {
      dataState = EmptyReadingTimeData();
    } else {
      dataState = _buildReadingTimeDataState(books);
    }

    return ReadingTimeStatsItem(dataState);
  }

  ReadingTimeDataState _buildReadingTimeDataState(List<Book> books) {
    final List<Book> finishedSortedBooks = books
        .where(
          (element) =>
              element.state == BookState.read &&
              element.startDate != null &&
              element.endDate != null,
        )
        .sorted(
          (a, b) =>
              a.endDate!.difference(a.startDate!).inDays -
              b.endDate!.difference(b.startDate!).inDays,
        );

    if (finishedSortedBooks.isEmpty) {
      return EmptyReadingTimeData();
    }

    return ReadingTimeData(
      fastestBook: finishedSortedBooks.first,
      slowestBook: finishedSortedBooks.last,
    );
  }
}
