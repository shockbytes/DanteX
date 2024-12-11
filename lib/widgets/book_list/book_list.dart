import 'dart:math';

import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_sort_strategy.dart';
import 'package:dantex/models/book_state.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/providers/repository.dart';
import 'package:dantex/providers/service.dart';
import 'package:dantex/providers/settings.dart';
import 'package:dantex/widgets/backup/pick_random_book_widget.dart';
import 'package:dantex/widgets/book_list/book_list_card.dart';
import 'package:dantex/widgets/book_list/empty_local_search_result.dart';
import 'package:dantex/widgets/book_list/no_books_found.dart';
import 'package:dantex/widgets/shared/book_image.dart';
import 'package:dantex/widgets/shared/cached_reorderable_list_view.dart';
import 'package:dantex/widgets/shared/dante_loading_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookList extends ConsumerWidget {
  const BookList({required this.bookState, super.key});

  final BookState bookState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksForState = ref.watch(booksForStateProvider(bookState));
    final searchTerm = ref.watch(searchTermProvider);
    var showRandomBookWidget = false;
    if (bookState == BookState.readLater) {
      showRandomBookWidget = ref.watch(randomBooksEnabledSettingProvider);
    }

    return booksForState.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
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
          header: showRandomBookWidget
              ? Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: PickRandomBookWidget(
                    onPickRandomBook: () async => showDialog<void>(
                      context: context,
                      builder: (context) => _RandomBookDialog(
                        key: const ValueKey('random_book_dialog'),
                        books: books,
                      ),
                    ),
                  ),
                )
              : null,
          onReorder: (oldIndex, newIndex) async {
            await ref
                .read(bookSortStrategySettingProvider.notifier)
                .set(BookSortStrategy.position);
            final movedBook = books.removeAt(oldIndex);
            books.insert(newIndex, movedBook);
            await ref.read(bookRepositoryProvider).updatePositions(books);
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

class _RandomBookDialog extends ConsumerWidget {
  const _RandomBookDialog({
    required this.books,
    super.key,
  });

  final List<Book> books;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final random = Random();
    final randomIndex = random.nextInt(books.length);
    final randomBook = books[randomIndex];

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            randomBook.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          BookImage(randomBook.thumbnailAddress, size: 160),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () async {
              await ref.read(bookRepositoryProvider).moveBookToState(
                    randomBook.id,
                    BookState.readLater,
                  );
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('book_action.move_to_reading').tr(),
          ),
        ],
      ),
    );
  }
}
