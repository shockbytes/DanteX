import 'package:dantex/providers/statistics.dart';
import 'package:dantex/util/date_time.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtherStats extends ConsumerWidget {
  const OtherStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mostActiveMonth = ref.watch(mostActiveMonthStatProvider);
    final averageBooksPerMonth = ref.watch(averageBooksPerMonthProvider);
    final averageRating = ref.watch(averageRatingStatProvider);

    if (averageRating == null &&
        mostActiveMonth == null &&
        averageBooksPerMonth == 0) {
      return Center(child: const Text('statistics.misc.empty').tr());
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (averageBooksPerMonth != 0) ...[
              Column(
                children: [
                  Text(
                    averageBooksPerMonth.toStringAsPrecision(2),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Text('statistics.misc.average_books.description').tr(),
                ],
              ),
              const SizedBox(width: 16),
            ],
            if (mostActiveMonth != null) ...[
              Column(
                children: [
                  Text(
                    mostActiveMonth.count.toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Text('statistics.misc.most_read_month.description').tr(
                    args: [
                      mostActiveMonth.month.formatWithMonthAndYearShort(),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        if (averageRating != null) ...[
          const Text('statistics.misc.average_rating.title').tr(),
          const SizedBox(height: 16),
          RatingBar.builder(
            initialRating: averageRating,
            minRating: 1,
            allowHalfRating: true,
            ignoreGestures: true,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Theme.of(context).colorScheme.primary,
            ),
            onRatingUpdate: (_) {},
          ),
          const SizedBox(height: 16),
          const Text('statistics.misc.average_rating.rating')
              .tr(args: [averageRating.toStringAsPrecision(2)]),
        ],
      ],
    );
  }
}
