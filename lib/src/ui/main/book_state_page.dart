import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/providers/book.dart';
import 'package:dantex/src/ui/book/book_item_widget.dart';
import 'package:dantex/src/ui/core/generic_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookStatePage extends ConsumerWidget {
  final BookState _state;

  const BookStatePage(this._state, {Key? key}) : super(key: key);

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

class _BooksScreen extends StatelessWidget {
  final List<Book> books;
  final BookState state;

  const _BooksScreen({required this.books, required this.state});

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return Center(
        child: Text('No books for the state ${state.name}'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      physics: const BouncingScrollPhysics(),
      itemCount: books.length,
      itemBuilder: (context, index) => BookItemWidget(books[index]),
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 16),
    );
  }
}
