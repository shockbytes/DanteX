import 'package:dantex/src/util/dante_colors.dart';
import 'package:flutter/material.dart';

class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Widget? leading;
  final Widget? title;
  final ShapeBorder? border;
  final Color? shadowColor;
  final double elevation;

  const ThemedAppBar({
    Key? key,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.backgroundColor = DanteColors.background,
    this.leading,
    this.title,
    this.border,
    this.shadowColor,
    this.elevation = 0.0,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor ?? DanteColors.background,
      centerTitle: true,
      elevation: elevation,
      leading: leading,
      title: title,
      shape: border,
      shadowColor: shadowColor,
    );
  }
}
