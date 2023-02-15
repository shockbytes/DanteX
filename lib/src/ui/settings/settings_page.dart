import 'package:dantex/src/ui/core/themed_app_bar.dart';
import 'package:dantex/src/util/dante_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(
        leading: InkWell(
          child: const Icon(
            Icons.arrow_back,
            color: DanteColors.textPrimary,
          ),
          enableFeedback: true,
          onTap: () => Get.back(),
        ),
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: const TextStyle(
            color: DanteColors.textPrimary,
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
