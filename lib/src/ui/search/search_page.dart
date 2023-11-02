import 'package:dantex/src/data/search/search.dart';
import 'package:dantex/src/providers/app_router.dart';
import 'package:dantex/src/providers/service.dart';
import 'package:dantex/src/ui/add/add_book_widget.dart';
import 'package:dantex/src/ui/core/dante_loading_indicator.dart';
import 'package:dantex/src/ui/core/generic_error_widget.dart';
import 'package:dantex/src/ui/search/empty_search_widget.dart';
import 'package:dantex/src/ui/search/interactive_dante_search_bar.dart';
import 'package:dantex/src/ui/search/local_book_search_item.dart';
import 'package:dantex/src/ui/search/remote_book_search_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Search search = ref.read(searchProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('search.hint'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InteractiveDanteSearchBar(onQueryChanged: search.onQueryChanged),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<SearchResultState>(
                stream: search.searchResults,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final SearchResultState state = snapshot.data!;

                    return switch (state) {
                      Idle() => _buildIdleScreen(),
                      (final SearchResult result) => _buildSearchResults(
                          search,
                          result.results,
                        ),
                    };
                  } else if (snapshot.hasError) {
                    return GenericErrorWidget(snapshot.error);
                  } else {
                    return const DanteLoadingIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(Search search, List<BookSearchResult> results) {
    if (results.isEmpty) {
      return EmptySearchWidget(
        onOnlineSearch: search.performOnlineSearch,
      );
    } else {
      return ListView.separated(
        itemBuilder: (context, index) {
          final BookSearchResult result = results[index];

          return switch (result) {
            (final LocalBookSearchResult local) => LocalBookSearchItem(
                local,
                onBookClicked: (String bookId) {
                  context.go(
                    DanteRoute.bookDetail.navigationUrl.replaceAll(
                      ':bookId',
                      bookId,
                    ),
                  );
                },
              ),
            (final RemoteBookSearchResult remote) => RemoteBookSearchItem(
                remote,
                onAddBook: (String isbn) {
                  openAddBookSheet(context, query: isbn);
                },
              ),
          };
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: results.length,
      );
    }
  }

  Widget _buildIdleScreen() {
    return Center(
      child: Text('search.page-hint'.tr()),
    );
  }
}
