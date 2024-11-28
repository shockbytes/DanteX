import 'package:dantex/providers/backup.dart';
import 'package:dantex/widgets/backup/create_backup.dart';
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

  group('Given a CreateBackup widget', () {
    group('When there is no most recent backup', () {
      patrolWidgetTest('Then no backup information is shown', ($) async {
        await $.pumpWidget(
          ProviderScope(
            overrides: [
              mostRecentBackupProvider.overrideWith((ref) => null),
            ],
            child: const MaterialApp(
              home: CreateBackup(),
            ),
          ),
        );

        expect($(#last_backup), findsNothing);
      });
    });
    group('When there is a recent backup', () {
      patrolWidgetTest('Then the backup information is shown', ($) async {
        await $.pumpWidget(
          ProviderScope(
            overrides: [
              mostRecentBackupProvider.overrideWith((ref) => backup),
            ],
            child: const MaterialApp(
              home: CreateBackup(),
            ),
          ),
        );

        expect($(#last_backup), findsOneWidget);
      });
    });
    group('When the google drive backup card is pressed', () {
      patrolWidgetTest('Then the loading indicator is shown', ($) async {
        await $.pumpWidget(
          ProviderScope(
            overrides: [
              mostRecentBackupProvider.overrideWith((ref) => backup),
            ],
            child: const MaterialApp(
              home: CreateBackup(),
            ),
          ),
        );

        await $(#create_google_drive_backup).tap();
        expect($(#google_drive_backup_in_progress), findsOneWidget);
      });
      patrolWidgetTest('Then the onCreateBackup is called', ($) async {
        var backupCreated = false;
        await $.pumpWidget(
          ProviderScope(
            overrides: [
              mostRecentBackupProvider.overrideWith((ref) => backup),
              createGoogleDriveBackupProvider.overrideWith((ref) {}),
            ],
            child: MaterialApp(
              home: CreateBackup(
                onCreateBackup: () {
                  backupCreated = true;
                },
              ),
            ),
          ),
        );

        await $(#create_google_drive_backup).tap();
        expect(backupCreated, isTrue);
      });
    });
  });
}
