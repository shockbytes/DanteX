import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DantePieChartSectionData {
  DantePieChartSectionData({
    required this.color,
    required this.value,
    required this.title,
    required this.badgeColor,
    this.titleIcon,
  });

  final Color color;
  final double value;
  final String title;
  final Color badgeColor;
  final Widget? titleIcon;

  PieChartSectionData toPieChartSectionData({bool isTouched = false}) {
    final fontSize = isTouched ? 18.0 : 14.0;
    final radius = isTouched ? 80.0 : 72.0;
    const shadows = [Shadow(blurRadius: 1)];
    final titleIcon = this.titleIcon;
    return PieChartSectionData(
      color: color,
      value: value,
      showTitle: false,
      radius: radius,
      badgeWidget: Card.outlined(
        color: badgeColor,
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (titleIcon != null) titleIcon,
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  shadows: shadows,
                ),
              ),
            ],
          ),
        ),
      ),
      badgePositionPercentageOffset: 1,
    );
  }
}

class DantePieChart extends StatefulWidget {
  const DantePieChart({required this.sections, super.key});

  final List<DantePieChartSectionData> sections;

  @override
  State<DantePieChart> createState() => _DantePieChartState();
}

class _DantePieChartState extends State<DantePieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 0,
        sectionsSpace: 0,
        pieTouchData: PieTouchData(
          touchCallback: (touchEvent, pieTouchResponse) {
            setState(() {
              if (!touchEvent.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                _touchedIndex = -1;
                return;
              }
              _touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        sections: widget.sections
            .mapIndexed(
              (index, section) => section.toPieChartSectionData(
                isTouched: index == _touchedIndex,
              ),
            )
            .toList(),
      ),
    );
  }
}
