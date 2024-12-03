import 'package:dantex/models/book_restore_strategy.dart';
import 'package:dantex/widgets/shared/subtitle_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RestoreBackupDialog extends StatelessWidget {
  const RestoreBackupDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.devices_other_outlined),
          const SizedBox(width: 8),
          const Text(
            'book_management.restore_strategy',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ).tr(),
        ],
      ),
      content: const Text('book_management.restore_detail').tr(),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
                onPressed: () =>
                    Navigator.of(context).pop(RestoreStrategy.merge),
                child: SizedBox(
                  child: SubtitleIcon(
                    size: 24,
                    icon: Icons.merge,
                    subtitle: 'book_management.merge'.tr(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
                onPressed: () =>
                    Navigator.of(context).pop(RestoreStrategy.overwrite),
                child: SubtitleIcon(
                  size: 24,
                  icon: Icons.content_copy_outlined,
                  subtitle: 'book_management.overwrite'.tr(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
