import 'dart:convert';
import 'dart:io';

import 'package:dantex/data/book/book_state.dart';
import 'package:dantex/providers/auth.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/providers/database.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

import 'util.dart';

void main() async {
  group('Given a booksForStateProvider', () {
    group('When the bookState is reading', () {
      test('Then the provider returns the books with state reading', () async {
        final mockDataString =
            await File('assets/data/test-repository.json').readAsString();
        final mockData = json.decode(mockDataString);

        final mockDatabase = MockFirebaseDatabase.instance;
        await mockDatabase.ref().set(mockData);

        final mockUser = MockUser(
          uid: 'userId',
          email: 'bob@somedomain.com',
          displayName: 'Bob',
        );

        final container = createContainer(
          overrides: [
            firebaseDatabaseProvider.overrideWithValue(mockDatabase),
            authStateChangesProvider.overrideWith(
              (ref) => Stream.value(mockUser),
            ),
          ],
        );

        final subscription = container.listen(
          booksForStateProvider(BookState.reading).future,
          (_, __) {},
        );

        final books = await subscription.read();
        expect(books, hasLength(1));
        expect(books.every((book) => book.state == BookState.reading), isTrue);
      });
    });
  });
}
