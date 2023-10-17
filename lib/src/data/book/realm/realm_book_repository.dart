import 'package:dantex/src/core/book_core.dart';
import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_label.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/data/book/realm/realm_book.dart';
import 'package:realm/realm.dart';

class RealmBookRepository implements BookRepository {

  /* TODO Inject this
    final Realm _realm = Realm(
    Configuration.local(
      [
        RealmBook.schema,
        RealmBookLabel.schema,
        RealmPageRecord.schema,
      ],
      schemaVersion: 9, // 9 is the current schema version of the old app
    ),
  );
   */

  final Realm _realm;

  RealmBookRepository(this._realm);

  @override
  Future<void> create(Book book) {
    // Not required.
    throw UnimplementedError();
  }

  @override
  Future<void> delete(BookId id) {
    // Not required.
    throw UnimplementedError();
  }

  @override
  Stream<List<Book>> listenAllBooks() {
    // Not required.
    throw UnimplementedError();
  }

  @override
  Future<Book> getBook(BookId id) {
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
                    bookId: rbl.bookId.toString(),
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
    // TODO Check this
    return true;
  }

  bool _hasRealmBookLabelRequiredData(RealmBookLabel bookLabel) {
    // TODO Check this
    return true;
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
  Future<void> updateCurrentPage(BookId bookId, int currentPage) {
    // Not required.
    throw UnimplementedError();
  }
}
