import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({required this.title, super.key});

  final Text title;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      children: [
        const Expanded(child: Divider()),
        title,
        const Expanded(child: Divider()),
      ],
    );
  }
}
