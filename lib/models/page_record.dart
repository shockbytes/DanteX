import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_record.freezed.dart';
part 'page_record.g.dart';

@freezed
class PageRecord with _$PageRecord {
  const factory PageRecord({
    required String bookId,
    required int fromPage,
    required int toPage,
    required DateTime timestamp,
  }) = _PageRecord;

  factory PageRecord.fromJson(Map<String, dynamic> json) =>
      _$PageRecordFromJson(json);
}
