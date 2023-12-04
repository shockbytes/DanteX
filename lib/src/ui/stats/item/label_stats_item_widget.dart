import 'package:dantex/src/data/stats/stats_item.dart';
import 'package:dantex/src/ui/stats/item/stats_item_card.dart';
import 'package:easy_localization/easy_localization.dart';
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
      content: Text('Labels'),
    );
  }
}
