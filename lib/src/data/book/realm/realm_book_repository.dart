import 'package:dantex/src/core/book_core.dart';
import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_label.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/data/book/realm/realm_book.dart';
import 'package:realm/realm.dart';

class RealmBookRepository implements BookRepository {

  final Realm _realm;

  RealmBookRepository(this._realm);

  @override
  Future<void> create(Book book) {
    // Not required.
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id) {
    // Not required.
    throw UnimplementedError();
  }

  @override
  Stream<List<Book>> listenAllBooks() {
    // Not required.
    throw UnimplementedError();
  }

  @override
  Future<Book> getBook(String id) {
    // Not required.
    throw UnimplementedError();
  }

  @override
  Future<List<Book>> getAllBooks() async {
    return _realm
        .all<RealmBook>()
        .where(_hasRealmBookRequiredData)
        .map(
          (rb) => Book(
            id: rb.id.toString(),
            title: rb.title!,
            subTitle: rb.subTitle!,
            author: rb.author!,
            state: BookState.values[rb.ordinalState],
            pageCount: rb.pageCount,
            currentPage: rb.currentPage,
            publishedDate: rb.publishedDate!,
            position: rb.position,
            isbn: rb.isbn!,
            thumbnailAddress: rb.thumbnailAddress,
            startDate: rb.startDate,
            endDate: rb.endDate,
            wishlistDate: rb.wishlistDate,
            language: rb.language!,
            rating: rb.rating,
            notes: rb.notes,
            summary: rb.summary,
            labels: rb.labels
                .where(_hasRealmBookLabelRequiredData)
                .map(
                  (rbl) => BookLabel(
                    id: rbl.bookId.toString(),
                    title: rbl.title!,
                    hexColor: rbl.hexColor!,
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  bool _hasRealmBookRequiredData(RealmBook book) {
    return
      book.id > -1 &&
      book.title != null &&
      book.subTitle != null &&
      book.author != null &&
      book.publishedDate != null &&
      book.language != null;
  }

  bool _hasRealmBookLabelRequiredData(RealmBookLabel bookLabel) {
    return bookLabel.bookId > -1 &&
        bookLabel.title?.isNotEmpty == true &&
        bookLabel.hexColor?.isNotEmpty == true;
  }

  @override
  Stream<List<Book>> getBooksForState(BookState state) {
    // Not required.
    throw UnimplementedError();
  }

  @override
  Stream<List<Book>> search(SearchCriteria criteria) {
    // Not required.
    throw UnimplementedError();
  }

  @override
  Future<void> update(Book book) {
    // Not required.
    throw UnimplementedError();
  }

  @override
  Future<void> updateCurrentPage(String bookId, int currentPage) {
    // Not required.
    throw UnimplementedError();
  }

  @override
  Future<void> addLabelToBook(String bookId, BookLabel label) {
    // Not required.
    throw UnimplementedError();
  }

  @override
  Future<void> addToForLater(Book book) {
    // Not required.
    throw UnimplementedError();
  }

  @override
  Future<void> addToRead(Book book) {
    // Not required.
    throw UnimplementedError();
  }

  @override
  Future<void> addToReading(Book book) {
    // Not required.
    throw UnimplementedError();
  }

  @override
  Future<void> addToWishlist(Book book) {
    // Not required.
    throw UnimplementedError();
  }

  @override
  Future<void> removeLabelFromBook(String bookId, String labelId) {
    // Not required.
    throw UnimplementedError();
  }
}
