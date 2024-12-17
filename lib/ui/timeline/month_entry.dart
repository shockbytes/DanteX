import 'package:dantex/models/book.dart';
import 'package:dantex/ui/shared/book_image.dart';
import 'package:dantex/util/date_time.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MonthEntry extends StatelessWidget {
  const MonthEntry({required this.month, required this.books, super.key});

  final DateTime month;
  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    const indicatorSize = Size(192, 48);
    const bookIndicatorSize = 96.0;
    const tileHeight = 150.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TimelineTile(
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
            indicator: Card.outlined(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    month.formatWithMonthAndYear(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ),
          ),
        ),
        ...books.map(
          (book) => TimelineTile(
            alignment: TimelineAlign.center,
            lineXY: 0.5,
            beforeLineStyle: LineStyle(
              color: Theme.of(context).colorScheme.primary,
              thickness: 2,
            ),
            indicatorStyle: IndicatorStyle(
              drawGap: true,
              color: Colors.black,
              width: bookIndicatorSize,
              height: bookIndicatorSize,
              indicator: GestureDetector(
                onTap: () {},
                child: BookImage(
                  book.thumbnailAddress,
                  size: bookIndicatorSize,
                ),
              ),
            ),
            endChild: const SizedBox(height: tileHeight),
          ),
        ),
      ],
    );
  }
}
