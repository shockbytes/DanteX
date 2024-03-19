import 'package:dantex/src/data/book/book_sort_strategy.dart';
import 'package:dantex/src/data/logging/event.dart';
import 'package:dantex/src/data/settings/settings_repository.dart';
import 'package:dantex/src/providers/app_router.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:dantex/src/providers/repository.dart';
import 'package:dantex/src/providers/service.dart';
import 'package:dantex/src/ui/core/themed_app_bar.dart';
import 'package:dantex/src/ui/settings/single_choice_dialog.dart';
import 'package:dantex/src/util/url_launcher.dart';
import 'package:dantex/src/util/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SettingsRepository repository = ref.watch(settingsRepositoryProvider);
    final sortingStrategy = ref.watch(sortingStrategyProvider);
    return Scaffold(
      appBar: ThemedAppBar(
        title: Text('settings.title'.tr()),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('settings.appearance.title'.tr()),
            tiles: [
              SettingsTile(
                title: Text('settings.appearance.theme'.tr()),
                value: _buildTextValue(context, repository.getThemeMode().name),
                leading: const Icon(Icons.dark_mode_outlined),
                onPressed: (context) async {
                  await showAdaptiveDialog(
                    context: context,
                    builder: (context) => SingleChoiceDialog<ThemeMode>(
                      title: 'settings.appearance.theme_choose_title'.tr(),
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
            title: Text('settings.books.title'.tr()),
            tiles: [
              SettingsTile(
                title: Text('settings.books.sort'.tr()),
                value: _buildTextValue(
                  context,
                  sortingStrategy.strategyName,
                ),
                leading: const Icon(Icons.sort_outlined),
                onPressed: (context) async {
                  await showAdaptiveDialog(
                    context: context,
                    builder: (context) => SingleChoiceDialog<BookSortStrategy>(
                      title: 'settings.books.sort_choose_title'.tr(),
                      icon: Icons.sort_outlined,
                      selectedValue: sortingStrategy,
                      choices: BookSortStrategy.values
                          .map(
                            (e) => Choice<BookSortStrategy>(
                              title: e.strategyName,
                              key: e,
                            ),
                          )
                          .toList(),
                      onValueSelected: (BookSortStrategy selectedStrategy) {
                        ref
                            .read(sortingStrategyProvider.notifier)
                            .set(selectedStrategy);
                      },
                    ),
                  );
                },
              ),
              SettingsTile.switchTile(
                initialValue: ref.watch(isRandomBooksEnabledProvider),
                activeSwitchColor: Theme.of(context).colorScheme.primary,
                onToggle: (bool newValue) {
                  ref.watch(isRandomBooksEnabledProvider.notifier).toggle();
                },
                title: Text('settings.books.random_book'.tr()),
                leading: const Icon(Icons.casino_outlined),
              ),
            ],
          ),
          SettingsSection(
            title: Text('settings.contribute.title'.tr()),
            tiles: [
              SettingsTile(
                title: Text('settings.contribute.code'.tr()),
                leading: const Icon(Icons.code),
                onPressed: (context) async =>
                    tryLaunchUrl('https://github.com/shockbytes/DanteX'),
              ),
              SettingsTile(
                title: Text('settings.contribute.community'.tr()),
                leading: const Icon(Icons.groups_outlined),
                onPressed: (context) async =>
                    tryLaunchUrl('https://discord.gg/EujYrCHjkm'),
              ),
              SettingsTile(
                title: Text('settings.contribute.feedback'.tr()),
                leading: const Icon(Icons.mail_outline),
                onPressed: (context) async {
                  final String body = '\n\n\nVersion: '
                      '${'version_number'.tr()}';
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
            title: Text('settings.data_privacy.title'.tr()),
            tiles: [
              SettingsTile.switchTile(
                initialValue: ref.watch(isTrackingEnabledProvider),
                activeSwitchColor: Theme.of(context).colorScheme.primary,
                onToggle: (bool newValue) {
                  ref.watch(isTrackingEnabledProvider.notifier).toggle();
                },
                title: Text('settings.data_privacy.tracking'.tr()),
                leading: const Icon(Icons.supervised_user_circle_outlined),
              ),
              SettingsTile(
                title: Text('settings.data_privacy.data_privacy'.tr()),
                leading: const Icon(Icons.privacy_tip_outlined),
                onPressed: (context) async =>
                    tryLaunchUrl('https://dantebooks.com/#/privacy'),
              ),
              SettingsTile(
                title: Text('settings.data_privacy.terms_and_conditions'.tr()),
                leading: const Icon(Icons.verified_user_outlined),
                onPressed: (context) async {
                  ref.read(loggerProvider).trackEvent(OpenTermsOfServices());
                  return tryLaunchUrl('https://dantebooks.com/#/terms');
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text(
              'settings.danger_zone.title'.tr(),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            tiles: [
              SettingsTile(
                title: Text(
                  'settings.danger_zone.delete_account'.tr(),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                leading: Icon(
                  Icons.no_accounts_outlined,
                  color: Theme.of(context).colorScheme.error,
                ),
                onPressed: (context) async => _deleteAccount(context, ref),
              ),
            ],
          ),
          SettingsSection(
            title: Text('settings.about.title'.tr()),
            tiles: [
              SettingsTile.navigation(
                title: Text('settings.about.developers_title'.tr()),
                leading: const Icon(Icons.flash_on_outlined),
                onPressed: (context) => context.go(
                  DanteRoute.contributors.navigationUrl,
                ),
              ),
              SettingsTile(
                title: Text('version'.tr()),
                value: _buildTextValue(
                  context,
                  'version_number'.tr(),
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

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final bool shouldDeleteAccount = await showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text('settings.danger_zone.delete_account_title'.tr()),
          content: Text('settings.danger_zone.delete_account_description'.tr()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('cancel'.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                'delete_anyway'.tr(),
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
        await ref.watch(authenticationRepositoryProvider).deleteAccount();
        if (context.mounted) {
          context.pushReplacement(DanteRoute.login.navigationUrl);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('settings.danger_zone.delete_account_error'.tr()),
            ),
          );
        }
      }
    }
  }
}
