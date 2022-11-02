import 'package:dantex/com.shockbytes.dante/core/book_core.dart';
import 'package:dantex/com.shockbytes.dante/data/book/entity/book.dart';
import 'package:dantex/com.shockbytes.dante/data/book/entity/book_state.dart';

abstract class BookRepository {
  Stream<List<Book>> getBooksForState(BookState state);

  Stream<List<Book>> getAllBooks();

  Future<Book> getBook(BookId id);

  Future<void> create(Book book);

  Future<void> update(Book book);

  Future<void> delete(BookId id);

  Future<void> updateCurrentPage(BookId bookId, int currentPage);

  Stream<List<Book>> search(SearchCriteria criteria);
}
