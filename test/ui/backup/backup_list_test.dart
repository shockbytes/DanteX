import 'package:dantex/providers/backup.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/ui/backup/backup_list.dart';
import 'package:dantex/ui/backup/backup_list_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../test_utilities.dart';

void main() {
  // Disable EasyLocalization logs for tests
  EasyLocalization.logger.enableBuildModes = [];
  final backup = getMockBackupData();
  group('Given a BackupList widget', () {
    group('When there is a backup ini progress', () {
      patrolWidgetTest('Then the loading indicator is shown', ($) async {
        await $.pumpWidget(
          ProviderScope(
            overrides: [
              googleDriveBackupsProvider.overrideWith((ref) => [backup]),
            ],
            child: const MaterialApp(
              home: BackupList(),
            ),
          ),
        );

        final element = $.tester.element($(BackupList));
        final container = ProviderScope.containerOf(element);

        // Set the backup in progress notifier to true
        container.read(backupInProgressNotifierProvider.notifier).start();
        await $.pump();

        expect($(#backup_list_loading), findsOneWidget);
      });
    });
    group('When there are backups available', () {
      patrolWidgetTest('Then they are displayed', ($) async {
        await $.pumpWidget(
          ProviderScope(
            overrides: [
              googleDriveBackupsProvider.overrideWith((ref) => [backup]),
            ],
            child: const MaterialApp(
              home: BackupList(),
            ),
          ),
        );

        expect($(#backup_list_loading), findsNothing);
        expect($(BackupListCard), findsAtLeast(1));
      });
    });
  });
}
