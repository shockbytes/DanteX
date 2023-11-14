import 'package:collection/collection.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/timeline/timeline.dart';
import 'package:dantex/src/providers/app_router.dart';
import 'package:dantex/src/providers/service.dart';
import 'package:dantex/src/ui/book/book_image.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/themed_app_bar.dart';
import 'package:dantex/src/ui/timeline/timeline_sort.dart';
import 'package:dantex/src/util/extensions.dart';
import 'package:dantex/src/util/layout_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeline_tile/timeline_tile.dart';

/// TODO
/// - Nice empty screen
class TimelinePage extends ConsumerWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Timeline timeline = ref.watch(timelineProvider);

    return Scaffold(
      appBar: ThemedAppBar(
        title: _buildSortingInput(timeline),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return StreamBuilder<List<TimelineMonthGrouping>>(
            stream: timeline.getTimelineData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              final List<TimelineMonthGrouping> data = snapshot.data!;

              if (data.isEmpty) {
                return _buildEmptyScreen();
              }

              return _buildTimeline(
                context,
                data,
                getDeviceFormFactor(constraints),
              );
            },
          );
        },
      ),
    );
  }

  // TODO build nice screen
  Widget _buildEmptyScreen() {
    return const Center(
      child: Text('TODO some nice stuff here'),
    );
  }

  Widget _buildTimeline(
    BuildContext context,
    List<TimelineMonthGrouping> grouping,
    DeviceFormFactor formFactor,
  ) {
    return Center(
      child: ListView(
        children: [
          ...grouping
              .map(
                (group) => [
                  _buildMonthTile(context, group.month, formFactor),
                  ...group.books.map(
                    (book) => _buildBookTimelineTile(context, book, formFactor),
                  ),
                ],
              )
              .flattened,
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSortingInput(Timeline timeline) {
    return StreamBuilder<TimelineSortStrategy>(
      stream: timeline.sortStrategy,
      builder: (context, snapshot) {
        final TimelineSortStrategy sortStrategy = snapshot.data ?? TimelineSortStrategy.byEndState;

        return SegmentedButton<TimelineSortStrategy>(
          onSelectionChanged: (Set<TimelineSortStrategy> selection) {
            timeline.setSortStrategy(selection.first);
          },
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: TimelineSortStrategy.byEndState,
              label: Text('timeline.sorting.ended-in'.tr()),
              icon: const Icon(Icons.check),
            ),
            ButtonSegment(
              value: TimelineSortStrategy.byStartDate,
              label: Text('timeline.sorting.started-in'.tr()),
              icon: const Icon(Icons.book_outlined),
            ),
          ],
          selected: { sortStrategy },
        );
      },
    );
  }

  Widget _buildBookTimelineTile(
    BuildContext context,
    Book book,
    DeviceFormFactor formFactor,
  ) {
    final (indicatorSize, tileHeight) = _bookTimelineSizes(formFactor);

    return TimelineTile(
      alignment: TimelineAlign.center,
      lineXY: 0.5,
      beforeLineStyle: LineStyle(
        color: Theme.of(context).colorScheme.primary,
        thickness: 2,
      ),
      indicatorStyle: IndicatorStyle(
        drawGap: true,
        color: Colors.black,
        width: indicatorSize,
        height: indicatorSize,
        indicator: GestureDetector(
          onTap: () => context.go(
            DanteRoute.bookDetail.navigationUrl.replaceAll(
              ':bookId',
              book.id,
            ),
          ),
          child: BookImage(
            book.thumbnailAddress,
            size: indicatorSize,
          ),
        ),
      ),
      endChild: SizedBox(height: tileHeight),
    );
  }

  Widget _buildMonthTile(
    BuildContext context,
    DateTime month,
    DeviceFormFactor formFactor,
  ) {
    final Size indicatorSize = _monthTimelineSize(formFactor);

    return TimelineTile(
      alignment: TimelineAlign.center,
      lineXY: 0.5,
      beforeLineStyle: LineStyle(
        color: Theme.of(context).colorScheme.primary,
        thickness: 2,
      ),
      indicatorStyle: IndicatorStyle(
        drawGap: true,
        color: Colors.black,
        width: indicatorSize.width,
        height: indicatorSize.height,
        indicator: DanteOutlinedCard(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                month.formatWithMonthAndYear(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }

  (double indicatorSize, double tileHeight) _bookTimelineSizes(
    DeviceFormFactor formFactor,
  ) {
    return switch (formFactor) {
      DeviceFormFactor.phone => (96, 150),
      DeviceFormFactor() => (128, 200),
    };
  }

  Size _monthTimelineSize(DeviceFormFactor formFactor) {
    return switch (formFactor) {
      DeviceFormFactor.phone => const Size(192, 48),
      DeviceFormFactor() => const Size(256, 64),
    };
  }
}
