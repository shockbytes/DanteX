import 'package:dantex/providers/recommendations.dart';
import 'package:dantex/providers/service.dart';
import 'package:dantex/ui/recommendations/recommendation_list_card.dart';
import 'package:dantex/ui/shared/dante_loading_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecommendationsList extends ConsumerWidget {
  const RecommendationsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationsList = ref.watch(recommendationsProvider);
    return RefreshIndicator(
      onRefresh: () async => ref.refresh(recommendationsProvider.future),
      child: recommendationsList.when(
        data: (recommendations) {
          return ListView.builder(
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final recommendation = recommendations[index];
              return RecommendationListCard(recommendation: recommendation);
            },
          );
        },
        error: (e, s) {
          ref
              .read(loggerProvider)
              .e('Error loading recommendations', error: e, stackTrace: s);
          return Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(child: const Text('recommendations.not_found').tr()),
              ],
            ),
          );
        },
        loading: DanteLoadingIndicator.new,
      ),
    );
  }
}
