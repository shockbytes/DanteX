

import 'package:dantex/src/data/stats/stats_item.dart';
import 'package:flutter/material.dart';

class ReadingTimeStatsItemWidget extends StatelessWidget {

  final ReadingTimeStatsItem _item;

  const ReadingTimeStatsItemWidget(this._item, {super.key,});

  @override
  Widget build(BuildContext context) {
    return Text(_item.title());
  }

}