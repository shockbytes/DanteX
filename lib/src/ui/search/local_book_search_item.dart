import 'package:dantex/src/data/search/search.dart';
import 'package:dantex/src/ui/book/book_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocalBookSearchItem extends ConsumerWidget {
  final Function(String bookId) onBookClicked;

  final LocalBookSearchResult _localBookSearchResult;

  const LocalBookSearchItem(
    this._localBookSearchResult, {
    required this.onBookClicked,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => onBookClicked(_localBookSearchResult.bookId),
      child: Row(
        children: [
          BookImage(
            _localBookSearchResult.thumbnailAddress,
            size: 48,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _localBookSearchResult.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  _localBookSearchResult.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
