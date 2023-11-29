import 'package:dantex/src/data/recommendations/book_recommendation.dart';

abstract class RecommendationsApi {
  Future<List<BookRecommendation>> loadRecommendations();

  Future<void> reportRecommendation(String recommendationId);

  Future<void> recommendBook(RecommendationRequest request);
}
