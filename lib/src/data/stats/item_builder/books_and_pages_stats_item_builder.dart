import 'package:collection/collection.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/data/stats/item_builder/stats_item_builder.dart';
import 'package:dantex/src/data/stats/stats_item.dart';

class BooksAndPagesStatsItemBuilder implements StatsItemBuilder<BooksAndPagesStatsItem> {
  @override
  BooksAndPagesStatsItem buildStatsItem(List<Book> books) {
    final BooksAndPagesDataState dataState;
    if (books.isEmpty) {
      dataState = EmptyBooksAndPagesData();
    } else {
      dataState = _buildPresentDataState(books);
    }

    return BooksAndPagesStatsItem(dataState);
  }

  BooksAndPagesDataState _buildPresentDataState(List<Book> books) {
    final Map<BookState, List<Book>> bookStates = books.groupListsBy(
      (b) => b.state,
    );

    final List<Book> booksWaiting = bookStates[BookState.readLater] ?? [];
    final List<Book> booksReading = bookStates[BookState.reading] ?? [];
    final List<Book> booksRead = bookStates[BookState.read] ?? [];

    final int pagesRead = booksRead.fold(
          0,
          (previousValue, element) => previousValue + element.pageCount,
        ) +
        booksReading.fold(
          0,
          (previousValue, element) => previousValue + element.currentPage,
        );

    final int pagesWaiting = booksWaiting.fold(
          0,
          (previousValue, element) => previousValue + element.pageCount,
        ) +
        booksReading.fold(
          0,
          (previousValue, element) =>
              previousValue + (element.pageCount - element.currentPage),
        );

    return BooksAndPagesData(
      booksWaiting: booksWaiting.length,
      booksReading: booksReading.length,
      booksRead: booksRead.length,
      pagesRead: pagesRead,
      pagesWaiting: pagesWaiting,
    );
  }
}
