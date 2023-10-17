import 'package:dantex/main.dart';
import 'package:dantex/src/data/authentication/authentication_repository.dart';
import 'package:dantex/src/data/book/book_sort_strategy.dart';
import 'package:dantex/src/data/settings/settings_repository.dart';
import 'package:dantex/src/providers/authentication.dart';
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

class SettingsPage extends ConsumerWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SettingsRepository repository = ref.watch(settingsRepositoryProvider);
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
                value: _buildTextValue(context, repository.getThemeMode().name),
                leading: const Icon(Icons.dark_mode_outlined),
                onPressed: (context) async {
                  await showAdaptiveDialog(
                    context: context,
                    builder: (context) => SingleChoiceDialog<ThemeMode>(
                      title: AppLocalizations.of(context)!
                          .settings_appearance_theme_choose_title,
                      icon: Icons.dark_mode_outlined,
                      selectedValue: repository.getThemeMode(),
                      choices: ThemeMode.values
                          .map(
                            (e) => Choice<ThemeMode>(title: e.name, key: e),
                          )
                          .toList(),
                      onValueSelected: (ThemeMode selectedTheme) {
                        repository.setThemeMode(selectedTheme);
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
                  repository.getSortingStrategy().strategyName,
                ),
                leading: const Icon(Icons.sort_outlined),
                onPressed: (context) async {
                  await showAdaptiveDialog(
                    context: context,
                    builder: (context) => SingleChoiceDialog<BookSortStrategy>(
                      title: AppLocalizations.of(context)!
                          .settings_books_sort_choose_title,
                      icon: Icons.sort_outlined,
                      selectedValue: repository.getSortingStrategy(),
                      choices: BookSortStrategy.values
                          .map(
                            (e) => Choice<BookSortStrategy>(
                              title: e.strategyName,
                              key: e,
                            ),
                          )
                          .toList(),
                      onValueSelected: (BookSortStrategy selectedStrategy) {
                        repository.setSortingStrategy(selectedStrategy);
                      },
                    ),
                  );
                },
              ),
              SettingsTile.switchTile(
                initialValue: ref.watch(isRandomBooksEnabledProvider),
                activeSwitchColor: Theme.of(context).colorScheme.primary,
                onToggle: (bool newValue) {
                  ref.read(isRandomBooksEnabledProvider.notifier).toggle();
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
                onPressed: (context) async =>
                    tryLaunchUrl('https://github.com/shockbytes/DanteX'),
              ),
              SettingsTile(
                title: Text(
                  AppLocalizations.of(context)!.settings_contribute_community,
                ),
                leading: const Icon(Icons.groups_outlined),
                onPressed: (context) async =>
                    tryLaunchUrl('https://discord.gg/EujYrCHjkm'),
              ),
              SettingsTile(
                title: Text(
                  AppLocalizations.of(context)!.settings_contribute_feedback,
                ),
                leading: const Icon(Icons.mail_outline),
                onPressed: (context) async {
                  final String body = '\n\n\nVersion: '
                      '${AppLocalizations.of(context)!.version_number}';
                  await tryLaunchUrl(
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
                initialValue: ref.watch(isTrackingEnabledProvider),
                activeSwitchColor: Theme.of(context).colorScheme.primary,
                onToggle: (bool newValue) {
                  ref.read(isTrackingEnabledProvider.notifier).toggle();
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
                onPressed: (context) async =>
                    tryLaunchUrl('https://dantebooks.com/#/privacy'),
              ),
              SettingsTile(
                title: Text(
                  AppLocalizations.of(context)!
                      .settings_data_privacy_terms_and_conditions,
                ),
                leading: const Icon(Icons.verified_user_outlined),
                onPressed: (context) async =>
                    tryLaunchUrl('https://dantebooks.com/#/terms'),
              ),
            ],
          ),
          SettingsSection(
            title: Text(
              AppLocalizations.of(context)!.settings_danger_zone,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            tiles: [
              SettingsTile(
                title: Text(
                  AppLocalizations.of(context)!
                      .settings_danger_zone_delete_account,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                leading: Icon(
                  Icons.no_accounts_outlined,
                  color: Theme.of(context).colorScheme.error,
                ),
                onPressed: (context) async => _deleteAccount(context),
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

  Future<void> _deleteAccount(BuildContext context) async {
    final bool shouldDeleteAccount = await showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(
            AppLocalizations.of(context)!
                .settings_danger_zone_delete_account_title,
          ),
          content: Text(
            AppLocalizations.of(context)!
                .settings_danger_zone_delete_account_description,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                AppLocalizations.of(context)!.delete_anyway,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDeleteAccount) {
      try {
        await _authenticationRepository.deleteAccount();
        if (context.mounted) {
          context.pushReplacement(DanteRoute.login.navigationUrl);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!
                    .settings_danger_zone_delete_account_error,
              ),
            ),
          );
        }
      }
    }
  }
}
