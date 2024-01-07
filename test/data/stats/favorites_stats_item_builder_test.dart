import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/stats/item_builder/favorites_stats_item_builder.dart';
import 'package:dantex/src/data/stats/stats_item.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../util/book_test_utils.dart';

void main() {
  final FavoritesStatsItemBuilder itemBuilder = FavoritesStatsItemBuilder();

  test('Favorites stats with empty books', () {
    final List<Book> data = [];

    final FavoritesStatsItem item = itemBuilder.buildStatsItem(data);

    expect(item.dataState, isA<EmptyFavoritesData>());
  });

  test('Favorites stats with single book, no 5 star rating', () {
    final List<Book> data = BookTestUtils.generateBooksWithSeed(
      [
        TestBookSeed.forAuthor(author: 'Ryan Holiday', date: DateTime.now()),
      ],
    );

    final FavoritesStatsItem item = itemBuilder.buildStatsItem(data);

    expect(
      item.dataState,
      equals(
        FavoritesData(
          favoriteAuthor: data,
          firstFiveStarBook: null,
        ),
      ),
    );
  });

  test('Favorites stats with single most read author, no 5 star rating', () {
    final currentDateTime = DateTime.now();

    final List<Book> data = BookTestUtils.generateBooksWithSeed(
      [
        TestBookSeed.forAuthor(author: 'Ryan Holiday', date: currentDateTime),
        TestBookSeed.forAuthor(author: 'Ryan Holiday', date: currentDateTime),
        TestBookSeed.forAuthor(author: 'Ryan Holiday', date: currentDateTime),
        TestBookSeed.forAuthor(
          author: 'Marcus Aurelius',
          date: currentDateTime,
        ),
        TestBookSeed.forAuthor(author: 'Robert Greene', date: currentDateTime),
      ],
    );

    final FavoritesStatsItem item = itemBuilder.buildStatsItem(data);

    final List<Book> favAuthorBooks = BookTestUtils.generateBooksWithSeed(
      [
        TestBookSeed.forAuthor(author: 'Ryan Holiday', date: currentDateTime),
        TestBookSeed.forAuthor(author: 'Ryan Holiday', date: currentDateTime),
        TestBookSeed.forAuthor(author: 'Ryan Holiday', date: currentDateTime),
      ],
    );

    expect(
      item.dataState,
      equals(
        FavoritesData(
          favoriteAuthor: favAuthorBooks,
          firstFiveStarBook: null,
        ),
      ),
    );
  });

  test('Favorites stats with multiple most read authors, no 5 star rating', () {
    final currentDateTime = DateTime.now();

    final List<Book> data = BookTestUtils.generateBooksWithSeed(
      [
        TestBookSeed.forAuthor(author: 'Robert Greene', date: currentDateTime),
        TestBookSeed.forAuthor(author: 'Robert Greene', date: currentDateTime),
        TestBookSeed.forAuthor(author: 'Robert Greene', date: currentDateTime),
        TestBookSeed.forAuthor(
          author: 'Marcus Aurelius',
          date: currentDateTime,
        ),
        TestBookSeed.forAuthor(author: 'Ryan Holiday', date: currentDateTime),
        TestBookSeed.forAuthor(author: 'Ryan Holiday', date: currentDateTime),
        TestBookSeed.forAuthor(author: 'Ryan Holiday', date: currentDateTime),
      ],
    );

    final FavoritesStatsItem item = itemBuilder.buildStatsItem(data);

    final List<Book> favAuthorBooks = BookTestUtils.generateBooksWithSeed(
      [
        TestBookSeed.forAuthor(author: 'Robert Greene', date: currentDateTime),
        TestBookSeed.forAuthor(author: 'Robert Greene', date: currentDateTime),
        TestBookSeed.forAuthor(author: 'Robert Greene', date: currentDateTime),
      ],
    );

    expect(
      item.dataState,
      equals(
        FavoritesData(
          favoriteAuthor: favAuthorBooks,
          firstFiveStarBook: null,
        ),
      ),
    );
  });

  test('Favorites stats with single most read author, a 5 star rating', () {
    final currentDateTime = DateTime.now();

    final List<Book> data = BookTestUtils.generateBooksWithSeed(
      [
        TestBookSeed.forAuthor(
          author: 'Ryan Holiday',
          date: currentDateTime,
          rating: 5,
        ),
        TestBookSeed.forAuthor(
          author: 'Ryan Holiday',
          date: currentDateTime,
          rating: 5,
        ),
        TestBookSeed.forAuthor(
          author: 'Ryan Holiday',
          date: currentDateTime,
          rating: 5,
        ),
        TestBookSeed.forAuthor(
          author: 'Robert Greene',
          date: currentDateTime,
          rating: 5,
        ),
        TestBookSeed.forAuthor(
          author: 'Marcus Aurelius',
          date: DateTime(2022, 5),
          rating: 5,
        ),
      ],
    );

    final FavoritesStatsItem item = itemBuilder.buildStatsItem(data);

    final Book firstFiveStarBook = BookTestUtils.generateFromSeed(
      TestBookSeed.forAuthor(
        author: 'Marcus Aurelius',
        date: DateTime(2022, 5),
        rating: 5,
      ),
      index: 4,
    );

    final List<Book> favAuthorBooks = BookTestUtils.generateBooksWithSeed(
      [
        TestBookSeed.forAuthor(
          author: 'Ryan Holiday',
          date: currentDateTime,
          rating: 5,
        ),
        TestBookSeed.forAuthor(
          author: 'Ryan Holiday',
          date: currentDateTime,
          rating: 5,
        ),
        TestBookSeed.forAuthor(
          author: 'Ryan Holiday',
          date: currentDateTime,
          rating: 5,
        ),
      ],
    );

    expect(
      item.dataState,
      equals(
        FavoritesData(
          favoriteAuthor: favAuthorBooks,
          firstFiveStarBook: firstFiveStarBook,
        ),
      ),
    );
  });
}
