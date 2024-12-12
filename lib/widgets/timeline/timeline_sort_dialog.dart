import 'package:dantex/models/timeline.dart';
import 'package:dantex/providers/settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimelineSortDialog extends ConsumerWidget {
  const TimelineSortDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortStrategy = ref.watch(timelineSortStrategySettingProvider);
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.calendar_month_outlined),
          const SizedBox(width: 8),
          const Text('timeline.sort_by.title').tr(),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: AbsorbPointer(
              absorbing: false,
              child: Radio<TimelineSortStrategy>(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                value: TimelineSortStrategy.byStartDate,
                groupValue: sortStrategy,
                onChanged: (_) {},
              ),
            ),
            title: Text('timeline.sort_by.start'.tr()),
            onTap: () async {
              Navigator.of(context).pop();
              await ref
                  .read(timelineSortStrategySettingProvider.notifier)
                  .set(TimelineSortStrategy.byStartDate);
            },
          ),
          ListTile(
            leading: AbsorbPointer(
              child: Radio<TimelineSortStrategy>(
                value: TimelineSortStrategy.byEndDate,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                groupValue: sortStrategy,
                onChanged: (_) {},
              ),
            ),
            title: Text('timeline.sort_by.end'.tr()),
            onTap: () async {
              Navigator.of(context).pop();
              await ref
                  .read(timelineSortStrategySettingProvider.notifier)
                  .set(TimelineSortStrategy.byEndDate);
            },
          ),
        ],
      ),
    );
  }
}
