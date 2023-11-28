import 'package:dantex/src/ui/core/themed_app_bar.dart';
import 'package:dantex/src/ui/recommendations/recommendation_item_widget.dart';
import 'package:dantex/src/util/layout_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RecommendationsPage extends StatelessWidget {
  const RecommendationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final DeviceFormFactor formFactor = getDeviceFormFactor(constraints);
        return Scaffold(
          appBar: formFactor == DeviceFormFactor.desktop
              ? null
              : ThemedAppBar(
                  title: Text('navigation.recommendations'.tr()),
                ),
          body: _buildBody(formFactor),
        );
      },
    );
  }

  Widget _buildBody(DeviceFormFactor formFactor) {
    return switch (formFactor) {
      DeviceFormFactor.desktop => _buildLargeLayout(columns: 3),
      DeviceFormFactor.tablet => _buildLargeLayout(columns: 2),
      DeviceFormFactor.phone => _buildPhoneLayout(),
    };
  }

  Widget _buildPhoneLayout() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      physics: const BouncingScrollPhysics(),
      itemCount: 10,
      // TODO Change
      itemBuilder: (context, index) => RecommendationItemWidget(),
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 16),
    );
  }

  Widget _buildLargeLayout({
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
      itemBuilder: (context, index) => RecommendationItemWidget(),
      itemCount: 10, // TODO Change
    );
  }
}
