import 'package:dantex/models/book_sort_strategy.dart';
import 'package:dantex/repositories/user_settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});
  final sharedPreferences = await SharedPreferences.getInstance();
  group('Given a UserSettingsRepository', () {
    final userSettingsRepository = UserSettingsRepository(
      sharedPreferences: sharedPreferences,
    );
    group('When getting the ThemeMode', () {
      group('And no ThemeMode is set', () {
        test('Then the system ThemeMode is returned', () async {
          final themeMode = userSettingsRepository.getThemeMode();
          expect(themeMode, ThemeMode.system);
        });
      });
    });
    group('When setting the ThemeMode', () {
      test('Then the ThemeMode is set', () async {
        await userSettingsRepository.setThemeMode(ThemeMode.dark);
        final themeMode = userSettingsRepository.getThemeMode();
        expect(themeMode, ThemeMode.dark);
      });
    });
    group('When setting the ShowBookSummary', () {
      test('Then the ShowBookSummary is set', () async {
        await userSettingsRepository.setShowBookSummary(showBookSummary: false);
        final showBookSummary = userSettingsRepository.getShowBookSummary();
        expect(showBookSummary, false);
      });
    });
    group('When setting the TrackingEnabled', () {
      test('Then the TrackingEnabled is set', () async {
        await userSettingsRepository.setTrackingEnabled(trackingEnabled: false);
        final trackingEnabled = userSettingsRepository.getTrackingEnabled();
        expect(trackingEnabled, false);
      });
    });
    group('When setting the RandomBooksEnabled', () {
      test('Then the RandomBooksEnabled is set', () async {
        await userSettingsRepository.setRandomBooksEnabled(
          randomBooksEnabled: false,
        );
        final randomBooksEnabled =
            userSettingsRepository.getRandomBooksEnabled();
        expect(randomBooksEnabled, false);
      });
    });
    group('When getting the SortStrategy', () {
      group('And the sort strategy is not set', () {
        test('Then the position sort strategy is returned', () {
          final sortStrategy = userSettingsRepository.getSortStrategy();
          expect(sortStrategy, BookSortStrategy.position);
        });
      });
    });
    group('When setting the SortStrategy', () {
      test('Then the SortStrategy is set', () async {
        await userSettingsRepository.setSortStrategy(
          sortStrategy: BookSortStrategy.title,
        );
        final sortStrategy = userSettingsRepository.getSortStrategy();
        expect(sortStrategy, BookSortStrategy.title);
      });
    });
    group('When setting the TimeLineSortStrategy', () {
      test('Then the TimeLineSortStrategy is set', () async {
        await userSettingsRepository.setTimelineSortStrategy(
          timelineSortStrategy: 'timelineSortStrategy',
        );
        final timelineSortStrategy =
            userSettingsRepository.getTimelineSortStrategy();
        expect(timelineSortStrategy, 'timelineSortStrategy');
      });
    });
  });
}
