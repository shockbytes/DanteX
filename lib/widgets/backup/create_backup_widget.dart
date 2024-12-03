import 'package:dantex/logger/event.dart';
import 'package:dantex/providers/backup.dart';
import 'package:dantex/providers/logger.dart';
import 'package:dantex/widgets/shared/dante_loading_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class CreateBackupWidget extends ConsumerStatefulWidget {
  const CreateBackupWidget({this.onCreateBackup, super.key});

  final VoidCallback? onCreateBackup;

  @override
  ConsumerState<CreateBackupWidget> createState() => _CreateBackupWidgetState();
}

class _CreateBackupWidgetState extends ConsumerState<CreateBackupWidget> {
  bool _googleBackupInProgress = false;

  @override
  Widget build(BuildContext context) {
    final mostRecentBackup = ref.watch(mostRecentBackupProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        mostRecentBackup.when(
          data: (backup) {
            if (backup == null) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                key: const Key('last_backup'),
                'book_management.last_backup'.tr(
                  args: [
                    DateFormat('dd MMM y - HH:mm').format(
                      backup.timeStamp,
                    ),
                  ],
                ),
              ),
            );
          },
          error: (e, s) {
            ref.read(loggerProvider).e(
                  'Failed to get most recent backup',
                  error: e,
                  stackTrace: s,
                );
            return const SizedBox.shrink();
          },
          loading: () => const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: const Text('book_management.backup_info').tr(),
        ),
        const SizedBox(height: 16),
        Card.outlined(
          child: _googleBackupInProgress
              ? SizedBox(
                  height: 148,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const DanteLoadingIndicator(
                          key: ValueKey('google_drive_backup_in_progress'),
                        ),
                        const SizedBox(height: 16),
                        const Text('book_management.creating').tr(),
                      ],
                    ),
                  ),
                )
              : InkWell(
                  key: const Key('create_google_drive_backup'),
                  borderRadius: BorderRadius.circular(8),
                  onTap: _createGoogleDriveBackup,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/google_drive_logo.svg',
                              width: 24,
                            ),
                            const SizedBox(width: 16),
                            const Text('book_management.google_drive').tr(),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text('book_management.google_drive_backup_info')
                            .tr(),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Future<void> _createGoogleDriveBackup() async {
    setState(() => _googleBackupInProgress = true);
    final logger = ref.read(loggerProvider);
    await ref.read(createGoogleDriveBackupProvider.future);
    logger.trackEvent(
      DanteEvent.backupCreated,
      data: {
        'source': 'google_drive',
      },
    );
    widget.onCreateBackup?.call();
    setState(() => _googleBackupInProgress = false);
  }
}
