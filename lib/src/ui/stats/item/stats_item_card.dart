import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:flutter/material.dart';

class StatsItemCard extends StatelessWidget {
  final String title;
  final Widget content;

  const StatsItemCard({
    required this.title,
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DanteOutlinedCard(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }
}
