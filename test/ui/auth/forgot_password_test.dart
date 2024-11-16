import 'package:dantex/providers/auth.dart';
import 'package:dantex/ui/auth/forgot_password.dart';
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

  group('Given a ForgetPasswordPage widget', () {
    group('When password reset succeeds', () {
      patrolWidgetTest('Then back to sign in button should be shown.',
          ($) async {
        final mockFirebaseAuth = MockFirebaseAuth();
        await $.pumpWidget(
          ProviderScope(
            overrides: [
              firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
            ],
            child: const MaterialApp(
              home: ForgotPasswordPage(),
            ),
          ),
        );

        await $(#email_field).enterText('email@thing.com');
        await $(#password_reset_button).tap();

        expect($(#back_to_sign_in_button), findsOneWidget);
      });
    });
    group('When password reset fails', () {
      patrolWidgetTest('Then the user should be not be signed in', ($) async {
        final mockFirebaseAuth = MockFirebaseAuth();

        whenCalling(Invocation.method(#sendPasswordResetEmail, null))
            .on(mockFirebaseAuth)
            .thenThrow(FirebaseAuthException(code: 'operation-not-allowed'));
        await $.pumpWidget(
          ProviderScope(
            overrides: [
              firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
            ],
            child: const MaterialApp(
              home: ForgotPasswordPage(),
            ),
          ),
        );

        await $(#email_field).enterText('email@thing.com');
        await $(#password_reset_button).tap();

        expect($(#back_to_sign_in_button), findsNothing);
        expect($(#password_reset_failed_snackbar), findsOneWidget);
      });
    });
  });
}
