import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_label.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/data/book/search_criteria.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseBookRepository implements BookRepository {
  final FirebaseAuth _fbAuth;
  final FirebaseDatabase _fbDb;

  FirebaseBookRepository(this._fbAuth, this._fbDb);

  @override
  Future<void> create(Book book) {
    final newRef = _rootRef().push();

    final data = book.copyWith(id: newRef.key!).toJson();

    return newRef.set(data);
  }

  @override
  Future<void> delete(String id) {
    return _rootRef().child(id).remove();
  }

  @override
  Stream<List<Book>> getAllBooks() {
    return _rootRef().onValue.map(
      (DatabaseEvent event) {
        final Map<String, dynamic>? data = event.snapshot.toMap();

        if (data == null) {
          return [];
        }

        return data
            .map(
              (key, value) {
                final Map<String, dynamic> bookMap =
                    (value as Map<dynamic, dynamic>).cast();
                final Book bookValue = Book.fromJson(bookMap);
                return MapEntry(key, bookValue);
              },
            )
            .values
            .toList();
      },
    );
  }

  @override
  Future<Book> getBook(String id) async {
    final bookSnapshot = await _rootRef().child(id).get();
    final bookMap = bookSnapshot.child(id).toMap();

    if (bookMap == null) {
      throw Exception('Cannot read book with id $id as it does not exist!');
    }

    return Book.fromJson(bookMap);
  }

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
  Stream<List<Book>> search(SearchCriteria criteria) {
    return getAllBooks().map(
      (books) => books.where(criteria.fulfillsCriteria).toList(),
    );
  }

  @override
  Future<void> update(Book book) {
    return _rootRef().child(book.id).set(book);
  }

  @override
  Future<void> updateCurrentPage(String bookId, int currentPage) async {
    final Book currentBook = await getBook(bookId);
    return update(currentBook.copyWith(currentPage: currentPage));
  }

  DatabaseReference _rootRef() {
    // At this point we can assume that the customer is already logged in, even as anonymous user
    final user = _fbAuth.currentUser!.uid;
    return _fbDb.ref('users/$user/books');
  }

  @override
  Future<void> addToWishlist(Book book) {
    return _addBook(book, BookState.wishlist);
  }

  @override
  Future<void> addToForLater(Book book) {
    return _addBook(
      book.copyWith(
        forLaterDate: DateTime.now(),
        startDate: null,
        endDate: null,
      ),
      BookState.readLater,
    );
  }

  @override
  Future<void> addToReading(Book book) {
    return _addBook(
      book.copyWith(startDate: DateTime.now(), endDate: null),
      BookState.reading,
    );
  }

  @override
  Future<void> addToRead(Book book) {
    return _addBook(
      book.copyWith(endDate: DateTime.now()),
      BookState.read,
    );
  }

  Future<void> _addBook(Book book, BookState bookState) {
    final Book updatedBook = book.copyWith(state: bookState);
    return create(updatedBook);
  }

  @override
  Future<void> addLabelToBook(String bookId, BookLabel label) async {
    final book = await getBook(bookId);
    book.addLabel(label);
    return update(book);
  }

  @override
  Future<void> removeLabelFromBook(String bookId, String labelId) async {
    final book = await getBook(bookId);
    book.removeLabel(labelId);
    return update(book);
  }
}

extension DataSnapshotExtension on DataSnapshot {
  Map<String, dynamic>? toMap() {
    return (value != null) ? (value as Map<dynamic, dynamic>).cast() : null;
  }
}
