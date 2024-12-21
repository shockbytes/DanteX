import 'package:dantex/logger/event.dart';
import 'package:dantex/providers/firebase.dart';
import 'package:dantex/providers/service.dart';
import 'package:dantex/ui/shared/loading_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  static String get routeName => 'sign-up';
  static String get routeLocation => routeName;
  static String get navigationUrl => '/sign-in/$routeLocation';

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: Center(
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.8,
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
                      'authentication.sign_up',
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
                            _maskPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onTap: () {
                            setState(
                              () => _maskPassword = !_maskPassword,
                            );
                          },
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
                          onTap: () {
                            setState(
                              () =>
                                  _maskConfirmPassword = !_maskConfirmPassword,
                            );
                          },
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
                        key: const ValueKey('email_sign_up_button'),
                        onPressed: _signUpWithEmail,
                        labelText: 'authentication.sign_up'.tr(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signUpWithEmail() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ref.read(firebaseAuthProvider).createUserWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text,
            );
        ref.read(loggerProvider).trackEvent(
          DanteEvent.appSignUp,
          data: {'source': 'email'},
        );
      } on FirebaseAuthException catch (e, s) {
        var message = 'sign_up_failed'.tr();
        if (e.code == 'email-already-in-use') {
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
