import 'package:dantex/providers/auth.dart';
import 'package:dantex/providers/firebase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignOutButton extends ConsumerWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      onPressed: () async {
        final user = ref.read(userProvider).value;
        if (user?.isAnonymous ?? false) {
          await showDialog<bool>(
            context: context,
            builder: (_) => const _AnonymousSignOutDialog(
              key: ValueKey('anonymous_sign_out_dialog'),
            ),
          );
        } else {
          await ref.read(firebaseAuthProvider).signOut();
        }
      },
      child: const Text('bottom_sheet_menu.sign_out').tr(),
    );
  }
}

class _AnonymousSignOutDialog extends ConsumerWidget {
  const _AnonymousSignOutDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('authentication.anonymous_sign_out.title').tr(),
      content: const Text('authentication.anonymous_sign_out.description').tr(),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('authentication.dismiss').tr(),
        ),
        OutlinedButton(
          onPressed: () async => ref.read(firebaseAuthProvider).signOut(),
          child: const Text('authentication.sign_out').tr(),
        ),
      ],
    );
  }
}
