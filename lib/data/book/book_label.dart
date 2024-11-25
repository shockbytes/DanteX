import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_label.freezed.dart';
part 'book_label.g.dart';

@freezed
class BookLabel with _$BookLabel {
  const factory BookLabel({
    required String id,
    required String title,
    required String hexColor,
  }) = _BookLabel;

  const BookLabel._();

  factory BookLabel.fromJson(Map<String, dynamic> json) =>
      _$BookLabelFromJson(json);

  Color get color {
    final color = hexColor.replaceAll('#', '');
    return Color(int.parse(color, radix: 16));
  }
}
