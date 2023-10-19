import 'dart:async';

import 'package:dantex/main.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/platform_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

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
                          AppLocalizations.of(context)!.welcome_back,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppLocalizations.of(context)!.login_with_account,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 24),
                        DanteComponents.outlinedButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              await ref
                                  .read(authenticationRepositoryProvider)
                                  .loginWithGoogle();
                              if (mounted) {
                                context.pushReplacement(
                                  DanteRoute.dashboard.navigationUrl,
                                );
                              }
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
                                  AppLocalizations.of(context)!
                                      .login_with_google,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        DanteComponents.outlinedButton(
                          onPressed: () => context.pushReplacement(
                            DanteRoute.emailLogin.navigationUrl,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.mail_outline),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .login_with_email,
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
                        DanteComponents.outlinedButton(
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
                                  AppLocalizations.of(context)!.stay_anonymous,
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
      SnackBar(content: Text(AppLocalizations.of(context)!.login_failed)),
    );
  }

  Future<void> _buildAnonymousLoginDialog() async {
    await PlatformComponents.showPlatformDialog(
      context,
      title: AppLocalizations.of(context)!.anonymous_login_title,
      content: AppLocalizations.of(context)!.anonymous_login_description,
      actions: <PlatformDialogAction>[
        PlatformDialogAction(
          action: (_) {
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).pop();
          },
          name: AppLocalizations.of(context)!.dismiss,
        ),
        PlatformDialogAction(
          action: (_) async {
            Navigator.of(context).pop();
            try {
              await ref
                  .read(authenticationRepositoryProvider)
                  .loginAnonymously();
              if (mounted) {
                context.pushReplacement(DanteRoute.dashboard.navigationUrl);
              }
            } on Exception catch (exception, stackTrace) {
              _loginErrorReceived(exception, stackTrace);
            }
          },
          name: AppLocalizations.of(context)!.login,
        ),
      ],
    );
  }
}
