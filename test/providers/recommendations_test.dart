import 'package:dantex/models/book_recommendation.dart';
import 'package:dantex/providers/recommendations.dart';
import 'package:dantex/providers/repository.dart';
import 'package:dantex/repositories/recommendations_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_utilities.dart';
import 'recommendations_test.mocks.dart';

@GenerateMocks([RecommendationsRepository])
void main() async {
  group('Given a recommendationsProvider', () {
    group('When the repo has recommendations', () {
      test('Then the provider returns all recommendations', () async {
        final mockRepository = MockRecommendationsRepository();
        when(mockRepository.loadRecommendations()).thenAnswer(
          (_) async => List.generate(
            3,
            (index) => BookRecommendation(
              suggestionId: 'suggestion$index',
              suggester: BookRecommender(name: 'Suggester $index'),
              suggestion: RecommendedBook(
                title: 'Title $index',
                subTitle: 'SubTitle $index',
                author: 'Author $index',
                state: 'State $index',
                pageCount: 100 + index,
                publishedDate: DateTime.now().toString(),
                isbn: 'ISBN $index',
                language: 'Language $index',
              ),
              recommendation: 'Recommendation $index',
            ),
          ),
        );

        final container = createContainer(
          overrides: [
            recommendationsRepositoryProvider
                .overrideWith((ref) => mockRepository),
          ],
        );

        final subscription = container.listen(
          recommendationsProvider.future,
          (_, __) {},
        );
        await container.pump();

        final recommendations = await subscription.read();
        expect(recommendations, hasLength(3));
      });
    });
  });
}
