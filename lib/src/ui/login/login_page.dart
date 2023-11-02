import 'dart:async';

import 'package:dantex/src/providers/app_router.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/platform_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator.adaptive()
                : Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
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
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'login_with_account'.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 24),
                        DanteOutlinedButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              await ref
                                  .read(authenticationRepositoryProvider)
                                  .loginWithGoogle();
                            } on Exception catch (exception, stackTrace) {
                              _loginErrorReceived(exception, stackTrace);
                            }
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/google_logo.png',
                                width: 24,
                                height: 24,
                              ),
                              Expanded(
                                child: Text(
                                  'login_with_google'.tr(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        DanteOutlinedButton(
                          onPressed: () => context.pushReplacement(
                            DanteRoute.emailLogin.navigationUrl,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.mail_outline),
                              Expanded(
                                child: Text(
                                  'login_with_email'.tr(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Divider(
                          height: 2,
                          color: Theme.of(context).dividerColor,
                        ),
                        const SizedBox(height: 16),
                        DanteOutlinedButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await _buildAnonymousLoginDialog();
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.no_accounts_outlined,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              Expanded(
                                child: Text(
                                  'stay_anonymous'.tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _loginErrorReceived(Exception exception, StackTrace stackTrace) {
    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('login_failed'.tr())),
    );
  }

  Future<void> _buildAnonymousLoginDialog() async {
    await showDanteDialog(
      context,
      title: 'anonymous_login.title'.tr(),
      content: 'anonymous_login.description'.tr(),
      actions: <DanteDialogAction>[
        DanteDialogAction(
          action: (_) {
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).pop();
          },
          name: 'dismiss'.tr(),
        ),
        DanteDialogAction(
          action: (_) async {
            Navigator.of(context).pop();
            try {
              await ref
                  .read(authenticationRepositoryProvider)
                  .loginAnonymously();
            } on Exception catch (exception, stackTrace) {
              _loginErrorReceived(exception, stackTrace);
            }
          },
          name: 'login'.tr(),
        ),
      ],
    );
  }
}
