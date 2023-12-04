import 'package:dantex/src/data/stats/stats_item.dart';
import 'package:dantex/src/ui/stats/item/chart/dante_pie_chart.dart';
import 'package:dantex/src/ui/stats/item/empty_stats_view.dart';
import 'package:dantex/src/ui/stats/item/stats_item_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BooksAndPagesStatsItemWidget extends StatelessWidget {
  final BooksAndPagesStatsItem _item;

  const BooksAndPagesStatsItemWidget(
    this._item, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StatsItemCard(
      title: _item.titleKey.tr(),
      content: _buildContent(),
    );
  }

  Widget _buildContent() {
    final BooksAndPagesDataState dataState = _item.dataState;
    return switch (dataState) {
      EmptyBooksAndPagesData() => EmptyStatsView('stats.books-and-pages.empty'.tr()),
      BooksAndPagesData() => _buildBody(dataState),
    };
  }

  Widget _buildBody(BooksAndPagesData data) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text('stats.books-and-pages.books'.tr()),
              SizedBox(
                height: 300,
                child: _buildBooksChart(data),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text('stats.books-and-pages.pages'.tr()),
              SizedBox(
                height: 300,
                child: _buildPagesChart(data),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBooksChart(BooksAndPagesData data) {
    final Map<String, int> pieData = {
      'stats.books-and-pages.books-waiting': data.booksWaiting,
      'stats.books-and-pages.books-reading': data.booksReading,
      'stats.books-and-pages.books-read': data.booksRead,
    };
    return DantePieChart(
      badgeBuilder: (String key, double size) => Card(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            key.tr(args: [pieData[key]!.toString()]),
          ),
        ),
      ),
      pieData: pieData,
      titleBuilder: (String key, int value) => '',
    );
  }

  Widget _buildPagesChart(BooksAndPagesData data) {
    final Map<String, int> pieData = {
      'stats.books-and-pages.pages-waiting': data.pagesWaiting,
      'stats.books-and-pages.pages-read': data.pagesRead,
    };
    return DantePieChart(
      badgeBuilder: (String key, double size) => Card(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            key.tr(args: [pieData[key]!.toString()]),
          ),
        ),
      ),
      pieData: pieData,
      titleBuilder: (String key, int value) => '',
    );
  }
}
