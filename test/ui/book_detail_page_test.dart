import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_label.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/providers/book.dart';
import 'package:dantex/src/ui/book/book_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Book details are shown correctly', (tester) async {
    final book = _getTestBook();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookProvider('book-id').overrideWith(
            (provider) => book,
          ),
        ],
        child: const MaterialApp(
          home: BookDetailPage(id: 'book-id'),
        ),
      ),
    );

    final bookDetailTitle = find.byWidgetPredicate(
      (widget) =>
          widget.key == const ValueKey('book-detail-app-bar-title') &&
          widget is Text &&
          widget.data == book.title,
      description: 'Book title is shown correctly',
    );

    expect(
      bookDetailTitle,
      findsOneWidget,
    );

    final bookInfo = find.byKey(const ValueKey('book-detail-info'));
    expect(bookInfo, findsOneWidget);

    final bookProgress =
        find.byKey(const ValueKey('book-detail-progress-indicator'));
    expect(bookProgress, findsOneWidget);

    final bookActions = find.byKey(const ValueKey('book-detail-actions'));
    expect(bookActions, findsOneWidget);

    final addBookButton = find.byKey(const ValueKey('book-detail-add-label'));
    expect(addBookButton, findsOneWidget);

    final bookLabels = find.byKey(const ValueKey('book-detail-labels'));
    expect(bookLabels, findsOneWidget);

    final fantasyLabel = find.byKey(const ValueKey('book-label-chip-Fantasy'));
    expect(fantasyLabel, findsOneWidget);
  });

  testWidgets('Progress bar is hidden when page count it 0', (tester) async {
    final book = _getTestBook(pageCount: 0);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookProvider('book-id').overrideWith(
            (provider) => book,
          ),
        ],
        child: const MaterialApp(
          home: BookDetailPage(id: 'book-id'),
        ),
      ),
    );

    final bookProgress =
        find.byKey(const ValueKey('book-detail-progress-indicator'));
    // Because the page count is 0 for this book, we shouldn't be showing the progress indicator
    expect(bookProgress, findsNothing);
  });
}

Book _getTestBook({int? pageCount}) {
  return Book(
    id: 'book-id',
    title: 'The Hobbit',
    subTitle: 'Or, There and Back Again',
    author: 'John Ronald Reuel Tolkien',
    state: BookState.readLater,
    pageCount: pageCount ?? 100,
    currentPage: 0,
    publishedDate: '2012-09-18',
    position: 0,
    isbn: '9780547928241',
    thumbnailAddress:
        'http://books.google.com/books/content?id=RXPjuQAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api',
    startDate: 0,
    endDate: 0,
    wishlistDate: 0,
    language: 'en',
    rating: 0,
    notes: '',
    summary: 'TODO Load Description',
    labels: [
      BookLabel(bookId: 'book-id', title: 'Fantasy', hexColor: '#FFC0CB'),
    ],
  );
}
