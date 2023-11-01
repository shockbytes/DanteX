import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_label.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/data/book/search_criteria.dart';

abstract class BookRepository {
  Stream<List<Book>> getBooksForState(BookState state);

  Stream<List<Book>> getAllBooks();

  Future<Book> getBook(String id);

  Future<void> create(Book book);

  Future<void> update(Book book);

  Future<void> delete(String id);

  Future<void> updateCurrentPage(String bookId, int currentPage);

  Stream<List<Book>> search(SearchCriteria criteria);

  Future<void> addToWishlist(Book book);

  Future<void> addToForLater(Book book);

  Future<void> addToReading(Book book);

  Future<void> addToRead(Book book);

  Future<void> addLabelToBook(String bookId, BookLabel label);

  Future<void> removeLabelFromBook(String bookId, String labelId);
}
