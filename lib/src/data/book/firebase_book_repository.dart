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
    var newRef = _rootRef().push();

    var data = book.copyWith(newId: newRef.key!).toMap();

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
        Map<String, dynamic> data =
            event.snapshot.value as Map<String, dynamic>;

        return data
            .map(
              (key, value) {
                Book bookValue =
                    BookExtension.fromMap(value as Map<String, dynamic>);
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
          (snapshot) =>
              BookExtension.fromMap(snapshot.value as Map<String, dynamic>),
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
    Book currentBook = await getBook(bookId);
    return update(currentBook.copyWith(newCurrentPage: currentPage));
  }

  DatabaseReference _rootRef() {
    // At this point we can assume that the customer is already logged in, even as anonymous user
    var user = _fbAuth.currentUser!.uid;
    return _fbDb.ref('users/$user/');
  }
}
