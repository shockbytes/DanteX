import 'package:dantex/providers/book.dart';
import 'package:dantex/ui/book/add_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
      loading: () => FractionallySizedBox(
        heightFactor: 0.5,
        child: Center(
          child: SpinKitPulsingGrid(
            itemBuilder: (context, index) {
              final color = Color.lerp(
                Colors.pink,
                Colors.blue,
                index / 24,
              );
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
