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
            // TODO Use form Factor for building a gridview?
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) =>
                  StatsItemWidgetResolver.resolveItem(
                items[index],
              ),
            );
          },
          error: (error, stackTrace) => GenericErrorWidget(error),
          loading: () => const DanteLoadingIndicator(),
        );
  }
}
