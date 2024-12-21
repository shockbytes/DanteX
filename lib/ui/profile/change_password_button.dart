import 'package:dantex/logger/event.dart';
import 'package:dantex/providers/firebase.dart';
import 'package:dantex/providers/service.dart';
import 'package:dantex/ui/shared/loading_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePasswordButton extends StatelessWidget {
  const ChangePasswordButton({required this.userEmail, super.key});

  final String userEmail;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async => showModalBottomSheet(
        showDragHandle: true,
        context: context,
        builder: (context) => _ChangePasswordBottomSheet(
          key: const ValueKey('change_password_bottom_sheet'),
          userEmail: userEmail,
        ),
      ),
      child: const Text('authentication.change_password').tr(),
    );
  }
}

class _ChangePasswordBottomSheet extends ConsumerStatefulWidget {
  const _ChangePasswordBottomSheet({required this.userEmail, super.key});

  final String userEmail;

  @override
  ConsumerState<_ChangePasswordBottomSheet> createState() =>
      _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState
    extends ConsumerState<_ChangePasswordBottomSheet> {
  bool _maskNewPassword = true;
  bool _maskConfirmNewPassword = true;
  bool _maskOldPassword = true;
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _oldPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _oldPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.95,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  'authentication.change_password',
                  style: Theme.of(context).textTheme.headlineMedium,
                ).tr(),
                const SizedBox(height: 8),
                Text(
                  'authentication.password_rules',
                  style: Theme.of(context).textTheme.bodyMedium,
                ).tr(),
                const SizedBox(height: 24),
                TextFormField(
                  key: const ValueKey('old_password_field'),
                  decoration: InputDecoration(
                    labelText: 'authentication.old_password'.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    suffixIcon: GestureDetector(
                      child: Icon(
                        _maskOldPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onTap: () =>
                          setState(() => _maskOldPassword = !_maskOldPassword),
                    ),
                  ),
                  obscureText: _maskOldPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'authentication.password_empty'.tr();
                    }
                    return null;
                  },
                  controller: _oldPasswordController,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  key: const ValueKey('new_password_field'),
                  decoration: InputDecoration(
                    labelText: 'authentication.new_password'.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    suffixIcon: GestureDetector(
                      child: Icon(
                        _maskNewPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onTap: () =>
                          setState(() => _maskNewPassword = !_maskNewPassword),
                    ),
                  ),
                  obscureText: _maskNewPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'authentication.password_empty'.tr();
                    }
                    return null;
                  },
                  controller: _newPasswordController,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  key: const ValueKey('confirm_new_password_field'),
                  decoration: InputDecoration(
                    labelText: 'authentication.confirm_new_password'.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    suffixIcon: GestureDetector(
                      child: Icon(
                        _maskConfirmNewPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onTap: () {
                        setState(
                          () => _maskConfirmNewPassword =
                              !_maskConfirmNewPassword,
                        );
                      },
                    ),
                  ),
                  obscureText: _maskConfirmNewPassword,
                  validator: (value) {
                    if (value != _newPasswordController.text) {
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
                    key: const ValueKey('change_password_button'),
                    onPressed: _changePassword,
                    labelText: 'authentication.change_password'.tr(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final credential = EmailAuthProvider.credential(
          email: widget.userEmail,
          password: _oldPasswordController.text,
        );

        await ref
            .read(firebaseAuthProvider)
            .currentUser
            ?.reauthenticateWithCredential(credential);

        await ref
            .read(firebaseAuthProvider)
            .currentUser
            ?.updatePassword(_newPasswordController.text);

        ref
            .read(loggerProvider)
            .trackEvent(DanteEvent.updateMailPasswordSuccess);
        if (mounted) {
          Navigator.of(context).pop();
        }
      } on FirebaseAuthException catch (e, s) {
        ref
            .read(loggerProvider)
            .e('Error changing password', error: e, stackTrace: s);
        ref.read(loggerProvider).trackEvent(
          DanteEvent.updateMailPasswordFailure,
          data: {'errorCode': e.code},
        );
        if (mounted) {
          Navigator.of(context).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              key: const ValueKey('change_password_failed_snackbar'),
              content: const Text('authentication.change_password_failed').tr(),
            ),
          );
        }
      }
    }
  }
}
