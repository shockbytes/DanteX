import 'package:dantex/src/data/book/entity/book.dart';

sealed class StatsItem {
  String title();
}

class BooksAndPagesStatsItem extends StatsItem {

  final BooksAndPagesDataState dataState;

  BooksAndPagesStatsItem(this.dataState);

  @override
  String title() => 'Books & Pages'; // TODO Translate
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
  String title() => 'Reading Time'; // TODO Translate
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

