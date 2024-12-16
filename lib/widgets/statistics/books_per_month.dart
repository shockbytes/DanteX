import 'package:collection/collection.dart';
import 'package:dantex/providers/settings.dart';
import 'package:dantex/providers/statistics.dart';
import 'package:dantex/util/date_time.dart';
import 'package:dantex/widgets/statistics/dante_line_chart.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

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
    extends ConsumerState<_BooksPerMonthGoalDialog>
    with SingleTickerProviderStateMixin {
  late double _sliderValue;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.initialValue?.toDouble() ?? 5.0;
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('statistics.books_per_month.books_goal').tr(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Slider(
            value: _sliderValue,
            max: 30,
            min: 1,
            divisions: 30,
            label: _sliderValue.toInt().toString(),
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
                _animationController.value = _mapSliderToLottieProgress(value);
              });
            },
          ),
          const Text('statistics.books_per_month.books_month_count')
              .tr(args: [_sliderValue.toInt().toString()]),
          ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: 0.8,
              child: Lottie.asset(
                'assets/lottie/reading-goal.json',
                controller: _animationController,
                onLoaded: (composition) {
                  // Set the controller's duration to match the animation duration
                  _animationController
                    ..duration = composition.duration
                    // Set the initial progress
                    ..value = _mapSliderToLottieProgress(_sliderValue);
                },
              ),
            ),
          ),
          Text(
            getProficiencyLabel(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
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
            await ref
                .read(booksPerMonthGoalProvider.notifier)
                .set(_sliderValue.toInt());

            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: const Text('reading_goal.apply').tr(),
        ),
      ],
    );
  }

  /// Maps the slider values (1-30) to Lottie progress
  double _mapSliderToLottieProgress(double sliderValue) {
    const lottieMin = 0.25;
    const lottieMax = 0.33;
    const sliderMin = 1;
    const sliderMax = 30;

    // Map the slider value to the Lottie animation progress range
    return lottieMin +
        (sliderValue - sliderMin) *
            (lottieMax - lottieMin) /
            (sliderMax - sliderMin);
  }

  String getProficiencyLabel() {
    if (_sliderValue / 29 <= 0.25) {
      return 'reading_goal.rookie'.tr();
    } else if (_sliderValue / 29 <= 0.5) {
      return 'reading_goal.serious_reader'.tr();
    } else if (_sliderValue / 29 <= 0.75) {
      return 'reading_goal.reading_brain'.tr();
    } else {
      return 'reading_goal.book_wizard'.tr();
    }
  }
}
