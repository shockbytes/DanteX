import 'dart:io';

import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/util/dante_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformDialogAction {
  final String name;
  final bool isPrimary;
  final Function(BuildContext context) action;

  PlatformDialogAction({
    required this.name,
    required this.action,
    this.isPrimary = true,
  });
}

class PlatformComponents {
  static Future showPlatformDialogCustom(
    BuildContext context, {
    required Widget content,
    List<PlatformDialogAction> actions = const [],
  }) {
    if (Platform.isIOS || Platform.isMacOS) {
      return _showAndBuildCupertinoDialog(
        context,
        content: content,
        actions: actions,
      );
    } else {
      return _showAndBuildMaterialDialog(
        context,
        content: content,
        actions: actions,
      );
    }
  }

  static Future showPlatformDialog(
    BuildContext context, {
    required String title,
    required String content,
    Widget? leading,
    List<PlatformDialogAction> actions = const [],
  }) {
    if (Platform.isIOS || Platform.isMacOS) {
      return _showAndBuildCupertinoDialog(
        context,
        title: _buildDialogTitle(title, leading),
        content: _buildDialogContent(content),
        actions: actions,
      );
    } else {
      return _showAndBuildMaterialDialog(
        context,
        title: _buildDialogTitle(title, leading),
        content: _buildDialogContent(content),
        actions: actions,
      );
    }
  }

  static Future showPlatformInputDialog(
    BuildContext context, {
    required String title,
    Widget? leading,
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
    TextInputAction textInputAction = TextInputAction.next,
    TextInputType textInputType = TextInputType.text,
    bool obscureText = false,
    List<PlatformDialogAction> actions = const [],
  }) {
    if (Platform.isIOS || Platform.isMacOS) {
      return _showAndBuildCupertinoDialog(
        context,
        title: _buildDialogTitle(title, leading),
        content: _buildCupertinoTextField(
          controller,
          obscureText: obscureText,
          hint: hint,
          maxLines: maxLines,
          textInputType: textInputType,
          textInputAction: textInputAction,
        ),
        actions: actions,
      );
    } else {
      return _showAndBuildMaterialDialog(
        context,
        title: _buildDialogTitle(title, leading),
        content: DanteComponents.textField(
          controller,
          obscureText: obscureText,
          hint: hint,
          maxLines: maxLines,
          textInputType: textInputType,
          textInputAction: textInputAction,
        ),
        actions: actions,
      );
    }
  }

  static Future _showAndBuildCupertinoDialog(
    BuildContext context, {
    Widget? title,
    required Widget content,
    required List<PlatformDialogAction> actions,
  }) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: title,
        content: content,
        actions: actions
            .map(
              (action) => _buildCupertinoActionButton(
                action.name,
                onPressed: () => action.action(context),
                isPrimary: action.isPrimary,
              ),
            )
            .toList(),
      ),
    );
  }

  static Future _showAndBuildMaterialDialog(
    BuildContext context, {
    Widget? title,
    required Widget content,
    required List<PlatformDialogAction> actions,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: title,
        content: content,
        actions: actions
            .map(
              (action) => _buildMaterialActionButton(
                action.name,
                onPressed: () => action.action(context),
                isPrimary: action.isPrimary,
              ),
            )
            .toList(),
      ),
    );
  }

  static Widget _buildDialogTitle(String title, Widget? leading) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        leading ?? const SizedBox.shrink(),
        Text(
          title,
          style: const TextStyle(
            color: DanteColors.textPrimary,
          ),
        ),
      ],
    );
  }

  static Text _buildDialogContent(String content) {
    return Text(
      content,
      style: const TextStyle(
        color: DanteColors.textPrimary,
      ),
    );
  }

  static Widget _buildCupertinoActionButton(
    String action, {
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Text(
        action,
        style: TextStyle(
          color: isPrimary ? DanteColors.accent : DanteColors.textPrimary,
        ),
      ),
    );
  }

  static Widget _buildMaterialActionButton(
    String action, {
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: isPrimary ? DanteColors.accent : DanteColors.white,
        backgroundColor: isPrimary ? DanteColors.accent : DanteColors.white,
      ),
      child: Text(
        action,
        style: TextStyle(
          color: isPrimary ? DanteColors.white : DanteColors.textPrimary,
        ),
      ),
    );
  }

  static Widget _buildCupertinoTextField(
    TextEditingController controller, {
    bool obscureText = false,
    String? hint,
    TextInputAction textInputAction = TextInputAction.next,
    TextInputType textInputType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: CupertinoTextField(
        controller: controller,
        obscureText: obscureText,
        cursorColor: DanteColors.accent,
        placeholder: hint,
        maxLines: maxLines,
        keyboardType: textInputType,
        textInputAction: textInputAction,
      ),
    );
  }
}
