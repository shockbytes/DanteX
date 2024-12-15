import 'package:collection/collection.dart';
import 'package:dantex/providers/statistics.dart';
import 'package:dantex/widgets/statistics/dante_pie_chart.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LanguagesStats extends ConsumerWidget {
  const LanguagesStats();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageStats = ref.watch(languageStatsProvider);

    if (languageStats.isEmpty) {
      return Center(
        child: const Text('statistics.language.empty').tr(),
      );
    }

    return SizedBox(
      height: 160,
      child: DantePieChart(
        sections: languageStats.entries
            .mapIndexed(
              (index, stat) => DantePieChartSectionData(
                color: stat.key.color,
                value: stat.value.toDouble(),
                title: stat.key.name,
                badgeColor: Theme.of(context).colorScheme.surfaceContainer,
                titleIcon: ClipOval(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: SvgPicture.asset(
                      stat.key.iconPath,
                      package: 'country_icons',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
