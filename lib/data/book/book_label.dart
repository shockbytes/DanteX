import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_label.freezed.dart';
part 'book_label.g.dart';

@freezed
class BookLabel with _$BookLabel {
  const factory BookLabel({
    required String id,
    required String title,

    /// This field is required to ensure backwards compatibility with already
    /// existing backups. Callers use now [labelHexColor] of type [HexColor]
    /// instead of working with the raw string.
    required String hexColor,
  }) = _BookLabel;

  factory BookLabel.fromJson(Map<String, dynamic> json) =>
      _$BookLabelFromJson(json);
}
