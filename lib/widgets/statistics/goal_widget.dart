import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GoalWidget extends StatefulWidget {
  const GoalWidget({
    required this.maxValue,
    required this.minValue,
    required this.labelKey,
    required this.divisions,
    required this.onSetGoal,
    super.key,
    this.initialValue,
  });

  final int? initialValue;
  final int maxValue;
  final int minValue;
  final int divisions;
  final String labelKey;
  final void Function(int value) onSetGoal;

  @override
  State<GoalWidget> createState() => _GoalWidgetState();
}

class _GoalWidgetState extends State<GoalWidget>
    with SingleTickerProviderStateMixin {
  late double _sliderValue;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _sliderValue =
        widget.initialValue?.toDouble() ?? widget.minValue.toDouble();
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Slider(
          value: _sliderValue,
          max: widget.maxValue.toDouble(),
          min: widget.minValue.toDouble(),
          divisions: widget.divisions,
          label: _sliderValue.toInt().toString(),
          onChanged: (value) {
            setState(() {
              _sliderValue = value;
              _animationController.value = _mapSliderToLottieProgress(value);
            });
            widget.onSetGoal(value.toInt());
          },
        ),
        Text(widget.labelKey).tr(args: [_sliderValue.toInt().toString()]),
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
          _getProficiencyLabel(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }

  /// Maps the slider values (1-30) to Lottie progress
  double _mapSliderToLottieProgress(double sliderValue) {
    const lottieMin = 0.25;
    const lottieMax = 0.33;

    // Map the slider value to the Lottie animation progress range
    return lottieMin +
        (sliderValue - widget.minValue) *
            (lottieMax - lottieMin) /
            (widget.maxValue - widget.minValue);
  }

  String _getProficiencyLabel() {
    if (_sliderValue / widget.maxValue <= 0.25) {
      return 'reading_goal.rookie'.tr();
    } else if (_sliderValue / widget.maxValue <= 0.5) {
      return 'reading_goal.serious_reader'.tr();
    } else if (_sliderValue / widget.maxValue <= 0.75) {
      return 'reading_goal.reading_brain'.tr();
    } else {
      return 'reading_goal.book_wizard'.tr();
    }
  }
}
