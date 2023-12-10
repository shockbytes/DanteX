import 'package:collection/collection.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/data/stats/item_builder/stats_item_builder.dart';
import 'package:dantex/src/data/stats/stats_item.dart';
import 'package:dantex/src/util/extensions.dart';
import 'package:easy_localization/easy_localization.dart';

class MiscStatsItemBuilder extends StatsItemBuilder<MiscStatsItem> {
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

    final DateTime start = doneBooks.firstOrNull?.startDate ?? DateTime.now();

    // Unfortunately Dart does not offer a `inMonths` method, so just divide
    // the output by 30. That will give a close enough estimate.
    final int monthsReading =
        (start.difference(DateTime.now()).inDays / 30) as int;

    if (monthsReading == 0) {
      return doneBooks.length.toDouble();
    } else {
      return doneBooks.length / monthsReading.toDouble();
    }
  }

  MostActiveMonth? _mostActiveMonth(List<Book> books) {
    final List<Book> booksOfMostReadMonth = books
            .where((book) => book.state == BookState.read)
            .groupListsBy(
              (book) => '${book.endDate!.month}-${book.endDate!.year}',
            )
            .entries
            .sorted((a, b) => a.value.length - b.value.length)
            .firstOrNull
            ?.value ??
        [];

    if (booksOfMostReadMonth.isEmpty) {
      return null;
    }

    final DateTime date = booksOfMostReadMonth.first.endDate!;
    return MostActiveMonth(
      formattedMonthAndYear:
          DateFormat(DateFormat.YEAR_ABBR_MONTH).format(date),
      books: booksOfMostReadMonth,
    );
  }
}
