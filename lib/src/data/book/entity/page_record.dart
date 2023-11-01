import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_record.freezed.dart';
part 'page_record.g.dart';

@freezed
class PageRecord with _$PageRecord {

  const PageRecord._();

  const factory PageRecord({
    required String id,
    required String bookId,
    required int fromPage,
    required int toPage,
    required DateTime dateTime,
  }) = _PageRecord;

  int get diffPages => toPage - fromPage;

  factory PageRecord.fromJson(Map<String, Object?> json) =>
      _$PageRecordFromJson(json);
}
