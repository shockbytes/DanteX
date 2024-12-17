import 'package:dantex/providers/settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PickRandomBookWidget extends ConsumerWidget {
  const PickRandomBookWidget({required this.onPickRandomBook, super.key});
  final VoidCallback onPickRandomBook;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          children: [
            Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () async => ref
                      .read(randomBooksEnabledSettingProvider.notifier)
                      .set(randomBooksEnabled: false),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Text(
              'book_list.pick_random_book_description',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ).tr(),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onPickRandomBook,
              child: const Text('book_list.pick_random_book').tr(),
            ),
          ],
        ),
      ),
    );
  }
}
