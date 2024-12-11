import 'package:dantex/providers/firebase.dart';
import 'package:dantex/widgets/profile/unlink_from_email_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

void main() async {
  EasyLocalization.logger.enableBuildModes = [];
  final mockFirebaseAuth = MockFirebaseAuth();
  await mockFirebaseAuth.createUserWithEmailAndPassword(
    email: 'test',
    password: 'test',
  );
  await mockFirebaseAuth.signInWithEmailAndPassword(
    email: 'test',
    password: 'test',
  );

  group('Given an UnlinkFromEmailButton', () {
    group('When the button is tapped', () {
      patrolWidgetTest('Then the unlink dialog is shown', ($) async {
        await $.pumpWidget(
          const MaterialApp(
            home: UnlinkFromEmailButton(),
          ),
        );

        await $(#unlink_email_button).tap();
        expect($(#unlink_email_dialog), findsOneWidget);
      });
    });
    group('And the dismiss button in the Dialog is tapped', () {
      patrolWidgetTest('Then the dialog is dismissed', ($) async {
        await $.pumpWidget(
          const MaterialApp(
            home: UnlinkFromEmailButton(),
          ),
        );

        await $(#unlink_email_button).tap();
        await $(#dismiss_unlink_email_dialog).tap();
        expect($(#unlink_email_dialog), findsNothing);
      });
    });
    group('And the unlink button in the Dialog is tapped', () {
      patrolWidgetTest('Then the user is unlinked from email', ($) async {
        await $.pumpWidget(
          ProviderScope(
            overrides: [
              firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
            ],
            child: const MaterialApp(
              home: UnlinkFromEmailButton(),
            ),
          ),
        );

        await $(#unlink_email_button).tap();
        await $(#proceed_unlink_email_dialog).tap();
        await $.pumpAndSettle();

        expect(
          mockFirebaseAuth.currentUser?.providerData.map((p) => p.providerId),
          isNot(contains('password')),
        );
      });
    });
  });
}
