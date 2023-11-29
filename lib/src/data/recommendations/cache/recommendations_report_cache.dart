abstract class RecommendationsReportCache {
  Future<void> cacheRecommendationsReport(String recommendationId);

  Future<List<String>> loadReportedRecommendations();
}
