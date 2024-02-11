import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class DanteDialogAction {
  final String name;
  final bool isPrimary;
  final Function(BuildContext context) action;
  final IconData? iconData;

  DanteDialogAction({
    required this.name,
    required this.action,
    this.isPrimary = true,
    this.iconData,
  });
}

Future<void> showDanteDialog(
  BuildContext context, {
  required String title,
  required Widget content,
  Widget? leading,
  Widget? trailing,
  List<DanteDialogAction> actions = const [],
  bool barrierDismissible = false,
}) {
  return showPlatformDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (_) => PlatformAlertDialog(
      title: _buildDialogTitle(title, leading, trailing),
      content: content,
      actions: actions
          .map(
            (action) => PlatformDialogAction(
              onPressed: () => action.action(context),
              child: Column(
                children: [
                  Visibility(
                    child: Icon(
                      action.iconData,
                      color: action.isPrimary
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    action.name,
                    style: TextStyle(
                      color: action.isPrimary
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
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
  Widget? trailing,
  String? hint,
  int maxLines = 1,
  TextInputAction textInputAction = TextInputAction.next,
  TextInputType textInputType = TextInputType.text,
  bool obscureText = false,
  List<DanteDialogAction> actions = const [],
}) {
  return showPlatformDialog(
    context: context,
    useRootNavigator: false,
    builder: (_) => PlatformAlertDialog(
      title: _buildDialogTitle(title, leading, trailing),
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
              onPressed: () {
                Navigator.of(context).pop();
                action.action(context);
              },
            ),
          )
          .toList(),
    ),
  );
}

Widget _buildDialogTitle(String title, Widget? leading, Widget? trailing) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      leading ?? const SizedBox.shrink(),
      const SizedBox(width: 8),
      Expanded(
        child: Text(title),
      ),
      trailing ?? const SizedBox.shrink(),
    ],
  );
}
