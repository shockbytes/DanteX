import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmptySearchWidget extends ConsumerWidget {
  final VoidCallback onOnlineSearch;

  const EmptySearchWidget({
    required this.onOnlineSearch,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // TODO Translate
        Text('Nothing found, wanna search online?'),
        FilledButton.tonalIcon(
          onPressed: onOnlineSearch,
          label: Text('Search online'),
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }
}
