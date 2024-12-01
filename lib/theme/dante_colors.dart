import 'package:flutter/material.dart';

class DanteColors extends ThemeExtension<DanteColors> {
  const DanteColors({
    required this.forLaterColor,
    required this.readingColor,
    required this.readColor,
    required this.wishlistColor,
  });

  final Color? forLaterColor;
  final Color? readingColor;
  final Color? readColor;
  final Color? wishlistColor;

  @override
  DanteColors copyWith({
    Color? forLaterColor,
    Color? readingColor,
    Color? readColor,
    Color? wishlistColor,
  }) {
    return DanteColors(
      forLaterColor: forLaterColor ?? this.forLaterColor,
      readingColor: readingColor ?? this.readingColor,
      readColor: readColor ?? this.readColor,
      wishlistColor: wishlistColor ?? this.wishlistColor,
    );
  }

  @override
  DanteColors lerp(DanteColors? other, double t) {
    if (other is! DanteColors) {
      return this;
    }
    return DanteColors(
      forLaterColor: Color.lerp(forLaterColor, other.forLaterColor, t),
      readingColor: Color.lerp(readingColor, other.readingColor, t),
      readColor: Color.lerp(readColor, other.readColor, t),
      wishlistColor: Color.lerp(wishlistColor, other.wishlistColor, t),
    );
  }

  // Optional
  @override
  String toString() =>
      'DanteColors(forLaterColor: $forLaterColor, readingColor: $readingColor, '
      'readColor: $readColor, wishlistColor: $wishlistColor)';
}
