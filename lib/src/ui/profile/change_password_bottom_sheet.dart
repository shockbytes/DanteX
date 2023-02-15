import 'package:dantex/src/bloc/auth/auth_bloc.dart';
import 'package:dantex/src/core/injection/dependency_injector.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/handle.dart';
import 'package:dantex/src/util/dante_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class ChangePasswordBottomSheet extends StatefulWidget {
  const ChangePasswordBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  createState() => ChangePasswordBottomSheetState();
}

class ChangePasswordBottomSheetState extends State<ChangePasswordBottomSheet> {
  final AuthBloc _bloc = DependencyInjector.get<AuthBloc>();

  String? _passwordErrorMessage;

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
              Text(
                AppLocalizations.of(context)!.password,
                style: const TextStyle(
                  color: DanteColors.textPrimary,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                width: 360,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: DanteComponents.textField(
                    _passwordController,
                    obscureText: true,
                    hint: AppLocalizations.of(context)!.password,
                    errorText: _passwordErrorMessage,
                    onChanged: (val) {
                      _validatePassword(val);
                    },
                  ),
                ),
              ),
              const Spacer(),
              OutlinedButton(
                child: Text(AppLocalizations.of(context)!.change_password),
                onPressed: () {
                  if (_isValidPassword()) {
                    Get.back();
                    _bloc.changePassword(password: _passwordController.text);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isValidPassword() {
    return _passwordErrorMessage == null && _passwordController.text != '';
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
