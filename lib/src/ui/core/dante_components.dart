import 'package:flutter/material.dart';

Divider danteDivider(
  BuildContext context, {
  double width = 0.5,
}) {
  return Divider(
    thickness: width,
    color: Theme.of(context).dividerColor.withOpacity(0.5),
  );
}

TextField danteTextField(
  BuildContext context,
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
    cursorColor: Theme.of(context).colorScheme.primary,
    keyboardType: textInputType,
    textInputAction: textInputAction,
    maxLines: maxLines,
    onChanged: onChanged,
    decoration: InputDecoration(
      errorText: errorText,
      hintText: hint,
      suffixIcon: suffixIcon,
      errorStyle: TextStyle(
        color: Theme.of(context).colorScheme.error,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        fontWeight: FontWeight.w400,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: 2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: 2,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
    ),
  );
}

OutlinedButton danteOutlinedButton({
  required Widget child,
  required void Function()? onPressed,
  Key? key,
}) {
  return OutlinedButton(
    key: key,
    onPressed: onPressed,
    child: child,
  );
}
