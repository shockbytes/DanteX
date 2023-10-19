import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/search_criteria.dart';
import 'package:dantex/src/data/bookdownload/book_downloader.dart';
import 'package:dantex/src/data/bookdownload/entity/book_suggestion.dart';
import 'package:rxdart/rxdart.dart';

class Search {
  String _lastQuery = '';
  final int _minQueryLength = 3;

  final BookRepository _repository;
  final BookDownloader _bookDownloader;

  Search(
    this._repository,
    this._bookDownloader,
  );

  final BehaviorSubject<SearchResultState> _searchResultSubject =
      BehaviorSubject.seeded(Idle());

  Stream<SearchResultState> get searchResults =>
      _searchResultSubject.stream;

  Future<void> onQueryChanged(String query) async {
    if (query.length < _minQueryLength) {
      return;
    }

    _lastQuery = query;

    final List<BookSearchResult> books = (
            // TODO Change this in repository once the migration PR is merged
            await _repository.search(_buildCriteria(query)).first)
        .map(LocalBookSearchResult.fromBook)
        .toList();

    _searchResultSubject.add(SearchResult(books));
  }

  Future<void> performOnlineSearch() async {
    final BookSuggestion suggestion = await _bookDownloader.downloadBook(
      _lastQuery,
    );

    final List<BookSearchResult> results = [
      RemoteBookSearchResult.fromBook(suggestion.target),
      ...suggestion.suggestions.map(RemoteBookSearchResult.fromBook),
    ];

    _searchResultSubject.add(SearchResult(results));
  }

  SearchCriteria _buildCriteria(String query) {
    return SimpleQuerySearchCriteria(query);
  }
}

sealed class SearchResultState {

}

class Idle extends SearchResultState {

}

class SearchResult extends SearchResultState {

  final List<BookSearchResult> results;

  SearchResult(this.results);
}

sealed class BookSearchResult {
  BookSearchResult();
}

class LocalBookSearchResult extends BookSearchResult {
  final String bookId;
  final String title;
  final String author;
  final String? thumbnailAddress;
  final String isbn;

  LocalBookSearchResult({
    required this.bookId,
    required this.title,
    required this.author,
    required this.thumbnailAddress,
    required this.isbn,
  });

  LocalBookSearchResult.fromBook(Book book)
      : bookId = book.id,
        title = book.title,
        author = book.author,
        thumbnailAddress = book.thumbnailAddress,
        isbn = book.isbn;
}

class RemoteBookSearchResult extends BookSearchResult {
  final String title;
  final String author;
  final String? thumbnailAddress;
  final String isbn;

  RemoteBookSearchResult({
    required this.title,
    required this.author,
    required this.thumbnailAddress,
    required this.isbn,
  });

  RemoteBookSearchResult.fromBook(Book book)
      : title = book.title,
        author = book.author,
        thumbnailAddress = book.thumbnailAddress,
        isbn = book.isbn;
}
