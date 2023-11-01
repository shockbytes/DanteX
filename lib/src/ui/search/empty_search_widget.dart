import 'package:easy_localization/easy_localization.dart';
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
        Text('search.empty.description'.tr()),
        FilledButton.tonalIcon(
          onPressed: onOnlineSearch,
          label: Text('search.empty.action'.tr()),
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }
}
