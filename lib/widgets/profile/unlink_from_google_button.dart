import 'package:dantex/providers/firebase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnlinkFromGoogleButton extends ConsumerWidget {
  const UnlinkFromGoogleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      key: const ValueKey('unlink_google_button'),
      onPressed: () async => showDialog(
        context: context,
        builder: (context) => const _UnlinkFromGoogleDialog(
          key: ValueKey('unlink_google_dialog'),
        ),
      ),
      child: const Text('authentication.unlink_google').tr(),
    );
  }
}

class _UnlinkFromGoogleDialog extends ConsumerWidget {
  const _UnlinkFromGoogleDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('authentication.unlink_google').tr(),
      content: const Text(
        'authentication.unlink_google_description',
      ).tr(),
      actions: [
        OutlinedButton(
          key: const ValueKey('dismiss_unlink_google_dialog'),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('authentication.dismiss').tr(),
        ),
        OutlinedButton(
          key: const ValueKey('proceed_unlink_google_dialog'),
          onPressed: () async {
            await ref
                .read(firebaseAuthProvider)
                .currentUser
                ?.unlink('google.com');
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: const Text('authentication.unlink').tr(),
        ),
      ],
    );
  }
}
