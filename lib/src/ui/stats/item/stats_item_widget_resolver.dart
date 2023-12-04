


import 'package:dantex/src/data/stats/stats_item.dart';
import 'package:dantex/src/ui/stats/item/books_and_pages_stats_item_widget.dart';
import 'package:dantex/src/ui/stats/item/label_stats_item_widget.dart';
import 'package:dantex/src/ui/stats/item/language_stats_item_widget.dart';
import 'package:dantex/src/ui/stats/item/reading_time_stats_item_widget.dart';
import 'package:flutter/material.dart';


class StatsItemWidgetResolver {

  StatsItemWidgetResolver._();

  static Widget resolveItem(StatsItem item) {
    return switch (item) {
      BooksAndPagesStatsItem() => BooksAndPagesStatsItemWidget(item),
      ReadingTimeStatsItem() => ReadingTimeStatsItemWidget(item),
      LanguageStatsItem() => LanguageStatsItemWidget(item),
      LabelStatsItem() => LabelStatsItemWidget(item),
    };
  }
}