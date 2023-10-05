import 'dart:async';

import 'package:dantex/src/bloc/auth/auth_bloc.dart';
import 'package:dantex/src/bloc/auth/login_event.dart';
import 'package:dantex/src/bloc/auth/management_event.dart';
import 'package:dantex/src/core/injection/dependency_injector.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/platform_components.dart';
import 'package:dantex/src/ui/login/email_bottom_sheet.dart';
import 'package:dantex/src/ui/main/main_page.dart';
import 'package:dantex/src/util/dante_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final AuthBloc _bloc = DependencyInjector.get<AuthBloc>();
  late StreamSubscription<LoginEvent> _loginSubscription;

  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _loginSubscription = _bloc.loginEvents.listen(
      _loginEventReceived,
      onError: (exception, stackTrace) =>
          _loginErrorReceived(exception, stackTrace),
    );
    _bloc.managementEvents.listen(
      _managementEventReceived,
      onError: (exception, stackTrace) =>
          _managementErrorReceived(exception, stackTrace),
    );
  }

  @override
  void dispose() {
    _loginSubscription.cancel();
    _isLoading = false;
    super.dispose();
  }

  void _loginErrorReceived(Exception exception, StackTrace stackTrace) {
    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.login_failed)),
    );
  }

  void _managementErrorReceived(Exception exception, StackTrace stackTrace) {
    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.account_creation_failed),
      ),
    );
  }

  void _loginEventReceived(LoginEvent event) {
    if (event == LoginEvent.loggingIn) {
      setState(() {
        _isLoading = true;
      });
    } else if (event == LoginEvent.googleLogin ||
        event == LoginEvent.anonymousLogin ||
        event == LoginEvent.emailLogin) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    }
  }

  void _managementEventReceived(ManagementEvent event) {
    if (event == ManagementEvent.creatingAccount) {
      setState(() {
        _isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(color: DanteColors.accent),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator(
                  color: DanteColors.background,
                )
              : Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: DanteColors.background,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        onPressed: () => _bloc.loginWithGoogle(),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.g_mobiledata,
                              color: Colors.red,
                            ),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.login_with_google,
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
                        onPressed: () => _openLoginBottomSheet(),
                        child: Row(
                          children: [
                            const Icon(Icons.mail_outline),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.login_with_email,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(
                        height: 2,
                        color: DanteColors.accent,
                      ),
                      const SizedBox(height: 16),
                      DanteComponents.outlinedButton(
                        onPressed: () => _buildAnonymousLoginDialog(),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.no_accounts_outlined,
                              color: DanteColors.textPrimary,
                            ),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.stay_anonymous,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: DanteColors.textPrimary,
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
    );
  }

  void _openLoginBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: EmailBottomSheet(
              unknownEmailAction: _bloc.createAccountWithMail,
              allowExistingEmails: true,
            ),
          ),
        );
      },
    );
  }

  void _buildAnonymousLoginDialog() {
    PlatformComponents.showPlatformDialog(
      context,
      title: AppLocalizations.of(context)!.anonymous_login_title,
      content: AppLocalizations.of(context)!.anonymous_login_description,
      actions: <PlatformDialogAction>[
        PlatformDialogAction(
          action: (_) => Navigator.of(context).pop(),
          name: AppLocalizations.of(context)!.dismiss,
        ),
        PlatformDialogAction(
          action: (_) {
            Navigator.of(context).pop();
            _bloc.loginAnonymously();
          },
          name: AppLocalizations.of(context)!.login,
        ),
      ],
    );
  }
}
