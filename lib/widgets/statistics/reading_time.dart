import 'package:dantex/models/book.dart';
import 'package:dantex/providers/statistics.dart';
import 'package:dantex/widgets/shared/book_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReadingTime extends ConsumerWidget {
  const ReadingTime();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (:fastestBook, :slowestBook) = ref.watch(readingTimeStatsProvider);

    if (fastestBook == null && slowestBook == null) {
      return Center(
        child: const Text('statistics.reading_time.empty').tr(),
      );
    }

    return Row(
      children: [
        if (fastestBook != null)
          _ReadingTimeWidget(
            key: const ValueKey('fastest_book'),
            book: fastestBook,
            label: 'statistics.reading_time.fastest_book'.tr(),
          ),
        if (slowestBook != null)
          _ReadingTimeWidget(
            key: const ValueKey('slowest_book'),
            book: slowestBook,
            label: 'statistics.reading_time.slowest_book'.tr(),
          ),
      ],
    );
  }
}

class _ReadingTimeWidget extends StatelessWidget {
  const _ReadingTimeWidget({
    required this.book,
    required this.label,
    super.key,
  });

  final Book book;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          BookImage(book.thumbnailAddress, size: 80),
          const SizedBox(height: 16),
          Text(
            book.title,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _durationInDays(book),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _durationInDays(Book book) {
    return 'statistics.reading_time.days'.tr(
      args: [
        (book.endDate ?? DateTime.now())
            .difference(book.startDate ?? DateTime.now())
            .inDays
            .toString(),
      ],
    );
  }
}
