import 'package:dantex/models/book_state.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/repositories/book_repository.dart';
import 'package:dantex/widgets/add_book/add_book_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../test_utilities.dart';

void main() async {
  // Disable EasyLocalization logs for tests
  EasyLocalization.logger.enableBuildModes = [];
  final book = getMockBook();

  final mockDatabase = await getMockDatabase();
  final bookRef = mockDatabase.ref(BookRepository.booksPath('userId'));
  final bookRepository = BookRepository(bookDatabase: bookRef);

  group('Given an AddBookWidget', () {
    group('When the add_book_to_read_later button is pressed', () {
      patrolWidgetTest(
        'Then the book is added to the read later state',
        ($) async {
          await $.pumpWidget(
            ProviderScope(
              overrides: [
                bookRepositoryProvider.overrideWith((ref) => bookRepository),
              ],
              child: MaterialApp(
                home: AddBookWidget(book: book),
              ),
            ),
          );

          final readLaterBooksBefore = await bookRepository
              .booksForState(
                BookState.readLater,
              )
              .first;
          await $(#add_book_to_read_later).tap();
          final readLaterBooks = await bookRepository
              .booksForState(
                BookState.readLater,
              )
              .first;
          expect(readLaterBooks.length, readLaterBooksBefore.length + 1);
        },
      );
    });
    group('When the add_book_to_reading button is pressed', () {
      patrolWidgetTest(
        'Then the book is added to the reading state',
        ($) async {
          await $.pumpWidget(
            ProviderScope(
              overrides: [
                bookRepositoryProvider.overrideWith((ref) => bookRepository),
              ],
              child: MaterialApp(
                home: AddBookWidget(book: book),
              ),
            ),
          );

          final readingBooksBefore = await bookRepository
              .booksForState(
                BookState.reading,
              )
              .first;
          await $(#add_book_to_reading).tap();
          final readingBooks = await bookRepository
              .booksForState(
                BookState.reading,
              )
              .first;
          expect(readingBooks.length, readingBooksBefore.length + 1);
        },
      );
    });
    group('When the add_book_to_read button is pressed', () {
      patrolWidgetTest(
        'Then the book is added to the read state',
        ($) async {
          await $.pumpWidget(
            ProviderScope(
              overrides: [
                bookRepositoryProvider.overrideWith((ref) => bookRepository),
              ],
              child: MaterialApp(
                home: AddBookWidget(book: book),
              ),
            ),
          );

          final readBooksBefore = await bookRepository
              .booksForState(
                BookState.read,
              )
              .first;
          await $(#add_book_to_read).tap();
          final readBooks = await bookRepository
              .booksForState(
                BookState.read,
              )
              .first;
          expect(readBooks.length, readBooksBefore.length + 1);
        },
      );
    });
    group('When the add_book_to_wishlist button is pressed', () {
      patrolWidgetTest(
        'Then the book is added to the wishlist state',
        ($) async {
          await $.pumpWidget(
            ProviderScope(
              overrides: [
                bookRepositoryProvider.overrideWith((ref) => bookRepository),
              ],
              child: MaterialApp(
                home: AddBookWidget(book: book),
              ),
            ),
          );

          final wishlistBooksBefore = await bookRepository
              .booksForState(
                BookState.wishlist,
              )
              .first;
          await $(#add_book_to_wishlist).tap();
          final wishlistBooks = await bookRepository
              .booksForState(
                BookState.wishlist,
              )
              .first;
          expect(wishlistBooks.length, wishlistBooksBefore.length + 1);
        },
      );
    });
  });
}
