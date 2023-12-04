import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:flutter/material.dart';

class StatsItemCard extends StatelessWidget {
  final String title;
  final Widget content;

  const StatsItemCard({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return DanteOutlinedCard(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(title),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }
}
