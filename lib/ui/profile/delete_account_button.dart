import 'package:dantex/models/user.dart';
import 'package:dantex/providers/auth.dart';
import 'package:dantex/providers/firebase.dart';
import 'package:dantex/providers/service.dart';
import 'package:dantex/ui/shared/loading_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteAccountButton extends ConsumerWidget {
  const DeleteAccountButton({required this.user, super.key});

  final DanteUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton.icon(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          Theme.of(context).colorScheme.errorContainer,
        ),
      ),
      icon: Icon(
        Icons.delete_forever_outlined,
        color: Theme.of(context).colorScheme.onErrorContainer,
      ),
      onPressed: () async {
        await showDialog<bool>(
          context: context,
          builder: (_) {
            if (user.isGoogleUser) {
              return const _DeleteGoogleAccountDialog(
                key: ValueKey('delete_google_account_dialog'),
              );
            }
            if (user.isMailUser) {
              return _DeleteEmailAccountDialog(
                key: const ValueKey('delete_email_account_dialog'),
                userEmail: user.email,
              );
            }
            return const _DeleteAnonymousAccountDialog(
              key: ValueKey('delete_anonymous_account_dialog'),
            );
          },
        );
      },
      label: Text(
        'authentication.delete_account.title',
        style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
      ).tr(),
    );
  }
}

class _DeleteGoogleAccountDialog extends ConsumerWidget {
  const _DeleteGoogleAccountDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('authentication.delete_account.title').tr(),
      content: const Text('authentication.delete_account.description').tr(),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('authentication.dismiss').tr(),
        ),
        LoadingButton(
          onPressed: () async => _deleteGoogleAccount(ref),
          labelText: 'authentication.delete_account.title'.tr(),
          color: Theme.of(context).colorScheme.errorContainer,
          textColor: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ],
    );
  }

  Future<void> _deleteGoogleAccount(WidgetRef ref) async {
    try {
      final googleUser = await ref.read(googleSignInProvider).signInSilently();
      final googleAuth = await googleUser?.authentication;
      if (googleAuth == null) {
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await ref
          .read(firebaseAuthProvider)
          .currentUser
          ?.reauthenticateWithCredential(credential);
      await ref.read(firebaseAuthProvider).currentUser?.delete();
    } on Exception catch (e, s) {
      ref
          .read(loggerProvider)
          .e('Failed to delete account', error: e, stackTrace: s);
    }
  }
}

class _DeleteEmailAccountDialog extends ConsumerStatefulWidget {
  const _DeleteEmailAccountDialog({required this.userEmail, super.key});

  final String? userEmail;

  @override
  ConsumerState<_DeleteEmailAccountDialog> createState() =>
      _DeleteEmailAccountDialogState();
}

class _DeleteEmailAccountDialogState
    extends ConsumerState<_DeleteEmailAccountDialog> {
  final _passwordController = TextEditingController();
  bool _maskPassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('authentication.delete_account.title').tr(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('authentication.delete_mail_account.description').tr(),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: TextFormField(
              key: const ValueKey('password_field'),
              decoration: InputDecoration(
                labelText: 'authentication.password'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                suffixIcon: GestureDetector(
                  child: Icon(
                    _maskPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onTap: () => setState(() => _maskPassword = !_maskPassword),
                ),
              ),
              obscureText: _maskPassword,
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'authentication.password_empty'.tr();
                }
                return null;
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('authentication.dismiss').tr(),
        ),
        LoadingButton(
          onPressed: _deleteEmailAccount,
          labelText: 'authentication.delete_account.title'.tr(),
          color: Theme.of(context).colorScheme.errorContainer,
          textColor: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ],
    );
  }

  Future<void> _deleteEmailAccount() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      final email = widget.userEmail;
      if (email == null) {
        return;
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: _passwordController.text,
      );

      await ref
          .read(firebaseAuthProvider)
          .currentUser
          ?.reauthenticateWithCredential(credential);
      await ref.read(firebaseAuthProvider).currentUser?.delete();
    } on Exception catch (e, s) {
      ref
          .read(loggerProvider)
          .e('Failed to delete account', error: e, stackTrace: s);
    }
  }
}

class _DeleteAnonymousAccountDialog extends ConsumerWidget {
  const _DeleteAnonymousAccountDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('authentication.delete_account.title').tr(),
      content: const Text('authentication.delete_account.description').tr(),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('authentication.dismiss').tr(),
        ),
        LoadingButton(
          onPressed: () async => _deleteAnonymousAccount(ref),
          labelText: 'authentication.delete_account.title'.tr(),
          color: Theme.of(context).colorScheme.errorContainer,
          textColor: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ],
    );
  }

  Future<void> _deleteAnonymousAccount(WidgetRef ref) async {
    try {
      await ref.read(firebaseAuthProvider).currentUser?.delete();
    } on Exception catch (e, s) {
      ref
          .read(loggerProvider)
          .e('Failed to delete account', error: e, stackTrace: s);
    }
  }
}
