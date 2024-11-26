import 'package:dantex/models/backup_data.dart';
import 'package:dantex/providers/google.dart';
import 'package:dantex/repositories/backup_repository.dart';
import 'package:dantex/widgets/backup_list_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'backup_list_card_test.mocks.dart';

@GenerateMocks([BackupRepository])
void main() {
  // Disable EasyLocalization logs for tests
  EasyLocalization.logger.enableBuildModes = [];

  group('Given a BackupListCard widget', () {
    group('When tapping on the delete button', () {
      patrolWidgetTest('Then the backup is deleted', ($) async {
        final backup = BackupData(
          id: 'id',
          device: 'device',
          fileName: 'fileName',
          bookCount: 10,
          timeStamp: DateTime.now(),
        );

        final mockBackupRepository = MockBackupRepository();
        when(mockBackupRepository.delete(backup.id)).thenAnswer((_) async {});

        await $.pumpWidget(
          ProviderScope(
            overrides: [
              backupRepositoryProvider
                  .overrideWith((ref) => mockBackupRepository),
            ],
            child: MaterialApp(
              home: BackupListCard(backup: backup, onTap: () {}),
            ),
          ),
        );

        await $(ValueKey('delete_backup_${backup.id}_button')).tap();
        verify(mockBackupRepository.delete(backup.id)).called(1);
      });
    });
    group('When tapping on the card', () {
      patrolWidgetTest('Then onTap is called', ($) async {
        final backup = BackupData(
          id: 'id',
          device: 'device',
          fileName: 'fileName',
          bookCount: 10,
          timeStamp: DateTime.now(),
        );

        var onTapCalled = false;
        await $.pumpWidget(
          MaterialApp(
            home: BackupListCard(
              backup: backup,
              onTap: () {
                onTapCalled = true;
              },
            ),
          ),
        );

        await $(ValueKey('backup_${backup.id}_card')).tap();
        expect(onTapCalled, isTrue);
      });
    });
  });
}
