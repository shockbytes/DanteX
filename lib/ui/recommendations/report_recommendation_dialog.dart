import 'package:dantex/models/book_recommendation.dart';
import 'package:dantex/providers/repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportRecommendationDialog extends ConsumerWidget {
  const ReportRecommendationDialog({required this.recommendation, super.key});

  final BookRecommendation recommendation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('recommendations.report_dialog_title').tr(),
      content: const Text('recommendations.report_dialog_description')
          .tr(args: [recommendation.suggestion.title]),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('recommendations.cancel').tr(),
        ),
        OutlinedButton(
          onPressed: () async {
            await ref
                .read(recommendationsRepositoryProvider)
                .reportRecommendation(recommendation.suggestionId);
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: const Text('recommendations.report').tr(),
        ),
      ],
    );
  }
}
