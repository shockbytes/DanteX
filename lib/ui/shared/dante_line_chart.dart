import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DanteLineChart extends StatelessWidget {
  const DanteLineChart({
    required this.points,
    required this.xConverter,
    this.goal,
    this.goalLabel,
    this.includeMaxY = false,
    super.key,
  });

  final List<({double x, double y})> points;
  final String Function(double x) xConverter;
  final double? goal;
  final String? goalLabel;
  final bool includeMaxY;

  @override
  Widget build(BuildContext context) {
    final goal = this.goal;
    final maxY =
        _conditionalRound(max<double>(points.map((p) => p.y).max, goal ?? 0));

    final gradientColors = [
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.primary,
    ];

    return AspectRatio(
      aspectRatio: 3,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(
            show: false,
          ),
          lineTouchData: const LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              fitInsideHorizontally: true,
              fitInsideVertically: true,
            ),
          ),
          extraLinesData: goal != null
              ? ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: goal,
                      color: Theme.of(context).colorScheme.secondary,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                      label: HorizontalLineLabel(
                        labelResolver: (p0) => goalLabel ?? '',
                        alignment: Alignment.topRight,
                        padding: const EdgeInsets.only(right: 24, bottom: 8),
                        show: true,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ],
                )
              : null,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                maxIncluded: false,
                showTitles: true,
                reservedSize: 32,
                interval: points.length < 5 ? 1 : 5,
                getTitlesWidget: (value, meta) => _bottomTitleWidgets(
                  context,
                  value,
                  meta,
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => _buildLegendText(
                  context,
                  value.toInt().toString(),
                ),
                reservedSize: (maxY.toString().length * 6).toDouble(),
                interval: maxY / 3,
                maxIncluded: includeMaxY,
              ),
            ),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          minX: 0,
          minY: 0,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: points.map((e) => FlSpot(e.x, e.y)).toList(),
              isCurved: true,
              gradient: LinearGradient(
                colors: gradientColors,
              ),
              dotData: FlDotData(
                getDotPainter: (p0, p1, p2, p3) {
                  return FlDotCirclePainter(
                    radius: 3,
                    color: gradientColors[1],
                    strokeWidth: 1,
                    strokeColor: gradientColors[1],
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors
                      .map(
                        (color) => color.withValues(
                          alpha: 0.3,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomTitleWidgets(
    BuildContext context,
    double value,
    TitleMeta meta,
  ) {
    return SideTitleWidget(
      meta: meta,
      space: 16,
      child: Transform.rotate(
        angle: -0.5,
        child: _buildLegendText(
          context,
          xConverter(value),
        ),
      ),
    );
  }

  Widget _buildLegendText(BuildContext context, String text) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

double _conditionalRound(double value) {
  if (value < 100) {
    return (value / 10).round() * 10; // Round to the nearest 10
  } else if (value < 1000) {
    return (value / 100).round() * 100; // Round to the nearest 100
  } else if (value < 10000) {
    return (value / 1000).round() * 1000; // Round to the nearest 1000
  } else {
    return (value / 10000).round() * 10000; // Round to the nearest 10000
  }
}
