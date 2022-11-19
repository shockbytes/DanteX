import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/data/bookdownload/book_downloader.dart';
import 'package:dantex/src/data/bookdownload/entity/book_suggestion.dart';
import 'package:rxdart/rxdart.dart';

class AddBookBloc {
  final BookDownloader _downloader;
  final BookRepository _repository;

  final PublishSubject<Book> _onCreatedSubject = PublishSubject();
  Stream<Book> get onBookCreated => _onCreatedSubject.stream;

  AddBookBloc(this._downloader, this._repository);

  Future<BookSuggestion> downloadBook(String query) {
    return _downloader.downloadBook(query);
  }

  void addToWishlist(Book book) {
    _addBook(book, BookState.WISHLIST);
  }

  void addToForLater(Book book) {
    _addBook(book, BookState.READ_LATER);
  }

  void addToReading(Book book) {
    _addBook(book, BookState.READING);
  }

  void addToRead(Book book) {
    _addBook(book, BookState.READ);
  }

  void _addBook(Book book, BookState state) {
    Book updatedBook = book.copyWith(newState: state);
    _repository.create(updatedBook)
        .then((value) => _onCreatedSubject.add(book));
  }

}
