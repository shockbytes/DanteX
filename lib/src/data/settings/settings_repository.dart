import 'package:dantex/src/data/book/book_sort_strategy.dart';
import 'package:dantex/src/ui/timeline/timeline_sort.dart';
import 'package:flutter/material.dart';

abstract class SettingsRepository {
  void setThemeMode(ThemeMode mode);
  ThemeMode getThemeMode();
  Stream<ThemeMode> observeThemeMode();

  void setSortingStrategy(BookSortStrategy strategy);
  BookSortStrategy getSortingStrategy();

  void setIsTrackingEnabled({required bool isTrackingEnabled});
  bool isTrackingEnabled();

  void setIsRandomBooksEnabled({required bool isRandomBooksEnabled});
  bool isRandomBooksEnabled();

  void setTimelineSortStrategy(TimelineSortStrategy sort);
  TimelineSortStrategy getTimelineSortStrategy();
}
