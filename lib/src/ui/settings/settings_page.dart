import 'dart:async';

import 'package:dantex/src/bloc/auth/login_bloc.dart';
import 'package:dantex/src/bloc/auth/login_event.dart';
import 'package:dantex/src/core/injection/dependency_injector.dart';
import 'package:dantex/src/ui/core/themed_app_bar.dart';
import 'package:dantex/src/ui/login/email_bottom_sheet.dart';
import 'package:dantex/src/util/dante_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  final bool isAnonymousUser;

  const SettingsPage({
    Key? key,
    required this.isAnonymousUser,
  }) : super(key: key);

  @override
  createState() => SettingsPageSate();
}

class SettingsPageSate extends State<SettingsPage> {
  final LoginBloc _bloc = DependencyInjector.get<LoginBloc>();
  late StreamSubscription<LoginEvent> _loginSubscription;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _loginSubscription = _bloc.loginEvents.listen(
      _loginEventReceived,
      onError: (exception, stackTrace) =>
          _loginErrorReceived(exception, stackTrace),
    );
  }

  void _loginErrorReceived(Exception exception, StackTrace stackTrace) {
    setState(() {
      _isLoading = false;
    });
    Fluttertoast.showToast(
      msg: AppLocalizations.of(context)!.upgrade_failed,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: DanteColors.background,
      textColor: Colors.red,
      fontSize: 16.0,
    );
  }

  void _loginEventReceived(LoginEvent event) {
    if (event == LoginEvent.upgradingAnonymousAccount) {
      setState(() {
        _isLoading = true;
      });
    } else if (event == LoginEvent.emailLogin) {
      setState(() {
        _isLoading = false;
      });
      Get.back();
    }
  }

  @override
  void dispose() {
    _loginSubscription.cancel();
    _isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(
        leading: InkWell(
          child: const Icon(
            Icons.arrow_back,
            color: DanteColors.textPrimary,
          ),
          enableFeedback: true,
          onTap: () => Get.back(),
        ),
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: const TextStyle(
            color: DanteColors.textPrimary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: _isLoading
          ? const CircularProgressIndicator()
          : Column(
              children: [
                Visibility(
                  visible: widget.isAnonymousUser,
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.upgrade_account,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          _openUpgradeBottomSheet(context);
                        },
                        child: Text(AppLocalizations.of(context)!.upgrade),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  _openUpgradeBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: EmailBottomSheet(
              unknownEmailAction: _bloc.upgradeAnonymousAccount,
              allowExistingEmails: false,
            ),
          ),
        );
      },
    );
  }
}
