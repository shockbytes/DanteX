import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/search_criteria.dart';
import 'package:dantex/src/data/bookdownload/book_downloader.dart';
import 'package:dantex/src/data/bookdownload/entity/book_suggestion.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  String query = '';

  final int _minQueryLength = 3;

  final BookRepository _repository;
  final BookDownloader _bookDownloader;

  SearchBloc(
    this._repository,
    this._bookDownloader,
  );

  final BehaviorSubject<List<BookSearchResult>> _searchResultSubject = BehaviorSubject.seeded([]);

  Stream<List<BookSearchResult>> get searchResults => _searchResultSubject.stream;

  void onQueryChanged(String query) async {
    if (query.length < _minQueryLength) {
      return;
    }

    this.query = query;

    List<BookSearchResult> books =
        (await _repository.search(_buildCriteria(query)).first) // TODO Replace with Future in Repository class.
            .map(LocalBookSearchResult.fromBook)
            .toList();

    _searchResultSubject.add(books);
  }

  void performOnlineSearch() async {
    // TODO Perform online search with query

    BookSuggestion suggestion = await _bookDownloader.downloadBook(query);

    List<BookSearchResult> results = [
      RemoteBookSearchResult.fromBook(suggestion.target),
      ...suggestion.suggestions.map(RemoteBookSearchResult.fromBook),
    ];

    _searchResultSubject.add(results);
  }

  SearchCriteria _buildCriteria(String query) {
    return SimpleQuerySearchCriteria(query);
  }
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
