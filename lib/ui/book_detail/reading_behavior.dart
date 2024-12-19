import 'package:collection/collection.dart';
import 'package:dantex/models/page_record.dart';
import 'package:dantex/ui/shared/dante_line_chart.dart';
import 'package:dantex/util/date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReadingBehavior extends ConsumerWidget {
  const ReadingBehavior({required this.pageRecords, super.key});

  final List<PageRecord> pageRecords;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = pageRecords
        .mapIndexed(
          (index, e) => (x: index.toDouble() + 1, y: e.toPage.toDouble()),
        )
        .toList()
      // Add the start point to the graph.
      ..insert(0, (x: 0.0, y: 0.0));

    return DanteLineChart(
      points: points,
      xConverter: (x) =>
          pageRecords[x.toInt()].timestamp.formatWithDayMonthYear(),
      includeMaxY: true,
    );
  }
}
