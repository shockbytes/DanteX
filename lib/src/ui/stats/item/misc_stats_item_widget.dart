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
    return Text('av');
  }
}
