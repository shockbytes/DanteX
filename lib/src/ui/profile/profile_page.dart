import 'dart:async';

import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/themed_app_bar.dart';
import 'package:dantex/src/ui/profile/change_password_bottom_sheet.dart';
import 'package:dantex/src/ui/profile/email_bottom_sheet.dart';
import 'package:dantex/src/ui/profile/profile_row_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  createState() => ProfilePageSate();
}

class ProfilePageSate extends ConsumerState<ProfilePage> {
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: ref.read(userProvider).when(
        data: (user) {
          if (_isLoading) {
            return const CircularProgressIndicator.adaptive();
          }
          return Column(
            children: [
              Visibility(
                visible: user?.source == AuthenticationSource.anonymous,
                child: ProfileRowItem(
                  label: Text(
                    AppLocalizations.of(context)!.upgrade_account,
                  ),
                  button: DanteComponents.outlinedButton(
                    onPressed: () async {
                      await _openUpgradeBottomSheet(context);
                    },
                    child: Text(AppLocalizations.of(context)!.upgrade),
                  ),
                ),
              ),
              Visibility(
                visible: user?.source == AuthenticationSource.mail,
                child: ProfileRowItem(
                  label: Text(
                    AppLocalizations.of(context)!.change_password,
                  ),
                  button: DanteComponents.outlinedButton(
                    onPressed: () async {
                      await _openChangePasswordBottomSheet(context);
                    },
                    child: Text(AppLocalizations.of(context)!.change),
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
