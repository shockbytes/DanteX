import 'package:dantex/models/book_state.dart';
import 'package:dantex/repositories/book_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utilities.dart';

void main() async {
  final mockDatabase = await getMockDatabase();
  final bookRef = mockDatabase.ref(BookRepository.booksPath('userId'));

  group('Given a book repository', () {
    final bookRepository = BookRepository(bookDatabase: bookRef);
    group('When the repository has books', () {
      test(
        'Then booksForState returns the books in the current state',
        () async {
          final books =
              await bookRepository.booksForState(BookState.reading).first;
          expect(books, hasLength(1));
          expect(
            books.every((book) => book.state == BookState.reading),
            isTrue,
          );
        },
      );
    });
    test(
      'Then addBookToState adds a book to the database with the correct state',
      () async {
        final book = getMockBook();
        await bookRepository.addBookToState(book, BookState.reading);
        final books =
            await bookRepository.booksForState(BookState.reading).first;
        expect(books, hasLength(2));
      },
    );
    test('Then overwrite books replaces the books in the database', () async {
      final book = getMockBook();
      await bookRepository.overwriteBooks([book]);
      final readingBooks =
          await bookRepository.booksForState(BookState.reading).first;
      expect(readingBooks, hasLength(1));
      final readLaterBooks =
          await bookRepository.booksForState(BookState.readLater).first;
      expect(readLaterBooks, hasLength(0));
      final readBooks =
          await bookRepository.booksForState(BookState.read).first;
      expect(readBooks, hasLength(0));
    });
    test('Then merge books adds any books with a different ISBN', () async {
      final book1 = getMockBook();
      final book2 = getMockBook(isbn: 'isbn2');
      final book3 = getMockBook();
      await bookRepository.overwriteBooks([book1]);
      await bookRepository.mergeBooks([book2, book3]);
      final readingBooks =
          await bookRepository.booksForState(BookState.reading).first;
      expect(readingBooks, hasLength(2));
    });
    test('Then update positions updates the positions of the books', () async {
      final book1 = getMockBook(position: 1, id: '1');
      final book2 = getMockBook(position: 2, id: '2');
      final book3 = getMockBook(position: 3, id: '3');
      await bookRepository.overwriteBooks([book1, book2, book3]);
      await bookRepository.updatePositions([
        book2,
        book3,
        book1,
      ]);
      final readingBooks =
          await bookRepository.booksForState(BookState.reading).first;
      expect(readingBooks, hasLength(3));
      expect(readingBooks[0].position, 2);
      expect(readingBooks[1].position, 0);
      expect(readingBooks[2].position, 1);
    });
  });
}
