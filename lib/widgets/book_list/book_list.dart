import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_state.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/providers/logger.dart';
import 'package:dantex/providers/repository.dart';
import 'package:dantex/widgets/book_list/book_list_card.dart';
import 'package:dantex/widgets/book_list/empty_local_search_result.dart';
import 'package:dantex/widgets/book_list/no_books_found.dart';
import 'package:dantex/widgets/shared/cached_reorderable_list_view.dart';
import 'package:dantex/widgets/shared/dante_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookList extends ConsumerWidget {
  const BookList({required this.bookState, super.key});

  final BookState bookState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksForState = ref.watch(booksForStateProvider(bookState));
    final searchTerm = ref.watch(searchTermProvider);

    return booksForState.when(
      data: (books) {
        if (books.isEmpty) {
          return NoBooksFound(
            key: ValueKey('no_${bookState.name}_books_found'),
            bookState: bookState,
          );
        }

        if (searchTerm.isNotEmpty) {
          books = books
              .where(
                (book) =>
                    book.title.toLowerCase().contains(searchTerm.toLowerCase()),
              )
              .toList();
        }

        if (books.isEmpty) {
          return const EmptyLocalSearchResult(
            key: ValueKey('empty_local_search_result'),
          );
        }

        return CachedReorderableListView<Book>(
          key: ValueKey('book_${bookState.name}_list'),
          onReorder: (oldIndex, newIndex) async {
            final updatedBooks = List<Book>.from(books);
            final movedBook = updatedBooks.removeAt(oldIndex);
            // If we're moving the book down the list, we need to adjust the
            // index to account for the book being removed.
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            updatedBooks.insert(newIndex, movedBook);
            await ref
                .read(bookRepositoryProvider)
                .updatePositions(updatedBooks);
          },
          list: books,
          itemBuilder: (context, book) => Padding(
            key: ValueKey('book_list_card_${book.id}'),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: BookListCard(book: book),
          ),
          proxyDecorator: (child, index, animation) => ColoredBox(
            color: Colors.transparent,
            child: child,
          ),
        );
      },
      error: (e, s) {
        ref.read(loggerProvider).e(
              'Error loading books',
              error: e,
              stackTrace: s,
            );
        return const SizedBox.shrink();
      },
      loading: () => const Center(
        child: DanteLoadingIndicator(),
      ),
    );
  }
}
