import 'package:dantex/src/data/book/book_sort_strategy.dart';
import 'package:dantex/src/data/settings/settings_repository.dart';
import 'package:dantex/src/ui/timeline/timeline_sort.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesSettingsRepository implements SettingsRepository {
  final SharedPreferences _sp;

  static const _keyTrackingEnabled = 'key_tracking_enabled';
  static const _keyRandomBooksEnabled = 'key_random_books_enabled';
  static const _keyThemeMode = 'key_theme_mode';
  static const _keySortStrategy = 'key_sort_strategy';
  static const _keyTimelineSortStrategy = 'key_timeline_sort_strategy';

  final BehaviorSubject<ThemeMode> _themeModeSubject = BehaviorSubject();

  SharedPreferencesSettingsRepository(this._sp) {
    _initializeThemeSubject();
  }

  void _initializeThemeSubject() {
    _themeModeSubject.add(getThemeMode());
  }

  @override
  BookSortStrategy getSortingStrategy() {
    final int sortStrategyOrdinal = _sp.getInt(_keySortStrategy) ?? 0;
    return BookSortStrategy.values[sortStrategyOrdinal];
  }

  @override
  ThemeMode getThemeMode() {
    final int themeModeOrdinal = _sp.getInt(_keyThemeMode) ?? 0;
    return ThemeMode.values[themeModeOrdinal];
  }

  @override
  bool isRandomBooksEnabled() {
    return _sp.getBool(_keyRandomBooksEnabled) ?? false;
  }

  @override
  bool isTrackingEnabled() {
    // If never set, default to true.
    return _sp.getBool(_keyTrackingEnabled) ?? true;
  }

  @override
  Future<void> setIsRandomBooksEnabled({
    required bool isRandomBooksEnabled,
  }) async {
    await _sp.setBool(_keyRandomBooksEnabled, isRandomBooksEnabled);
  }

  @override
  Future<void> setIsTrackingEnabled({required bool isTrackingEnabled}) async {
    await _sp.setBool(_keyTrackingEnabled, isTrackingEnabled);
  }

  @override
  Future<void> setSortingStrategy(BookSortStrategy strategy) async {
    await _sp.setInt(_keySortStrategy, strategy.index);
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeModeSubject.add(themeMode);

    await _sp.setInt(_keyThemeMode, themeMode.index);
  }

  @override
  Stream<ThemeMode> observeThemeMode() {
    return _themeModeSubject.stream;
  }

  @override
  TimelineSortStrategy getTimelineSortStrategy() {
    final int timelineSortStrategyOrdinal =
        _sp.getInt(_keyTimelineSortStrategy) ?? 0;
    return TimelineSortStrategy.values[timelineSortStrategyOrdinal];
  }

  @override
  Future<void> setTimelineSortStrategy(
    TimelineSortStrategy sortStrategy,
  ) async {
    await _sp.setInt(_keyTimelineSortStrategy, sortStrategy.index);
  }
}
