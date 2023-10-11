import 'package:dantex/src/bloc/search_bloc.dart';
import 'package:dantex/src/providers/repository.dart';
import 'package:dantex/src/providers/service.dart';
import 'package:dantex/src/ui/core/generic_error_widget.dart';
import 'package:dantex/src/ui/search/interactive_dante_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPage extends ConsumerWidget{

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // TODO Fully inject bloc here
    final SearchBloc bloc = SearchBloc(
      ref.read(bookRepositoryProvider),
      ref.read(bookDownloaderProvider),
    );
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Search your library'), // TODO Translate
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InteractiveDanteSearchBar(onQueryChanged: bloc.onQueryChanged),
            Expanded(
              child: StreamBuilder(
                stream: bloc.searchResults,
                builder: (context, snapshot) {

                  // TODO Loading indicator

                  if (snapshot.hasData) {
                    List<BookSearchResult> results = snapshot.data!;

                    if (results.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Nothing found, wanna search online?'),
                          FilledButton.tonalIcon(
                            onPressed: bloc.performOnlineSearch,
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
                            LocalBookSearchResult() => Text(result.title), // TODO Build widget
                            RemoteBookSearchResult() => Text('Online ${result.title}'), // TODO Build widget
                          };
                        },
                        separatorBuilder: (context, index) => const Divider(),
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
}
