import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/providers/repository.dart';
import 'package:dantex/src/ui/book/book_item_widget.dart';
import 'package:dantex/src/ui/core/generic_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookStatePage extends ConsumerWidget {
  final BookState _state;

  const BookStatePage(this._state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookRepository = ref.watch(bookRepositoryProvider);

    return StreamBuilder<List<Book>>(
      stream: bookRepository.getBooksForState(_state),
      builder: (context, snapshot) {
        final data = snapshot.data;

        if (snapshot.hasData && data != null) {
          return _buildBookScreen(data);
        } else if (snapshot.hasError) {
          return GenericErrorWidget(snapshot.error);
        } else {
          return _buildLoadingScreen();
        }
      },
    );
  }

  Widget _buildBookScreen(List<Book> books) {
    if (books.isEmpty) {
      return _buildEmptyScreen();
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

  Widget _buildLoadingScreen() {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  Widget _buildEmptyScreen() {
    return Center(
      child: Text('No books for the state ${_state.name}'),
    );
  }
}
