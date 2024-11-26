import 'package:dantex/providers/google.dart';
import 'package:dantex/providers/logger.dart';
import 'package:dantex/widgets/pulsing_grid.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class CreateBackup extends ConsumerStatefulWidget {
  const CreateBackup({this.onCreateBackup, super.key});

  final VoidCallback? onCreateBackup;

  @override
  ConsumerState<CreateBackup> createState() => _CreateBackupState();
}

class _CreateBackupState extends ConsumerState<CreateBackup> {
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
                'last_backup'.tr(
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
        Card.outlined(
          child: _googleBackupInProgress
              ? const SizedBox(
                  height: 148,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PulsingGrid(),
                        SizedBox(height: 16),
                        Text('Creating backup...'),
                      ],
                    ),
                  ),
                )
              : InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () async {
                    setState(() => _googleBackupInProgress = true);
                    await ref.read(createGoogleDriveBackupProvider.future);
                    widget.onCreateBackup?.call();
                    setState(() => _googleBackupInProgress = false);
                  },
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
                            Text('google_drive'.tr()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text('google_drive_backup_info'.tr()),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
