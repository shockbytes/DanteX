import 'package:dantex/models/book_recommendation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommendations_response.freezed.dart';
part 'recommendations_response.g.dart';

@freezed
class RecommendationsResponse with _$RecommendationsResponse {
  const factory RecommendationsResponse({
    required List<BookRecommendation> suggestions,
  }) = _RecommendationsResponse;

  factory RecommendationsResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendationsResponseFromJson(json);
}
