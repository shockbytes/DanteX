import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DanteDivider extends StatelessWidget {
  final double width;

  const DanteDivider({this.width = 0.5, super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: width,
      color: Theme.of(context).dividerColor.withOpacity(0.5),
    );
  }
}

class DanteTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final String? initialValue;
  final String? hint;
  final Widget? suffixIcon;
  final Widget? label;
  final bool? enabled;
  final void Function(String)? onChanged;
  final int maxLines;
  final String? errorText;
  final TextInputFormatter? formatter;
  final Widget? Function(
    BuildContext context, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  })? buildCounter;
  final int? maxLength;

  const DanteTextField({
    required this.controller,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines = 1,
    this.obscureText = false,
    super.key,
    this.initialValue,
    this.hint,
    this.suffixIcon,
    this.enabled,
    this.onChanged,
    this.errorText,
    this.formatter,
    this.label,
    this.buildCounter,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    if (initialValue != null) {
      controller.text = initialValue ?? '';
    }

    return TextField(
      enabled: enabled,
      controller: controller,
      obscureText: obscureText,
      cursorColor: Theme.of(context).colorScheme.primary,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      inputFormatters: [if (formatter != null) formatter!],
      buildCounter: buildCounter,
      decoration: InputDecoration(
        label: label,
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
}

class DanteOutlinedButton extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;

  const DanteOutlinedButton({required this.child, super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      key: key,
      onPressed: onPressed,
      child: child,
    );
  }
}

class DanteOutlinedCard extends StatelessWidget {
  final Widget child;

  const DanteOutlinedCard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: 0.5,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: child,
    );
  }
}

class IconSubtitle extends StatelessWidget {
  final IconData icon;
  final String subtitle;

  const IconSubtitle({required this.icon, required this.subtitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon),
        Text(subtitle),
      ],
    );
  }
}
