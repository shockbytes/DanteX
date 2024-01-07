import 'package:cached_network_image/cached_network_image.dart';
import 'package:dantex/src/data/stats/stats_item.dart';
import 'package:dantex/src/ui/stats/item/chart/dante_pie_chart.dart';
import 'package:dantex/src/ui/stats/item/empty_stats_view.dart';
import 'package:dantex/src/ui/stats/item/stats_item_card.dart';
import 'package:dantex/src/ui/stats/item/util/mobile_stats_mixin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LanguageStatsItemWidget extends StatelessWidget with MobileStatsMixin {
  final LanguageStatsItem _item;
  final bool isMobile;

  const LanguageStatsItemWidget(
    this._item, {
    required this.isMobile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StatsItemCard(
      title: _item.titleKey.tr(),
      content: resolveTopLevelWidget(
        isMobile: isMobile,
        child: _buildContent(),
        mobileHeight: 240,
      ),
    );
  }

  Widget _buildContent() {
    final LanguageDataState state = _item.dataState;
    return switch (state) {
      EmptyLanguageData() => EmptyStatsView('stats.language.empty'.tr()),
      LanguageData() => _buildChart(state),
    };
  }

  Widget _buildChart(LanguageData data) {
    return DantePieChart(
      pieData: data.languageDistribution,
      badgeBuilder: _Badge.new,
      titleBuilder: (_, value) => value.toString(),
    );
  }
}

class _Badge extends StatelessWidget {
  final String _languageNotAvailable = 'na';
  final String language;
  final double size;

  const _Badge(
    this.language,
    this.size,
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: _buildFlag(),
      ),
    );
  }

  Widget _buildFlag() {
    if (language.toLowerCase() == _languageNotAvailable) {
      return Text('stats.label.na'.tr());
    }

    return CachedNetworkImage(
      imageUrl: _buildUrl(language),
    );
  }

  String _buildUrl(String language) {
    return 'https://flagsapi.com/${_normalizeLanguage(language)}/flat/64.png';
  }

  String _normalizeLanguage(String language) {
    if (language.toLowerCase() == 'en') {
      return 'GB';
    }

    return language.toUpperCase();
  }
}
