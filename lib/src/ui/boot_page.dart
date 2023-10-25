import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BootPage extends ConsumerWidget {
  const BootPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo/ic-launcher.jpg',
            width: 96,
            height: 96,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: const LinearProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
