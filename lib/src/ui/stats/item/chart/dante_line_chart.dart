import 'package:dantex/src/util/point_2d.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DanteLineChart extends StatelessWidget {
  final List<Color> _gradientColors = [
    Colors.lightBlue,
    Colors.blue,
  ];

  final List<Point2D> _points;
  final String Function(double x) xConverter;
  final bool isMobile;

  DanteLineChart(
    this._points, {
    required this.xConverter,
    required this.isMobile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: isMobile ? 3 : 2,
      child: LineChart(
        _buildLineChartData(context),
      ),
    );
  }

  LineChartData _buildLineChartData(BuildContext context) {
    return LineChartData(
      gridData: const FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (double value, TitleMeta meta) =>
                _bottomTitleWidgets(
              context,
              value,
              meta,
            ),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (double value, TitleMeta meta) => _buildLegendText(
              context,
              value.toString(),
            ),
            reservedSize: 42,
          ),
        ),
        rightTitles: const AxisTitles(),
        topTitles: const AxisTitles(),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      // maxX: 11,
      minY: 0,
      // maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: _points.map((e) => FlSpot(e.x, e.y)).toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: _gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: _gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomTitleWidgets(
    BuildContext context,
    double value,
    TitleMeta meta,
  ) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: _buildLegendText(
        context,
        xConverter(value),
      ),
    );
  }

  Widget _buildLegendText(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      textAlign: TextAlign.left,
    );
  }
}
