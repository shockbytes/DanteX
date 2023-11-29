import 'package:dantex/src/data/recommendations/cache/recommendations_cache.dart';
import 'package:dantex/src/data/recommendations/cache/recommendations_report_cache.dart';
import 'package:dantex/src/data/recommendations/cache/shared_preferences_recommendations_cache.dart';
import 'package:dantex/src/data/recommendations/cache/shared_preferences_recommendations_report_cache.dart';
import 'package:dantex/src/providers/service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cache.g.dart';

@riverpod
RecommendationsCache recommendationsCache(RecommendationsCacheRef ref) =>
    SharedPreferencesRecommendationsCache(
      ref.watch(sharedPreferencesProvider),
      ref.watch(loggerProvider),
      ttl: const Duration(days: 7),
    );

@riverpod
RecommendationsReportCache recommendationsReportCache(RecommendationsReportCacheRef ref) =>
    SharedPreferencesRecommendationsReportCache(
      ref.watch(sharedPreferencesProvider),
    );
