import 'package:dantex/providers/google.dart';
import 'package:dantex/repositories/backup_repository.dart';
import 'package:dantex/widgets/backup/backup_list_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../test_utilities.dart';
import 'backup_list_card_test.mocks.dart';

@GenerateMocks([BackupRepository])
void main() {
  // Disable EasyLocalization logs for tests
  EasyLocalization.logger.enableBuildModes = [];
  final backup = getMockBackupData();

  group('Given a BackupListCard widget', () {
    group('When tapping on the delete button', () {
      patrolWidgetTest('Then the backup is deleted', ($) async {
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
