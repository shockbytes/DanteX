import 'package:flutter/material.dart';

class SubtitleIcon extends StatelessWidget {
  const SubtitleIcon({
    required this.icon,
    required this.subtitle,
    required this.size,
    this.iconColor,
    super.key,
  });

  final IconData icon;
  final Color? iconColor;
  final String subtitle;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: size,
          color: iconColor,
        ),
        const SizedBox(height: 4),
        Text(subtitle),
      ],
    );
  }
}
