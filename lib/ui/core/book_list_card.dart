import 'package:dantex/data/book/book.dart';
import 'package:dantex/data/book/book_state.dart';
import 'package:dantex/ui/core/book_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BookListCard extends ConsumerWidget {
  const BookListCard({
    required this.book,
    super.key,
  });

  final Book book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  BookImage(book.thumbnailAddress, size: 48),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          book.subTitle,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          book.author,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_horiz),
                      ),
                      if (book.state == BookState.reading)
                        _buildProgressCircle(
                          context,
                          currentPage: book.currentPage,
                          pageCount: book.pageCount,
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (book.labels.isNotEmpty) Text(book.labels.join(', ')),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildProgressCircle(
  BuildContext context, {
  required int currentPage,
  required int pageCount,
}) {
  final percentage = computePercentage(currentPage, pageCount);

  return CircularPercentIndicator(
    radius: 20,
    lineWidth: 2,
    percent: percentage,
    center: Text(
      doublePercentageToString(percentage),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    ),
    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
    progressColor: Theme.of(context).colorScheme.onSecondaryContainer,
  );
}

double computePercentage(int current, int max) {
  if (max == 0) {
    return 0;
  }
  if (current > max) {
    return 1;
  }

  return current / max;
}

String doublePercentageToString(double percentage) {
  return '${(percentage * 100).toInt()}%';
}
