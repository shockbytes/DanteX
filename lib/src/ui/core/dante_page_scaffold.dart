import 'package:dantex/src/providers/app_router.dart';
import 'package:dantex/src/ui/core/dante_app_bar.dart';
import 'package:dantex/src/util/layout_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DantePageScaffold extends StatefulWidget {
  final Widget content;

  const DantePageScaffold({
    required this.content,
    super.key,
  });

  @override
  State<DantePageScaffold> createState() => _DantePageScaffoldState();
}

class _DantePageScaffoldState extends State<DantePageScaffold> {

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isDesktop(constraints)) {
          return _buildDesktopView(context);
        } else {
          return _buildMobileView(context);
        }
      },
    );
  }

  Widget _buildDesktopView(BuildContext context) {
    return Row(
      children: [
        _buildNavigationRail(context),
        const VerticalDivider(
          thickness: 1,
          width: 1,
        ),
        Expanded(
          child: widget.content,
        ),
      ],
    );
  }

  Widget _buildNavigationRail(BuildContext context) {
    return SizedBox(
      width: 160,
      child: NavigationRail(
        leading: const UserTag(useMobileLayout: false),
        useIndicator: true,
        onDestinationSelected: _onDestinationSelected,
        labelType: NavigationRailLabelType.all,
        destinations: [
          NavigationRailDestination(
            icon: const Icon(Icons.book_outlined),
            selectedIcon: const Icon(Icons.book),
            label: Text('navigation.library'.tr()),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.pie_chart_outline),
            selectedIcon: const Icon(Icons.pie_chart),
            label: Text('navigation.stats'.tr()),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.linear_scale_outlined),
            selectedIcon: const Icon(Icons.linear_scale),
            label: Text('navigation.timeline'.tr()),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.article_outlined),
            selectedIcon: const Icon(Icons.article),
            label: Text('navigation.wishlist'.tr()),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.whatshot_outlined),
            selectedIcon: const Icon(Icons.whatshot),
            label: Text('navigation.recommendations'.tr()),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.all_inbox_outlined),
            selectedIcon: const Icon(Icons.all_inbox),
            label: Text('navigation.book-keeping'.tr()),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: Text('navigation.settings'.tr()),
          ),
        ],
        selectedIndex: _selectedIndex,
      ),
    );
  }

  // For mobile, we are not using a dedicated layout
  Widget _buildMobileView(BuildContext context) {
    return widget.content;
  }

  void _onDestinationSelected(int destinationIndex) {

    final DanteRoute? route = switch (destinationIndex) {
      0 => DanteRoute.dashboard,
      // TODO Add other routes
      6 => DanteRoute.settings,
      int() => null,
    };

    if (route != null) {
      context.go(route.navigationUrl);
    }

    setState(() {
      _selectedIndex = destinationIndex;
    });
  }
}
