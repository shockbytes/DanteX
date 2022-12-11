import 'dart:async';

import 'package:dantex/src/bloc/auth/auth_bloc.dart';
import 'package:dantex/src/bloc/auth/auth_event.dart';
import 'package:dantex/src/core/injection/dependency_injector.dart';
import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:dantex/src/ui/core/themed_app_bar.dart';
import 'package:dantex/src/ui/login/email_bottom_sheet.dart';
import 'package:dantex/src/ui/profile/ProfileRowItem.dart';
import 'package:dantex/src/ui/profile/change_password_bottom_sheet.dart';
import 'package:dantex/src/util/dante_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  createState() => ProfilePageSate();
}

class ProfilePageSate extends State<ProfilePage> {
  final AuthBloc _bloc = DependencyInjector.get<AuthBloc>();
  late StreamSubscription<AuthEvent> _authSubscription;
  late bool _isLoading;
  late DanteUser? _user;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _authSubscription = _bloc.authEvents.listen(
      _authEventReceived,
      onError: (exception, stackTrace) =>
          _authErrorReceived(exception, stackTrace),
    );
    _getUser();
  }

  void _getUser() async {
    final currentUser = await _bloc.getAccount();
    setState(() {
      _user = currentUser;
    });
  }

  void _authErrorReceived(Exception exception, StackTrace stackTrace) {
    setState(() {
      _isLoading = false;
    });
    // TODO: Check if error is from upgrading email before showing this toast.
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

  void _authEventReceived(AuthEvent event) {
    if (event == AuthEvent.upgradingAnonymousAccount) {
      setState(() {
        _isLoading = true;
      });
    } else if (event == AuthEvent.emailLogin) {
      setState(() {
        _isLoading = false;
      });
      Get.back();
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
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
          AppLocalizations.of(context)!.profile,
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
                  visible: _user?.source == AuthenticationSource.anonymous,
                  child: ProfileRowItem(
                    label: Text(
                      AppLocalizations.of(context)!.upgrade_account,
                    ),
                    button: OutlinedButton(
                      onPressed: () {
                        _openUpgradeBottomSheet(context);
                      },
                      child: Text(AppLocalizations.of(context)!.upgrade),
                    ),
                  ),
                ),
                ProfileRowItem(
                  label: Text(
                    AppLocalizations.of(context)!.change_password,
                  ),
                  button: OutlinedButton(
                    onPressed: () {
                      _openChangePasswordBottomSheet(context);
                    },
                    child: Text(AppLocalizations.of(context)!.change),
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

  _openChangePasswordBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: const ChangePasswordBottomSheet(),
          ),
        );
      },
    );
  }
}
