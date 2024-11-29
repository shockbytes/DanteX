import 'package:dantex/logger/event.dart';
import 'package:dantex/providers/firebase.dart';
import 'package:dantex/providers/logger.dart';
import 'package:dantex/widgets/loading_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  static String get routeName => 'forgot-password';
  static String get routeLocation => '/$routeName';

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _linkSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'sign_in.forgot_password',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ).tr(),
                    const SizedBox(height: 8),
                    if (_linkSent) ...[
                      const Icon(Icons.check_circle_outline, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'sign_in.forgot_password_sent',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ).tr(),
                      const SizedBox(height: 8),
                      Text(
                        'sign_in.forgot_password_sent_info',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ).tr(),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          key: const ValueKey('back_to_sign_in_button'),
                          onPressed: () => context.pop(),
                          child: const Text('sign_in.back_to_sign_in').tr(),
                        ),
                      ),
                    ] else ...[
                      Text(
                        'sign_in.forgot_password_info',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ).tr(),
                      const SizedBox(height: 24),
                      TextFormField(
                        key: const ValueKey('email_field'),
                        decoration: InputDecoration(
                          labelText: 'sign_in.email'.tr(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'sign_in.email_empty'.tr();
                          }
                          if (!EmailValidator.validate(value)) {
                            return 'sign_in.email_invalid'.tr();
                          }
                          return null;
                        },
                        controller: _emailController,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: LoadingButton(
                          key: const ValueKey('password_reset_button'),
                          onPressed: _resetPassword,
                          labelText: 'sign_in.send_link_email'.tr(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ref.read(firebaseAuthProvider).sendPasswordResetEmail(
              email: _emailController.text,
            );
        ref.read(loggerProvider).trackEvent(DanteEvent.resetPasswordSuccess);
        setState(() => _linkSent = true);
      } on FirebaseAuthException catch (e) {
        ref.read(loggerProvider).trackEvent(
          DanteEvent.resetPasswordFailed,
          data: {'error': e.code},
        );
        _handleFailedPasswordReset();
      }
    }
  }

  void _handleFailedPasswordReset() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: const ValueKey('password_reset_failed_snackbar'),
        content: const Text('sign_in.password_reset_failed').tr(),
      ),
    );
  }
}
