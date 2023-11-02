import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:flutter/material.dart';

class ProfileRowItem extends StatelessWidget {
  final Text label;
  final DanteOutlinedButton button;

  const ProfileRowItem({
    required this.label,
    required this.button,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        label,
        const SizedBox(
          width: 10,
        ),
        button,
      ],
    );
  }
}
