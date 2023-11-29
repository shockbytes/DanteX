import 'package:dantex/src/data/recommendations/book_recommendation.dart';

class RecommendationsResponse {
  final List<BookRecommendation> recommendations;

  RecommendationsResponse(this.recommendations);

  static RecommendationsResponse fromJson(dynamic json) {
    final List<BookRecommendation> recommendations = [];
    json['suggestions'].forEach((element) {
      recommendations.add(BookRecommendation.fromJson(element));
    });

    return RecommendationsResponse(recommendations);
  }
}
