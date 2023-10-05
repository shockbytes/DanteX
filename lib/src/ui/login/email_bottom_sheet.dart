import 'package:dantex/src/bloc/auth/auth_bloc.dart';
import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/handle.dart';
import 'package:dantex/src/ui/core/platform_components.dart';
import 'package:dantex/src/util/dante_colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailBottomSheet extends ConsumerStatefulWidget {
  final bool allowExistingEmails;
  final void Function({
    required String email,
    required String password,
  }) unknownEmailAction;

  const EmailBottomSheet({
    Key? key,
    required this.unknownEmailAction,
    required this.allowExistingEmails,
  }) : super(key: key);

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
      child: Container(
        height: 300,
        color: DanteColors.background,
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
                  _emailController,
                  enabled: _phase == LoginPhase.email,
                  textInputType: TextInputType.emailAddress,
                  hint: AppLocalizations.of(context)!.email,
                  errorText: _emailErrorMessage,
                  onChanged: (val) {
                    _validateEmail(val);
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
                        visible: _phase == LoginPhase.passwordExistingUser,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            _buildForgotPasswordDialog();
                          },
                          child: Text(
                            AppLocalizations.of(context)!.forgot_password,
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
    final AuthBloc bloc = ref.read(authBlocProvider);

    if (_phase == LoginPhase.email) {
      if (_isValidEmail()) {
        setState(() {
          _emailErrorMessage = null;
        });
        return () async {
          final signInMethod = await bloc.fetchSignInMethodsForEmail(
            email: _emailController.text,
          );
          if (listEquals(signInMethod, [AuthenticationSource.google])) {
            if (mounted) {
              Navigator.of(context).pop();
            }
            _buildGoogleAccountDialog();
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
      return () {
        Navigator.of(context).pop();
        bloc.loginWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
        );
      };
    } else {
      if (_isValidPassword()) {
        return () {
          Navigator.of(context).pop();
          widget.unknownEmailAction(
            email: _emailController.text,
            password: _passwordController.text,
          );
        };
      }
    }
    return null;
  }

  void _buildForgotPasswordDialog() {
    final AuthBloc bloc = ref.read(authBlocProvider);

    PlatformComponents.showPlatformDialog(
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
          action: (_) {
            Navigator.of(context).pop();
            bloc.sendPasswordResetRequest(email: _emailController.text);
          },
          name: 'Reset',
          isPrimary: true,
        ),
      ],
    );
  }

  void _buildGoogleAccountDialog() {
    PlatformComponents.showPlatformDialog(
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

  void _validateEmail(String val) async {
    final AuthBloc bloc = ref.read(authBlocProvider);

    if (val.isEmpty) {
      setState(() {
        _emailErrorMessage = AppLocalizations.of(context)!.email_empty;
      });
    } else if (!EmailValidator.validate(val)) {
      setState(() {
        _emailErrorMessage = AppLocalizations.of(context)!.email_invalid;
      });
    } else if (!widget.allowExistingEmails) {
      final signInMethod = await bloc.fetchSignInMethodsForEmail(
        email: _emailController.text,
      );
      if (signInMethod.isNotEmpty) {
        setState(() {
          _emailErrorMessage = AppLocalizations.of(context)!.email_in_use_title;
        });
      }
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

class BottomSheetTitle extends StatelessWidget {
  final LoginPhase phase;

  const BottomSheetTitle({Key? key, required this.phase}) : super(key: key);

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
            color: DanteColors.textPrimary,
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
