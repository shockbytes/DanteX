import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:dantex/src/providers/app_router.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/platform_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EmailLoginPage extends ConsumerStatefulWidget {
  const EmailLoginPage({super.key});

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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        leading: BackButton(
          onPressed: () => context.pushReplacement(
            DanteRoute.login.navigationUrl,
          ),
        ),
      ),
      body: Material(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
          child: SafeArea(
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator.adaptive()
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoginPageTitle(
                            key: ValueKey('title-phase-$_phase'),
                            phase: _phase,
                          ),
                          SizedBox(
                            width: 360,
                            child: DanteTextField(
                              controller: _emailController,
                              enabled: _phase == LoginPhase.email,
                              textInputType: TextInputType.emailAddress,
                              hint: 'email'.tr(),
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
                                    child: DanteTextField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      hint: 'password'.tr(),
                                      errorText: _passwordErrorMessage,
                                      onChanged: (val) {
                                        if (_phase ==
                                            LoginPhase.passwordNewUser) {
                                          _validatePassword(val);
                                        }
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: _phase ==
                                        LoginPhase.passwordExistingUser,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await _buildForgotPasswordDialog();
                                      },
                                      child: Text('forgot_password'.tr()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: DanteOutlinedButton(
                              key: ValueKey(_phase),
                              onPressed: _getButtonAction(),
                              child: Text(_getButtonText()),
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

  String _getButtonText() {
    if (_phase == LoginPhase.email) {
      return 'continue'.tr();
    } else if (_phase == LoginPhase.passwordExistingUser) {
      return 'sign_in'.tr();
    } else {
      return 'sign_up_with_mail'.tr();
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
        content: Text('account_creation_failed'.tr()),
      ),
    );
  }

  void _loginErrorReceived(Exception exception, StackTrace stackTrace) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('login_failed'.tr())),
    );
  }

  Future<void> _buildForgotPasswordDialog() async {
    return showDanteDialog(
      context,
      title: 'reset_password'.tr(),
      content: Text('reset_password_text'.tr()),
      actions: <DanteDialogAction>[
        DanteDialogAction(
          action: (_) {
            // Close the dialog.
            Navigator.of(context).pop();
          },
          name: 'no_thanks'.tr(),
          isPrimary: false,
        ),
        DanteDialogAction(
          action: (_) async {
            // Close the dialog.
            Navigator.of(context).pop();
            await ref
                .read(authenticationRepositoryProvider)
                .sendPasswordResetRequest(email: _emailController.text);
            // Navigate back to the login page.
            if (context.mounted) {
              context.pushReplacement(DanteRoute.login.navigationUrl);
            }
          },
          name: 'Reset',
        ),
      ],
    );
  }

  Future<void> _buildGoogleAccountDialog() async {
    return showDanteDialog(
      context,
      title: 'email_in_use_title'.tr(),
      leading: const Icon(
        Icons.g_mobiledata,
        color: Colors.red,
      ),
      content: Text('email_in_use_description'.tr()),
      actions: <DanteDialogAction>[
        DanteDialogAction(
          action: (_) {
            // Close the dialog
            Navigator.of(context).pop();

            // Navigate back to the login page
            context.pushReplacement(
              DanteRoute.login.navigationUrl,
            );
          },
          name: 'got_it'.tr(),
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
        _emailErrorMessage = 'email_empty'.tr();
      });
    } else if (!EmailValidator.validate(val)) {
      setState(() {
        _emailErrorMessage = 'email_invalid'.tr();
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
        _passwordErrorMessage = 'password_empty'.tr();
      });
    } else if (val.length < 6) {
      setState(() {
        _passwordErrorMessage = 'password_too_short'.tr();
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

  const LoginPageTitle({required this.phase, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: Text(
          phase == LoginPhase.email ? 'enter_email'.tr() : 'password'.tr(),
          key: ValueKey(phase),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
