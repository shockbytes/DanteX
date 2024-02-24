import 'dart:async';

import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/providers/app_router.dart';
import 'package:dantex/src/providers/book.dart';
import 'package:dantex/src/providers/repository.dart';
import 'package:dantex/src/ui/book/book_item_widget.dart';
import 'package:dantex/src/ui/core/generic_error_widget.dart';
import 'package:dantex/src/ui/main/empty_state_view.dart';
import 'package:dantex/src/util/layout_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BookStatePage extends ConsumerWidget {
  final BookState _state;

  const BookStatePage(this._state, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(booksForStateProvider(_state)).when(
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
          DeviceFormFactor.desktop => _buildLargeLayout(
              context,
              bookRepository,
              columns: 3,
            ),
          DeviceFormFactor.tablet => _buildLargeLayout(
              context,
              bookRepository,
              columns: 2,
            ),
          DeviceFormFactor.phone => _buildPhoneLayout(
              context,
              bookRepository,
            ),
        };
      },
    );
  }

  Widget _buildPhoneLayout(
    BuildContext context,
    BookRepository bookRepository,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      physics: const BouncingScrollPhysics(),
      itemCount: books.length,
      itemBuilder: (context, index) => _buildItem(
        context,
        books[index],
        bookRepository,
        useMobileLayout: true,
      ),
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 16),
    );
  }

  Widget _buildLargeLayout(
    BuildContext context,
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
        context,
        books[index],
        bookRepository,
        useMobileLayout: false,
      ),
      itemCount: books.length,
    );
  }

  Widget _buildItem(
    BuildContext context,
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
      onBookEditClicked: (Book book) => _handleBookEditClicked(context, book),
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

  void _handleBookEditClicked(
    BuildContext context,
    Book book,
  ) {
    context.go(
        DanteRoute.editBook.navigationUrl.replaceAll(':bookId', book.id),
    );
  }
}
