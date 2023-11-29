import 'package:dantex/src/data/recommendations/book_recommendation.dart';
import 'package:dantex/src/ui/book/book_image.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/user_avatar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RecommendationItemWidget extends StatelessWidget {
  final BookRecommendation _recommendation;

  final Function(String recommendationId) onReportRecommendation;
  final Function(BookRecommendation recommendation) onAddToWishlist;

  const RecommendationItemWidget(
    this._recommendation, {
    required this.onReportRecommendation,
    required this.onAddToWishlist,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DanteOutlinedCard(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                BookImage(_recommendation.book.thumbnailAddress, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _recommendation.book.title,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _recommendation.book.author,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // TODO Show dialog first
                    onReportRecommendation(_recommendation.recommendationId);
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
                    child: Text(
                      _recommendation.recommendation,
                      maxLines: 4,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
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
                  Text(
                    '- ${_recommendation.recommender.name}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  const SizedBox(width: 8),
                  UserAvatar(userImageUrl: _recommendation.recommender.picture),
                ],
              ),
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () {
                onAddToWishlist(_recommendation);
              },
              child: Text(
                'recommendations.add-to-wishlist'.tr(),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
