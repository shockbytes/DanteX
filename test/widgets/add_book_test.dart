import 'package:dantex/models/book_state.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/repositories/book_repository.dart';
import 'package:dantex/widgets/add_book.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../test_utilities.dart';
import 'add_book_test.mocks.dart';

@GenerateMocks([
  BookRepository,
])
void main() async {
  // Disable EasyLocalization logs for tests
  EasyLocalization.logger.enableBuildModes = [];
  final book = getMockBook();
  final mockBookRepository = MockBookRepository();

  group('Given an add book widget', () {
    group('When the add_book_to_read_later button is pressed', () {
      patrolWidgetTest(
        'Then the book is added to the read later state',
        ($) async {
          await $.pumpWidget(
            ProviderScope(
              overrides: [
                bookRepositoryProvider
                    .overrideWith((ref) => mockBookRepository),
              ],
              child: MaterialApp(
                home: AddBook(book: book),
              ),
            ),
          );

          await $(#add_book_to_read_later).tap();
          verify(mockBookRepository.addBookToState(book, BookState.readLater))
              .called(1);
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
                bookRepositoryProvider
                    .overrideWith((ref) => mockBookRepository),
              ],
              child: MaterialApp(
                home: AddBook(book: book),
              ),
            ),
          );

          await $(#add_book_to_reading).tap();
          verify(mockBookRepository.addBookToState(book, BookState.reading))
              .called(1);
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
                bookRepositoryProvider
                    .overrideWith((ref) => mockBookRepository),
              ],
              child: MaterialApp(
                home: AddBook(book: book),
              ),
            ),
          );

          await $(#add_book_to_read).tap();
          verify(mockBookRepository.addBookToState(book, BookState.read))
              .called(1);
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
                bookRepositoryProvider
                    .overrideWith((ref) => mockBookRepository),
              ],
              child: MaterialApp(
                home: AddBook(book: book),
              ),
            ),
          );

          await $(#add_book_to_wishlist).tap();
          verify(mockBookRepository.addBookToState(book, BookState.wishlist))
              .called(1);
        },
      );
    });
  });
}
