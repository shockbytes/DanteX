import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_recommendation.dart';
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

  Map<String, dynamic> get _headers => {
        'Authorization': 'Bearer $_authToken',
        'Access-Control-Allow-Origin': '*',
      };
}
