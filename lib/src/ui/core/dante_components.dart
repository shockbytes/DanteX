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

  static TextField textField(
    TextEditingController controller, {
    bool obscureText = false,
    TextInputAction textInputAction = TextInputAction.next,
    TextInputType textInputType = TextInputType.text,
    String? initialValue,
    String? hint,
    Widget? suffixIcon,
    bool? enabled,
    void Function(String)? onChanged,
    int maxLines = 1,
    String? errorText,
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
      onChanged: onChanged,
      decoration: InputDecoration(
        errorText: errorText,
        hintText: hint,
        suffixIcon: suffixIcon,
        errorStyle: const TextStyle(
          color: DanteColors.textError,
          fontWeight: FontWeight.w400,
        ),
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
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(
            color: DanteColors.textError,
            width: 2,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(
            color: DanteColors.textError,
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

  static OutlinedButton outlinedButton({
    Key? key,
    required Widget child,
    required void Function()? onPressed,
  }) {
    return OutlinedButton(
      key: key,
      onPressed: onPressed,
      child: child,
    );
  }
}
