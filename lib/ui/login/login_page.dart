import 'package:dantex/data/logger/event.dart';
import 'package:dantex/data/providers/auth.dart';
import 'package:dantex/data/providers/logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  static String get routeName => 'login';
  static String get routeLocation => '/$routeName';

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _loggingIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: Center(
          child: _loggingIn
              ? const CircularProgressIndicator()
              : Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo/ic-launcher.jpg',
                        width: 92,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'welcome_back'.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'login_with_account'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        key: const ValueKey('google_login_button'),
                        onPressed: _signInWithGoogle,
                        label: const Text('Google Login'),
                        icon: Image.asset(
                          'assets/images/google_logo.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      OutlinedButton.icon(
                        key: const ValueKey('email_login_button'),
                        onPressed: _signInWithEmail,
                        label: const Text('Email Login'),
                        icon: const Icon(Icons.email_outlined),
                      ),
                      OutlinedButton.icon(
                        key: const ValueKey('anonymous_login_button'),
                        onPressed: _signInAnonymously,
                        label: const Text('Anonymous Login'),
                        icon: const Icon(Icons.person_outline),
                      ),
                      const Divider(),
                      OutlinedButton(
                        key: const ValueKey('sign_up_button'),
                        onPressed: () {},
                        child: const Text('Sign Up'),
                      ),
                    ],
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
      setState(() => _loggingIn = true);
      final googleUser = await ref.read(googleSignInProvider).signIn();
      final googleAuth = await googleUser?.authentication;
      if (googleAuth == null) {
        setState(() => _loggingIn = false);
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
      _showLoginFailedSnackBar();
    } finally {
      setState(() => _loggingIn = false);
    }
  }

  Future<void> _signInWithEmail() async {}

  Future<void> _signInAnonymously() async {
    ref.read(loggerProvider).trackEvent(
      DanteEvent.openLogin,
      data: {'source': 'anonymous'},
    );
    final loginInAnonymously = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        key: const ValueKey('anonymous_login_dialog'),
        title: Text('anonymous_login.title'.tr()),
        content: Text('anonymous_login.description'.tr()),
        actions: [
          TextButton(
            key: const ValueKey('dismiss_anonymous_login_button'),
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('dismiss'.tr()),
          ),
          TextButton(
            key: const ValueKey('proceed_anonymous_login_button'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('login'.tr()),
          ),
        ],
      ),
    );

    if (loginInAnonymously != true) {
      setState(() => _loggingIn = false);
      return;
    }

    try {
      setState(() => _loggingIn = true);
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
      _showLoginFailedSnackBar();
    } finally {
      setState(() => _loggingIn = false);
    }
  }

  void _showLoginFailedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: const ValueKey('login_failed_snackbar'),
        content: Text('login_failed'.tr()),
      ),
    );
  }
}
