import 'package:collection/collection.dart';
import 'package:dantex/providers/settings.dart';
import 'package:dantex/providers/statistics.dart';
import 'package:dantex/ui/shared/dante_line_chart.dart';
import 'package:dantex/ui/statistics/goal_widget.dart';
import 'package:dantex/util/date_time.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PagesPerMonth extends ConsumerWidget {
  const PagesPerMonth({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagesPerMonthStats = ref.watch(pagesPerMonthStatsProvider);
    final pagesPerMonthGoal = ref.watch(pagesPerMonthGoalProvider);

    if (pagesPerMonthStats.isEmpty) {
      return Center(
        child: const Text('statistics.books_per_month.empty').tr(),
      );
    }

    final points = pagesPerMonthStats.entries
        .mapIndexed((index, e) => (x: index.toDouble(), y: e.value.toDouble()))
        .toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (pagesPerMonthGoal != null) ...[
              const Text(
                'statistics.pages_per_month.goal',
              ).tr(args: [pagesPerMonthGoal.toString()]),
            ] else
              const Text('statistics.pages_per_month.goal_not_set').tr(),
            OutlinedButton(
              onPressed: () async => showDialog(
                context: context,
                builder: (context) => _PagesPerMonthDialog(
                  key: const ValueKey('pages_per_month_goal_dialog'),
                  initialValue: pagesPerMonthGoal,
                ),
              ),
              child: const Text('statistics.books_per_month.set_goal').tr(),
            ),
          ],
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 160,
          child: DanteLineChart(
            points: points,
            xConverter: (x) => pagesPerMonthStats.entries
                .toList()[x.toInt()]
                .key
                .formatWithMonthAndYearShort(),
            goal: pagesPerMonthGoal?.toDouble(),
          ),
        ),
      ],
    );
  }
}

class _PagesPerMonthDialog extends ConsumerStatefulWidget {
  const _PagesPerMonthDialog({super.key, this.initialValue});

  final int? initialValue;

  @override
  ConsumerState<_PagesPerMonthDialog> createState() =>
      _PagesPerMonthDialogState();
}

class _PagesPerMonthDialogState extends ConsumerState<_PagesPerMonthDialog> {
  late int goal;

  @override
  void initState() {
    super.initState();
    goal = widget.initialValue ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('statistics.pages_per_month.pages_goal').tr(),
      content: GoalWidget(
        initialValue: widget.initialValue,
        maxValue: 3000,
        minValue: 30,
        divisions: 297,
        labelKey: 'statistics.pages_per_month.page_month_count',
        onSetGoal: (value) => setState(() => goal = value),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await ref.read(pagesPerMonthGoalProvider.notifier).reset();
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: Text(
            'reading_goal.delete',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ).tr(),
        ),
        TextButton(
          onPressed: () async {
            await ref.read(pagesPerMonthGoalProvider.notifier).set(goal);

            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: const Text('reading_goal.apply').tr(),
        ),
      ],
    );
  }
}
