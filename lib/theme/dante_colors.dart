import 'package:flutter/material.dart';

class DanteColors extends ThemeExtension<DanteColors> {
  const DanteColors({
    required this.forLaterColor,
    required this.readingColor,
    required this.readColor,
    required this.wishlistColor,
    required this.shareColor,
    required this.suggestColor,
    required this.editColor,
    required this.deleteColor,
  });

  const DanteColors.lightTheme()
      : this(
          forLaterColor: Colors.green,
          readingColor: Colors.lightBlue,
          readColor: Colors.orange,
          wishlistColor: Colors.purple,
          shareColor: Colors.blue,
          suggestColor: Colors.pink,
          editColor: Colors.grey,
          deleteColor: Colors.red,
        );

  const DanteColors.darkTheme()
      : this(
          forLaterColor: Colors.green,
          readingColor: Colors.lightBlue,
          readColor: Colors.orange,
          wishlistColor: Colors.purple,
          shareColor: Colors.blue,
          suggestColor: Colors.pink,
          editColor: Colors.grey,
          deleteColor: Colors.red,
        );

  final Color? forLaterColor;
  final Color? readingColor;
  final Color? readColor;
  final Color? wishlistColor;
  final Color? shareColor;
  final Color? suggestColor;
  final Color? editColor;
  final Color? deleteColor;

  @override
  DanteColors copyWith({
    Color? forLaterColor,
    Color? readingColor,
    Color? readColor,
    Color? wishlistColor,
    Color? shareColor,
    Color? suggestColor,
    Color? editColor,
    Color? deleteColor,
  }) {
    return DanteColors(
      forLaterColor: forLaterColor ?? this.forLaterColor,
      readingColor: readingColor ?? this.readingColor,
      readColor: readColor ?? this.readColor,
      wishlistColor: wishlistColor ?? this.wishlistColor,
      shareColor: shareColor ?? this.shareColor,
      suggestColor: suggestColor ?? this.suggestColor,
      editColor: editColor ?? this.editColor,
      deleteColor: deleteColor ?? this.deleteColor,
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
      shareColor: Color.lerp(shareColor, other.shareColor, t),
      suggestColor: Color.lerp(suggestColor, other.suggestColor, t),
      editColor: Color.lerp(editColor, other.editColor, t),
      deleteColor: Color.lerp(deleteColor, other.deleteColor, t),
    );
  }

  // Optional
  @override
  String toString() =>
      'DanteColors(forLaterColor: $forLaterColor, readingColor: $readingColor, '
      'readColor: $readColor, wishlistColor: $wishlistColor, shareColor: $shareColor, '
      'suggestColor: $suggestColor, editColor: $editColor, deleteColor: $deleteColor)';
}
