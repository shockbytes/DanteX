

import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/recommendations/book_recommendation.dart';

abstract class RecommendationsRepository {

  DateTime dateForNewRecommendations();

  Future<List<BookRecommendation>> loadRecommendations();

  Future<void> reportRecommendation(String recommendationId);

  Future<List<String>> getReportedRecommendations();

  Future<void> recommendBook(Book book, String recommendation);

}