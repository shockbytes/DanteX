import 'package:dantex/src/bloc/add/add_book_bloc.dart';
import 'package:dantex/src/core/injection/dependency_injector.dart';
import 'package:dantex/src/data/bookdownload/entity/book_suggestion.dart';
import 'package:flutter/material.dart';

class AddBookSheet extends StatelessWidget {
  final AddBookBloc _bloc = DependencyInjector.get<AddBookBloc>();

  final String _query;

  AddBookSheet(
    this._query, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Handle'),
        FutureBuilder<BookSuggestion>(
          future: _bloc.downloadBook(_query),
          builder: (context, snapshot) {
            Widget child;
            if (snapshot.hasData) {
              child = _buildBookWidget(snapshot.data!);
            } else if (snapshot.hasError) {
              child = Text('Error');
            } else {
              child = const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            return SizedBox(
              height: 400,
              child: child,
            );
          },
        ),
      ],
    );
  }

  Widget _buildBookWidget(BookSuggestion bookSuggestion) {
    return Center(
      child: Text(
        bookSuggestion.target.title,
      ),
    );
  }
}

openAddBookSheet(BuildContext context, String query) async {
  await showModalBottomSheet(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => AddBookSheet(query),
  );
}
