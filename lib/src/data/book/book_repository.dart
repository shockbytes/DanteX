import 'package:dantex/src/core/book_core.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';

abstract class BookRepository {
  Stream<List<Book>> getBooksForState(BookState state);

  Stream<List<Book>> listenAllBooks();

  Future<List<Book>> getAllBooks();

  Future<Book> getBook(BookId id);

  Future<void> create(Book book);

  Future<void> update(Book book);

  Future<void> delete(BookId id);

  Future<void> updateCurrentPage(BookId bookId, int currentPage);

  Stream<List<Book>> search(SearchCriteria criteria);
}
