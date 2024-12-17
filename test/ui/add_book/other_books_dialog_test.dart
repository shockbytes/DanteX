import 'package:dantex/ui/add_book/other_books_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../test_utilities.dart';

void main() {
  final book = getMockBook(id: 'book_id');

  group('Given a OtherBooksDialog widget', () {
    group('When tapping on a card', () {
      patrolWidgetTest('Then onTap is called', ($) async {
        var onTapCalled = false;
        await $.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: OtherBooksDialog(
                books: [book],
                onTap: (book) => onTapCalled = true,
              ),
            ),
          ),
        );

        await $(ValueKey('book_${book.id}_search_list_card')).tap();
        expect(onTapCalled, isTrue);
      });
    });
  });
}
