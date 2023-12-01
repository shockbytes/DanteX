import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_label.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/data/book/search_criteria.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseBookRepository implements BookRepository {
  final FirebaseAuth _fbAuth;
  final FirebaseDatabase _fbDb;

  final BehaviorSubject<List<Book>> _booksSubject = BehaviorSubject();

  FirebaseBookRepository(this._fbAuth, this._fbDb) {
    _setupBooksSubject();
  }

  void _setupBooksSubject() {
    _booksRef().onValue.listen(
      (DatabaseEvent event) {
        switch (event.type) {
          case DatabaseEventType.childAdded:
          case DatabaseEventType.childRemoved:
          case DatabaseEventType.childChanged:
          case DatabaseEventType.childMoved:
            // No need to handle these case.
            break;
          case DatabaseEventType.value:
            final Map<String, dynamic>? data = event.snapshot.toMap();

            if (data == null) {
              return;
            }

            final List<Book> books = data.values.map(
              (value) {
                final Map<String, dynamic> bookMap =
                    (value as Map<dynamic, dynamic>).cast();
                return Book.fromJson(bookMap);
              },
            ).toList();

            _booksSubject.add(books);
            break;
        }
      },
    );
  }

  @override
  Future<void> create(Book book) {
    final newRef = _booksRef().push();

    final data = book.copyWith(id: newRef.key!).toJson();

    return newRef.set(data);
  }

  @override
  Future<void> delete(String id) {
    return _booksRef().child(id).remove();
  }

  @override
  Stream<List<Book>> getAllBooks() {
    return _booksSubject.stream;
  }

  @override
  Stream<Book> getBook(String id) {
    return _booksRef().child(id).onValue.map((DatabaseEvent event) {
      final Map<String, dynamic>? data = event.snapshot.toMap();

      if (data == null) {
        throw Exception('Cannot read book with id $id as it does not exist!');
      }

      return Book.fromJson(data);
    });
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
    return _booksRef().child(book.id).set(book.toJson());
  }

  @override
  Future<void> updateCurrentPage(String bookId, int currentPage) async {
    final bookSnapshot = await _booksRef().child(bookId).get();
    final bookMap = bookSnapshot.child(bookId).toMap();

    if (bookMap == null) {
      throw Exception('Cannot read book with id $bookId as it does not exist!');
    }
    final currentBook = Book.fromJson(bookMap);

    return update(currentBook.copyWith(currentPage: currentPage));
  }

  DatabaseReference _booksRef() {
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
    final bookSnapshot = await _booksRef().child(bookId).get();
    final bookMap = bookSnapshot.child(bookId).toMap();

    if (bookMap == null) {
      throw Exception('Cannot read book with id $bookId as it does not exist!');
    }
    final book = Book.fromJson(bookMap);

    return update(
      book.copyWith(
        labels: book.labels..add(label),
      ),
    );
  }

  @override
  Future<void> removeLabelFromBook(String bookId, String labelId) async {
    final bookSnapshot = await _booksRef().child(bookId).get();
    final bookMap = bookSnapshot.child(bookId).toMap();

    if (bookMap == null) {
      throw Exception('Cannot read book with id $bookId as it does not exist!');
    }
    final book = Book.fromJson(bookMap);
    return update(
      book.copyWith(
        labels: book.labels..removeWhere((label) => label.id == labelId),
      ),
    );
  }
}

extension DataSnapshotExtension on DataSnapshot {
  Map<String, dynamic>? toMap() {
    return (value != null) ? (value as Map<dynamic, dynamic>).cast() : null;
  }
}
