import 'package:dantex/models/book_sort_strategy.dart';
import 'package:dantex/models/timeline.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsRepository {
  UserSettingsRepository({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  static const _keyThemeMode = 'key_theme_mode';
  static const _keyShowBookSummary = 'key_show_book_summary';
  static const _keyTrackingEnabled = 'key_tracking_enabled';
  static const _keyRandomBooksEnabled = 'key_random_books_enabled';
  static const _keySortStrategy = 'key_sort_strategy';
  static const _keyTimelineSortStrategy = 'key_timeline_sort_strategy';
  static const _pagesPerMonthGoal = 'key_pages_per_month_goal';
  static const _booksPerMonthGoal = 'key_books_per_month_goal';

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _sharedPreferences.setInt(_keyThemeMode, themeMode.index);
  }

  ThemeMode getThemeMode() {
    final themeModeIndex = _sharedPreferences.getInt(_keyThemeMode);
    return themeModeIndex != null
        ? ThemeMode.values[themeModeIndex]
        : ThemeMode.system;
  }

  Future<void> setShowBookSummary({required bool showBookSummary}) async {
    await _sharedPreferences.setBool(_keyShowBookSummary, showBookSummary);
  }

  bool getShowBookSummary() {
    return _sharedPreferences.getBool(_keyShowBookSummary) ?? true;
  }

  Future<void> setTrackingEnabled({required bool trackingEnabled}) async {
    await _sharedPreferences.setBool(_keyTrackingEnabled, trackingEnabled);
  }

  bool getTrackingEnabled() {
    return _sharedPreferences.getBool(_keyTrackingEnabled) ?? true;
  }

  Future<void> setRandomBooksEnabled({required bool randomBooksEnabled}) async {
    await _sharedPreferences.setBool(
      _keyRandomBooksEnabled,
      randomBooksEnabled,
    );
  }

  bool getRandomBooksEnabled() {
    return _sharedPreferences.getBool(_keyRandomBooksEnabled) ?? true;
  }

  Future<void> setSortStrategy({required BookSortStrategy sortStrategy}) async {
    await _sharedPreferences.setString(_keySortStrategy, sortStrategy.name);
  }

  BookSortStrategy getSortStrategy() {
    final sortStrategyName = _sharedPreferences.getString(_keySortStrategy);
    return BookSortStrategy.values.firstWhere(
      (sortStrategy) => sortStrategy.name == sortStrategyName,
      orElse: () => BookSortStrategy.position,
    );
  }

  Future<void> setTimelineSortStrategy({
    required TimelineSortStrategy timelineSortStrategy,
  }) async {
    await _sharedPreferences.setString(
      _keyTimelineSortStrategy,
      timelineSortStrategy.name,
    );
  }

  TimelineSortStrategy getTimelineSortStrategy() {
    final timelineSortStrategyName =
        _sharedPreferences.getString(_keyTimelineSortStrategy);
    return TimelineSortStrategy.values.firstWhere(
      (timelineSortStrategy) =>
          timelineSortStrategy.name == timelineSortStrategyName,
      orElse: () => TimelineSortStrategy.byStartDate,
    );
  }

  Future<void> setPagesPerMonthGoal({required int pagesPerMonthGoal}) async {
    await _sharedPreferences.setInt(_pagesPerMonthGoal, pagesPerMonthGoal);
  }

  int? getPagesPerMonthGoal() {
    return _sharedPreferences.getInt(_pagesPerMonthGoal);
  }

  Future<void> resetPagesPerMonthTotal() async {
    await _sharedPreferences.remove(_pagesPerMonthGoal);
  }

  Future<void> setBooksPerMonthGoal({required int booksPerMonthGoal}) async {
    await _sharedPreferences.setInt(_booksPerMonthGoal, booksPerMonthGoal);
  }

  Future<void> resetBooksPerMonthGoal() async {
    await _sharedPreferences.remove(_booksPerMonthGoal);
  }

  int? getBooksPerMonthGoal() {
    return _sharedPreferences.getInt(_booksPerMonthGoal);
  }
}
