import 'package:dantex/providers/firebase.dart';
import 'package:dantex/screens/sign_up_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:patrol_finders/patrol_finders.dart';

void main() {
  // Disable EasyLocalization logs for tests
  EasyLocalization.logger.enableBuildModes = [];

  group('Given a SignUpScreen widget', () {
    group('When Email sign up succeeds', () {
      patrolWidgetTest('Then the user should be signed in', ($) async {
        final mockFirebaseAuth = MockFirebaseAuth();
        await $.pumpWidget(
          ProviderScope(
            overrides: [
              firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
            ],
            child: const MaterialApp(
              home: SignUpScreen(),
            ),
          ),
        );

        await $(#email_field).enterText('email@thing.com');
        await $(#password_field).enterText('password');
        await $(#confirm_password_field).enterText('password');
        await $(#email_sign_up_button).tap();

        expect(mockFirebaseAuth.currentUser, isNotNull);
      });
    });
    group('When Email sign up fails', () {
      patrolWidgetTest('Then the user should be not be signed in', ($) async {
        final mockFirebaseAuth = MockFirebaseAuth();

        whenCalling(Invocation.method(#createUserWithEmailAndPassword, null))
            .on(mockFirebaseAuth)
            .thenThrow(FirebaseAuthException(code: 'operation-not-allowed'));
        await $.pumpWidget(
          ProviderScope(
            overrides: [
              firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
            ],
            child: const MaterialApp(
              home: SignUpScreen(),
            ),
          ),
        );

        await $(#email_field).enterText('email@thing.com');
        await $(#password_field).enterText('password');
        await $(#confirm_password_field).enterText('password');
        await $(#email_sign_up_button).tap();

        expect(mockFirebaseAuth.currentUser, isNull);
        expect($(#sign_up_failed_snackbar), findsOneWidget);
      });
    });
  });
}
