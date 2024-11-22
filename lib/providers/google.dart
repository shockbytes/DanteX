import 'package:dantex/data/google/backup_data.dart';
import 'package:dantex/data/repo/backup_repository.dart';
import 'package:dantex/providers/auth.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google.g.dart';

@riverpod
Future<BackupRepository> backupRepository(Ref ref) async {
  final googleSignIn = ref.watch(googleSignInProvider);
  await googleSignIn.signInSilently();

  final httpClient = await googleSignIn.authenticatedClient();
  if (httpClient == null) {
    throw Exception('Failed to get authenticated client');
  }

  final driveApi = DriveApi(httpClient);

  return BackupRepository(driveApi: driveApi);
}

@riverpod
Future<List<BackupData>> googleDriveBackups(Ref ref) async {
  final repository = await ref.watch(backupRepositoryProvider.future);
  return repository.listGoogleDriveBackups();
}
