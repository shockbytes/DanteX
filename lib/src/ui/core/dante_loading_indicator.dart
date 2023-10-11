import 'package:flutter/material.dart';

class DanteLoadingIndicator extends StatelessWidget {
  const DanteLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}
