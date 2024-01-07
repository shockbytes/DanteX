import 'package:dantex/src/data/stats/stats_item.dart';
import 'package:dantex/src/ui/stats/item/empty_stats_view.dart';
import 'package:dantex/src/ui/stats/item/stats_item_card.dart';
import 'package:dantex/src/ui/stats/item/util/mobile_stats_mixin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MiscStatsItemWidget extends StatelessWidget with MobileStatsMixin {
  final MiscStatsItem _item;
  final bool isMobile;

  const MiscStatsItemWidget(
    this._item, {
    required this.isMobile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StatsItemCard(
      title: _item.titleKey.tr(),
      content: resolveTopLevelWidget(
        child: _buildContent(context),
        isMobile: isMobile,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final MiscDataState dataState = _item.dataState;
    return switch (dataState) {
      EmptyMiscData() => EmptyStatsView('stats.misc.empty'.tr()),
      MiscData() => _buildMiscContent(context, dataState),
    };
  }

  Widget _buildMiscContent(BuildContext context, MiscData dataState) {
    return Row(
      children: [
        _buildMiscWidget(
          context,
          content: dataState.averageBooksPerMonth.toStringAsFixed(2),
          description: 'stats.misc.average-books.description'.tr(),
        ),
        _buildMostActiveMonthWidget(context, dataState),
      ],
    );
  }

  Widget _buildMostActiveMonthWidget(BuildContext context, MiscData dataState) {
    if (dataState.mostActiveMonth == null) {
      return const SizedBox.shrink();
    }

    final String content =
        dataState.mostActiveMonth?.bookCount.toString() ?? '---';

    final String description = 'stats.misc.most-read-month.description'.tr(
      args: [dataState.mostActiveMonth!.formattedMonth],
    );

    return _buildMiscWidget(
      context,
      content: content,
      description: description,
    );
  }

  Widget _buildMiscWidget(
    BuildContext context, {
    required String content,
    required String description,
  }) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            content,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
