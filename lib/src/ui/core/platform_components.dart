import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class DanteDialogAction {
  final String name;
  final bool isPrimary;
  final Function(BuildContext context) action;

  DanteDialogAction({
    required this.name,
    required this.action,
    this.isPrimary = true,
  });
}

Future<void> showDanteDialog(
  BuildContext context, {
  required String title,
  required String content,
  Widget? leading,
  List<DanteDialogAction> actions = const [],
}) {
  return showPlatformDialog(
    context: context,
    builder: (_) => PlatformAlertDialog(
      title: _buildDialogTitle(title, leading),
      content: Text(content),
      actions: actions
          .map(
            (action) => PlatformDialogAction(
              child: Text(
                action.name,
                style: TextStyle(
                  color: action.isPrimary
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              onPressed: () => action.action(context),
            ),
          )
          .toList(),
    ),
  );
}

Future showDanteInputDialog(
  BuildContext context, {
  required String title,
  required TextEditingController controller,
  Widget? leading,
  String? hint,
  int maxLines = 1,
  TextInputAction textInputAction = TextInputAction.next,
  TextInputType textInputType = TextInputType.text,
  bool obscureText = false,
  List<DanteDialogAction> actions = const [],
}) {
  return showPlatformDialog(
    context: context,
    builder: (_) => PlatformAlertDialog(
      title: _buildDialogTitle(title, leading),
      content: PlatformTextField(
        controller: controller,
        obscureText: obscureText,
        cursorColor: Theme.of(context).colorScheme.primary,
        hintText: hint,
        maxLines: maxLines,
        keyboardType: textInputType,
        textInputAction: textInputAction,
      ),
      actions: actions
          .map(
            (action) => PlatformDialogAction(
              child: Text(
                action.name,
                style: TextStyle(
                  color: action.isPrimary
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              onPressed: () => action.action(context),
            ),
          )
          .toList(),
    ),
  );
}

Widget _buildDialogTitle(String title, Widget? leading) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      leading ?? const SizedBox.shrink(),
      Text(title),
    ],
  );
}
