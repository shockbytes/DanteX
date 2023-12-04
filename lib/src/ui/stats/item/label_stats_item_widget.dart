import 'package:dantex/src/data/stats/stats_item.dart';
import 'package:dantex/src/ui/stats/item/empty_stats_view.dart';
import 'package:dantex/src/ui/stats/item/stats_item_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LabelStatsItemWidget extends StatelessWidget {
  final LabelStatsItem _item;

  const LabelStatsItemWidget(
    this._item, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StatsItemCard(
      title: _item.titleKey.tr(),
      content: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final LabelDataState state = _item.dataState;
    return switch (state) {
      EmptyLabelData() => Expanded(
          child: EmptyStatsView(
            'stats.label.empty'.tr(),
          ),
        ),
      LabelData() => Flexible(child: _buildChart(context, state)),
    };
  }

  Widget _buildChart(BuildContext context, LabelData state) {
    return AspectRatio(
      aspectRatio: 0.8,
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          dataSets: [
            RadarDataSet(
              fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              borderColor: Theme.of(context).colorScheme.primary,
              entryRadius: 1,
              dataEntries: state.labelDistribution.values
                  .map(
                    (e) => RadarEntry(value: e.toDouble()),
                  )
                  .toList(),
              borderWidth: 2,
            )
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
            final MapEntry<String, int> entry =
                state.labelDistribution.entries.toList()[index];
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
            width: 1,
          ),
        ),
      ),
    );
  }
}
