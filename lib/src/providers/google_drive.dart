import 'package:dantex/src/data/google_drive/backup_client.dart';
import 'package:dantex/src/data/google_drive/entity/backup_data.dart';
import 'package:dantex/src/data/google_drive/google_drive_client.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google_drive.g.dart';

@riverpod
BackupClient googleDriveClient(GoogleDriveClientRef ref) =>
    GoogleDriveClient(googleSignIn: ref.watch(googleSignInProvider));

@riverpod
Future<List<BackupData>> listGoogleDriveBackups(
  ListGoogleDriveBackupsRef ref,
) async {
  return ref.read(googleDriveClientProvider).listBackups();
}

@riverpod
Future<void> deleteBackup(DeleteBackupRef ref, String id) async {
  await ref.read(googleDriveClientProvider).deleteBackup(id);
}
