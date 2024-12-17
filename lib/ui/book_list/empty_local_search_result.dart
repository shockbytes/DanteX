import 'package:dantex/providers/book.dart';
import 'package:dantex/ui/add_book/search_result_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmptyLocalSearchResult extends ConsumerWidget {
  const EmptyLocalSearchResult({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchTerm = ref.watch(searchTermProvider);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'book_list.empty_states.search',
              textAlign: TextAlign.center,
            ).tr(),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () async =>
                  showSearchResultBottomSheet(context, searchTerm),
              child: const Text('book_list.empty_states.search_online').tr(),
            ),
          ],
        ),
      ),
    );
  }
}
