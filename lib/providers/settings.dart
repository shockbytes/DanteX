import 'package:dantex/models/book_sort_strategy.dart';
import 'package:dantex/models/timeline.dart';
import 'package:dantex/providers/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings.g.dart';

@riverpod
class ThemeModeSetting extends _$ThemeModeSetting {
  @override
  ThemeMode build() => ref.watch(userSettingsRepositoryProvider).getThemeMode();

  Future<void> set(ThemeMode themeMode) async {
    await ref.read(userSettingsRepositoryProvider).setThemeMode(themeMode);
    state = themeMode;
  }
}

@riverpod
class ShowBookSummarySetting extends _$ShowBookSummarySetting {
  @override
  bool build() =>
      ref.watch(userSettingsRepositoryProvider).getShowBookSummary();

  Future<void> set({required bool showBookSummary}) async {
    await ref.read(userSettingsRepositoryProvider).setShowBookSummary(
          showBookSummary: showBookSummary,
        );
    state = showBookSummary;
  }
}

@riverpod
class BookSortStrategySetting extends _$BookSortStrategySetting {
  @override
  BookSortStrategy build() =>
      ref.watch(userSettingsRepositoryProvider).getSortStrategy();

  Future<void> set(BookSortStrategy bookSortStrategy) async {
    await ref.read(userSettingsRepositoryProvider).setSortStrategy(
          sortStrategy: bookSortStrategy,
        );
    state = bookSortStrategy;
  }
}

@riverpod
class RandomBooksEnabledSetting extends _$RandomBooksEnabledSetting {
  @override
  bool build() =>
      ref.watch(userSettingsRepositoryProvider).getRandomBooksEnabled();

  Future<void> set({required bool randomBooksEnabled}) async {
    await ref.read(userSettingsRepositoryProvider).setRandomBooksEnabled(
          randomBooksEnabled: randomBooksEnabled,
        );
    state = randomBooksEnabled;
  }
}

@riverpod
class UsageTrackingSetting extends _$UsageTrackingSetting {
  @override
  bool build() =>
      ref.watch(userSettingsRepositoryProvider).getTrackingEnabled();

  Future<void> set({required bool trackingEnabled}) async {
    await ref.read(userSettingsRepositoryProvider).setTrackingEnabled(
          trackingEnabled: trackingEnabled,
        );
    state = trackingEnabled;
  }
}

@riverpod
Future<String> appVersion(Ref ref) async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

@riverpod
class TimelineSortStrategySetting extends _$TimelineSortStrategySetting {
  @override
  TimelineSortStrategy build() =>
      ref.watch(userSettingsRepositoryProvider).getTimelineSortStrategy();

  Future<void> set(TimelineSortStrategy timelineSortStrategy) async {
    await ref.read(userSettingsRepositoryProvider).setTimelineSortStrategy(
          timelineSortStrategy: timelineSortStrategy,
        );
    state = timelineSortStrategy;
  }
}
