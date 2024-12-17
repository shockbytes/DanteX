import 'package:dantex/models/book_recommendation.dart';
import 'package:dantex/ui/recommendations/report_recommendation_dialog.dart';
import 'package:dantex/ui/shared/book_image.dart';
import 'package:flutter/material.dart';

class RecommendationListCard extends StatelessWidget {
  const RecommendationListCard({required this.recommendation, super.key});

  final BookRecommendation recommendation;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BookImage(recommendation.suggestion.thumbnailAddress, size: 48),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recommendation.suggestion.title,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        recommendation.suggestion.author,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async => showDialog(
                    context: context,
                    builder: (context) => ReportRecommendationDialog(
                      recommendation: recommendation,
                    ),
                  ),
                  icon: Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
            Text(recommendation.recommendation),
          ],
        ),
      ),
    );
  }
}
