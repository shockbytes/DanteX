import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_state.dart';
import 'package:dantex/models/page_record.dart';
import 'package:dantex/providers/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:ulid/ulid.dart';

class BookProgressWidget extends ConsumerStatefulWidget {
  const BookProgressWidget({required this.book, super.key});

  final Book book;

  @override
  ConsumerState<BookProgressWidget> createState() => _BookProgressWidgetState();
}

class _BookProgressWidgetState extends ConsumerState<BookProgressWidget> {
  late double currentPercentage;

  @override
  void initState() {
    super.initState();
    currentPercentage = widget.book.progressPercentage * 100;
  }

  @override
  Widget build(BuildContext context) {
    final isReading = widget.book.state == BookState.reading;
    return GestureDetector(
      onTap: isReading ? () {} : null,
      child: SizedBox(
        width: 160,
        height: 160,
        child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              startAngle: 270,
              endAngle: 270,
              showTicks: false,
              showLabels: false,
              axisLineStyle: AxisLineStyle(
                thickness: 4,
                color: isReading
                    ? Theme.of(context).colorScheme.secondaryContainer
                    : Colors.transparent,
              ),
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  widget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.menu_book_outlined,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        getCenterText(isReading: isReading),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
              pointers: <GaugePointer>[
                WidgetPointer(
                  value: currentPercentage,
                  enableAnimation: true,
                  enableDragging: true,
                  // Outer container that is transparent to make the touch area
                  // bigger.
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Align(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isReading
                              ? Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  onValueChanged: (value) =>
                      setState(() => currentPercentage = value),
                  onValueChangeEnd: (value) async {
                    final currentPage =
                        (widget.book.pageCount * (currentPercentage / 100))
                            .round();
                    await ref.read(bookRepositoryProvider).setCurrentPage(
                          widget.book.id,
                          currentPage,
                        );
                    await ref.read(bookRepositoryProvider).addPageRecord(
                          widget.book,
                          PageRecord(
                            id: Ulid().toString(),
                            bookId: widget.book.id,
                            fromPage: widget.book.currentPage,
                            toPage: currentPage,
                            timestamp: DateTime.now(),
                          ),
                        );
                  },
                ),
                RangePointer(
                  value: currentPercentage,
                  width: 4,
                  color: isReading
                      ? Theme.of(context).colorScheme.onSecondaryContainer
                      : Colors.transparent,
                  enableAnimation: true,
                  cornerStyle: CornerStyle.bothCurve,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getCenterText({required bool isReading}) {
    if (isReading) {
      final currentPage =
          (widget.book.pageCount * (currentPercentage / 100)).round();
      return '$currentPage / ${widget.book.pageCount}';
    } else {
      return '${widget.book.pageCount}';
    }
  }
}
