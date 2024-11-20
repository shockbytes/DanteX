import 'package:dantex/providers/book.dart';
import 'package:dantex/ui/book/book_image.dart';
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
        final book = result.first;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          width: double.infinity,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BookImage(book.thumbnailAddress, size: 80),
                const SizedBox(height: 16),
                Text(
                  book.title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(book.author),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text('Read Later'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text('Reading'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                OutlinedButton(onPressed: () {}, child: const Text('Wishlist')),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Not my book'),
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) => Center(
        child: Text('Error: $error'),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
