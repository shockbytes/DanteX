import 'package:dantex/models/book_state.dart';
import 'package:dantex/ui/book_list/book_list_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../test_utilities.dart';

void main() async {
  EasyLocalization.logger.enableBuildModes = [];
  group('Given a BookListCard', () {
    group('When tapping on the more actions button', () {
      patrolWidgetTest(
        'Then the book actions bottom sheet is shown',
        ($) async {
          final book = getMockBook();
          await $.pumpWidget(
            MaterialApp(
              home: BookListCard(book: book),
            ),
          );

          await $(#more_actions_button).tap();
          expect($(#book_actions_bottom_sheet), findsOneWidget);
        },
      );
    });
    group('When the book state is reading', () {
      patrolWidgetTest(
        'Then the progress indicator is shown',
        ($) async {
          final book = getMockBook(state: BookState.reading);
          await $.pumpWidget(
            MaterialApp(
              home: BookListCard(book: book),
            ),
          );

          expect($(ValueKey('book_${book.id}_progress')), findsOneWidget);
        },
      );
    });
  });
}
