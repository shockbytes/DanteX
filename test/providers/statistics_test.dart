import 'package:dantex/models/book_state.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/providers/statistics.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utilities.dart';

void main() {
  group('Given a bookCountsProvider', () {
    group('When the allBooksProvider has data', () {
      test('Then the correct book counts are returned', () async {
        final mockBooks = List.generate(
          5,
          (index) => getMockBook().copyWith(
            id: 'book-$index',
            state: index == 0
                ? BookState.wishlist
                : index == 1
                    ? BookState.readLater
                    : index == 2
                        ? BookState.reading
                        : BookState.read,
          ),
        );
        final container = createContainer(
          overrides: [
            allBooksProvider.overrideWith((ref) => Stream.value(mockBooks)),
          ],
        );
        final subscription = container.listen(
          bookCountsProvider,
          (_, __) {},
        );
        await container.pump();

        final stats = subscription.read();
        expect(stats, (readLaterCount: 1, readingCount: 1, readCount: 2));
      });
    });
    group('When the allBooksDataProvider has an error', () {
      test('Then zero book counts are returned', () async {
        final container = createContainer(
          overrides: [
            allBooksProvider.overrideWith((ref) => Stream.error('error')),
          ],
        );
        final subscription = container.listen(
          bookCountsProvider,
          (_, __) {},
        );
        await container.pump();

        final stats = subscription.read();
        expect(stats, zeroBookCount);
      });
    });
  });

  group('Given a pageCountsProvider', () {
    group('When the allBooksProvider has data', () {
      test('Then the correct page counts are returned', () async {
        final mockBooks = List.generate(
          5,
          (index) => getMockBook().copyWith(
            id: 'book-$index',
            state: index == 0
                ? BookState.wishlist
                : index == 1
                    ? BookState.readLater
                    : index == 2
                        ? BookState.reading
                        : BookState.read,
            pageCount: 10,
          ),
        );
        final container = createContainer(
          overrides: [
            allBooksProvider.overrideWith((ref) => Stream.value(mockBooks)),
          ],
        );
        final subscription = container.listen(
          pageCountsProvider,
          (_, __) {},
        );
        await container.pump();

        final stats = subscription.read();
        expect(stats, (pagesWaiting: 10, pagesRead: 20));
      });
    });
    group('When the allBooksDataProvider has an error', () {
      test('Then zero page counts are returned', () async {
        final container = createContainer(
          overrides: [
            allBooksProvider.overrideWith((ref) => Stream.error('error')),
          ],
        );
        final subscription = container.listen(
          pageCountsProvider,
          (_, __) {},
        );
        await container.pump();

        final stats = subscription.read();
        expect(stats, zeroPageCount);
      });
    });
  });
}
