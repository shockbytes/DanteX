import 'dart:async';

import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/themed_app_bar.dart';
import 'package:dantex/src/ui/profile/change_password_bottom_sheet.dart';
import 'package:dantex/src/ui/profile/email_bottom_sheet.dart';
import 'package:dantex/src/ui/profile/profile_row_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  createState() => ProfilePageSate();
}

class ProfilePageSate extends ConsumerState<ProfilePage> {
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(
        title: Text(
          'profile'.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: ref.watch(userProvider).when(
        data: (user) {
          if (_isLoading) {
            return const CircularProgressIndicator.adaptive();
          }
          return Column(
            children: [
              Visibility(
                visible: user?.source == AuthenticationSource.anonymous,
                child: ProfileRowItem(
                  label: Text('upgrade_account'.tr()),
                  button: DanteOutlinedButton(
                    onPressed: () async {
                      await _openUpgradeBottomSheet(context);
                    },
                    child: Text('upgrade'.tr()),
                  ),
                ),
              ),
              Visibility(
                visible: user?.source == AuthenticationSource.mail,
                child: ProfileRowItem(
                  label: Text('change_password'.tr()),
                  button: DanteOutlinedButton(
                    onPressed: () async {
                      await _openChangePasswordBottomSheet(context);
                    },
                    child: Text('change'.tr()),
                  ),
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          return const SizedBox.shrink();
        },
        loading: () {
          return const CircularProgressIndicator.adaptive();
        },
      ),
    );
  }

  Future<void> _openUpgradeBottomSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: const EmailBottomSheet(),
          ),
        );
      },
    );
  }

  Future<void> _openChangePasswordBottomSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
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
