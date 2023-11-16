import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/google_drive/entity/backup_data.dart';

abstract class BackupClient {
  Future<List<BackupData>> listBackups();
  Future<void> deleteBackup(String id);
  Future<List<Book>> fetchBackup(String id);
}
