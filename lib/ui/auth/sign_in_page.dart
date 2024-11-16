import 'package:dantex/logger/event.dart';
import 'package:dantex/providers/auth.dart';
import 'package:dantex/providers/logger.dart';
import 'package:dantex/ui/auth/forgot_password.dart';
import 'package:dantex/ui/auth/sign_up_page.dart';
import 'package:dantex/ui/core/loading_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  static String get routeName => 'sign-in';
  static String get routeLocation => '/$routeName';

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
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
                    'welcome_back'.tr(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'login_with_account'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          key: const ValueKey('email_field'),
                          decoration: InputDecoration(
                            labelText: 'email'.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'email_empty'.tr();
                            }
                            return null;
                          },
                          controller: _emailController,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          key: const ValueKey('password_field'),
                          decoration: InputDecoration(
                            labelText: 'password'.tr(),
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
                              return 'password_empty'.tr();
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
                          context.pushNamed(ForgotPasswordPage.routeName),
                      child: Text(
                        'forgot_password'.tr(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: LoadingButton(
                      key: const ValueKey('email_sign_in_button'),
                      onPressed: _signInWithEmail,
                      labelText: 'sign_in'.tr(),
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
                      labelText: 'login_with_google'.tr(),
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
                      labelText: 'stay_anonymous'.tr(),
                      icon: const Icon(Icons.person_outline),
                      disabled: _signingIn,
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'dont_have_account'.tr(),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        key: const ValueKey('create_account_button'),
                        onTap: () async =>
                            context.pushNamed(SignUpPage.routeName),
                        child: Text(
                          'sign_up'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
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
        title: Text('anonymous_login.title'.tr()),
        content: Text('anonymous_login.description'.tr()),
        actions: [
          TextButton(
            key: const ValueKey('dismiss_anonymous_sign_in_button'),
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('dismiss'.tr()),
          ),
          TextButton(
            key: const ValueKey('proceed_anonymous_sign_in_button'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('login'.tr()),
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
        content: Text('login_failed'.tr()),
      ),
    );
  }
}
