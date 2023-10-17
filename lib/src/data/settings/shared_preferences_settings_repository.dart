import 'package:dantex/src/data/book/book_sort_strategy.dart';
import 'package:dantex/src/data/settings/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesSettingsRepository implements SettingsRepository {

  final SharedPreferences _sp;

  static const _keyTrackingEnabled = 'key_tracking_enabled';
  static const _keyRandomBooksEnabled = 'key_random_books_enabled';
  static const _keyThemeMode = 'key_theme_mode';
  static const _keySortStrategy = 'key_sort_strategy';

  final BehaviorSubject<ThemeMode> _themeModeSubject = BehaviorSubject();

  SharedPreferencesSettingsRepository(this._sp) {
    _initializeThemeSubject();
  }

  void _initializeThemeSubject() {
    _themeModeSubject.add(getThemeMode());
  }

  @override
  BookSortStrategy getSortingStrategy() {
    int sortStrategyOrdinal = _sp.getInt(_keySortStrategy) ?? 0;
    return BookSortStrategy.values[sortStrategyOrdinal];
  }

  @override
  ThemeMode getThemeMode() {
    int themeModeOrdinal = _sp.getInt(_keyThemeMode) ?? 0;
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
  void setIsRandomBooksEnabled(bool isRandomBooksEnabled) {
    _sp.setBool(_keyRandomBooksEnabled, isRandomBooksEnabled);
  }

  @override
  void setIsTrackingEnabled(bool isTrackingEnabled) {
    _sp.setBool(_keyTrackingEnabled, isTrackingEnabled);
  }

  @override
  void setSortingStrategy(BookSortStrategy strategy) {
    _sp.setInt(_keySortStrategy, strategy.index);
  }

  @override
  void setThemeMode(ThemeMode themeMode) {
    _themeModeSubject.add(themeMode);

    _sp.setInt(_keyThemeMode, themeMode.index);
  }

  @override
  Stream<ThemeMode> observeThemeMode() {
    return _themeModeSubject.stream;
  }
}