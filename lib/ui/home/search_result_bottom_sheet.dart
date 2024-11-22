import 'package:dantex/providers/book.dart';
import 'package:dantex/ui/book/add_book.dart';
import 'package:dantex/ui/core/pulsing_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchResultBottomSheet extends ConsumerWidget {
  const SearchResultBottomSheet({required this.searchTerm});

  final String searchTerm;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResult = ref.watch(searchRemoteBooksProvider(searchTerm));
    return searchResult.when(
      data: (result) {
        if (result.isEmpty) {
          return const Center(
            child: Text('No results found'),
          );
        }

        return AddBook(book: result.first);
      },
      error: (error, stackTrace) => Center(
        child: Text('Error: $error \n $stackTrace'),
      ),
      loading: () => const FractionallySizedBox(
        heightFactor: 0.5,
        child: Center(
          child: PulsingGrid(),
        ),
      ),
    );
  }
}
