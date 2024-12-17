import 'package:dantex/logger/event.dart';
import 'package:dantex/providers/service.dart';
import 'package:dantex/providers/settings.dart' hide ThemeModeSetting;
import 'package:dantex/ui/settings/book_sort_dialog.dart';
import 'package:dantex/ui/settings/contributors_screen.dart';
import 'package:dantex/ui/settings/section_tile.dart';
import 'package:dantex/ui/settings/settings_tile.dart';
import 'package:dantex/ui/settings/theme_dialog.dart';
import 'package:dantex/util/string.dart';
import 'package:dantex/util/url.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static String get routeName => 'settings';
  static String get routeLocation => '/$routeName';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeSettingProvider);
    final showBookSummary = ref.watch(showBookSummarySettingProvider);
    final randomBooksEnabled = ref.watch(randomBooksEnabledSettingProvider);
    final usageTrackingEnabled = ref.watch(usageTrackingSettingProvider);
    final appVersion = ref.watch(appVersionProvider).when(
          data: (version) => version,
          loading: () => '...',
          error: (error, _) => '...',
        );
    return Scaffold(
      appBar: AppBar(
        title: const Text('settings.title').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView(
          children: [
            SectionTitle(
              key: const ValueKey('appearance_title'),
              title: 'settings.appearance.title'.tr(),
            ),
            SettingsTile(
              key: const ValueKey('theme_tile'),
              leading: themeMode == ThemeMode.dark
                  ? const Icon(Icons.nightlight_round)
                  : themeMode == ThemeMode.light
                      ? const Icon(Icons.wb_sunny)
                      : const Icon(Icons.settings_outlined),
              title: const Text('settings.appearance.theme').tr(),
              subtitle: Text(themeMode.name.capitalize),
              onTap: () async => showDialog<void>(
                context: context,
                builder: (context) => const ThemeDialog(
                  key: ValueKey('theme_dialog'),
                ),
              ),
            ),
            SectionTitle(title: 'settings.books.title'.tr()),
            SettingsTile(
              leading: const Icon(Icons.info_outlined),
              title: const Text('settings.books.show_book_summary').tr(),
              subtitle:
                  const Text('settings.books.show_book_summary_description')
                      .tr(),
              onTap: () async => ref
                  .read(showBookSummarySettingProvider.notifier)
                  .set(showBookSummary: !showBookSummary),
              trailing: AbsorbPointer(
                child: Switch(
                  value: showBookSummary,
                  // Handled by the SettingsTile onTap
                  onChanged: (_) {},
                ),
              ),
            ),
            SettingsTile(
              leading: const Icon(Icons.sort),
              title: const Text('settings.books.sort').tr(),
              subtitle: const Text('settings.books.sort_description').tr(
                args: [
                  ref.watch(bookSortStrategySettingProvider).strategyName,
                ],
              ),
              onTap: () async => showDialog<void>(
                context: context,
                builder: (context) => const BookSortDialog(
                  key: ValueKey('book_sort_dialog'),
                ),
              ),
            ),
            SettingsTile(
              leading: const Icon(Icons.casino_outlined),
              title: const Text('settings.books.random_book_selection').tr(),
              subtitle:
                  const Text('settings.books.random_book_selection_description')
                      .tr(),
              onTap: () async {
                await ref
                    .read(randomBooksEnabledSettingProvider.notifier)
                    .set(randomBooksEnabled: !randomBooksEnabled);
                if (!randomBooksEnabled) {
                  ref
                      .read(loggerProvider)
                      .trackEvent(DanteEvent.disableRandomBookInteraction);
                }
              },
              trailing: AbsorbPointer(
                child: Switch(
                  value: randomBooksEnabled,
                  // Handled by the SettingsTile onTap
                  onChanged: (_) {},
                ),
              ),
            ),
            SectionTitle(title: 'settings.contribute.title'.tr()),
            SettingsTile(
              leading: SvgPicture.asset(
                'assets/images/github.svg',
                colorFilter: ColorFilter.mode(
                  Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                  BlendMode.srcIn,
                ),
                width: 24,
                height: 24,
              ),
              title: const Text('settings.contribute.code').tr(),
              subtitle:
                  const Text('settings.contribute.contribute_to_dante').tr(),
              onTap: () async =>
                  tryLaunchUrl('https://github.com/shockbytes/DanteX'),
            ),
            SettingsTile(
              leading: const Icon(Icons.groups_outlined),
              title: const Text('settings.contribute.community').tr(),
              subtitle: const Text('settings.contribute.join_community').tr(),
              onTap: () async => tryLaunchUrl('https://discord.gg/EujYrCHjkm'),
            ),
            SettingsTile(
              leading: const Icon(Icons.mail_outline),
              title: const Text('settings.contribute.feedback').tr(),
              subtitle:
                  const Text('settings.contribute.feedback_description').tr(),
              onTap: () async {
                final version = await ref.read(appVersionProvider.future);
                final body = '\n\n\nVersion: '
                    '$version';
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
            SectionTitle(title: 'settings.privacy.title'.tr()),
            SettingsTile(
              leading: const Icon(Icons.person_pin_circle_outlined),
              title: const Text('settings.privacy.tracking').tr(),
              subtitle:
                  const Text('settings.privacy.tracking_description').tr(),
              onTap: () async {
                await ref
                    .read(usageTrackingSettingProvider.notifier)
                    .set(trackingEnabled: !usageTrackingEnabled);
                ref
                    .read(loggerProvider)
                    .trackEvent(DanteEvent.trackingStateChanged);
              },
              trailing: AbsorbPointer(
                child: Switch(
                  value: usageTrackingEnabled,
                  onChanged: (_) {},
                ),
              ),
            ),
            SettingsTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('settings.privacy.privacy_policy').tr(),
              onTap: () async =>
                  tryLaunchUrl('https://dantebooks.com/#/privacy'),
            ),
            SettingsTile(
              leading: const Icon(Icons.policy_outlined),
              title: const Text('settings.privacy.terms_and_conditions').tr(),
              onTap: () async {
                final launched =
                    await tryLaunchUrl('https://dantebooks.com/#/terms');
                if (launched) {
                  ref
                      .read(loggerProvider)
                      .trackEvent(DanteEvent.openTermsOfService);
                }
              },
            ),
            SectionTitle(title: 'settings.about.title'.tr()),
            SettingsTile(
              leading: const Icon(Icons.flash_on_outlined),
              title: const Text('settings.about.developers').tr(),
              onTap: () async => context.push(ContributorsScreen.navigationUrl),
            ),
            SettingsTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('settings.about.version').tr(),
              subtitle: Text(appVersion),
              onTap: null,
            ),
          ],
        ),
      ),
    );
  }
}
