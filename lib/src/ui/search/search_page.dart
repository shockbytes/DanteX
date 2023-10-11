import 'package:dantex/src/bloc/search_bloc.dart';
import 'package:dantex/src/data/book/firebase_book_repository.dart';
import 'package:dantex/src/ui/core/generic_error_widget.dart';
import 'package:dantex/src/ui/search/interactive_dante_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  // TODO Use riverpod instead
  final SearchBloc _bloc = SearchBloc(
    FirebaseBookRepository(
      FirebaseAuth.instance,
      FirebaseDatabase.instance,
    ),
  );

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search your library'), // TODO Translate
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InteractiveDanteSearchBar(onQueryChanged: _bloc.onQueryChanged),
            Expanded(
              child: StreamBuilder(
                stream: _bloc.searchResults,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<BookSearchResult> results = snapshot.data!;

                    if (results.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Nothing found, wanna search online?'),
                          FilledButton.tonalIcon(
                            onPressed: _bloc.performOnlineSearch,
                            label: Text('Search online'),
                            icon: Icon(Icons.search),
                          ),
                        ],
                      );
                    } else {
                      return ListView.separated(
                        itemBuilder: (context, index) {

                          BookSearchResult result = results[index];

                          return switch (result) {
                            LocalBookSearchResult() => Text(result.book.title),
                            RemoteBookSearchResult() => Text('Online book'),
                          };
                        },
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: results.length,
                      );
                    }
                  } else if (snapshot.hasError) {
                    return GenericErrorWidget(snapshot.error);
                  } else {
                    // TODO Replace with other widget
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stream<List<BookSearchResult>> stream() {
    return Stream.value([]);
  }
}
