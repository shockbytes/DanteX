import 'package:dantex/src/data/book/book_sort_strategy.dart';
import 'package:dantex/src/ui/timeline/timeline_sort.dart';
import 'package:dantex/src/data/book/migration/migration_score.dart';
import 'package:flutter/material.dart';

abstract class SettingsRepository {
  Future<void> setThemeMode(ThemeMode mode);
  ThemeMode getThemeMode();
  Stream<ThemeMode> observeThemeMode();

  Future<void> setSortingStrategy(BookSortStrategy strategy);
  BookSortStrategy getSortingStrategy();

  Future<void> setIsTrackingEnabled({required bool isTrackingEnabled});
  bool isTrackingEnabled();

  Future<void> setIsRandomBooksEnabled({required bool isRandomBooksEnabled});
  bool isRandomBooksEnabled();

  void setTimelineSortStrategy(TimelineSortStrategy sort);
  TimelineSortStrategy getTimelineSortStrategy();

  Future<void> setRealmMigrationStatus(MigrationStatus newStatus);
  MigrationStatus? getRealmMigrationStatus();
}
