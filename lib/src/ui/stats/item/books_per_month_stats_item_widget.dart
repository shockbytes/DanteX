import 'package:collection/collection.dart';
import 'package:dantex/src/data/stats/stats_item.dart';
import 'package:dantex/src/ui/stats/item/chart/dante_line_chart.dart';
import 'package:dantex/src/ui/stats/item/empty_stats_view.dart';
import 'package:dantex/src/ui/stats/item/stats_item_card.dart';
import 'package:dantex/src/ui/stats/item/util/mobile_stats_mixin.dart';
import 'package:dantex/src/util/extensions.dart';
import 'package:dantex/src/util/point_2d.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BooksPerMonthStatsItemWidget extends StatelessWidget
    with MobileStatsMixin {
  final BooksPerMonthStatsItem _item;

  final bool isMobile;

  const BooksPerMonthStatsItemWidget(
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
    final BooksPerMonthDataState state = _item.dataState;
    return switch (state) {
      EmptyBooksPerMonthData() => EmptyStatsView(
          'stats.books-per-month.empty'.tr(),
        ),
      BooksPerMonthData() => _buildChart(context, state),
    };
  }

  Widget _buildChart(BuildContext context, BooksPerMonthData state) {
    return DanteLineChart(
      _buildPoints(state.booksPerMonthDistribution),
      xConverter: (double x) => state.booksPerMonthDistribution.entries
          .toList()[x.toInt()]
          .key
          .formatWithMonthAndYearShort(),
      isMobile: isMobile,
    );
  }

  List<Point2D> _buildPoints(Map<DateTime, int> booksPerMonthDistribution) {
    return booksPerMonthDistribution.entries
        .mapIndexed(
          (index, e) => Point2D(
            x: index.toDouble(),
            y: e.value.toDouble(),
          ),
        )
        .toList();
  }
}
