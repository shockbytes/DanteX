import 'package:dantex/providers/settings.dart' hide ThemeModeSetting;
import 'package:dantex/util/string.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeDialog extends ConsumerWidget {
  const ThemeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('settings.appearance.theme').tr(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.wb_sunny),
            title: Text(ThemeMode.light.name.capitalize).tr(),
            onTap: () async {
              await ref
                  .read(themeModeSettingProvider.notifier)
                  .set(ThemeMode.light);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            trailing: ref.watch(themeModeSettingProvider) == ThemeMode.light
                ? const Icon(Icons.check)
                : null,
          ),
          ListTile(
            leading: const Icon(Icons.nightlight_round),
            title: Text(ThemeMode.dark.name.capitalize).tr(),
            onTap: () async {
              await ref
                  .read(themeModeSettingProvider.notifier)
                  .set(ThemeMode.dark);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            trailing: ref.watch(themeModeSettingProvider) == ThemeMode.dark
                ? const Icon(Icons.check)
                : null,
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(ThemeMode.system.name.capitalize).tr(),
            onTap: () async {
              await ref
                  .read(themeModeSettingProvider.notifier)
                  .set(ThemeMode.system);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            trailing: ref.watch(themeModeSettingProvider) == ThemeMode.system
                ? const Icon(Icons.check)
                : null,
          ),
        ],
      ),
    );
  }
}
