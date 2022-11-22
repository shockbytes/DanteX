import 'package:dantex/src/bloc/main/book_state_bloc.dart';
import 'package:dantex/src/core/injection/dependency_injector.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/ui/book/book_item_widget.dart';
import 'package:dantex/src/ui/core/generic_error_widget.dart';
import 'package:flutter/material.dart';

class BookStatePage extends StatelessWidget {
  final BookState _state;

  final BookStateBloc _bloc = DependencyInjector.get();

  BookStatePage(this._state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Book>>(
      stream: _bloc.getBooksForState(_state),
      builder: (context, snapshot) {
        var data = snapshot.data;

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
      child: Text('No books for the state ' + _state.name),
    );
  }
}
