import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_recommendation.dart';
import 'package:dantex/models/recommendations_response.dart';
import 'package:dio/dio.dart';

class RecommendationsRepository {
  const RecommendationsRepository({
    required String? authToken,
    required Dio client,
  })  : _authToken = authToken,
        _client = client;

  final String? _authToken;
  final Dio _client;

  Future<void> recommendBook(Book book, String recommendation) async {
    final request = RecommendationRequest(
      recommendation: recommendation,
      suggestion: RecommendedBook.fromBook(book),
    );

    await _client.post<void>(
      '/suggestions',
      data: request.toJson(),
      options: Options(
        headers: _headers,
      ),
    );
  }

  Future<List<BookRecommendation>> loadRecommendations() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/suggestions',
      options: Options(
        headers: _headers,
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Unable to load suggestions from server: ${response.statusMessage}',
      );
    }

    final data = response.data;
    if (data == null) {
      return [];
    }

    return RecommendationsResponse.fromJson(data).suggestions;
  }

  Future<void> reportRecommendation(String recommendationId) async {
    await _client.post<void>(
      '/suggestions/$recommendationId/report',
      options: Options(
        headers: _headers,
      ),
    );
  }

  Map<String, dynamic> get _headers => {
        'Authorization': 'Bearer $_authToken',
        'Access-Control-Allow-Origin': '*',
      };
}
