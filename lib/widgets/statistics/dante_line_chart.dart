import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

const List<Color> _gradientColors = [
  Colors.lightBlue,
  Colors.blue,
];

class DanteLineChart extends StatelessWidget {
  const DanteLineChart({
    required this.points,
    required this.xConverter,
    super.key,
  });

  final List<({double x, double y})> points;
  final String Function(double x) xConverter;

  @override
  Widget build(BuildContext context) {
    final maxY = points.map((p) => p.y).max;

    return AspectRatio(
      aspectRatio: 3,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(
            show: false,
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                maxIncluded: false,
                showTitles: true,
                reservedSize: 32,
                interval: 5,
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
                maxIncluded: false,
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
          lineBarsData: [
            LineChartBarData(
              spots: points.map((e) => FlSpot(e.x, e.y)).toList(),
              isCurved: true,
              gradient: const LinearGradient(
                colors: _gradientColors,
              ),
              dotData: FlDotData(
                getDotPainter: (p0, p1, p2, p3) {
                  return FlDotCirclePainter(
                    radius: 3,
                    color: _gradientColors[1],
                    strokeWidth: 1,
                    strokeColor: _gradientColors[1],
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: _gradientColors
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
      axisSide: meta.axisSide,
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
