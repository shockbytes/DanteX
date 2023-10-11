import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/search_criteria.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {

  String query = '';

  final BookRepository _repository;

  SearchBloc(this._repository);

  final BehaviorSubject<List<BookSearchResult>> _searchResultSubject = BehaviorSubject.seeded([]);

  Stream<List<BookSearchResult>> get searchResults => _searchResultSubject.stream;

  void onQueryChanged(String query) async {
    this.query = query;


    List<BookSearchResult> books = (await _repository.search(_buildCriteria(query)).first) // TODO Replace with Future in Repository class.
        .map(LocalBookSearchResult.new)
        .toList();

    _searchResultSubject.add(books);
  }

  void performOnlineSearch() {
    // TODO Perform online search with query
  }

  SearchCriteria _buildCriteria(String query) {
    return SimpleQuerySearchCriteria(query);
  }
}

sealed class BookSearchResult {}

class LocalBookSearchResult extends BookSearchResult {
  final Book book;

  LocalBookSearchResult(this.book);
}

class RemoteBookSearchResult extends BookSearchResult {}
