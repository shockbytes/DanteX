import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieView extends StatelessWidget {
  final String lottieAsset;
  final String text;

  const LottieView({
    required this.lottieAsset,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset(lottieAsset),
          Text(
            text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
