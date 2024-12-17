import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DanteLoadingIndicator extends StatelessWidget {
  const DanteLoadingIndicator({super.key});

  @override
  Widget build(Object context) {
    return SpinKitPulsingGrid(
      itemBuilder: (context, index) {
        final color = Color.lerp(
          Colors.pink,
          Colors.deepPurpleAccent,
          index / 9,
        );
        return DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
    );
  }
}
