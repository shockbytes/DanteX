import 'package:dantex/src/data/recommendations/api/recommendations_api.dart';
import 'package:dantex/src/data/recommendations/api/recommendations_response.dart';
import 'package:dantex/src/data/recommendations/book_recommendation.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRecommendationsApi implements RecommendationsApi {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: _baseUrl),
  );

  static const _baseUrl =
      'https://us-central1-dante-166506.cloudfunctions.net/app/';

  final FirebaseAuth _fbAuth;

  FirebaseRecommendationsApi(this._fbAuth);

  @override
  Future<List<BookRecommendation>> loadRecommendations() async {
    try {

      final headers = await _buildHeaders();
      final Response response = await _dio.get(
        '/suggestions',
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Unable to load suggestions from server: ${response.statusMessage}',
        );
      }

      return RecommendationsResponse.fromJson(response.data).recommendations;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> reportRecommendation(String recommendationId) async {
    await _dio.post(
      '/suggestions/$recommendationId/report',
      options: Options(
        headers: await _buildHeaders(),
      ),
    );
  }

  @override
  Future<void> recommendBook(RecommendationRequest request) async {
    final Response response = await _dio.post(
      '/suggestions',
      data: request.toJson(),
      options: Options(
        headers: await _buildHeaders(),
      ),
    );
  }

  Future<Map<String, dynamic>> _buildHeaders() async {

    final String? token = await _fbAuth.currentUser?.getIdToken();

    return {
      'Authorization': 'Bearer $token',
      'Access-Control-Allow-Origin': '*',
    };
  }
}
