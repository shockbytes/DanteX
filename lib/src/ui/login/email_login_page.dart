import 'package:dantex/main.dart';
import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/platform_components.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EmailLoginPage extends ConsumerStatefulWidget {
  const EmailLoginPage({Key? key}) : super(key: key);

  @override
  createState() => EmailLoginPageState();
}

class EmailLoginPageState extends ConsumerState<EmailLoginPage> {
  String? _emailErrorMessage;
  String? _passwordErrorMessage;

  LoginPhase _phase = LoginPhase.email;
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator.adaptive()
              : Center(
                  child: Column(
                    children: [
                      LoginPageTitle(
                        key: ValueKey('title-phase-$_phase'),
                        phase: _phase,
                      ),
                      SizedBox(
                        width: 360,
                        child: DanteComponents.textField(
                          context,
                          _emailController,
                          enabled: _phase == LoginPhase.email,
                          textInputType: TextInputType.emailAddress,
                          hint: AppLocalizations.of(context)!.email,
                          errorText: _emailErrorMessage,
                          onChanged: (val) async {
                            await _validateEmail(val);
                          },
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: _phase == LoginPhase.email ? 0.0 : 1.0,
                        child: SizedBox(
                          width: 360,
                          child: Column(
                            children: [
                              Padding(
                                key: ValueKey(_phase),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: DanteComponents.textField(
                                  context,
                                  _passwordController,
                                  obscureText: true,
                                  hint: AppLocalizations.of(context)!.password,
                                  errorText: _passwordErrorMessage,
                                  onChanged: (val) {
                                    if (_phase == LoginPhase.passwordNewUser) {
                                      _validatePassword(val);
                                    }
                                  },
                                ),
                              ),
                              Visibility(
                                visible:
                                    _phase == LoginPhase.passwordExistingUser,
                                child: GestureDetector(
                                  onTap: () async {
                                    await _buildForgotPasswordDialog();
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .forgot_password,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: DanteComponents.outlinedButton(
                          key: ValueKey(_phase),
                          child: Text(_getButtonText()),
                          onPressed: _getButtonAction(),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  String _getButtonText() {
    if (_phase == LoginPhase.email) {
      return AppLocalizations.of(context)!.cont;
    } else if (_phase == LoginPhase.passwordExistingUser) {
      return AppLocalizations.of(context)!.sign_in;
    } else {
      return AppLocalizations.of(context)!.sign_up_with_mail;
    }
  }

  void Function()? _getButtonAction() {
    if (_phase == LoginPhase.email) {
      if (_isValidEmail()) {
        setState(() {
          _emailErrorMessage = null;
        });
        return () async {
          final signInMethod = await ref
              .read(authenticationRepositoryProvider)
              .fetchSignInMethodsForEmail(email: _emailController.text);
          if (listEquals(signInMethod, [AuthenticationSource.google])) {
            await _buildGoogleAccountDialog();
          } else if (listEquals(signInMethod, [AuthenticationSource.mail])) {
            setState(() {
              _phase = LoginPhase.passwordExistingUser;
            });
          } else {
            setState(() {
              _phase = LoginPhase.passwordNewUser;
            });
          }
        };
      }
    } else if (_phase == LoginPhase.passwordExistingUser) {
      return () async {
        try {
          setState(() {
            _isLoading = true;
          });
          await ref.read(authenticationRepositoryProvider).loginWithEmail(
                email: _emailController.text,
                password: _passwordController.text,
              );
          if (mounted) {
            context.pushReplacement(DanteRoute.dashboard.navigationUrl);
          }
        } on Exception catch (exception, stackTrace) {
          setState(() {
            _isLoading = false;
          });
          _loginErrorReceived(exception, stackTrace);
        }
      };
    } else {
      if (_isValidPassword()) {
        return () async {
          try {
            setState(() {
              _isLoading = true;
            });
            await ref
                .read(authenticationRepositoryProvider)
                .createAccountWithMail(
                  email: _emailController.text,
                  password: _passwordController.text,
                );
            if (mounted) {
              context.pushReplacement(DanteRoute.dashboard.navigationUrl);
            }
          } on Exception catch (exception, stackTrace) {
            setState(() {
              _isLoading = false;
            });
            _createUserException(exception, stackTrace);
          }
        };
      }
    }
    return null;
  }

  void _createUserException(Exception exception, StackTrace stackTrace) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.account_creation_failed),
      ),
    );
  }

  void _loginErrorReceived(Exception exception, StackTrace stackTrace) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.login_failed)),
    );
  }

  Future<void> _buildForgotPasswordDialog() async {
    return PlatformComponents.showPlatformDialog(
      context,
      title: AppLocalizations.of(context)!.reset_password,
      content: AppLocalizations.of(context)!.reset_password_text,
      actions: <PlatformDialogAction>[
        PlatformDialogAction(
          action: (_) {
            // Close the dialog.
            Navigator.of(context).pop();
          },
          name: AppLocalizations.of(context)!.no_thanks,
          isPrimary: false,
        ),
        PlatformDialogAction(
          action: (_) async {
            // Close the dialog.
            Navigator.of(context).pop();
            await ref
                .read(authenticationRepositoryProvider)
                .sendPasswordResetRequest(email: _emailController.text);
            // Navigate back to the login page.
            if (mounted) {
              context.pushReplacement(DanteRoute.login.navigationUrl);
            }
          },
          name: 'Reset',
        ),
      ],
    );
  }

  Future<void> _buildGoogleAccountDialog() async {
    return PlatformComponents.showPlatformDialog(
      context,
      title: AppLocalizations.of(context)!.email_in_use_title,
      leading: const Icon(
        Icons.g_mobiledata,
        color: Colors.red,
      ),
      content: AppLocalizations.of(context)!.email_in_use_description,
      actions: <PlatformDialogAction>[
        PlatformDialogAction(
          action: (_) {
            // Close the dialog
            Navigator.of(context).pop();

            // Navigate back to the login page
            context.pushReplacement(
              DanteRoute.login.navigationUrl,
            );
          },
          name: AppLocalizations.of(context)!.got_it,
        ),
      ],
    );
  }

  bool _isValidPassword() {
    return _passwordErrorMessage == null && _passwordController.text != '';
  }

  bool _isValidEmail() {
    return _emailErrorMessage == null && _emailController.text != '';
  }

  Future<void> _validateEmail(String val) async {
    if (val.isEmpty) {
      setState(() {
        _emailErrorMessage = AppLocalizations.of(context)!.email_empty;
      });
    } else if (!EmailValidator.validate(val)) {
      setState(() {
        _emailErrorMessage = AppLocalizations.of(context)!.email_invalid;
      });
    } else {
      setState(() {
        _emailErrorMessage = null;
      });
    }
  }

  void _validatePassword(String val) {
    if (val.isEmpty) {
      setState(() {
        _passwordErrorMessage = AppLocalizations.of(context)!.password_empty;
      });
    } else if (val.length < 6) {
      setState(() {
        _passwordErrorMessage =
            AppLocalizations.of(context)!.password_too_short;
      });
    } else {
      setState(() {
        _passwordErrorMessage = null;
      });
    }
  }
}

enum LoginPhase {
  email,
  passwordExistingUser,
  passwordNewUser,
}

class LoginPageTitle extends StatelessWidget {
  final LoginPhase phase;

  const LoginPageTitle({required this.phase, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: Text(
          phase == LoginPhase.email
              ? AppLocalizations.of(context)!.enter_email
              : AppLocalizations.of(context)!.password,
          key: ValueKey(phase),
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}