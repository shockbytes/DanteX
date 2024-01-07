import 'package:collection/collection.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/data/stats/item_builder/stats_item_builder.dart';
import 'package:dantex/src/data/stats/stats_item.dart';
import 'package:dantex/src/util/extensions.dart';

class MiscStatsItemBuilder extends StatsItemBuilder<MiscStatsItem> {
  final DateTime _currentDateTime;

  MiscStatsItemBuilder(this._currentDateTime);

  @override
  MiscStatsItem buildStatsItem(List<Book> books) {
    final MiscDataState dataState =
        books.isEmpty ? EmptyMiscData() : _buildMiscData(books);

    return MiscStatsItem(dataState);
  }

  MiscData _buildMiscData(List<Book> books) {
    return MiscData(
      averageBooksPerMonth: _averageBooksPerMonth(books),
      mostActiveMonth: _mostActiveMonth(books),
    );
  }

  double _averageBooksPerMonth(List<Book> books) {
    final List<Book> doneBooks = books
        .where(
          (book) => book.startDate != null && book.state == BookState.read,
        )
        .sortedByStartDate();

    if (doneBooks.isEmpty) {
      return 0;
    }

    final DateTime start = doneBooks.firstOrNull?.startDate ?? DateTime.now();
    final DateTime startCorrected = DateTime(start.year, start.month);

    // Unfortunately Dart does not offer a `inMonths` method, so just divide
    // the output by 30 and add +1 (+1 because of the last month, as it just
    // started, but the days are not added to the datetime).
    // That will give a close enough estimate.
    final int monthsReading =
        (_currentDateTime.difference(startCorrected).inDays ~/ 30) + 1;

    if (monthsReading == 0) {
      return doneBooks.length.toDouble();
    } else {
      return doneBooks.length / monthsReading.toDouble();
    }
  }

  MostActiveMonth? _mostActiveMonth(List<Book> books) {
    final List<Book> booksOfMostReadMonth = books
            .where(
              (book) => book.state == BookState.read && book.endDate != null,
            )
            .groupListsBy(
              (book) => '${book.endDate!.month}-${book.endDate!.year}',
            )
            .entries
            .sorted((a, b) => b.value.length - a.value.length)
            .firstOrNull
            ?.value ??
        [];

    if (booksOfMostReadMonth.isEmpty) {
      return null;
    }

    final DateTime date = DateTime(
      booksOfMostReadMonth.first.endDate!.year,
      booksOfMostReadMonth.first.endDate!.month,
    );
    return MostActiveMonth(
      month: date,
      books: booksOfMostReadMonth,
    );
  }
}
