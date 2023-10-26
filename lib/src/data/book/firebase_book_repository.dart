import 'package:dantex/src/core/book_core.dart';
import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/util/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseBookRepository implements BookRepository {
  final FirebaseAuth _fbAuth;
  final FirebaseDatabase _fbDb;

  FirebaseBookRepository(this._fbAuth, this._fbDb);

  @override
  Future<void> create(Book book) {
    final newRef = _rootRef().push();

    final data = book.copyWith(newId: newRef.key!).toMap();

    return newRef.set(data);
  }

  @override
  Future<void> delete(BookId id) {
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
                final Map<String, dynamic> bookData =
                    (value as Map<dynamic, dynamic>).cast();
                final Book bookValue = BookExtension.fromMap(bookData);
                return MapEntry(key, bookValue);
              },
            )
            .values
            .toList();
      },
    );
  }

  @override
  Future<Book> getBook(BookId id) {
    return _rootRef().child(id).get().then(
      (snapshot) {
        final Map<String, dynamic>? data = snapshot.toMap();

        if (data == null) {
          throw Exception('Cannot read book with id $id as it does not exist!');
        }

        return BookExtension.fromMap(data);
      },
    );
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
  Future<void> updateCurrentPage(BookId bookId, int currentPage) async {
    final Book currentBook = await getBook(bookId);
    return update(currentBook.copyWith(newCurrentPage: currentPage));
  }

  DatabaseReference _rootRef() {
    // At this point we can assume that the customer is already logged in, even as anonymous user
    final user = _fbAuth.currentUser!.uid;
    return _fbDb.ref('users/$user/');
  }
}

extension DataSnapshotExtension on DataSnapshot {
  Map<String, dynamic>? toMap() {
    return (value != null) ? (value as Map<dynamic, dynamic>).cast() : null;
  }
}
