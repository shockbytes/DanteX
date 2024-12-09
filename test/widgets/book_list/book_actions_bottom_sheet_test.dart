import 'package:dantex/models/book_state.dart';
import 'package:dantex/providers/repository.dart';
import 'package:dantex/repositories/book_repository.dart';
import 'package:dantex/widgets/book_list/book_actions_bottom_sheet.dart';
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

  group('Given a BookActionsBottomSheet', () {
    group('When the book state is readLater', () {
      patrolWidgetTest(
        'Then the move to read later action is not shown',
        ($) async {
          final book = getMockBook(state: BookState.readLater);
          await $.pumpWidget(
            MaterialApp(
              home: Card(
                child: BookActionsBottomSheet(book: book),
              ),
            ),
          );

          expect($(#move_to_read_later), findsNothing);
        },
      );
    });
    group('When the book state is reading', () {
      patrolWidgetTest(
        'Then the move to reading action is not shown',
        ($) async {
          final book = getMockBook(state: BookState.reading);
          await $.pumpWidget(
            MaterialApp(
              home: Card(
                child: BookActionsBottomSheet(book: book),
              ),
            ),
          );

          expect($(#move_to_reading), findsNothing);
        },
      );
    });
    group('When the book state is read', () {
      patrolWidgetTest(
        'Then the move to read action is not shown',
        ($) async {
          final book = getMockBook(state: BookState.read);
          await $.pumpWidget(
            MaterialApp(
              home: Card(
                child: BookActionsBottomSheet(book: book),
              ),
            ),
          );

          expect($(#move_to_read), findsNothing);
        },
      );
    });
    group('When the delete action is tapped', () {
      patrolWidgetTest(
        'Then the book is deleted',
        ($) async {
          final book = getMockBook(id: '-NrxXubOxfZs_7WXU5dr');
          await $.pumpWidget(
            ProviderScope(
              overrides: [
                bookRepositoryProvider.overrideWith((ref) => bookRepository),
              ],
              child: MaterialApp(
                home: Card(
                  child: BookActionsBottomSheet(book: book),
                ),
              ),
            ),
          );
          await $.pumpAndSettle();

          await $(#book_action_delete).tap();
          final allBooks = await bookRepository.allBooks().first;
          expect(allBooks.map((b) => b.id), isNot(contains(book.id)));
        },
      );
    });
  });
}
