import 'package:dantex/src/bloc/auth/auth_bloc.dart';
import 'package:dantex/src/core/injection/dependency_injector.dart';
import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/handle.dart';
import 'package:dantex/src/util/dante_colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class EmailBottomSheet extends StatefulWidget {
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

class EmailBottomSheetState extends State<EmailBottomSheet> {
  final AuthBloc _bloc = DependencyInjector.get<AuthBloc>();

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
              _buildTitle(),
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
                  child: Padding(
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
                ),
              ),
              const Spacer(),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: OutlinedButton(
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

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: Text(
          _phase == LoginPhase.email
              ? AppLocalizations.of(context)!.enter_email
              : AppLocalizations.of(context)!.password,
          key: ValueKey(_phase),
          style: const TextStyle(
            color: DanteColors.textPrimary,
            fontWeight: FontWeight.w400,
            fontSize: 20,
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
          final signInMethod = await _bloc.fetchSignInMethodsForEmail(
            email: _emailController.text,
          );
          if (listEquals(signInMethod, [AuthenticationSource.google])) {
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
        Get.back();
        _bloc.loginWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
        );
      };
    } else {
      if (_isValidPassword()) {
        return () {
          Get.back();
          widget.unknownEmailAction(
            email: _emailController.text,
            password: _passwordController.text,
          );
        };
      }
    }
    return null;
  }

  void _buildGoogleAccountDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          children: [
            const Icon(
              Icons.g_mobiledata,
              color: Colors.red,
            ),
            Text(AppLocalizations.of(context)!.email_in_use_title),
          ],
        ),
        content: Text(AppLocalizations.of(context)!.email_in_use_description),
        actions: <Widget>[
          OutlinedButton(
            onPressed: () => Get.back(),
            child: Text(AppLocalizations.of(context)!.got_it),
          ),
        ],
      ),
    );
  }

  bool _isValidPassword() {
    return _passwordErrorMessage == null && _passwordController.text != '';
  }

  bool _isValidEmail() {
    return _emailErrorMessage == null && _emailController.text != '';
  }

  void _validateEmail(String val) async {
    final signInMethod = await _bloc.fetchSignInMethodsForEmail(
      email: _emailController.text,
    );

    if (val.isEmpty) {
      setState(() {
        _emailErrorMessage = AppLocalizations.of(context)!.email_empty;
      });
    } else if (!EmailValidator.validate(val)) {
      setState(() {
        _emailErrorMessage = AppLocalizations.of(context)!.email_invalid;
      });
    } else if (!widget.allowExistingEmails && signInMethod.isNotEmpty) {
      setState(() {
        _emailErrorMessage = AppLocalizations.of(context)!.email_in_use_title;
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