import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/recommendations/api/recommendations_api.dart';
import 'package:dantex/src/data/recommendations/book_recommendation.dart';
import 'package:dantex/src/data/recommendations/cache/recommendations_cache.dart';
import 'package:dantex/src/data/recommendations/cache/recommendations_report_cache.dart';
import 'package:dantex/src/data/recommendations/recommendations_repository.dart';

class DefaultRecommendationsRepository implements RecommendationsRepository {
  final RecommendationsApi _api;
  final RecommendationsCache _cache;
  final RecommendationsReportCache _reportCache;

  DefaultRecommendationsRepository(this._api, this._cache, this._reportCache);

  @override
  DateTime dateForNewRecommendations() {
    return _cache.cacheValidUntil();
  }

  @override
  Future<List<String>> getReportedRecommendations() {
    return _reportCache.loadReportedRecommendations();
  }

  @override
  Future<List<BookRecommendation>> loadRecommendations() async {
    final List<BookRecommendation>? cachedRecommendations = await _cache.get();

    if (cachedRecommendations != null) {
      return cachedRecommendations;
    }

    final List<BookRecommendation> recommendations =
        await _api.loadRecommendations();

    // TODO Enable caching later...
    // await _cache.put(recommendations);

    return recommendations;
  }

  @override
  Future<void> recommendBook(Book book, String recommendation) {
    return _api.recommendBook(
      RecommendationRequest(
        recommendation,
        RecommendedBook.fromBook(book),
      ),
    );
  }

  @override
  Future<void> reportRecommendation(String recommendationId) {
    return _api.reportRecommendation(recommendationId).then(
          (value) => _reportCache.cacheRecommendationsReport(recommendationId),
        );
  }
}
