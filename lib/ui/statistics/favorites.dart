import 'package:collection/collection.dart';
import 'package:dantex/providers/statistics.dart';
import 'package:dantex/ui/shared/book_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const int _maxBooks = 3;

class Favorites extends ConsumerWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteAuthorBooks = ref.watch(favoriteAuthorBooksProvider);
    final firstFiveStarBook = ref.watch(firstFiveStarBookProvider);
    if (firstFiveStarBook == null && favoriteAuthorBooks.isEmpty) {
      return Center(
        child: const Text('statistics.favorites.empty').tr(),
      );
    }

    return Column(
      spacing: 16,
      children: [
        if (favoriteAuthorBooks.isNotEmpty) ...[
          Text(
            'statistics.favorites.favorite_author',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ).tr(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: favoriteAuthorBooks
                .take(_maxBooks)
                .mapIndexed(
                  (index, e) => BookImage(
                    e.thumbnailAddress,
                    size: 80,
                  ),
                )
                .toList(),
          ),
          Text(
            favoriteAuthorBooks.first.author,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
        if (firstFiveStarBook != null) ...[
          Text(
            'statistics.favorites.first_five_star_book',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ).tr(),
          BookImage(
            firstFiveStarBook.thumbnailAddress,
            size: 80,
          ),
          Text(
            firstFiveStarBook.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
