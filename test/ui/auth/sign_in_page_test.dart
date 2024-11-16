import 'package:dantex/providers/auth.dart';
import 'package:dantex/providers/firebase.dart';
import 'package:dantex/ui/auth/sign_in_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:patrol_finders/patrol_finders.dart';

void main() {
  // Disable EasyLocalization logs for tests
  EasyLocalization.logger.enableBuildModes = [];

  group('Given a SignInPage widget', () {
    group('When the anonymous sign in dialog is shown', () {
      patrolWidgetTest('Then dismissing should return to the sign up page',
          ($) async {
        await $.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: SignInPage(),
            ),
          ),
        );

        await $(#anonymous_sign_in_button).tap();

        // Dismiss the anonymous sign up and verify that the dialog is gone and
        // the progress indicator is no longer shown.
        await $(#dismiss_anonymous_sign_in_button).tap();
        expect($(#anonymous_sign_in_dialog), findsNothing);
      });
      patrolWidgetTest('Then proceeding should call sign up anonymously',
          ($) async {
        final mockFirebaseAuth = MockFirebaseAuth();
        await $.pumpWidget(
          ProviderScope(
            overrides: [
              firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
            ],
            child: const MaterialApp(
              home: SignInPage(),
            ),
          ),
        );

        await $(#anonymous_sign_in_button).tap();

        // Proceed with the anonymous sign up and verify that the dialog is gone.
        await $(#proceed_anonymous_sign_in_button).tap();
        expect($(#anonymous_sign_in_dialog), findsNothing);
        // Confirm that we have signed in anonymously.
        expect(mockFirebaseAuth.currentUser, isNotNull);
      });
    });
    group('When anonymous sign in succeeds', () {
      patrolWidgetTest('Then the anonymous sign in dialog should be shown',
          ($) async {
        await $.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: SignInPage(),
            ),
          ),
        );

        await $(#anonymous_sign_in_button).tap();

        expect($(#anonymous_sign_in_dialog), findsOneWidget);
        expect($(#dismiss_anonymous_sign_in_button), findsOneWidget);
        expect($(#proceed_anonymous_sign_in_button), findsOneWidget);
      });
    });
    group('When anonymous sign in fails', () {
      patrolWidgetTest('Then the sign up error snackbar should be shown',
          ($) async {
        final mockFirebaseAuth = MockFirebaseAuth();
        whenCalling(Invocation.method(#signInAnonymously, null))
            .on(mockFirebaseAuth)
            .thenThrow(FirebaseAuthException(code: 'operation-not-allowed'));
        await $.pumpWidget(
          ProviderScope(
            overrides: [
              firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
            ],
            child: const MaterialApp(
              home: SignInPage(),
            ),
          ),
        );

        await $(#anonymous_sign_in_button).tap();

        // Proceed with the anonymous sign up and verify that the snackbar appears
        // for failed sign up.
        await $(#proceed_anonymous_sign_in_button).tap();
        expect($(#sign_in_failed_snackbar), findsOneWidget);
      });
    });
    group('When Google sign in succeeds', () {
      patrolWidgetTest('Then the user should be signed in', ($) async {
        final mockFirebaseAuth = MockFirebaseAuth();
        final mockGoogleSignIn = MockGoogleSignIn();
        await $.pumpWidget(
          ProviderScope(
            overrides: [
              firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
              googleSignInProvider.overrideWithValue(mockGoogleSignIn),
            ],
            child: const MaterialApp(
              home: SignInPage(),
            ),
          ),
        );

        await $(#google_sign_in_button).tap();

        expect(mockFirebaseAuth.currentUser, isNotNull);
      });
    });
    group('When Google sign in fails', () {
      patrolWidgetTest('Then the user should be not be signed in', ($) async {
        final mockFirebaseAuth = MockFirebaseAuth();
        final mockGoogleSignIn = MockGoogleSignIn();

        whenCalling(Invocation.method(#signInWithCredential, null))
            .on(mockFirebaseAuth)
            .thenThrow(FirebaseAuthException(code: 'operation-not-allowed'));
        await $.pumpWidget(
          ProviderScope(
            overrides: [
              firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
              googleSignInProvider.overrideWithValue(mockGoogleSignIn),
            ],
            child: const MaterialApp(
              home: SignInPage(),
            ),
          ),
        );

        await $(#google_sign_in_button).tap();

        expect(mockFirebaseAuth.currentUser, isNull);
        expect($(#sign_in_failed_snackbar), findsOneWidget);
      });
    });

    group('When email sign in succeeds', () {
      patrolWidgetTest('Then the user should be signed in', ($) async {
        final mockFirebaseAuth = MockFirebaseAuth();
        await $.pumpWidget(
          ProviderScope(
            overrides: [
              firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
            ],
            child: const MaterialApp(
              home: SignInPage(),
            ),
          ),
        );

        await $(#email_field).enterText('email');
        await $(#password_field).enterText('password');
        await $(#email_sign_in_button).tap();

        expect(mockFirebaseAuth.currentUser, isNotNull);
      });
    });
    group('When email sign in fails', () {
      patrolWidgetTest('Then the user should be not be signed in', ($) async {
        final mockFirebaseAuth = MockFirebaseAuth();

        whenCalling(Invocation.method(#signInWithEmailAndPassword, null))
            .on(mockFirebaseAuth)
            .thenThrow(FirebaseAuthException(code: 'operation-not-allowed'));
        await $.pumpWidget(
          ProviderScope(
            overrides: [
              firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
            ],
            child: const MaterialApp(
              home: SignInPage(),
            ),
          ),
        );

        await $(#email_field).enterText('email');
        await $(#password_field).enterText('password');
        await $(#email_sign_in_button).tap();

        expect(mockFirebaseAuth.currentUser, isNull);
        expect($(#sign_in_failed_snackbar), findsOneWidget);
      });
    });
  });
}
