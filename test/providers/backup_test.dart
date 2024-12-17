import 'package:dantex/providers/backup.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/repositories/backup_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_utilities.dart';
import '../ui/backup/backup_list_card_test.mocks.dart';

@GenerateMocks([BackupRepository])
void main() {
  group('Given a googleDriveBackupsProvider', () {
    group('When there are google drive backups', () {
      test('Then they are returned', () async {
        final mockBackupRepository = MockBackupRepository();
        final mockBackup = getMockBackupData();
        when(mockBackupRepository.listGoogleDriveBackups())
            .thenAnswer((_) async => [mockBackup]);

        final container = createContainer(
          overrides: [
            backupRepositoryProvider
                .overrideWith((ref) => mockBackupRepository),
          ],
        );

        final backups = await container.read(googleDriveBackupsProvider.future);
        expect(backups, isNotEmpty);
      });
    });
  });
  group('Given a deleteGoogleDriveBackupProvider', () {
    group('When deleting a backup', () {
      test('Then the backup is deleted', () async {
        final mockBackupRepository = MockBackupRepository();
        final mockBackup = getMockBackupData();
        when(mockBackupRepository.delete(mockBackup.id))
            .thenAnswer((_) async {});

        final container = createContainer(
          overrides: [
            backupRepositoryProvider
                .overrideWith((ref) => mockBackupRepository),
          ],
        );

        await container
            .read(deleteGoogleDriveBackupProvider(mockBackup.id).future);
        verify(mockBackupRepository.delete(mockBackup.id)).called(1);
      });
    });
  });
  group('Given a mostRecentBackupProvider', () {
    group('When there are multiple backups', () {
      test('Then the most recent backup is returned', () async {
        final now = DateTime.now();
        final mockBackupRepository = MockBackupRepository();
        final mockBackup1 =
            getMockBackupData(timeStamp: now.subtract(const Duration(days: 1)));
        final mockBackup2 = getMockBackupData(timeStamp: now);
        when(mockBackupRepository.listGoogleDriveBackups())
            .thenAnswer((_) async => [mockBackup1, mockBackup2]);

        final container = createContainer(
          overrides: [
            backupRepositoryProvider
                .overrideWith((ref) => mockBackupRepository),
          ],
        );

        final backup = await container.read(mostRecentBackupProvider.future);
        expect(backup, equals(mockBackup2));
      });
    });
    group('When there are no backups', () {
      test('Then nothing is returned', () async {
        final mockBackupRepository = MockBackupRepository();
        when(mockBackupRepository.listGoogleDriveBackups())
            .thenAnswer((_) async => []);

        final container = createContainer(
          overrides: [
            backupRepositoryProvider
                .overrideWith((ref) => mockBackupRepository),
          ],
        );

        final backup = await container.read(mostRecentBackupProvider.future);
        expect(backup, isNull);
      });
    });
  });
  group('Given a createGoogleDriveBackupProvider', () {
    group('When creating a backup', () {
      test('Then the backup is created', () async {
        final mockBackupRepository = MockBackupRepository();
        final mockBooks = [getMockBook()];

        final container = createContainer(
          overrides: [
            backupRepositoryProvider
                .overrideWith((ref) => mockBackupRepository),
            allBooksProvider.overrideWith((ref) => Stream.value(mockBooks)),
          ],
        );

        await container.read(createGoogleDriveBackupProvider.future);
        verify(mockBackupRepository.createBackup(mockBooks)).called(1);
      });
    });
  });
}
