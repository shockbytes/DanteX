import 'package:dantex/logger/event.dart';
import 'package:dantex/providers/firebase.dart';
import 'package:dantex/providers/service.dart';
import 'package:dantex/ui/shared/loading_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LinkWithEmailButton extends StatelessWidget {
  const LinkWithEmailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: const Icon(Icons.email_outlined),
      onPressed: () async => showModalBottomSheet(
        isScrollControlled: true,
        showDragHandle: true,
        context: context,
        builder: (context) => const _LinkWithEmailBottomSheet(
          key: ValueKey('link_with_email_bottom_sheet'),
        ),
      ),
      label: const Text('Link with email').tr(),
    );
  }
}

class _LinkWithEmailBottomSheet extends ConsumerStatefulWidget {
  const _LinkWithEmailBottomSheet({super.key});

  @override
  ConsumerState<_LinkWithEmailBottomSheet> createState() =>
      _LinkWithEmailBottomSheetState();
}

class _LinkWithEmailBottomSheetState
    extends ConsumerState<_LinkWithEmailBottomSheet> {
  bool _maskPassword = true;
  bool _maskConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: mq.size.height * 0.95,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: mq.viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  'authentication.link_account.link_with_email',
                  style: Theme.of(context).textTheme.headlineMedium,
                ).tr(),
                const SizedBox(height: 8),
                Text(
                  'authentication.sign_up_rules',
                  style: Theme.of(context).textTheme.bodyMedium,
                ).tr(),
                const SizedBox(height: 24),
                TextFormField(
                  key: const ValueKey('email_field'),
                  decoration: InputDecoration(
                    labelText: 'authentication.email'.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'authentication.email_empty'.tr();
                    }
                    if (!EmailValidator.validate(value)) {
                      return 'authentication.email_invalid'.tr();
                    }
                    return null;
                  },
                  controller: _emailController,
                ),
                const SizedBox(height: 8),
                TextFormField(
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
                      onTap: () =>
                          setState(() => _maskPassword = !_maskPassword),
                    ),
                  ),
                  obscureText: _maskPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'authentication.password_empty'.tr();
                    }
                    return null;
                  },
                  controller: _passwordController,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  key: const ValueKey('confirm_password_field'),
                  decoration: InputDecoration(
                    labelText: 'authentication.confirm_password'.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    suffixIcon: GestureDetector(
                      child: Icon(
                        _maskConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onTap: () => setState(
                        () => _maskConfirmPassword = !_maskConfirmPassword,
                      ),
                    ),
                  ),
                  obscureText: _maskConfirmPassword,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'authentication.passwords_must_match'.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: LoadingButton(
                    key: const ValueKey('link_email_button'),
                    onPressed: _linkEmail,
                    labelText:
                        'authentication.link_account.link_with_email'.tr(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _linkEmail() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final credential = EmailAuthProvider.credential(
          email: _emailController.text,
          password: _passwordController.text,
        );

        await ref
            .read(firebaseAuthProvider)
            .currentUser
            ?.linkWithCredential(credential);

        ref.read(loggerProvider).trackEvent(
          DanteEvent.anonymousUpgrade,
          data: {'source': 'email'},
        );
        if (mounted) {
          Navigator.of(context).pop();
        }
      } on FirebaseAuthException catch (e, s) {
        var message = 'authentication.sign_up_failed'.tr();
        if (e.code == 'credential-already-in-use') {
          ref.read(loggerProvider).e(
                'The account already exists for that email.',
                error: e,
                stackTrace: s,
              );
          message = 'authentication.email_already_in_use'.tr();
        } else if (e.code == 'weak-password') {
          ref
              .read(loggerProvider)
              .e('The password provided is too weak.', error: e, stackTrace: s);
          message = 'authentication.password_too_weak'.tr();
        } else if (e.code == 'provider-already-linked') {
          ref.read(loggerProvider).e(
                'The provider has already been linked to the user.',
                error: e,
                stackTrace: s,
              );
          message = 'authentication.link_account.provider_already_linked'.tr();
        } else if (e.code == 'invalid-credential') {
          ref.read(loggerProvider).e(
                "The provider's credential is not valid.",
                error: e,
                stackTrace: s,
              );
          message = 'authentication.link_account.invalid_credential'.tr();
        } else if (e.code == 'email-already-in-use') {
          ref.read(loggerProvider).e(
                'The email address is already in use by another account.',
                error: e,
                stackTrace: s,
              );
          message = 'authentication.email_already_in_use'.tr();
        } else {
          ref.read(loggerProvider).e(
                'Unknown error',
                error: e,
                stackTrace: s,
              );
        }
        if (mounted) {
          Navigator.of(context).pop();
        }
        _handleFailedSignUp(message);
      }
    }
  }

  void _handleFailedSignUp(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: const ValueKey('sign_up_failed_snackbar'),
        content: Text(message),
      ),
    );
  }
}
