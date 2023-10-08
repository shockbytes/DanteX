import 'package:dantex/src/ui/core/themed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(
        leading: InkWell(
          enableFeedback: true,
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: const Center(
        child: Text('Settings Page'),
      ),
    );
  }
}
