

import 'package:dantex/src/data/stats/stats_item.dart';
import 'package:flutter/material.dart';

class BooksAndPagesStatsItemWidget extends StatelessWidget {

  final BooksAndPagesStatsItem _item;

  const BooksAndPagesStatsItemWidget(this._item, {super.key,});

  @override
  Widget build(BuildContext context) {
    return Text(_item.title());
  }


}