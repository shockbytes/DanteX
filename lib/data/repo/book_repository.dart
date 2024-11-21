import 'package:dantex/data/book/book.dart';
import 'package:dantex/data/book/book_state.dart';
import 'package:firebase_database/firebase_database.dart';

class BookRepository {
  const BookRepository({required DatabaseReference bookDatabase})
      : _bookDatabase = bookDatabase;
  final DatabaseReference _bookDatabase;
  static String booksPath(String uid) => 'users/$uid/books';
  static String bookPath(String uid, String bookId) =>
      'users/$uid/books/$bookId';

  Stream<List<Book>> booksForState(BookState bookState) {
    return _bookDatabase.onValue.map((event) {
      switch (event.type) {
        case DatabaseEventType.childAdded:
        case DatabaseEventType.childRemoved:
        case DatabaseEventType.childChanged:
        case DatabaseEventType.childMoved:
          // No need to handle these case.
          break;
        case DatabaseEventType.value:
          final data = event.snapshot.toMap();

          if (data == null) {
            return [];
          }

          final books = data.values
              .map(
                (value) {
                  final bookMap =
                      (value as Map<dynamic, dynamic>).cast<String, dynamic>();
                  return Book.fromJson(bookMap);
                },
              )
              .where((book) => book.state == bookState)
              .toList();

          return books;
      }
      return [];
    });
  }

  Future<void> addBookToState(Book book, BookState bookState) async {
    final bookId = _bookDatabase.push().key;
    if (bookId == null) {
      throw Exception('Failed to generate book id');
    }

    final bookMap = book.toJson();
    bookMap['state'] = bookState.name;

    await _bookDatabase.child(bookId).set(bookMap);
  }

  Future<void> clearBooks() async {
    await _bookDatabase.remove();
  }
}

extension on DataSnapshot {
  Map<String, dynamic>? toMap() {
    return (value != null) ? (value! as Map<dynamic, dynamic>).cast() : null;
  }
}
