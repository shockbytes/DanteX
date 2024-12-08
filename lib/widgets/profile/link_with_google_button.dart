import 'package:dantex/logger/event.dart';
import 'package:dantex/providers/firebase.dart';
import 'package:dantex/providers/logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LinkWithGoogleButton extends ConsumerWidget {
  const LinkWithGoogleButton({this.isAnonymous = false, super.key});

  final bool isAnonymous;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton.icon(
      icon: Image.asset(
        'assets/images/google_logo.png',
        width: 24,
        height: 24,
      ),
      onPressed: () async {
        final googleUser = await GoogleSignIn().signIn();
        final googleAuth = await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        await ref
            .read(firebaseAuthProvider)
            .currentUser
            ?.linkWithCredential(credential);

        if (isAnonymous) {
          ref.read(loggerProvider).trackEvent(
            DanteEvent.anonymousUpgrade,
            data: {'source': 'google'},
          );
        } else {
          ref.read(loggerProvider).trackEvent(
            DanteEvent.emailUpgrade,
            data: {'source': 'google'},
          );
        }
      },
      label: const Text('authentication.link_account.link_with_google').tr(),
    );
  }
}
