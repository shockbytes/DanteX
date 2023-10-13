import 'package:dantex/src/ui/core/themed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
        ),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.settings_appearance_title),
            tiles: [
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.settings_appearance_theme),
                value: Text(AppLocalizations.of(context)!.settings_appearance_theme_system),
                leading: const Icon(Icons.dark_mode_outlined),
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.settings_books_title),
            tiles: [
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.settings_books_sort),
                value: Text(AppLocalizations.of(context)!.settings_books_sort_standard),
                leading: const Icon(Icons.sort),
              ),
              SettingsTile.switchTile(
                initialValue: true,
                activeSwitchColor: Theme.of(context).colorScheme.primary,
                onToggle: (bool newVal) {},
                title: Text(AppLocalizations.of(context)!.settings_books_random_book),
                leading: const Icon(Icons.play_circle_filled_outlined),
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.settings_contribute_title),
            tiles: [
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.settings_contribute_code),
                leading: const Icon(Icons.code),
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.settings_contribute_community),
                leading: const Icon(Icons.groups_outlined),
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.settings_contribute_feedback),
                leading: const Icon(Icons.mail_outline),
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.settings_data_privacy_title),
            tiles: [
              SettingsTile.switchTile(
                initialValue: true,
                activeSwitchColor: Theme.of(context).colorScheme.primary,
                onToggle: (bool newVal) {},
                title: Text(AppLocalizations.of(context)!.settings_data_privacy_tracking),
                leading: const Icon(Icons.supervised_user_circle_outlined),
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.settings_data_privacy_data_privacy),
                leading: const Icon(Icons.privacy_tip_outlined),
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.settings_data_privacy_terms_and_conditions),
                leading: const Icon(Icons.verified_user_outlined),
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.settings_about_title),
            tiles: [
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.settings_about_developers_title),
                value: Text(
                  AppLocalizations.of(context)!.settings_about_developers,
                  textAlign: TextAlign.end,
                ),
                leading: const Icon(Icons.flash_on),
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.version),
                value: Text(AppLocalizations.of(context)!.version_number),
                leading: const Icon(Icons.info_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
