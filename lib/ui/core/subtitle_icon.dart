import 'package:flutter/material.dart';

class SubtitleIcon extends StatelessWidget {
  const SubtitleIcon({
    required this.icon,
    required this.subtitle,
    required this.size,
    super.key,
  });

  final IconData icon;
  final String subtitle;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: size),
        const SizedBox(height: 4),
        Text(subtitle),
      ],
    );
  }
}
