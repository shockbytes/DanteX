import 'package:dantex/logger/event.dart';
import 'package:dantex/models/book_recommendation.dart';
import 'package:dantex/models/book_state.dart';
import 'package:dantex/providers/repository.dart';
import 'package:dantex/providers/service.dart';
import 'package:dantex/ui/recommendations/report_recommendation_dialog.dart';
import 'package:dantex/ui/shared/book_image.dart';
import 'package:dantex/ui/shared/user_avatar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecommendationListCard extends ConsumerWidget {
  const RecommendationListCard({required this.recommendation, super.key});

  final BookRecommendation recommendation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                BookImage(recommendation.suggestion.thumbnailAddress, size: 48),
                const SizedBox(width: 16),
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
                    Icons.report_outlined,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                children: [
                  const WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(Icons.format_quote_outlined, size: 16),
                  ),
                  TextSpan(text: ' ${recommendation.recommendation} '),
                  const WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(Icons.format_quote_outlined, size: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('- ${recommendation.suggester.name}'),
                const SizedBox(width: 8),
                ExternalUserAvatar(
                  imageUrl: recommendation.suggester.picture,
                ),
              ],
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () async {
                await ref.read(bookRepositoryProvider).addBook(
                      recommendation.suggestion.toBook.copyWith(
                        state: BookState.wishlist,
                      ),
                    );
                ref
                    .read(loggerProvider)
                    .trackEvent(DanteEvent.addSuggestionToWishlist);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          const Text('recommendations.added_to_wishlist').tr(
                        args: [
                          recommendation.suggestion.title,
                        ],
                      ),
                    ),
                  );
                }
              },
              child: const Text('recommendations.add_to_wishlist').tr(),
            ),
          ],
        ),
      ),
    );
  }
}
