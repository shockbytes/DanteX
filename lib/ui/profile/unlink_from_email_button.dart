import 'package:dantex/providers/firebase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnlinkFromEmailButton extends ConsumerWidget {
  const UnlinkFromEmailButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      key: const ValueKey('unlink_email_button'),
      onPressed: () async => showDialog(
        context: context,
        builder: (context) => const _UnlinkFromEmailDialog(
          key: ValueKey('unlink_email_dialog'),
        ),
      ),
      child: const Text('authentication.unlink_email').tr(),
    );
  }
}

class _UnlinkFromEmailDialog extends ConsumerWidget {
  const _UnlinkFromEmailDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('authentication.unlink_email').tr(),
      content: const Text(
        'authentication.unlink_email_description',
      ).tr(),
      actions: [
        OutlinedButton(
          key: const ValueKey('dismiss_unlink_email_dialog'),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('authentication.dismiss').tr(),
        ),
        OutlinedButton(
          key: const ValueKey('proceed_unlink_email_dialog'),
          onPressed: () async {
            await ref
                .read(firebaseAuthProvider)
                .currentUser
                ?.unlink('password');
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
