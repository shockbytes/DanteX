import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/handle.dart';
import 'package:dantex/src/ui/core/platform_components.dart';
import 'package:dantex/src/ui/main/main_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailBottomSheet extends ConsumerStatefulWidget {
  const EmailBottomSheet({super.key});

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
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: DanteTextField(
                          controller: _passwordController,
                          obscureText: true,
                          hint: 'password'.tr(),
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
                child: DanteOutlinedButton(
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
      return 'continue'.tr();
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
        content: Text('upgrade_failed'.tr()),
      ),
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
      content: 'email_in_use_description'.tr(),
      actions: <DanteDialogAction>[
        DanteDialogAction(
          action: (_) => Navigator.of(context).pop(),
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
      final signInMethod = await ref
          .read(authenticationRepositoryProvider)
          .fetchSignInMethodsForEmail(email: _emailController.text);
      if (signInMethod.isNotEmpty) {
        setState(() {
          _emailErrorMessage = 'email_in_use_title'.tr();
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
  passwordNewUser,
}

class BottomSheetTitle extends StatelessWidget {
  final LoginPhase phase;

  const BottomSheetTitle({required this.phase, super.key});

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
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
