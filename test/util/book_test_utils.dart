import 'package:collection/collection.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';

class BookTestUtils {
  BookTestUtils._();

  static Book generateFromSeed(
    TestBookSeed seed, {
    int index = 0,
  }) {
    return _fromSeedAndIndex(seed, index);
  }

  static List<Book> generateBooksWithSeed(List<TestBookSeed> seeds) {
    return seeds
        .mapIndexed(
          (index, element) => _fromSeedAndIndex(element, index),
        )
        .toList();
  }

  static Book _fromSeedAndIndex(TestBookSeed seed, int index) {
    return Book(
      id: index.toString(),
      title: index.toString(),
      subTitle: index.toString(),
      author: seed.author ?? index.toString(),
      state: seed.state,
      pageCount: 256,
      currentPage: 0,
      publishedDate: '',
      position: 0,
      isbn: '12345678',
      thumbnailAddress: null,
      startDate: seed.startDate,
      endDate: seed.endDate,
      forLaterDate: seed.forLaterDate,
      language: 'en',
      rating: seed.rating,
      notes: index.toString(),
      summary: index.toString(),
    );
  }
}

class TestBookSeed {
  final BookState state;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? forLaterDate;
  final int rating;
  final String? author;

  TestBookSeed({
    required this.state,
    this.startDate,
    this.endDate,
    this.forLaterDate,
    this.rating = 0,
    this.author,
  });

  TestBookSeed.singleDate({
    required this.state,
    required DateTime date,
    this.rating = 0,
    this.author,
  })  : startDate = date,
        endDate = date,
        forLaterDate = date;

  TestBookSeed.forAuthor({
    required this.author,
    required DateTime date,
    this.rating = 0,
  })  : startDate = date,
        endDate = date,
        forLaterDate = date,
        state = BookState.read;
}
