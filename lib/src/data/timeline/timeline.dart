import 'package:collection/collection.dart';
import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/settings/settings_repository.dart';

import 'package:dantex/src/ui/timeline/timeline_sort.dart';
import 'package:rxdart/rxdart.dart';

class Timeline {
  final SettingsRepository _settingsRepository;
  final BookRepository _bookRepository;

  final BehaviorSubject<TimelineSortStrategy> _sortStrategySubject;

  Stream<TimelineSortStrategy> get sortStrategy => _sortStrategySubject.stream;

  Timeline(this._settingsRepository, this._bookRepository)
      : _sortStrategySubject = BehaviorSubject.seeded(
          _settingsRepository.getTimelineSortStrategy(),
        );

  void setSortStrategy(TimelineSortStrategy sortStrategy) {
    _sortStrategySubject.add(sortStrategy);
    _settingsRepository.setTimelineSortStrategy(sortStrategy);
  }

  Stream<List<TimelineMonthGrouping>> getTimelineData() {
    return _sortStrategySubject.flatMap(_createTimelineForSortStrategy);
  }

  Stream<List<TimelineMonthGrouping>> _createTimelineForSortStrategy(
    TimelineSortStrategy sortStrategy,
  ) {
    return _bookRepository.getAllBooks().map((books) {
      return books
          .where(
            (element) {
              return switch (sortStrategy) {
                TimelineSortStrategy.byStartDate => element.startDate != null,
                TimelineSortStrategy.byEndState => element.endDate != null,
              };
            },
          )
          .groupListsBy(
            (e) {
              return switch (_sortStrategySubject.value) {
                TimelineSortStrategy.byStartDate => DateTime(
                    e.startDate!.year,
                    e.startDate!.month,
                  ),
                TimelineSortStrategy.byEndState => DateTime(
                    e.endDate!.year,
                    e.endDate!.month,
                  ),
              };
            },
          )
          .entries
          // Sort descending
          .sorted((a, b) => a.key.isBefore(b.key) ? 1 : -1)
          .map<TimelineMonthGrouping>(
            (MapEntry<DateTime, List<Book>> entry) =>
                TimelineMonthGrouping(month: entry.key, books: entry.value),
          )
          .toList();
    });
  }
}

class TimelineMonthGrouping {
  final DateTime month;
  final List<Book> books;

  TimelineMonthGrouping({
    required this.month,
    required this.books,
  });
}
