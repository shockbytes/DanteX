import 'package:collection/collection.dart';
import 'package:dantex/providers/statistics.dart';
import 'package:dantex/util/date_time.dart';
import 'package:dantex/widgets/statistics/dante_line_chart.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BooksPerYear extends ConsumerWidget {
  const BooksPerYear({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksPerYearStats = ref.watch(booksPerYearStatsProvider);

    if (booksPerYearStats.isEmpty) {
      return Center(
        child: const Text('statistics.books_per_year.empty').tr(),
      );
    }

    final points = booksPerYearStats.entries
        .mapIndexed((index, e) => (x: index.toDouble(), y: e.value.toDouble()))
        .toList();

    return SizedBox(
      height: 160,
      child: DanteLineChart(
        points: points,
        xConverter: (x) =>
            booksPerYearStats.entries.toList()[x.toInt()].key.formatWithYear(),
      ),
    );
  }
}
