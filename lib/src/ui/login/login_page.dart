import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dantex/main.dart';
import 'package:dantex/src/bloc/auth/auth_bloc.dart';
import 'package:dantex/src/bloc/auth/login_event.dart';
import 'package:dantex/src/bloc/auth/management_event.dart';
import 'package:dantex/src/providers/bloc.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/platform_components.dart';
import 'package:dantex/src/ui/login/email_bottom_sheet.dart';
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
  late StreamSubscription<LoginEvent> _loginSubscription;
  late AuthBloc _bloc;

  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _bloc = ref.read(authBlocProvider);
    _isLoading = false;
    _loginSubscription = _bloc.loginEvents.listen(
      _loginEventReceived,
      onError: (exception, stackTrace) => _loginErrorReceived(exception, stackTrace),
    );
    _bloc.managementEvents.listen(
      _managementEventReceived,
      onError: (exception, stackTrace) => _managementErrorReceived(exception, stackTrace),
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

      context.pushReplacement(DanteRoute.dashboard.navigationUrl);
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant),
        child: Center(
          child: _isLoading
              ? CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                )
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo/ic-launcher.jpg',
                        width: 92,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.welcome_back,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.login_with_account,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 24),
                      DanteComponents.outlinedButton(
                        onPressed: () => _bloc.loginWithGoogle(),
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: 'https://static-00.iconduck.com/assets.00/google-icon-2048x2048-czn3g8x8.png',
                              height: 24,
                              width: 24,
                            ),
                            const SizedBox(width: 4),
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
                            Icon(
                              Icons.mail_outline,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.login_with_email,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
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
                        onPressed: () => _buildAnonymousLoginDialog(),
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
                                  color: Theme.of(context).colorScheme.secondary,
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
