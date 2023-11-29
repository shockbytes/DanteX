import 'package:dantex/src/data/recommendations/book_recommendation.dart';
import 'package:dantex/src/ui/book/book_image.dart';
import 'package:dantex/src/ui/core/user_avatar.dart';
import 'package:flutter/material.dart';

class RecommendationItemWidget extends StatelessWidget {

  final BookRecommendation _recommendation;

  const RecommendationItemWidget(this._recommendation, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                BookImage(_recommendation.book.thumbnailAddress, size: 48),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_recommendation.book.title),
                      const SizedBox(height: 4),
                      Text(_recommendation.book.author),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // TODO Callback for reporting
                  },
                  icon: Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
            const Spacer(),
            FractionallySizedBox(
              widthFactor: 0.9,
              child: Row(
                children: [
                  const Icon(Icons.format_quote_outlined),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(_recommendation.recommendation),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.format_quote_outlined),
                ],
              ),
            ),
            const SizedBox(height: 8),
            FractionallySizedBox(
              widthFactor: 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('- ${_recommendation.recommender.name}'),
                  const SizedBox(width: 8),
                  UserAvatar(userImageUrl: _recommendation.recommender.picture),
                ],
              ),
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () {
                // TODO Add to wishlist
              },
              child: Text(
                'Zur Wunschliste hinzufügen',
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
