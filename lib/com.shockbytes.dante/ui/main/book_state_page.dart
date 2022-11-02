import 'package:dantex/com.shockbytes.dante/bloc/main/book_state_bloc.dart';
import 'package:dantex/com.shockbytes.dante/core/injection/dependency_injector.dart';
import 'package:dantex/com.shockbytes.dante/data/book/entity/book.dart';
import 'package:dantex/com.shockbytes.dante/data/book/entity/book_state.dart';
import 'package:dantex/com.shockbytes.dante/ui/book/book_item_widget.dart';
import 'package:flutter/material.dart';

class BookStatePage extends StatelessWidget {
  final BookState _state;

  final BookStateBloc _bloc = DependencyInjector.get();

  BookStatePage(this._state);

  Widget build(BuildContext context) {
    return StreamBuilder<List<Book>>(
      stream: _bloc.getBooksForState(_state),
      builder: (context, snapshot) {
        var data = snapshot.data;

        if (snapshot.hasData && data != null) {
          return _buildBookScreen(data);
        } else if (snapshot.hasError) {
          return _buildErrorScreen(snapshot.error!);
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
      physics: BouncingScrollPhysics(),
      itemCount: books.length,
      itemBuilder: (context, index) => BookItemWidget(books[index]),
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: 16),
    );
  }

  Widget _buildErrorScreen(Object error) {
    return Center(
      child: Text(error.toString()),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  Widget _buildEmptyScreen() {
    return Center(
      child: Text('No books for the state ' + _state.name),
    );
  }
}
