import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DanteRadarChart extends StatelessWidget {
  const DanteRadarChart({required this.dataMap, super.key});

  final Map<String, int> dataMap;

  @override
  Widget build(BuildContext context) {
    return RadarChart(
      RadarChartData(
        radarShape: RadarShape.polygon,
        dataSets: [
          RadarDataSet(
            fillColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            borderColor: Theme.of(context).colorScheme.primary,
            entryRadius: 1,
            dataEntries: dataMap.values
                .map(
                  (e) => RadarEntry(value: e.toDouble()),
                )
                .toList(),
            borderWidth: 2,
          ),
        ],
        radarBackgroundColor: Colors.transparent,
        borderData: FlBorderData(show: false),
        radarBorderData: const BorderSide(color: Colors.transparent),
        titlePositionPercentageOffset: 0.2,
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: 12,
        ),
        getTitle: (index, angle) {
          final entry = dataMap.entries.toList()[index];
          return RadarChartTitle(
            text: '${entry.key}\n(${entry.value})',
          );
        },
        tickCount: 1,
        ticksTextStyle: const TextStyle(
          color: Colors.transparent,
          fontSize: 10,
        ),
        tickBorderData: const BorderSide(color: Colors.transparent),
        gridBorderData: BorderSide(
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
    );
  }
}
