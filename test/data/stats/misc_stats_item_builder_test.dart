import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/data/stats/item_builder/misc_stats_item_builder.dart';
import 'package:dantex/src/data/stats/stats_item.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../util/book_test_utils.dart';


void main() {
  final DateTime currentDateTime = DateTime(2023, 10);
  final MiscStatsItemBuilder itemBuilder = MiscStatsItemBuilder(
    currentDateTime,
  );

  test('Misc stats with empty books', () {
    final List<Book> data = [];

    final MiscStatsItem item = itemBuilder.buildStatsItem(data);

    expect(item.dataState, isA<EmptyMiscData>());
  });

  test('Misc stats with no book finished', () {
    final List<Book> data = BookTestUtils.generateBooksWithSeed(
      [
        TestBookSeed(
          state: BookState.reading,
          startDate: DateTime.now(),
          forLaterDate: DateTime.now(),
        ),
      ],
    );

    final MiscStatsItem item = itemBuilder.buildStatsItem(data);

    expect(
      item.dataState,
      equals(
        const MiscData(
          averageBooksPerMonth: 0,
          mostActiveMonth: null,
        ),
      ),
    );
  });

  test('Misc stats with single book finished', () {
    final List<Book> data = BookTestUtils.generateBooksWithSeed(
      [
        TestBookSeed.singleDate(
          state: BookState.read,
          date: DateTime(2023, 10, 10),
        ),
      ],
    );

    final MiscStatsItem item = itemBuilder.buildStatsItem(data);

    expect(
      item.dataState,
      equals(
        MiscData(
          averageBooksPerMonth: 1,
          mostActiveMonth: MostActiveMonth(
            month: DateTime(2023, 10),
            books: data,
          ),
        ),
      ),
    );
  });

  test('Misc stats with many books finished', () {
    final List<Book> data = BookTestUtils.generateBooksWithSeed(
      [
        TestBookSeed.singleDate(
          state: BookState.read,
          date: DateTime(2023, 10, 10),
        ),
        TestBookSeed.singleDate(
          state: BookState.read,
          date: DateTime(2023, 10, 10),
        ),
        TestBookSeed.singleDate(
          state: BookState.read,
          date: DateTime(2023, 10, 10),
        ),
        TestBookSeed.singleDate(
          state: BookState.read,
          date: DateTime(2023, 10, 10),
        ),
        TestBookSeed.singleDate(
          state: BookState.read,
          date: DateTime(2023, 9, 10),
        ),
        TestBookSeed.singleDate(
          state: BookState.read,
          date: DateTime(2023, 8, 10),
        ),
      ],
    );

    final MiscStatsItem item = itemBuilder.buildStatsItem(data);

    final expectedBookData = BookTestUtils.generateBooksWithSeed(
      [
        TestBookSeed.singleDate(
          state: BookState.read,
          date: DateTime(2023, 10, 10),
        ),
        TestBookSeed.singleDate(
          state: BookState.read,
          date: DateTime(2023, 10, 10),
        ),
        TestBookSeed.singleDate(
          state: BookState.read,
          date: DateTime(2023, 10, 10),
        ),
        TestBookSeed.singleDate(
          state: BookState.read,
          date: DateTime(2023, 10, 10),
        ),
      ],
    );

    expect(
      item.dataState,
      equals(
        MiscData(
          averageBooksPerMonth: 2.0,
          mostActiveMonth: MostActiveMonth(
            month: DateTime(2023, 10),
            books: expectedBookData,
          ),
        ),
      ),
    );
  });
}
