import 'package:dantex/src/bloc/auth/auth_bloc.dart';
import 'package:dantex/src/providers/bloc.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/handle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePasswordBottomSheet extends ConsumerStatefulWidget {
  const ChangePasswordBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  createState() => ChangePasswordBottomSheetState();
}

class ChangePasswordBottomSheetState
    extends ConsumerState<ChangePasswordBottomSheet> {
  String? _passwordErrorMessage;

  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthBloc bloc = ref.read(authBlocProvider);

    return SafeArea(
      child: Container(
        height: 300,
        child: Center(
          child: Column(
            children: <Widget>[
              const Handle(),
              Text(
                AppLocalizations.of(context)!.password,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                width: 360,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: DanteComponents.textField(
                    context,
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
              DanteComponents.outlinedButton(
                child: Text(AppLocalizations.of(context)!.change_password),
                onPressed: () {
                  if (_isValidPassword()) {
                    Navigator.of(context).pop();
                    bloc.changePassword(password: _passwordController.text);
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
