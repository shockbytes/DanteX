import 'package:collection/collection.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/recommendations/book_recommendation.dart';
import 'package:dantex/src/data/recommendations/recommendations_repository.dart';

class Recommendations {
  final RecommendationsRepository _repository;

  Recommendations(this._repository);

  DateTime newRecommendationsAvailableAt() =>
      _repository.dateForNewRecommendations();

  Future<List<BookRecommendation>> load() async {
    final List<BookRecommendation> recommendations =
        await _repository.loadRecommendations();
    final List<String> reportedRecommendations =
        await _repository.getReportedRecommendations();

    return recommendations
        .whereNot(
          (element) =>
              reportedRecommendations.contains(element.recommendationId),
        )
        .toList();
  }

  Future<void> reportRecommendation(String recommendationId) {
    return _repository.reportRecommendation(recommendationId);
  }

  Future<void> recommendBook(Book book, String recommendation) {
    return _repository.recommendBook(book, recommendation);
  }
}
