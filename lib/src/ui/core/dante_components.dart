import 'package:dantex/src/util/dante_colors.dart';
import 'package:flutter/material.dart';

class DanteComponents {
  DanteComponents._();

  static Divider divider({Color color = DanteColors.grey, double width = 2.0}) {
    return Divider(
      thickness: width,
      color: color,
    );
  }

  static TextField textField(TextEditingController controller, {
    bool obscureText = false,
    TextInputAction textInputAction = TextInputAction.next,
    TextInputType textInputType = TextInputType.text,
    String? initialValue,
    String? hint,
    Widget? suffixIcon,
    bool? enabled,
    int maxLines = 1,
  }) {
    if (initialValue != null) {
      controller.text = initialValue;
    }

    return TextField(
      enabled: enabled,
      controller: controller,
      obscureText: obscureText,
      cursorColor: DanteColors.accent,
      cursorWidth: 2,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffixIcon,
        hintStyle: TextStyle(
          color: DanteColors.textPrimary.withOpacity(0.5),
          fontWeight: FontWeight.w400,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(
            color: DanteColors.accent,
            width: 2,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(
            color: DanteColors.grey,
            width: 2,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(
            color: DanteColors.accent,
            width: 2,
          ),
        ),
      ),
    );
  }
}