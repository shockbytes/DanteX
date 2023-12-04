import 'package:dantex/src/data/stats/stats_item.dart';
import 'package:dantex/src/providers/service.dart';
import 'package:dantex/src/ui/core/dante_loading_indicator.dart';
import 'package:dantex/src/ui/core/generic_error_widget.dart';
import 'package:dantex/src/ui/core/themed_app_bar.dart';
import 'package:dantex/src/ui/stats/item/stats_item_widget_resolver.dart';
import 'package:dantex/src/util/layout_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final DeviceFormFactor formFactor = getDeviceFormFactor(constraints);
        return Scaffold(
          appBar: formFactor == DeviceFormFactor.desktop
              ? null
              : ThemedAppBar(
                  title: Text('navigation.stats'.tr()),
                ),
          body: _buildBody(
            ref,
            context,
            formFactor,
          ),
        );
      },
    );
  }

  Widget _buildBody(
    WidgetRef ref,
    BuildContext context,
    DeviceFormFactor formFactor,
  ) {
    return ref.watch(statsBuilderItemsProvider).when(
          data: (List<StatsItem> items) {
            return switch (formFactor) {
              DeviceFormFactor.desktop => _buildDesktopView(items),
              DeviceFormFactor.tablet => _buildMobileView(items),
              DeviceFormFactor.phone => _buildMobileView(items),
            };
          },
          error: (error, stackTrace) => GenericErrorWidget(error),
          loading: () => const DanteLoadingIndicator(),
        );
  }

  Widget _buildDesktopView(List<StatsItem> items) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.custom(
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          repeatPattern: QuiltedGridRepeatPattern.inverted,
          pattern: items
              .map(
                (e) => QuiltedGridTile(
                  e.desktopSize.height,
                  e.desktopSize.width,
                ),
              )
              .toList(),
        ),
        childrenDelegate: SliverChildBuilderDelegate(
          childCount: items.length,
          (context, index) => StatsItemWidgetResolver.resolveItem(
            items[index],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileView(List<StatsItem> items) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) => StatsItemWidgetResolver.resolveItem(
        items[index],
      ),
    );
  }
}
