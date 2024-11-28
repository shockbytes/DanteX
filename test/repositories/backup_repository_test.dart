import 'package:dantex/repositories/backup_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_utilities.dart';
import 'backup_repository_test.mocks.dart';

@GenerateMocks([
  DriveApi,
  FilesResource,
])
void main() {
  final mockDriveApi = MockDriveApi();
  final mockFilesResource = MockFilesResource();
  when(mockDriveApi.files).thenReturn(mockFilesResource);
  group('Given a backup repository', () {
    final backupRepository = BackupRepository(driveApi: mockDriveApi);
    group('When calling listing backups', () {
      group('And the driveApi response is empty', () {
        test('Then no books are returned', () async {
          when(
            mockFilesResource.list(
              spaces: 'appDataFolder',
              q: "mimeType = 'application/json'",
            ),
          ).thenAnswer((_) async => FileList());
          final result = await backupRepository.listGoogleDriveBackups();
          expect(result, isEmpty);
        });
      });
      group('And the driveApi response is not empty', () {
        test('Then the backup data is returned', () async {
          when(
            mockFilesResource.list(
              spaces: 'appDataFolder',
              q: "mimeType = 'application/json'",
            ),
          ).thenAnswer(
            (_) async => FileList(
              files: [
                File(
                  id: 'id',
                  name: 'google-drive_man_1654506876202_59_SM-A325F.json',
                  kind: 'drive#file',
                  mimeType: 'application/json',
                ),
              ],
            ),
          );
          final result = await backupRepository.listGoogleDriveBackups();
          expect(result, isNotEmpty);
          expect(result.first.bookCount, 59);
          expect(result.first.device, 'SM-A325F');
        });
      });
    });
    group('When fetching a backup', () {
      group('And the response is not a Media type', () {
        test('Then an empty list is returned', () async {
          when(
            mockFilesResource.get(
              any,
              downloadOptions: anyNamed('downloadOptions'),
            ),
          ).thenAnswer((_) async => File());
          final result = await backupRepository.fetchBackup('id');
          expect(result, isEmpty);
        });
      });
      group('And the response is a Media type', () {
        test('Then the books are returned', () async {
          final (:stream, :length) = getLegacyBookStream();
          when(
            mockFilesResource.get(
              any,
              downloadOptions: anyNamed('downloadOptions'),
            ),
          ).thenAnswer((_) async => Media(stream, length));
          final result = await backupRepository.fetchBackup('id');
          expect(result, isNotEmpty);
        });
      });
    });
    group('When deleting a backup', () {
      test('Then the backup is deleted', () async {
        when(
          mockFilesResource.delete('id'),
        ).thenAnswer((_) async => null);
        await backupRepository.delete('id');
        verify(mockFilesResource.delete('id')).called(1);
      });
    });
  });
}
