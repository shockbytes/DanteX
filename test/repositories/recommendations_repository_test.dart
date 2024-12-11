import 'package:dantex/repositories/recommendations_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '../test_utilities.dart';

void main() async {
  final mockRecommendationsClient = Dio(BaseOptions());
  final dioAdapter = DioAdapter(dio: mockRecommendationsClient);
  const mockAuthToken = 'mock-auth-token';
  const recommendation = 'mock-recommendation';
  final book = getMockBook();

  final recommendationsRepository = RecommendationsRepository(
    authToken: mockAuthToken,
    client: mockRecommendationsClient,
  );
  group('Given a RecommendationsRepository', () {
    group('When recommending a book', () {
      test('Then every succeeds', () {
        dioAdapter.onPost(
          '/suggestions',
          data: Matchers.any,
          (server) => server.reply(200, null),
        );

        expect(
          recommendationsRepository.recommendBook(book, recommendation),
          completes,
        );
      });
    });
  });
}
