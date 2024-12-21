import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_state.dart';
import 'package:dantex/models/page_record.dart';
import 'package:dantex/util/data.dart';
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

  Future<void> clearBooks() async {
    await _bookDatabase.remove();
  }

  Future<void> overwriteBooksFromBackup(List<Book> books) async {
    await clearBooks();

    for (final book in books) {
      await addBook(book);
    }
  }

  Future<void> mergeBooksFromBackup(List<Book> books) async {
    // Get the ISBN of each book already in the repository.
    final snapshot = await _bookDatabase.get();
    final bookMap = snapshot.toMap();
    final existingBooks =
        _getBooksFromDataMap(bookMap).map((book) => book.isbn);

    for (final book in books) {
      if (!existingBooks.contains(book.isbn)) {
        await addBook(book);
      }
    }
  }

  Future<void> updatePositions(List<Book> books) async {
    for (var i = 0; i < books.length; i++) {
      books[i] = books[i].copyWith(position: i);
    }

    // Convert our list of books into a JSON blob that has the book ID as the
    // key for each book entry.
    final bookMap = {
      for (final book in books) book.id: book.toJson(),
    };

    await _bookDatabase.update(bookMap);
  }

  /// Adds a new book to the database and returns the newly created book's ID.
  Future<String> addBook(Book book) async {
    final bookId = _bookDatabase.push().key;
    if (bookId == null) {
      throw Exception('Failed to generate book id');
    }

    var updatedBook = book.copyWith(id: bookId);

    // If the book has page records, update the book ID of each page record with
    // the new book ID.
    if (book.pageRecords.isNotEmpty) {
      final pageRecords = book.pageRecords.map((pageRecord) {
        return pageRecord.copyWith(bookId: bookId);
      }).toList();

      updatedBook = updatedBook.copyWith(pageRecords: pageRecords);
    }

    final bookMap = updatedBook.toJson();

    await _bookDatabase.child(bookId).set(bookMap);

    return bookId;
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

  Future<void> setCurrentPage(String bookId, int currentPage) async {
    await _bookDatabase.child(bookId).update({'currentPage': currentPage});
  }

  Future<void> setNotes(String bookId, String notes) async {
    await _bookDatabase.child(bookId).update({'notes': notes});
  }

  Future<void> setRating(String bookId, int rating) async {
    await _bookDatabase.child(bookId).update({'rating': rating});
  }

  Future<void> resetPageRecords(String bookId) async {
    await _bookDatabase.child(bookId).child('pageRecords').remove();
  }

  Future<void> deletePageRecord(Book book, String pageRecordId) async {
    final updatedBook = book.copyWith(
      pageRecords: book.pageRecords
          .where((pageRecord) => pageRecord.id != pageRecordId)
          .toList(),
    );

    await updateBook(updatedBook);
  }

  Future<void> addPageRecord(Book book, PageRecord pageRecord) async {
    final updatedBook = book.copyWith(
      pageRecords: [...book.pageRecords, pageRecord],
    );

    await updateBook(updatedBook);
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
