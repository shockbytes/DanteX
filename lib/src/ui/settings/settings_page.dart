import 'package:dantex/src/ui/core/themed_app_bar.dart';
import 'package:dantex/src/util/url_launcher.dart';
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
                onPressed: (context) {
                  // TODO Switch theme
                },
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
                onPressed: (context) {
                  // TODO Save book sorting strategy
                },
              ),
              SettingsTile.switchTile(
                initialValue: true,
                activeSwitchColor: Theme.of(context).colorScheme.primary,
                onToggle: (bool newVal) {
                  // TODO Save if random book should be shown
                },
                title: Text(AppLocalizations.of(context)!.settings_books_random_book),
                leading: const Icon(Icons.casino_outlined),
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.settings_contribute_title),
            tiles: [
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.settings_contribute_code),
                leading: const Icon(Icons.code),
                onPressed: (context) => UrlLauncher.launch('https://github.com/shockbytes/DanteX'),
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.settings_contribute_community),
                leading: const Icon(Icons.groups_outlined),
                onPressed: (context) => UrlLauncher.launch('https://discord.gg/EujYrCHjkm'),
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.settings_contribute_feedback),
                leading: const Icon(Icons.mail_outline),
                onPressed: (context) {
                  String body = '\n\n\nVersion: ${AppLocalizations.of(context)!.version_number}';
                  UrlLauncher.launch(
                    'mailto:shockbytesstudio@gmail.com?subject=Feedback Dante App&body=$body',
                  );
                }
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.settings_data_privacy_title),
            tiles: [
              SettingsTile.switchTile(
                initialValue: true,
                activeSwitchColor: Theme.of(context).colorScheme.primary,
                onToggle: (bool newVal) {
                  // TODO Switch tracking
                },
                title: Text(AppLocalizations.of(context)!.settings_data_privacy_tracking),
                leading: const Icon(Icons.supervised_user_circle_outlined),
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.settings_data_privacy_data_privacy),
                leading: const Icon(Icons.privacy_tip_outlined),
                onPressed: (context) => UrlLauncher.launch('https://dantebooks.com/#/privacy'),
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.settings_data_privacy_terms_and_conditions),
                leading: const Icon(Icons.verified_user_outlined),
                onPressed: (context) => UrlLauncher.launch('https://dantebooks.com/#/terms'),
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.settings_about_title),
            tiles: [
              SettingsTile.navigation(
                title: Text(AppLocalizations.of(context)!.settings_about_developers_title),
                value: Text(
                  AppLocalizations.of(context)!.settings_about_developers,
                  textAlign: TextAlign.end,
                ),
                leading: const Icon(Icons.flash_on),
                onPressed: (context) {
                  // TODO Show developer profiles
                },
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
