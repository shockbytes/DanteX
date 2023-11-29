import 'package:dantex/src/data/recommendations/book_recommendation.dart';

abstract class RecommendationsCache {

  Future<List<BookRecommendation>?> get();

  Future<void> put(List<BookRecommendation> content);

  DateTime cacheValidUntil();
}
