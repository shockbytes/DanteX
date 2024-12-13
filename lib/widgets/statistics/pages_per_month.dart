import 'package:collection/collection.dart';
import 'package:dantex/providers/statistics.dart';
import 'package:dantex/util/date_time.dart';
import 'package:dantex/widgets/statistics/dante_line_chart.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PagesPerMonth extends ConsumerWidget {
  const PagesPerMonth({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagesPerMonthStats = ref.watch(pagesPerMonthStatsProvider);

    if (pagesPerMonthStats.isEmpty) {
      return Center(
        child: const Text('statistics.books_per_month.empty').tr(),
      );
    }

    final points = pagesPerMonthStats.entries
        .mapIndexed((index, e) => (x: index.toDouble(), y: e.value.toDouble()))
        .toList();

    return SizedBox(
      height: 160,
      child: DanteLineChart(
        points: points,
        xConverter: (x) => pagesPerMonthStats.entries
            .toList()[x.toInt()]
            .key
            .formatWithMonthAndYearShort(),
      ),
    );
  }
}
