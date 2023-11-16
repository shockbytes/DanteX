import 'package:flutter/material.dart';

class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? title;
  final PreferredSizeWidget? bottom;

  const ThemedAppBar({
    super.key,
    this.actions,
    this.leading,
    this.title,
    this.bottom,
  });

  @override
  Size get preferredSize {
    // If we have a bottom widget, for example a tab bar as part of the app bar
    // we need to add the height of the bottom widget to the app bar height.
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: actions,
      backgroundColor: Theme.of(context).colorScheme.background,
      // Disable coloring of action bar on scroll
      surfaceTintColor: Theme.of(context).colorScheme.background,
      scrolledUnderElevation: 4,
      shadowColor: Theme.of(context).colorScheme.onBackground,
      centerTitle: true,
      elevation: 0,
      leading: leading,
      title: title,
      bottom: bottom,
    );
  }
}
