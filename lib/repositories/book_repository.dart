import 'dart:developer';

import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_state.dart';
import 'package:firebase_database/firebase_database.dart';

class BookRepository {
  const BookRepository({required DatabaseReference bookDatabase})
      : _bookDatabase = bookDatabase;

  final DatabaseReference _bookDatabase;

  static String booksPath(String uid) => 'users/$uid/books';

  Stream<List<Book>> allBooks() {
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
          final books = _getBooksFromDataMap(data);
          return books;
      }
      return [];
    });
  }

  Stream<List<Book>> booksForState(BookState bookState) {
    return allBooks().map((books) {
      return books.where((book) => book.state == bookState).toList();
    });
  }

  Future<void> addBookToState(Book book, BookState bookState) async {
    final bookId = _bookDatabase.push().key;
    if (bookId == null) {
      throw Exception('Failed to generate book id');
    }

    final bookMap = book.toJson();
    bookMap['id'] = bookId;
    bookMap['state'] = bookState.name;

    await _bookDatabase.child(bookId).set(bookMap);
  }

  Future<void> clearBooks() async {
    await _bookDatabase.remove();
  }

  Future<void> overwriteBooks(List<Book> books) async {
    await clearBooks();

    for (final book in books) {
      await addBookToState(book, book.state);
    }
  }

  Future<void> mergeBooks(List<Book> books) async {
    // Get the ISBN of each book already in the repository.
    final snapshot = await _bookDatabase.get();
    final bookMap = snapshot.toMap();
    final existingBooks =
        _getBooksFromDataMap(bookMap).map((book) => book.isbn);

    for (final book in books) {
      if (!existingBooks.contains(book.isbn)) {
        await addBookToState(book, book.state);
      }
    }
  }

  Future<void> updatePositions(List<Book> books) async {
    for (var i = 0; i < books.length; i++) {
      books[i] = books[i].copyWith(position: i);
    }

    log('Updated positions to: ${books.map(
      (b) => {
        b.title,
        b.position,
      }.toString(),
    )}');
    // Convert our list of books into a JSON blob that has the book ID as the
    // key for each book entry.
    final bookMap = {
      for (final book in books) book.id: book.toJson(),
    };

    await _bookDatabase.update(bookMap);
  }

  Future<void> addBook(Book book) async {
    return addBookToState(book, book.state);
  }

  Future<void> moveBookToState(String bookId, BookState bookState) async {
    await _bookDatabase.child(bookId).update({'state': bookState.name});
  }

  Future<void> delete(String bookId) async {
    await _bookDatabase.child(bookId).remove();
  }

  Stream<Book?> getBook(String bookId) {
    return _bookDatabase.child(bookId).onValue.map((event) {
      switch (event.type) {
        case DatabaseEventType.childAdded:
        case DatabaseEventType.childRemoved:
        case DatabaseEventType.childChanged:
        case DatabaseEventType.childMoved:
          // No need to handle these case.
          break;
        case DatabaseEventType.value:
          final data = event.snapshot.toMap();
          final book = _getBookFromDataMap(data);
          return book;
      }
      return null;
    });
  }

  Future<void> updateBook(Book book) async {
    await _bookDatabase.child(book.id).update(book.toJson());
  }
}

Book? _getBookFromDataMap(Map<String, dynamic>? data) {
  if (data == null) {
    return null;
  }

  final bookMap = data.cast<String, dynamic>();
  return Book.fromJson(bookMap);
}

List<Book> _getBooksFromDataMap(Map<String, dynamic>? data) {
  if (data == null) {
    return [];
  }

  final books = data.values.map(
    (value) {
      final bookMap = (value as Map<dynamic, dynamic>).cast<String, dynamic>();
      return Book.fromJson(bookMap);
    },
  ).toList();

  return books;
}

extension on DataSnapshot {
  Map<String, dynamic>? toMap() {
    return (value != null) ? (value! as Map<dynamic, dynamic>).cast() : null;
  }
}
