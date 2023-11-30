import 'package:dantex/src/data/recommendations/book_recommendation.dart';
import 'package:dantex/src/data/recommendations/recommendations.dart';
import 'package:dantex/src/providers/service.dart';
import 'package:dantex/src/ui/core/dante_loading_indicator.dart';
import 'package:dantex/src/ui/core/generic_error_widget.dart';
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
    final Recommendations recommendations = ref.read(recommendationsProvider);

    ref.watch(bookRecommendationEventsProvider).whenData(
          (event) => _handleEvent(context, event),
        );

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
            formFactor,
            ref,
          ),
          bottomNavigationBar: _buildNewRecommendationsHint(
            context,
            recommendations.newRecommendationsAvailableAt(),
            formFactor,
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    DeviceFormFactor formFactor,
    WidgetRef ref,
  ) {
    return ref.watch(bookRecommendationsProvider).when(
          data: (recommendedBooks) {
            if (recommendedBooks.isEmpty) {
              return Center(
                child: Text(
                  'recommendations.empty'.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              );
            }

            return switch (formFactor) {
              DeviceFormFactor.desktop => _buildLargeLayout(
                  recommendedBooks,
                  ref,
                  columns: 3,
                ),
              DeviceFormFactor.tablet => _buildLargeLayout(
                  recommendedBooks,
                  ref,
                  columns: 2,
                ),
              DeviceFormFactor.phone => _buildPhoneLayout(
                  recommendedBooks,
                  ref,
                ),
            };
          },
          error: (error, stackTrace) => GenericErrorWidget(error),
          loading: () => const DanteLoadingIndicator(),
        );
  }

  Widget _buildPhoneLayout(
    List<BookRecommendation> recommendedBooks,
    WidgetRef ref,
  ) {
    final Recommendations recommendations = ref.read(recommendationsProvider);
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      physics: const BouncingScrollPhysics(),
      itemCount: recommendedBooks.length,
      itemBuilder: (_, index) => RecommendationItemWidget(
        recommendedBooks[index],
        withHeight: 300,
        onAddToWishlist: recommendations.addToWishlist,
        onReportRecommendation: recommendations.reportRecommendation,
      ),
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 16),
    );
  }

  Widget _buildLargeLayout(
    List<BookRecommendation> recommendedBooks,
    WidgetRef ref, {
    required int columns,
  }) {
    final Recommendations recommendations = ref.read(recommendationsProvider);

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
    DeviceFormFactor formFactor,
  ) {
    final double height = formFactor == DeviceFormFactor.desktop ? 56 : 84;
    return Row(
      children: [
        Expanded(
          child: Card(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: SizedBox(
              height: height,
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

  void _handleEvent(BuildContext context, RecommendationEvent event) {
    // Hide current banner first.
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

    switch (event) {
      case MoveToWishlistEvent():
        _showBanner(
          context,
          text: 'recommendations.events.move-to-wishlist.title'.tr(
            args: [event.title],
          ),
        );
        break;
      case ReportRecommendationEvent():
        _showBanner(
          context,
          text: 'recommendations.events.report.title'.tr(
            args: [event.title],
          ),
        );
        break;
    }
  }

  void _showBanner(
    BuildContext context, {
    required String text,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        content: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}
