import 'package:collection/collection.dart';
import 'package:dantex/models/book.dart';
import 'package:dantex/models/timeline.dart';
import 'package:dantex/providers/repository.dart';
import 'package:dantex/providers/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timeline.g.dart';

typedef TimelineMonthGrouping = ({DateTime month, List<Book> books});

@riverpod
Stream<List<TimelineMonthGrouping>> timeLineBooks(Ref ref) {
  final sortStrategy = ref.watch(timelineSortStrategySettingProvider);

  return ref.watch(bookRepositoryProvider).allBooks().map((bookList) {
    return bookList
        .where((book) {
          return switch (sortStrategy) {
            TimelineSortStrategy.byStartDate => book.startDate != null,
            TimelineSortStrategy.byEndDate => book.endDate != null,
          };
        })
        .groupListsBy((book) {
          return switch (sortStrategy) {
            TimelineSortStrategy.byStartDate => DateTime(
                book.startDate!.year,
                book.startDate!.month,
              ),
            TimelineSortStrategy.byEndDate => DateTime(
                book.endDate!.year,
                book.endDate!.month,
              ),
          };
        })
        .entries
        // Sort descending
        .sorted((a, b) => a.key.isBefore(b.key) ? 1 : -1)
        .map<TimelineMonthGrouping>(
          (entry) => (month: entry.key, books: entry.value),
        )
        .toList();
  });
}
