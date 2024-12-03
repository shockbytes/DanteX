import 'dart:developer';

import 'package:dantex/logger/event.dart';
import 'package:dantex/providers/auth.dart';
import 'package:dantex/providers/firebase.dart';
import 'package:dantex/providers/logger.dart';
import 'package:dantex/screens/forgot_password_screen.dart';
import 'package:dantex/screens/sign_up_screen.dart';
import 'package:dantex/widgets/shared/loading_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  static String get routeName => 'sign-in';
  static String get routeLocation => '/$routeName';

  @override
  ConsumerState<SignInScreen> createState() => _SingInScreenState();
}

class _SingInScreenState extends ConsumerState<SignInScreen> {
  bool _signingIn = false;
  bool _maskPassword = true;
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo/ic-launcher.jpg',
                    width: 120,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'sign_in.welcome_back',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ).tr(),
                  const SizedBox(height: 8),
                  Text(
                    'sign_in.login_with_account',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ).tr(),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            return null;
                          },
                          controller: _emailController,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          key: const ValueKey('password_field'),
                          decoration: InputDecoration(
                            labelText: 'sign_in.password'.tr(),
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
                              return 'sign_in.password_empty'.tr();
                            }
                            return null;
                          },
                          controller: _passwordController,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      key: const ValueKey('forgot_password_button'),
                      onTap: () async =>
                          context.pushNamed(ForgotPasswordScreen.routeName),
                      child: Text(
                        'sign_in.forgot_password',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.end,
                      ).tr(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: LoadingButton(
                      key: const ValueKey('email_sign_in_button'),
                      onPressed: _signInWithEmail,
                      labelText: 'sign_in.sign_in'.tr(),
                      disabled: _signingIn,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: LoadingButton.icon(
                      key: const ValueKey('google_sign_in_button'),
                      onPressed: _signInWithGoogle,
                      labelText: 'sign_in.sign_in_with_google'.tr(),
                      icon: Image.asset(
                        'assets/images/google_logo.png',
                        width: 24,
                        height: 24,
                      ),
                      disabled: _signingIn,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: LoadingButton.icon(
                      key: const ValueKey('anonymous_sign_in_button'),
                      onPressed: _signInAnonymously,
                      labelText: 'sign_in.stay_anonymous'.tr(),
                      icon: const Icon(Icons.person_outline),
                      disabled: _signingIn,
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'sign_in.dont_have_account',
                        style: Theme.of(context).textTheme.labelLarge,
                      ).tr(),
                      const SizedBox(width: 4),
                      GestureDetector(
                        key: const ValueKey('create_account_button'),
                        onTap: () async =>
                            context.pushNamed(SignUpScreen.routeName),
                        child: Text(
                          'sign_in.sign_up',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ).tr(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    ref.read(loggerProvider).trackEvent(
      DanteEvent.openLogin,
      data: {'source': 'google'},
    );
    try {
      setState(() => _signingIn = true);
      final googleUser = await ref.read(googleSignInProvider).signIn();
      final googleAuth = await googleUser?.authentication;
      if (googleAuth == null) {
        setState(() => _signingIn = false);
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await ref.read(firebaseAuthProvider).signInWithCredential(credential);
      ref.read(loggerProvider).trackEvent(
        DanteEvent.appLogin,
        data: {'source': 'google'},
      );
    } on Exception catch (e, stackTrace) {
      log('Got exception: $e', error: e, stackTrace: stackTrace);
      ref.read(loggerProvider).e(
            'Failed to sign in with Google',
            error: e,
            stackTrace: stackTrace,
          );
      _handleFailedSignIn();
    } finally {
      setState(() => _signingIn = false);
    }
  }

  Future<void> _signInWithEmail() async {
    ref.read(loggerProvider).trackEvent(
      DanteEvent.openLogin,
      data: {'source': 'email'},
    );
    if (_formKey.currentState?.validate() ?? false) {
      try {
        setState(() => _signingIn = true);
        await ref.read(firebaseAuthProvider).signInWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text,
            );
        ref.read(loggerProvider).trackEvent(
          DanteEvent.appLogin,
          data: {'source': 'email'},
        );
      } on FirebaseAuthException catch (e, stackTrace) {
        ref.read(loggerProvider).e(
              'Failed to sign in with email',
              error: e,
              stackTrace: stackTrace,
            );
        _handleFailedSignIn();
      } finally {
        setState(() => _signingIn = false);
      }
    }
  }

  Future<void> _signInAnonymously() async {
    ref.read(loggerProvider).trackEvent(
      DanteEvent.openLogin,
      data: {'source': 'anonymous'},
    );
    final signInAnonymously = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        key: const ValueKey('anonymous_sign_in_dialog'),
        title: const Text('sign_in.anonymous_login.title').tr(),
        content: const Text('sign_in.anonymous_login.description').tr(),
        actions: [
          TextButton(
            key: const ValueKey('dismiss_anonymous_sign_in_button'),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('sign_in.dismiss').tr(),
          ),
          TextButton(
            key: const ValueKey('proceed_anonymous_sign_in_button'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('sign_in.sign_in').tr(),
          ),
        ],
      ),
    );

    if (signInAnonymously != true) {
      setState(() => _signingIn = false);
      return;
    }

    try {
      setState(() => _signingIn = true);
      await ref.read(firebaseAuthProvider).signInAnonymously();
      ref.read(loggerProvider).trackEvent(
        DanteEvent.appLogin,
        data: {'source': 'anonymous'},
      );
    } on FirebaseAuthException catch (e, stackTrace) {
      switch (e.code) {
        case 'operation-not-allowed':
          ref.read(loggerProvider).e(
                "Anonymous auth hasn't been enabled for this project",
                error: e,
                stackTrace: stackTrace,
              );
        default:
          ref.read(loggerProvider).e(
                'Failed to sign in anonymously',
                error: e,
                stackTrace: stackTrace,
              );
      }
      _handleFailedSignIn();
    } finally {
      setState(() => _signingIn = false);
    }
  }

  void _handleFailedSignIn() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: const ValueKey('sign_in_failed_snackbar'),
        content: const Text('sign_in.sign_in_failed').tr(),
      ),
    );
  }
}
