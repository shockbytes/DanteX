import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DantePieChart extends StatefulWidget {
  final Widget Function(
    String key,
    double size,
  ) badgeBuilder;

  final String Function(String key, int value) titleBuilder;

  final Map<String, int> pieData;

  const DantePieChart({
    required this.badgeBuilder,
    required this.pieData,
    required this.titleBuilder,
    super.key,
  });

  @override
  State<DantePieChart> createState() => _DantePieChartState();
}

class _DantePieChartState extends State<DantePieChart> {
  List<Color> get _colors => [
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.primaryContainer,
        Theme.of(context).colorScheme.tertiaryContainer,
        Theme.of(context).colorScheme.error,
        Theme.of(context).colorScheme.tertiary,
        Theme.of(context).colorScheme.secondary,
        Theme.of(context).colorScheme.secondaryContainer,
      ];

  List<Color> get _textColors => [
        Theme.of(context).colorScheme.onPrimary,
        Theme.of(context).colorScheme.onPrimaryContainer,
        Theme.of(context).colorScheme.onTertiaryContainer,
        Theme.of(context).colorScheme.onError,
        Theme.of(context).colorScheme.onTertiary,
        Theme.of(context).colorScheme.onSecondary,
        Theme.of(context).colorScheme.onSecondaryContainer,
      ];

  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
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
        borderData: FlBorderData(
          show: false,
        ),
        sectionsSpace: 0,
        centerSpaceRadius: 0,
        sections: _showingSections(widget.pieData),
      ),
    );
  }

  List<PieChartSectionData> _showingSections(
    Map<String, int> data,
  ) {
    final int length = data.length;
    return data.entries.mapIndexed(
      (index, dataEntry) {
        final isTouched = index == _touchedIndex;
        final fontSize = isTouched ? 20.0 : 16.0;
        final radius = isTouched ? 110.0 : 100.0;
        final widgetSize = isTouched ? 55.0 : 40.0;
        const shadows = [Shadow(blurRadius: 1)];

        return PieChartSectionData(
          color: _colors[index % length],
          value: dataEntry.value.toDouble(),
          title: widget.titleBuilder(dataEntry.key, dataEntry.value),
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: _textColors[index % length],
            shadows: shadows,
          ),
          badgeWidget: widget.badgeBuilder(
            dataEntry.key,
            widgetSize,
          ),
          badgePositionPercentageOffset: .98,
        );
      },
    ).toList();
  }
}
