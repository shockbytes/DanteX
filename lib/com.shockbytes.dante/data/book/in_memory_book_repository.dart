import 'package:dantex/com.shockbytes.dante/core/book_core.dart';
import 'package:dantex/com.shockbytes.dante/data/book/book_repository.dart';
import 'package:dantex/com.shockbytes.dante/data/book/entity/book.dart';
import 'package:dantex/com.shockbytes.dante/data/book/entity/book_state.dart';

class InMemoryBookRepository implements BookRepository {
  List<Book> _books = List.empty(growable: true);

  @override
  Stream<List<Book>> getBooksForState(BookState state) {
    return getAllBooks().map(
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
  }

  @override
  Future<void> delete(BookId id) {
    throw UnimplementedError('Not required');
  }

  @override
  Stream<List<Book>> getAllBooks() {
    return Stream.value(_books);
  }

  @override
  Future<Book> getBook(id) {
    throw UnimplementedError('Not required');
  }

  @override
  Stream<List<Book>> search(SearchCriteria criteria) {
    return getAllBooks().map(
      (books) => books
          .where(criteria.fulfillsCriteria)
          .toList(),
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
