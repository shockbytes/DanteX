import 'package:dantex/providers/auth.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/providers/book_label.dart';
import 'package:dantex/providers/firebase.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utilities.dart';

void main() async {
  group('Given an allBookLabelsProvider', () {
    group('When the repo has book labels', () {
      test('Then the provider returns all book labels', () async {
        final mockDatabase = await getMockDatabase();

        final mockUser = MockUser(
          uid: 'userId',
          email: 'bob@somedomain.com',
          displayName: 'Bob',
        );

        final container = createContainer(
          overrides: [
            authStateChangesProvider.overrideWith(
              (ref) => Stream.value(mockUser),
            ),
            firebaseDatabaseProvider.overrideWithValue(mockDatabase),
          ],
        );

        final subscription = container.listen(
          allBookLabelsProvider.future,
          (_, __) {},
        );
        await container.pump();

        final labels = await subscription.read();
        expect(labels, hasLength(1));
      });
    });
  });
  group('Given a booksWithLabelProvider', () {
    group("When the label doesn't exist in the repo", () {
      test('Then the provider returns an empty list', () async {
        final mockBook = getMockBook().copyWith(
          labels: [
            getMockBookLabel().copyWith(id: 'book-label-id'),
          ],
        );
        final container = createContainer(
          overrides: [
            allBooksProvider.overrideWith((ref) => Stream.value([mockBook])),
          ],
        );
        final subscription = container.listen(
          booksWithLabelProvider('non-existent-label-id'),
          (_, __) {},
        );
        await container.pump();

        final books = subscription.read();
        expect(books, isEmpty);
      });
    });
    group('When the label does exist in the repo', () {
      test('Then the provider returns the books with that label', () async {
        final mockBook = getMockBook().copyWith(
          labels: [
            getMockBookLabel().copyWith(id: 'book-label-id'),
          ],
        );
        final container = createContainer(
          overrides: [
            allBooksProvider.overrideWith((ref) => Stream.value([mockBook])),
          ],
        );
        final subscription = container.listen(
          booksWithLabelProvider('book-label-id'),
          (_, __) {},
        );
        await container.pump();

        final books = subscription.read();
        expect(books, hasLength(1));
      });
    });
    group('When the allBooksProvider throws and exception', () {
      test('Then the provider returns an empty list', () async {
        final container = createContainer(
          overrides: [
            allBooksProvider.overrideWith((ref) => throw Exception()),
          ],
        );
        final subscription = container.listen(
          booksWithLabelProvider('book-label-id'),
          (_, __) {},
        );
        await container.pump();

        final books = subscription.read();
        expect(books, isEmpty);
      });
    });
  });
}
