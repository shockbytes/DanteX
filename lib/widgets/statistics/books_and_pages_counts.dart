import 'package:dantex/providers/statistics.dart';
import 'package:dantex/theme/dante_colors.dart';
import 'package:dantex/widgets/statistics/dante_pie_chart.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const double _columnHeight = 200;

class BooksAndPagesCounts extends ConsumerWidget {
  const BooksAndPagesCounts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookCounts = ref.watch(bookCountsProvider);
    final pageCounts = ref.watch(pageCountsProvider);

    if (bookCounts == zeroBookCount || pageCounts == zeroPageCount) {
      return Center(
        child: const Text('statistics.books_and_pages.empty').tr(),
      );
    }

    final (:readLaterCount, :readingCount, :readCount) = bookCounts;
    final (:pagesWaiting, :pagesRead) = pageCounts;

    final danteColors = Theme.of(context).extension<DanteColors>();
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text('statistics.books_and_pages.books'.tr()),
              SizedBox(
                height: _columnHeight,
                child: DantePieChart(
                  sections: [
                    DantePieChartSectionData(
                      color: danteColors?.forLaterColor ?? Colors.yellow,
                      value: readLaterCount.toDouble(),
                      title: 'statistics.books_and_pages.books_waiting'
                          .plural(readLaterCount),
                      badgeColor:
                          Theme.of(context).colorScheme.surfaceContainer,
                    ),
                    DantePieChartSectionData(
                      color: danteColors?.readingColor ?? Colors.blue,
                      value: readingCount.toDouble(),
                      title: 'statistics.books_and_pages.books_reading'
                          .plural(readingCount),
                      badgeColor:
                          Theme.of(context).colorScheme.surfaceContainer,
                    ),
                    DantePieChartSectionData(
                      color: danteColors?.readColor ?? Colors.green,
                      value: readCount.toDouble(),
                      title: 'statistics.books_and_pages.books_read'
                          .plural(readCount),
                      badgeColor:
                          Theme.of(context).colorScheme.surfaceContainer,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text('statistics.books_and_pages.pages'.tr()),
              SizedBox(
                height: _columnHeight,
                child: DantePieChart(
                  sections: [
                    DantePieChartSectionData(
                      color: danteColors?.forLaterColor ?? Colors.yellow,
                      value: pagesWaiting.toDouble(),
                      title: 'statistics.books_and_pages.pages_waiting'
                          .plural(pagesWaiting),
                      badgeColor:
                          Theme.of(context).colorScheme.surfaceContainer,
                    ),
                    DantePieChartSectionData(
                      color: danteColors?.readColor ?? Colors.green,
                      value: pagesRead.toDouble(),
                      title: 'statistics.books_and_pages.pages_read'
                          .plural(pagesRead),
                      badgeColor:
                          Theme.of(context).colorScheme.surfaceContainer,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
