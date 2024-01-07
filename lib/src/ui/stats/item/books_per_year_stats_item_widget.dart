import 'package:collection/collection.dart';
import 'package:dantex/src/data/stats/stats_item.dart';
import 'package:dantex/src/ui/stats/item/chart/dante_line_chart.dart';
import 'package:dantex/src/ui/stats/item/empty_stats_view.dart';
import 'package:dantex/src/ui/stats/item/stats_item_card.dart';
import 'package:dantex/src/ui/stats/item/util/mobile_stats_mixin.dart';
import 'package:dantex/src/util/point_2d.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BooksPerYearStatsItemWidget extends StatelessWidget
    with MobileStatsMixin {
  final BooksPerYearStatsItem _item;

  final bool isMobile;

  const BooksPerYearStatsItemWidget(
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
    final BooksPerYearDataState state = _item.dataState;
    return switch (state) {
      EmptyBooksPerYearData() => EmptyStatsView(
          'stats.books-per-year.empty'.tr(),
        ),
      BooksPerYearData() => _buildChart(context, state),
    };
  }

  Widget _buildChart(BuildContext context, BooksPerYearData state) {
    return DanteLineChart(
      _buildPoints(state.booksPerYearDistribution),
      xConverter: (double x) => state.booksPerYearDistribution.entries
          .toList()[x.toInt()]
          .key
          .toString(),
      isMobile: isMobile,
    );
  }

  List<Point2D> _buildPoints(Map<int, int> booksPerYearDistribution) {
    return booksPerYearDistribution.entries
        .mapIndexed(
          (index, e) => Point2D(
            x: index.toDouble(),
            y: e.value.toDouble(),
          ),
        )
        .toList();
  }
}
