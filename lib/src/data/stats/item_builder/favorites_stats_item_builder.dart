import 'package:collection/collection.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/stats/item_builder/stats_item_builder.dart';
import 'package:dantex/src/data/stats/stats_item.dart';
import 'package:dantex/src/util/extensions.dart';

class FavoritesStatsItemBuilder extends StatsItemBuilder<FavoritesStatsItem> {
  @override
  FavoritesStatsItem buildStatsItem(List<Book> books) {
    final List<Book> favoriteAuthor = _favoriteAuthor(books);
    final Book? firstFiveStarRating = _firstFiveStarRating(books);

    final FavoritesDataState dataState = favoriteAuthor.isEmpty
        ? EmptyFavoritesData()
        : FavoritesData(
            favoriteAuthor: favoriteAuthor,
            firstFiveStarBook: firstFiveStarRating,
          );

    return FavoritesStatsItem(dataState);
  }

  List<Book> _favoriteAuthor(List<Book> books) {
    return books
            .groupListsBy((e) => e.author)
            .entries
            .sorted((a, b) => b.value.length - a.value.length)
            .firstOrNull
            ?.value ??
        [];
  }

  Book? _firstFiveStarRating(List<Book> books) {

    return books.first;

    return books
        .where((book) => book.rating == 5 && book.startDate != null)
        .sortedByStartDate()
        .firstOrNull;
  }
}
