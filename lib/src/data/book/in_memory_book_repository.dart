import 'package:dantex/src/core/book_core.dart';
import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:rxdart/rxdart.dart';

@Deprecated('For test cases only!')
class InMemoryBookRepository implements BookRepository {
  final List<Book> _books = List.empty(growable: true);

  final BehaviorSubject<List<Book>> _bookSubject = BehaviorSubject();

  @override
  Stream<List<Book>> getBooksForState(BookState state) {
    return listenAllBooks().map(
      (books) => books
          .where(
            (book) => book.state == state,
          )
          .toList(),
    );
  }

  @override
  Future<void> create(Book book) async {
    _books.add(book);
    _bookSubject.add(_books);
  }

  @override
  Future<void> delete(BookId id) {
    throw UnimplementedError('Not required');
  }

  @override
  Stream<List<Book>> listenAllBooks() {
    return _bookSubject.stream;
  }

  @override
  Future<List<Book>> getAllBooks() async {
    return _bookSubject.value;
  }

  @override
  Future<Book> getBook(id) {
    throw UnimplementedError('Not required');
  }

  @override
  Stream<List<Book>> search(SearchCriteria criteria) {
    return listenAllBooks().map(
      (books) => books.where(criteria.fulfillsCriteria).toList(),
    );
  }

  @override
  Future<void> update(Book book) {
    throw UnimplementedError('Not required');
  }

  @override
  Future<void> updateCurrentPage(bookId, int currentPage) {
    throw UnimplementedError('Not required');
  }
}
