import 'package:flutter/widgets.dart';
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
    return Column(
      children: [
        LottieBuilder.asset(lottieAsset),
        Text(text),
      ],
    );
  }
}
