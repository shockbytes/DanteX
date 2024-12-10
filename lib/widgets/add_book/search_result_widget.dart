import 'package:dantex/providers/book.dart';
import 'package:dantex/providers/service.dart';
import 'package:dantex/widgets/add_book/add_book_widget.dart';
import 'package:dantex/widgets/shared/dante_loading_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchResultWidget extends ConsumerWidget {
  const SearchResultWidget({required this.searchTerm});

  final String searchTerm;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResult = ref.watch(searchRemoteBooksProvider(searchTerm));
    return searchResult.when(
      data: (results) {
        if (results.isEmpty) {
          return const _NoSearchResults(key: ValueKey('no_search_results'));
        }

        return AddBookWidget(
          books: results,
          key: const ValueKey('add_book_widget'),
        );
      },
      error: (e, s) {
        ref.read(loggerProvider).e(
              'Failed to load search results',
              error: e,
              stackTrace: s,
            );
        return const SizedBox.shrink();
      },
      loading: () => const FractionallySizedBox(
        key: ValueKey('search_loading'),
        heightFactor: 0.5,
        child: Center(
          child: DanteLoadingIndicator(),
        ),
      ),
    );
  }
}

class _NoSearchResults extends StatelessWidget {
  const _NoSearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off, size: 48),
          const SizedBox(height: 16),
          const Text('search.no_results').tr(),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('search.got_it').tr(),
          ),
        ],
      ),
    );
  }
}

Future<void> showSearchResultBottomSheet(
  BuildContext context,
  String searchTerm,
) async {
  await showModalBottomSheet<void>(
    showDragHandle: true,
    context: context,
    builder: (context) => AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          child: SearchResultWidget(searchTerm: searchTerm),
        ),
      ),
    ),
  );
}
