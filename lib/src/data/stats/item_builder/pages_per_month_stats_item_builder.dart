

import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/stats/item_builder/stats_item_builder.dart';
import 'package:dantex/src/data/stats/stats_item.dart';

class PagesPerMonthStatsItemBuilder implements StatsItemBuilder<PagesPerMonthStatsItem> {
  @override
  PagesPerMonthStatsItem buildStatsItem(List<Book> books) {
    return PagesPerMonthStatsItem();
  }

}