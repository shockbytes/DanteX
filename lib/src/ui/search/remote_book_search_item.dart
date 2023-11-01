import 'package:dantex/src/data/search/search.dart';
import 'package:dantex/src/ui/book/book_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RemoteBookSearchItem extends ConsumerWidget {
  final Function(String isbn) onAddBook;

  final RemoteBookSearchResult _remoteBookSearchResult;

  const RemoteBookSearchItem(
    this._remoteBookSearchResult, {
    required this.onAddBook,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: BookImage(
            _remoteBookSearchResult.thumbnailAddress,
            size: 48,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _remoteBookSearchResult.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                _remoteBookSearchResult.author,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        FilledButton.tonalIcon(
          onPressed: () => onAddBook(_remoteBookSearchResult.isbn),
          icon: const Icon(Icons.add),
          label: Text('add'.tr()),
        ),
      ],
    );
  }
}
