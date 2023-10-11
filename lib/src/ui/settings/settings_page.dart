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
            title: Text('Appearance'),
            tiles: [
              SettingsTile(
                title: Text('Theme'),
                value: Text('System'),
                leading: Icon(Icons.dark_mode_outlined),
              ),
            ],
          ),
          SettingsSection(
            title: Text('Books'),
            tiles: [
              SettingsTile(
                title: Text('Sort books'),
                value: Text('Standard'),
                leading: Icon(Icons.sort),
              ),
              SettingsTile.switchTile(
                initialValue: true,
                activeSwitchColor: Theme.of(context).colorScheme.primary,
                onToggle: (bool newVal) {},
                title: Text('Random book'),
                leading: Icon(Icons.play_circle_filled_outlined),
              ),
            ],
          ),
          SettingsSection(
            title: Text('Data Privacy'),
            tiles: [
              SettingsTile(
                title: Text('Code'),
                leading: Icon(Icons.code),
              ),
              SettingsTile(
                title: Text('Community'),
                leading: Icon(Icons.groups_outlined),
              ),
              SettingsTile(
                title: Text('Feedback'),
                leading: Icon(Icons.mail_outline),
              ),
            ],
          ),
          SettingsSection(
            title: Text('Data Privacy'),
            tiles: [
              SettingsTile.switchTile(
                initialValue: true,
                activeSwitchColor: Theme.of(context).colorScheme.primary,
                onToggle: (bool newVal) {},
                title: Text('tracking'),
                leading: Icon(Icons.supervised_user_circle_outlined),
              ),
              SettingsTile(
                title: Text('Data Privacy'),
                leading: Icon(Icons.privacy_tip_outlined),
              ),
              SettingsTile(
                title: Text('Terms and Conditions'),
                leading: Icon(Icons.verified_user_outlined),
              ),
            ],
          ),
          SettingsSection(
            title: Text('About'),
            tiles: [
              SettingsTile(
                title: Text('Developer'),
                value: Text(
                  'Shockbytes Studio\n2016 - 2023',
                  textAlign: TextAlign.end,
                ),
                leading: Icon(Icons.flash_on),
              ),
              SettingsTile(
                title: Text('App Version'),
                value: Text('5.0'),
                leading: Icon(Icons.info_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
