import 'package:dantex/data/providers/auth.dart';
import 'package:dantex/ui/login/login_page.dart';
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

  group('Given a LoginPage widget', () {
    group('When the page is rendered', () {
      patrolWidgetTest('Then it should display all buttons and widgets',
          ($) async {
        await $.pumpWidget(
          const MaterialApp(
            home: LoginPage(),
          ),
        );

        expect($(#email_login_button), findsOneWidget);
        expect($(#google_login_button), findsOneWidget);
        expect($(#anonymous_login_button), findsOneWidget);
        expect($(#sign_up_button), findsOneWidget);

        expect($(#anonymous_login_dialog), findsNothing);
        expect($(CircularProgressIndicator), findsNothing);
      });
    });
    group('When tapping the anonymous sign in button', () {
      patrolWidgetTest('Then the anonymous sign in dialog should be shown',
          ($) async {
        await $.pumpWidget(
          const MaterialApp(
            home: LoginPage(),
          ),
        );

        await $(#anonymous_login_button).tap();

        expect($(#anonymous_login_dialog), findsOneWidget);
        expect($(#dismiss_anonymous_login_button), findsOneWidget);
        expect($(#proceed_anonymous_login_button), findsOneWidget);
      });
    });
    group('When the anonymous sign in dialog is shown', () {
      patrolWidgetTest('Then dismissing should return to the login page',
          ($) async {
        await $.pumpWidget(
          const MaterialApp(
            home: LoginPage(),
          ),
        );

        await $(#anonymous_login_button).tap();

        // Dismiss the anonymous login and verify that the dialog is gone and
        // the progress indicator is no longer shown.
        await $(#dismiss_anonymous_login_button).tap();
        expect($(#anonymous_login_dialog), findsNothing);
        expect($(CircularProgressIndicator), findsNothing);
      });
      patrolWidgetTest('Then proceeding should call login anonymously',
          ($) async {
        final mockFirebaseAuth = MockFirebaseAuth();
        await $.pumpWidget(
          ProviderScope(
            overrides: [
              firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
            ],
            child: const MaterialApp(
              home: LoginPage(),
            ),
          ),
        );

        await $(#anonymous_login_button).tap();

        // Proceed with the anonymous login and verify that the dialog is gone.
        await $(#proceed_anonymous_login_button).tap();
        expect($(#anonymous_login_dialog), findsNothing);
        // Confirm that we have signed in anonymously.
        expect(mockFirebaseAuth.currentUser, isNotNull);
      });
    });
    group('When anonymous sign in fails', () {
      patrolWidgetTest('Then the login error snackbar should be shown',
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
              home: LoginPage(),
            ),
          ),
        );

        await $(#anonymous_login_button).tap();

        // Proceed with the anonymous login and verify that the snackbar appears
        // for failed login.
        await $(#proceed_anonymous_login_button).tap();
        expect($(#login_failed_snackbar), findsOneWidget);
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
              home: LoginPage(),
            ),
          ),
        );

        await $(#google_login_button).tap();

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
              home: LoginPage(),
            ),
          ),
        );

        await $(#google_login_button).tap();

        expect(mockFirebaseAuth.currentUser, isNull);
        expect($(#login_failed_snackbar), findsOneWidget);
        expect($(#CircularProgressIndicator), findsNothing);
      });
    });
  });
}
