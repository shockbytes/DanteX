import 'package:flutter/material.dart';

class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? title;

  const ThemedAppBar({
    super.key,
    this.actions,
    this.leading,
    this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

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
    );
  }
}
