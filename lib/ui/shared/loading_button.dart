import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  const LoadingButton({
    required this.onPressed,
    required this.labelText,
    this.disabled = false,
    this.color,
    this.textColor,
    super.key,
  }) : icon = null;

  const LoadingButton.icon({
    required this.onPressed,
    required this.icon,
    required this.labelText,
    this.disabled = false,
    this.color,
    this.textColor,
    super.key,
  });

  final Future<void> Function() onPressed;
  final Widget? icon;
  final String labelText;
  final bool disabled;
  final Color? color;
  final Color? textColor;

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final icon = widget.icon;
    if (_isLoading) {
      return const OutlinedButton(
        onPressed: null,
        child: CircularProgressIndicator(),
      );
    }

    if (icon != null) {
      return OutlinedButton.icon(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(widget.color),
        ),
        key: ValueKey('loading_button_loading_${widget.labelText}'),
        onPressed: widget.disabled ? null : _runFuture,
        label: Text(
          widget.labelText,
          style: TextStyle(color: widget.textColor),
        ),
        icon: icon,
      );
    }

    return FilledButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(widget.color),
      ),
      key: ValueKey('loading_button_${widget.labelText}'),
      onPressed: widget.disabled ? null : _runFuture,
      child: Text(widget.labelText, style: TextStyle(color: widget.textColor)),
    );
  }

  Future<void> _runFuture() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await widget.onPressed();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
