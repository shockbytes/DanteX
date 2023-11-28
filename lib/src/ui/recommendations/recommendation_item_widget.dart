import 'package:dantex/src/ui/book/book_image.dart';
import 'package:flutter/material.dart';

class RecommendationItemWidget extends StatelessWidget {
  const RecommendationItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const BookImage(null, size: 48),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Title'),
                      SizedBox(height: 4),
                      Text('Author'),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const FractionallySizedBox(
              widthFactor: 0.9,
              child: Row(
                children: [
                  Icon(Icons.format_quote_outlined),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'This is one of the best books I have ever read. Every page is truly inspiring and amazing! This is one of the best books I have ever read. Every page is truly inspiring and amazing!',
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.format_quote_outlined),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const FractionallySizedBox(
              widthFactor: 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('- Martin Macheiner'),
                  SizedBox(width: 8),
                  Icon(Icons.account_circle_outlined),
                ],
              ),
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () {},
              child: Text(
                'Zur Wunschliste hinzufügen',
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
