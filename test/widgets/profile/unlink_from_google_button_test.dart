import 'package:dantex/widgets/profile/unlink_from_google_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:patrol_finders/patrol_finders.dart';

void main() async {
  EasyLocalization.logger.enableBuildModes = [];
  final mockFirebaseAuth = MockFirebaseAuth();
  final googleSignIn = MockGoogleSignIn();
  final signinAccount = await googleSignIn.signIn();
  final googleAuth = await signinAccount?.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );
  await mockFirebaseAuth.signInWithCredential(credential);

  group('Given an UnlinkFromGoogleButton', () {
    group('When the button is tapped', () {
      patrolWidgetTest('Then the unlink dialog is shown', ($) async {
        await $.pumpWidget(
          const MaterialApp(
            home: UnlinkFromGoogleButton(),
          ),
        );

        await $(#unlink_google_button).tap();
        expect($(#unlink_google_dialog), findsOneWidget);
      });
    });
    group('And the dismiss button in the Dialog is tapped', () {
      patrolWidgetTest('Then the dialog is dismissed', ($) async {
        await $.pumpWidget(
          const MaterialApp(
            home: UnlinkFromGoogleButton(),
          ),
        );

        await $(#unlink_google_button).tap();
        await $(#dismiss_unlink_google_dialog).tap();
        expect($(#unlink_google_dialog), findsNothing);
      });
    });
  });
}
