import 'package:collection/collection.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/stats/stats_item.dart';
import 'package:dantex/src/ui/book/book_image.dart';
import 'package:dantex/src/ui/stats/item/empty_stats_view.dart';
import 'package:dantex/src/ui/stats/item/stats_item_card.dart';
import 'package:dantex/src/ui/stats/item/util/mobile_stats_mixin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FavoritesStatsItemWidget extends StatelessWidget with MobileStatsMixin {

  static const int _maxBooks = 3;

  final FavoritesStatsItem _item;
  final bool isMobile;

  double get _imageSize => isMobile ? 48 : 72;

  const FavoritesStatsItemWidget(
    this._item, {
    required this.isMobile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StatsItemCard(
      title: _item.titleKey.tr(),
      content: resolveTopLevelWidget(
        child: _buildContent(context),
        isMobile: isMobile,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final FavoritesDataState dataState = _item.dataState;
    return switch (dataState) {
      EmptyFavoritesData() => EmptyStatsView('stats.favorites.empty'.tr()),
      FavoritesData() => _buildFavoritesContent(context, dataState),
    };
  }

  Widget _buildFavoritesContent(
    BuildContext context,
    FavoritesData dataState,
  ) {
    return Row(
      children: [
        _buildFavoriteAuthor(
          context,
          dataState.favoriteAuthor,
        ),
        if (dataState.firstFiveStarBook != null) ...[
          const VerticalDivider(
            indent: 16,
            endIndent: 16,
            thickness: 1,
          ),
          _buildFirstFiveStarBook(
            context,
            dataState.firstFiveStarBook!,
          ),
        ],
      ],
    );
  }

  Widget _buildFavoriteAuthor(
    BuildContext context,
    List<Book> favoriteAuthorBooks,
  ) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'stats.favorites.favorite-author'.tr(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: favoriteAuthorBooks
                .take(_maxBooks)
                .mapIndexed(
                  (index, e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: BookImage(
                      e.thumbnailAddress,
                      size: _imageSize,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Text(
            favoriteAuthorBooks.first.author,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFirstFiveStarBook(
    BuildContext context,
    Book book,
  ) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'stats.favorites.first-five-star-book'.tr(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          BookImage(
            book.thumbnailAddress,
            size: _imageSize,
          ),
          const SizedBox(height: 16),
          Text(
            book.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
