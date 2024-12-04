import 'package:dantex/models/book_state.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/repositories/book_repository.dart';
import 'package:dantex/widgets/book_list/book_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../test_utilities.dart';

void main() async {
  EasyLocalization.logger.enableBuildModes = [];
  final mockDatabase = await getMockDatabase();
  final bookRef = mockDatabase.ref(BookRepository.booksPath('userId'));
  final bookRepository = BookRepository(bookDatabase: bookRef);
  final book = getMockBook(state: BookState.readLater);
  await bookRepository.clearBooks();

  group('Given a BookList widget', () {
    group('When there are no books for the current state', () {
      patrolWidgetTest(
        'Then the NoBooksFound widget is shown',
        ($) async {
          await $.pumpWidget(
            ProviderScope(
              overrides: [
                bookRepositoryProvider.overrideWith((ref) => bookRepository),
              ],
              child: const MaterialApp(
                home: BookList(bookState: BookState.readLater),
              ),
            ),
          );

          await $.pumpAndSettle();
          expect($(#no_readLater_books_found), findsOneWidget);
        },
      );
    });
    group('When there are books for the current state', () {
      patrolWidgetTest(
        'Then the BookListCard widget is shown',
        ($) async {
          await bookRepository.addBook(book);

          await $.pumpWidget(
            ProviderScope(
              overrides: [
                bookRepositoryProvider.overrideWith((ref) => bookRepository),
              ],
              child: const MaterialApp(
                home: BookList(bookState: BookState.readLater),
              ),
            ),
          );

          await $.pumpAndTrySettle();
          expect($(#book_readLater_list), findsOneWidget);
        },
      );
    });
  });
}
