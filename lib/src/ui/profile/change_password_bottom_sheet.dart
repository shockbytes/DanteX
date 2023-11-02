import 'package:dantex/src/providers/authentication.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/handle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePasswordBottomSheet extends ConsumerStatefulWidget {
  const ChangePasswordBottomSheet({
    super.key,
  });

  @override
  createState() => ChangePasswordBottomSheetState();
}

class ChangePasswordBottomSheetState
    extends ConsumerState<ChangePasswordBottomSheet> {
  String? _passwordErrorMessage;

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
              Text(
                'password'.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                width: 360,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: DanteTextField(
                    controller: _passwordController,
                    obscureText: true,
                    hint: 'password'.tr(),
                    errorText: _passwordErrorMessage,
                    onChanged: (val) {
                      _validatePassword(val);
                    },
                  ),
                ),
              ),
              const Spacer(),
              DanteOutlinedButton(
                child: Text('change_password'.tr()),
                onPressed: () async {
                  if (_isValidPassword()) {
                    Navigator.of(context).pop();
                    await ref
                        .read(authenticationRepositoryProvider)
                        .updateMailPassword(password: _passwordController.text);
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
