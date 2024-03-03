import 'dart:async';

import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/book_sort_strategy.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/providers/book.dart';
import 'package:dantex/src/providers/repository.dart';
import 'package:dantex/src/ui/book/book_item_widget.dart';
import 'package:dantex/src/ui/core/generic_error_widget.dart';
import 'package:dantex/src/ui/main/empty_state_view.dart';
import 'package:dantex/src/util/layout_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookStatePage extends ConsumerWidget {
  final BookState _state;

  const BookStatePage(this._state, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(booksForStateProvider(_state)).when(
          skipLoadingOnRefresh: true,
          skipLoadingOnReload: true,
          data: (data) => _BooksScreen(books: data, state: _state),
          error: (error, stackTrace) => GenericErrorWidget(error),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
  }
}

class _BooksScreen extends ConsumerWidget {
  final List<Book> books;
  final BookState state;

  const _BooksScreen({required this.books, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BookRepository bookRepository = ref.read(bookRepositoryProvider);

    if (books.isEmpty) {
      return EmptyStateView(state);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final DeviceFormFactor formFactor = getDeviceFormFactor(constraints);

        return switch (formFactor) {
          DeviceFormFactor.desktop =>
            _buildLargeLayout(bookRepository, columns: 3),
          DeviceFormFactor.tablet =>
            _buildLargeLayout(bookRepository, columns: 2),
          DeviceFormFactor.phone => _buildPhoneLayout(bookRepository, ref),
        };
      },
    );
  }

  Widget _buildPhoneLayout(BookRepository bookRepository, WidgetRef ref) {
    return ReorderableListView.builder(
      proxyDecorator: (child, index, animation) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 16,
                child: Material(
                  borderRadius: BorderRadius.circular(16),
                  elevation: 24,
                  shadowColor: Colors.black.withOpacity(0.6),
                ),
              ),
              child,
            ],
          ),
        );
      },
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      physics: const BouncingScrollPhysics(),
      itemCount: books.length,
      itemBuilder: (context, index) => Column(
        key: ValueKey(books[index].id),
        children: [
          _buildItem(
            books[index],
            bookRepository,
            useMobileLayout: true,
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
      onReorder: (oldIndex, newIndex) async {
        if (ref.read(sortingStrategyProvider) != BookSortStrategy.position) {
          ref
              .read(sortingStrategyProvider.notifier)
              .set(BookSortStrategy.position);
        }
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final Book book = books.removeAt(oldIndex);
        books.insert(newIndex, book);
        await bookRepository.updatePositions(books);
      },
    );
  }

  Widget _buildLargeLayout(
    BookRepository bookRepository, {
    required int columns,
  }) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 4,
      ),
      itemBuilder: (context, index) => _buildItem(
        books[index],
        bookRepository,
        useMobileLayout: false,
      ),
      itemCount: books.length,
    );
  }

  Widget _buildItem(
    Book book,
    BookRepository bookRepository, {
    required bool useMobileLayout,
  }) {
    return BookItemWidget(
      book,
      useMobileLayout: useMobileLayout,
      onBookDeleted: (Book book) => _handleBookDeletion(bookRepository, book),
      onBookStateChanged: (book, state) => _handleBookUpdate(
        bookRepository,
        book,
        state,
      ),
    );
  }

  void _handleBookUpdate(
    BookRepository repository,
    Book book,
    BookState state,
  ) {
    unawaited(
      repository.update(book.copyWith(state: state)),
    );
  }

  void _handleBookDeletion(
    BookRepository repository,
    Book book,
  ) {
    unawaited(
      repository.delete(book.id),
    );
  }
}
