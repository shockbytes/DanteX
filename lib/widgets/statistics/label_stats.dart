import 'package:dantex/providers/settings.dart';
import 'package:dantex/widgets/statistics/dante_radar_chart.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LabelStats extends ConsumerWidget {
  const LabelStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labelStats = ref.watch(bookLabelStatsProvider);
    if (labelStats.isEmpty) {
      return Center(
        child: const Text('statistics.label.empty').tr(),
      );
    }

    return SizedBox(
      height: 200,
      child: DanteRadarChart(
        dataMap: labelStats
            .map<String, int>((key, value) => MapEntry(key.title, value)),
      ),
    );
  }
}
