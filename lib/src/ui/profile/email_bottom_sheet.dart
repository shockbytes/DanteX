import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/handle.dart';
import 'package:dantex/src/ui/core/platform_components.dart';
import 'package:dantex/src/ui/main/main_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailBottomSheet extends ConsumerStatefulWidget {
  const EmailBottomSheet({Key? key}) : super(key: key);

  @override
  createState() => EmailBottomSheetState();
}

class EmailBottomSheetState extends ConsumerState<EmailBottomSheet> {
  String? _emailErrorMessage;
  String? _passwordErrorMessage;

  LoginPhase _phase = LoginPhase.email;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 300,
        child: Center(
          child: Column(
            children: <Widget>[
              const Handle(),
              BottomSheetTitle(
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
                        padding: const EdgeInsets.symmetric(vertical: 8),
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
    );
  }

  String _getButtonText() {
    if (_phase == LoginPhase.email) {
      return AppLocalizations.of(context)!.cont;
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
            if (mounted) {
              Navigator.of(context).pop();
            }
            await _buildGoogleAccountDialog();
          } else {
            setState(() {
              _phase = LoginPhase.passwordNewUser;
            });
          }
        };
      }
    } else {
      if (_isValidPassword()) {
        return () async {
          try {
            await ref
                .read(authenticationRepositoryProvider)
                .upgradeAnonymousAccount(
                  email: _emailController.text,
                  password: _passwordController.text,
                );
            if (mounted) {
              Navigator.of(context).pop();
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const MainPage(),
                ),
              );
            }
          } on Exception catch (exception, stackTrace) {
            _upgradeUserException(exception, stackTrace);
          }
        };
      }
    }
    return null;
  }

  void _upgradeUserException(Exception exception, StackTrace stackTrace) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.upgrade_failed,
        ),
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
            Navigator.of(context).pop();
          },
          name: AppLocalizations.of(context)!.no_thanks,
          isPrimary: false,
        ),
        PlatformDialogAction(
          action: (_) async {
            Navigator.of(context).pop();
            await ref
                .read(authenticationRepositoryProvider)
                .sendPasswordResetRequest(email: _emailController.text);
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
          action: (_) => Navigator.of(context).pop(),
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
      final signInMethod = await ref
          .read(authenticationRepositoryProvider)
          .fetchSignInMethodsForEmail(email: _emailController.text);
      if (signInMethod.isNotEmpty) {
        setState(() {
          _emailErrorMessage = AppLocalizations.of(context)!.email_in_use_title;
        });
      } else {
        setState(() {
          _emailErrorMessage = null;
        });
      }
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
  passwordNewUser,
}

class BottomSheetTitle extends StatelessWidget {
  final LoginPhase phase;

  const BottomSheetTitle({required this.phase, Key? key}) : super(key: key);

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