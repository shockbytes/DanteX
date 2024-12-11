import 'package:dantex/providers/settings.dart' hide ThemeModeSetting;
import 'package:dantex/util/string_utilities.dart';
import 'package:dantex/widgets/settings/book_sort_dialog.dart';
import 'package:dantex/widgets/settings/section_tile.dart';
import 'package:dantex/widgets/settings/settings_tile.dart';
import 'package:dantex/widgets/settings/theme_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static String get routeName => 'settings';
  static String get routeLocation => '/$routeName';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeSettingProvider);
    final showBookSummary = ref.watch(showBookSummarySettingProvider);
    final randomBooksEnabled = ref.watch(randomBooksEnabledSettingProvider);
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
              onTap: () async => ref
                  .read(randomBooksEnabledSettingProvider.notifier)
                  .set(randomBooksEnabled: !randomBooksEnabled),
              trailing: AbsorbPointer(
                child: Switch(
                  value: randomBooksEnabled,
                  // Handled by the SettingsTile onTap
                  onChanged: (_) {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
