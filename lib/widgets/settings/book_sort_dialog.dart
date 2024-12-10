import 'package:dantex/models/book_sort_strategy.dart';
import 'package:dantex/providers/settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookSortDialog extends ConsumerWidget {
  const BookSortDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('settings.books.sort').tr(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(BookSortStrategy.position.strategyName).tr(),
            onTap: () async {
              await ref
                  .read(bookSortStrategySettingProvider.notifier)
                  .set(BookSortStrategy.position);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            trailing: ref.watch(bookSortStrategySettingProvider) ==
                    BookSortStrategy.position
                ? const Icon(Icons.check)
                : null,
          ),
          ListTile(
            title: Text(BookSortStrategy.author.strategyName).tr(),
            onTap: () async {
              await ref
                  .read(bookSortStrategySettingProvider.notifier)
                  .set(BookSortStrategy.author);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            trailing: ref.watch(bookSortStrategySettingProvider) ==
                    BookSortStrategy.author
                ? const Icon(Icons.check)
                : null,
          ),
          ListTile(
            title: Text(BookSortStrategy.title.strategyName).tr(),
            onTap: () async {
              await ref
                  .read(bookSortStrategySettingProvider.notifier)
                  .set(BookSortStrategy.title);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            trailing: ref.watch(bookSortStrategySettingProvider) ==
                    BookSortStrategy.title
                ? const Icon(Icons.check)
                : null,
          ),
          ListTile(
            title: Text(BookSortStrategy.progress.strategyName).tr(),
            onTap: () async {
              await ref
                  .read(bookSortStrategySettingProvider.notifier)
                  .set(BookSortStrategy.progress);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            trailing: ref.watch(bookSortStrategySettingProvider) ==
                    BookSortStrategy.progress
                ? const Icon(Icons.check)
                : null,
          ),
          ListTile(
            title: Text(BookSortStrategy.pages.strategyName).tr(),
            onTap: () async {
              await ref
                  .read(bookSortStrategySettingProvider.notifier)
                  .set(BookSortStrategy.pages);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            trailing: ref.watch(bookSortStrategySettingProvider) ==
                    BookSortStrategy.pages
                ? const Icon(Icons.check)
                : null,
          ),
          ListTile(
            title: Text(BookSortStrategy.labels.strategyName).tr(),
            onTap: () async {
              await ref
                  .read(bookSortStrategySettingProvider.notifier)
                  .set(BookSortStrategy.labels);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            trailing: ref.watch(bookSortStrategySettingProvider) ==
                    BookSortStrategy.labels
                ? const Icon(Icons.check)
                : null,
          ),
        ],
      ),
    );
  }
}
