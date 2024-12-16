import 'package:collection/collection.dart';
import 'package:dantex/providers/settings.dart';
import 'package:dantex/providers/statistics.dart';
import 'package:dantex/util/date_time.dart';
import 'package:dantex/widgets/statistics/dante_line_chart.dart';
import 'package:dantex/widgets/statistics/goal_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BooksPerMonth extends ConsumerWidget {
  const BooksPerMonth({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksPerMonthStats = ref.watch(booksPerMonthStatsProvider);
    final booksPerMonthGoal = ref.watch(booksPerMonthGoalProvider);

    if (booksPerMonthStats.isEmpty) {
      return Center(
        child: const Text('statistics.books_per_month.empty').tr(),
      );
    }

    final points = booksPerMonthStats.entries
        .mapIndexed((index, e) => (x: index.toDouble(), y: e.value.toDouble()))
        .toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (booksPerMonthGoal != null) ...[
              const Text(
                'statistics.books_per_month.goal',
              ).tr(args: [booksPerMonthGoal.toString()]),
            ] else
              const Text('statistics.books_per_month.goal_not_set').tr(),
            OutlinedButton(
              onPressed: () async => showDialog(
                context: context,
                builder: (context) => _BooksPerMonthGoalDialog(
                  key: const ValueKey('books_per_month_goal_dialog'),
                  initialValue: booksPerMonthGoal,
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
            xConverter: (x) => booksPerMonthStats.entries
                .toList()[x.toInt()]
                .key
                .formatWithMonthAndYearShort(),
            goal: booksPerMonthGoal?.toDouble(),
            goalLabel: 'reading_goal.title'.tr(),
          ),
        ),
      ],
    );
  }
}

class _BooksPerMonthGoalDialog extends ConsumerStatefulWidget {
  const _BooksPerMonthGoalDialog({super.key, this.initialValue});

  final int? initialValue;

  @override
  ConsumerState<_BooksPerMonthGoalDialog> createState() =>
      _BooksPerMonthGoalDialogState();
}

class _BooksPerMonthGoalDialogState
    extends ConsumerState<_BooksPerMonthGoalDialog> {
  late int goal;

  @override
  void initState() {
    super.initState();
    goal = widget.initialValue ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('statistics.books_per_month.books_goal').tr(),
      content: GoalWidget(
        initialValue: widget.initialValue,
        maxValue: 30,
        minValue: 1,
        divisions: 30,
        labelKey: 'statistics.books_per_month.books_month_count',
        onSetGoal: (value) => setState(() => goal = value),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await ref.read(booksPerMonthGoalProvider.notifier).reset();
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
            await ref.read(booksPerMonthGoalProvider.notifier).set(goal);

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
