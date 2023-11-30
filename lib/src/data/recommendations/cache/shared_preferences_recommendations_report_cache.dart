import 'package:dantex/src/data/recommendations/cache/recommendations_report_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRecommendationsReportCache
    implements RecommendationsReportCache {
  final SharedPreferences _sp;

  final String _key = 'reported_recommendations_cache_key';

  SharedPreferencesRecommendationsReportCache(this._sp);

  @override
  Future<void> cacheRecommendationsReport(String recommendationId) async {
    final List<String> reportedRecommendations =
        await loadReportedRecommendations();

    if (reportedRecommendations.contains(recommendationId)) {
      return;
    }

    reportedRecommendations.add(recommendationId);

    await _sp.setStringList(_key, reportedRecommendations);
  }

  @override
  Future<List<String>> loadReportedRecommendations() async {
    return _sp.getStringList(_key) ?? [];
  }
}
