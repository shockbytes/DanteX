import 'package:dantex/models/user.dart';
import 'package:dantex/providers/auth.dart';
import 'package:dantex/providers/firebase.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utilities.dart';

void main() {
  group('Given a userProvider', () {
    group('When the user is null', () {
      test('Then the provider returns null', () async {
        final mockFirebaseAuth = MockFirebaseAuth();
        final container = createContainer(
          overrides: [
            firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
          ],
        );

        final subscription = container.listen(userProvider.future, (_, __) {});
        final user = await subscription.read();

        expect(user, isNull);
      });
    });
    group('When there is a user', () {
      test('Then the provider returns the user transformed to a DanteUser',
          () async {
        final mockFirebaseAuth = MockFirebaseAuth();
        final container = createContainer(
          overrides: [
            firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
          ],
        );

        final subscription = container.listen(userProvider.future, (_, __) {});
        await container.read(firebaseAuthProvider).signInAnonymously();
        await container.pump();
        await container.pump();
        final user = await subscription.read();

        expect(user, isNotNull);
        expect(user, isA<DanteUser>());
      });
    });
  });
}
