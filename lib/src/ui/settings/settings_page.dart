import 'package:dantex/main.dart';
import 'package:dantex/src/data/book/book_sort_strategy.dart';
import 'package:dantex/src/data/settings/settings_repository.dart';
import 'package:dantex/src/providers/repository.dart';
import 'package:dantex/src/ui/core/themed_app_bar.dart';
import 'package:dantex/src/ui/settings/single_choice_dialog.dart';
import 'package:dantex/src/util/url_launcher.dart';
import 'package:dantex/src/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late final SettingsRepository _repository;

  bool _isTrackingEnabled = false;
  bool _isRandomBooksEnabled = false;
  late ThemeMode _selectedTheme;
  late BookSortStrategy _selectedSortStrategy;

  @override
  void initState() {
    _repository = ref.read(settingsRepositoryProvider);
    _isTrackingEnabled = _repository.isTrackingEnabled();
    _isRandomBooksEnabled = _repository.isRandomBooksEnabled();
    _selectedTheme = _repository.getThemeMode();
    _selectedSortStrategy = _repository.getSortingStrategy();
    super.initState();
  }

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
            title:
                Text(AppLocalizations.of(context)!.settings_appearance_title),
            tiles: [
              SettingsTile(
                title: Text(
                  AppLocalizations.of(context)!.settings_appearance_theme,
                ),
                value: _buildTextValue(context, _selectedTheme.name),
                leading: const Icon(Icons.dark_mode_outlined),
                onPressed: (context) {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) => SingleChoiceDialog<ThemeMode>(
                      title: AppLocalizations.of(context)!
                          .settings_appearance_theme_choose_title,
                      icon: Icons.dark_mode_outlined,
                      selectedValue: _selectedTheme,
                      choices: ThemeMode.values
                          .map(
                            (e) => Choice<ThemeMode>(title: e.name, key: e),
                          )
                          .toList(),
                      onValueSelected: (ThemeMode selectedTheme) {
                        _repository.setThemeMode(selectedTheme);
                        setState(() {
                          _selectedTheme = selectedTheme;
                        });
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.settings_books_title),
            tiles: [
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.settings_books_sort),
                value: _buildTextValue(
                  context,
                  _selectedSortStrategy.strategyName,
                ),
                leading: const Icon(Icons.sort_outlined),
                onPressed: (context) {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) => SingleChoiceDialog<BookSortStrategy>(
                      title: AppLocalizations.of(context)!
                          .settings_books_sort_choose_title,
                      icon: Icons.sort_outlined,
                      selectedValue: _selectedSortStrategy,
                      choices: BookSortStrategy.values
                          .map(
                            (e) => Choice<BookSortStrategy>(
                              title: e.strategyName,
                              key: e,
                            ),
                          )
                          .toList(),
                      onValueSelected: (BookSortStrategy selectedStrategy) {
                        _repository.setSortingStrategy(selectedStrategy);
                        setState(() {
                          _selectedSortStrategy = selectedStrategy;
                        });
                      },
                    ),
                  );
                },
              ),
              SettingsTile.switchTile(
                initialValue: _isRandomBooksEnabled,
                activeSwitchColor: Theme.of(context).colorScheme.primary,
                onToggle: (bool newValue) {
                  _repository.setIsRandomBooksEnabled(newValue);
                  setState(() {
                    _isRandomBooksEnabled = newValue;
                  });
                },
                title: Text(
                  AppLocalizations.of(context)!.settings_books_random_book,
                ),
                leading: const Icon(Icons.casino_outlined),
              ),
            ],
          ),
          SettingsSection(
            title:
                Text(AppLocalizations.of(context)!.settings_contribute_title),
            tiles: [
              SettingsTile(
                title: Text(
                  AppLocalizations.of(context)!.settings_contribute_code,
                ),
                leading: const Icon(Icons.code),
                onPressed: (context) =>
                    UrlLauncher.launch('https://github.com/shockbytes/DanteX'),
              ),
              SettingsTile(
                title: Text(
                  AppLocalizations.of(context)!.settings_contribute_community,
                ),
                leading: const Icon(Icons.groups_outlined),
                onPressed: (context) =>
                    UrlLauncher.launch('https://discord.gg/EujYrCHjkm'),
              ),
              SettingsTile(
                title: Text(
                  AppLocalizations.of(context)!.settings_contribute_feedback,
                ),
                leading: const Icon(Icons.mail_outline),
                onPressed: (context) {
                  String body = '\n\n\nVersion: '
                      '${AppLocalizations.of(context)!.version_number}';
                  UrlLauncher.launch(
                    Uri(
                      scheme: 'mailto',
                      path: 'shockbytesstudio@gmail.com',
                      query: encodeQueryParameters({
                        'subject': 'Feedback Dante App',
                        'body': body,
                      }),
                    ).toString(),
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text(
              AppLocalizations.of(context)!.settings_data_privacy_title,
            ),
            tiles: [
              SettingsTile.switchTile(
                initialValue: _isTrackingEnabled,
                activeSwitchColor: Theme.of(context).colorScheme.primary,
                onToggle: (bool newValue) {
                  _repository.setIsTrackingEnabled(newValue);
                  setState(() {
                    _isTrackingEnabled = newValue;
                  });
                },
                title: Text(
                  AppLocalizations.of(context)!.settings_data_privacy_tracking,
                ),
                leading: const Icon(Icons.supervised_user_circle_outlined),
              ),
              SettingsTile(
                title: Text(
                  AppLocalizations.of(context)!
                      .settings_data_privacy_data_privacy,
                ),
                leading: const Icon(Icons.privacy_tip_outlined),
                onPressed: (context) =>
                    UrlLauncher.launch('https://dantebooks.com/#/privacy'),
              ),
              SettingsTile(
                title: Text(
                  AppLocalizations.of(context)!
                      .settings_data_privacy_terms_and_conditions,
                ),
                leading: const Icon(Icons.verified_user_outlined),
                onPressed: (context) =>
                    UrlLauncher.launch('https://dantebooks.com/#/terms'),
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.settings_about_title),
            tiles: [
              SettingsTile.navigation(
                title: Text(
                  AppLocalizations.of(context)!.settings_about_developers_title,
                ),
                leading: const Icon(Icons.flash_on_outlined),
                onPressed: (context) => context.go(
                  DanteRoute.contributors.navigationUrl,
                ),
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.version),
                value: _buildTextValue(
                  context,
                  AppLocalizations.of(context)!.version_number,
                ),
                leading: const Icon(Icons.info_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextValue(BuildContext context, String value) {
    return Text(
      value,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
