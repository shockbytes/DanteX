import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup_data.freezed.dart';

@freezed
class BackupData with _$BackupData {
  const factory BackupData({
    required String id,
    required String device,
    required String fileName,
    required int bookCount,
    required DateTime timeStamp,
    required bool isLegacyBackup,
  }) = _BackupData;
}
