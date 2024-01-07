import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/stats/stats_item.dart';
import 'package:dantex/src/ui/book/book_image.dart';
import 'package:dantex/src/ui/stats/item/empty_stats_view.dart';
import 'package:dantex/src/ui/stats/item/stats_item_card.dart';
import 'package:dantex/src/ui/stats/item/util/mobile_stats_mixin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ReadingTimeStatsItemWidget extends StatelessWidget with MobileStatsMixin {
  final ReadingTimeStatsItem _item;
  final bool isMobile;

  const ReadingTimeStatsItemWidget(
    this._item, {
    required this.isMobile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StatsItemCard(
      title: _item.titleKey.tr(),
      content: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final ReadingTimeDataState dataState = _item.dataState;
    return switch (dataState) {
      EmptyReadingTimeData() => resolveTopLevelWidget(
          isMobile: isMobile,
          child: EmptyStatsView('stats.reading-time.empty'.tr()),
        ),
      ReadingTimeData() => _buildReadingTimeContent(context, dataState),
    };
  }

  Widget _buildReadingTimeContent(
    BuildContext context,
    ReadingTimeData dataState,
  ) {
    return resolveTopLevelWidget(
      isMobile: isMobile,
      child: Row(
        children: [
          _buildReadingTimeWidget(
            context,
            'stats.reading-time.fastest-book'.tr(),
            dataState.fastestBook,
          ),
          const VerticalDivider(
            indent: 16,
            endIndent: 16,
            thickness: 1,
          ),
          _buildReadingTimeWidget(
            context,
            'stats.reading-time.slowest-book'.tr(),
            dataState.slowestBook,
          ),
        ],
      ),
    );
  }

  Widget _buildReadingTimeWidget(
    BuildContext context,
    String label,
    Book book,
  ) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          BookImage(book.thumbnailAddress, size: 48),
          const SizedBox(height: 16),
          Text(
            book.title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _durationInDays(book),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _durationInDays(Book book) {
    return 'stats.reading-time.days'.tr(
      args: [book.endDate!.difference(book.startDate!).inDays.toString()],
    );
  }
}
