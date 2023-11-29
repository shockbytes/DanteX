import 'package:dantex/src/data/recommendations/book_recommendation.dart';
import 'package:dantex/src/data/recommendations/recommendations.dart';
import 'package:dantex/src/providers/service.dart';
import 'package:dantex/src/ui/core/dante_loading_indicator.dart';
import 'package:dantex/src/ui/core/themed_app_bar.dart';
import 'package:dantex/src/ui/recommendations/recommendation_item_widget.dart';
import 'package:dantex/src/util/layout_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecommendationsPage extends ConsumerWidget {
  const RecommendationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Recommendations recommendations = ref.watch(recommendationsProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final DeviceFormFactor formFactor = getDeviceFormFactor(constraints);
        return Scaffold(
          appBar: formFactor == DeviceFormFactor.desktop
              ? null
              : ThemedAppBar(
                  title: Text('navigation.recommendations'.tr()),
                ),
          body: _buildBody(
            context,
            recommendations,
            formFactor,
          ),
          bottomNavigationBar: _buildNewRecommendationsHint(
            context,
            recommendations.newRecommendationsAvailableAt(),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    Recommendations recommendations,
    DeviceFormFactor formFactor,
  ) {
    return FutureBuilder<List<BookRecommendation>>(
      // ignore: discarded_futures
      future: recommendations.load(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<BookRecommendation> recommendedBooks = snapshot.data!;

          if (recommendedBooks.isEmpty) {
            return Expanded(
              child: Center(
                child: Text('recommendations.empty'.tr()),
              ),
            );
          }

          return switch (formFactor) {
            DeviceFormFactor.desktop => _buildLargeLayout(
                recommendedBooks,
                recommendations,
                columns: 3,
              ),
            DeviceFormFactor.tablet => _buildLargeLayout(
                recommendedBooks,
                recommendations,
                columns: 2,
              ),
            DeviceFormFactor.phone => _buildPhoneLayout(
                recommendedBooks,
                recommendations,
              ),
          };
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'recommendations.error'.tr(
                args: [snapshot.error!.toString()],
              ),
            ),
          );
        } else {
          return const Expanded(
            child: DanteLoadingIndicator(),
          );
        }
      },
    );
  }

  Widget _buildPhoneLayout(
    List<BookRecommendation> recommendedBooks,
    Recommendations recommendations,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      physics: const BouncingScrollPhysics(),
      itemCount: recommendedBooks.length,
      itemBuilder: (_, index) => RecommendationItemWidget(
        recommendedBooks[index],
        onAddToWishlist: recommendations.addToWishlist,
        onReportRecommendation: recommendations.reportRecommendation,
      ),
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 16),
    );
  }

  Widget _buildLargeLayout(
    List<BookRecommendation> recommendedBooks,
    Recommendations recommendations, {
    required int columns,
  }) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 2,
      ),
      itemBuilder: (_, index) => RecommendationItemWidget(
        recommendedBooks[index],
        onAddToWishlist: recommendations.addToWishlist,
        onReportRecommendation: recommendations.reportRecommendation,
      ),
      itemCount: recommendedBooks.length,
    );
  }

  Widget _buildNewRecommendationsHint(
    BuildContext context,
    DateTime newRecommendationsAvailableAt,
  ) {
    return Row(
      children: [
        Expanded(
          child: Card(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: SizedBox(
              height: 56,
              child: Center(
                child: Text(
                  'recommendations.new-banner'.tr(
                    args: [
                      DateFormat('dd. MMM yyyy')
                          .format(newRecommendationsAvailableAt),
                    ],
                  ),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
