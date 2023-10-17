

import 'package:dantex/src/data/book/book_sort_strategy.dart';
import 'package:flutter/material.dart';

abstract class SettingsRepository {

  void setThemeMode(ThemeMode mode);
  ThemeMode getThemeMode();
  Stream<ThemeMode> observeThemeMode();

  void setSortingStrategy(BookSortStrategy strategy);
  BookSortStrategy getSortingStrategy();

  void setIsTrackingEnabled(bool isTrackingEnabled);
  bool isTrackingEnabled();

  void setIsRandomBooksEnabled(bool isRandomBooksEnabled);
  bool isRandomBooksEnabled();
}