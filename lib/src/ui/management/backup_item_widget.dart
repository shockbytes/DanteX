import 'dart:async';

import 'package:dantex/src/data/google_drive/entity/backup_data.dart';
import 'package:dantex/src/providers/google_drive.dart';
import 'package:dantex/src/providers/repository.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/platform_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackupItemWidget extends ConsumerWidget {
  final BackupData backupData;

  const BackupItemWidget(this.backupData, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async => _buildRestoreBackupDialog(context, ref),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: .2,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SvgPicture.asset(
                'assets/images/google_drive_logo.svg',
                width: 32.0,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    DateFormat('dd MMM y - HH:mm').format(backupData.timeStamp),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconSubtitle(
                        icon: Icons.book_outlined,
                        subtitle: '${backupData.bookCount} books',
                      ),
                      IconSubtitle(
                        icon: Icons.smartphone_outlined,
                        subtitle: backupData.device,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32),
              child: PopupMenuButton(
                onSelected: (item) async {
                  await ref
                      .read(googleDriveClientProvider)
                      .deleteBackup(backupData.id);
                  // Invalidate the list backups provider here so that we
                  // refetch the list of backups from Google Drive. We could
                  // achieve the same effect by watching for changes in the
                  // Google Drive state, but this is easier.
                  ref.invalidate(listGoogleDriveBackupsProvider);
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete_outlined,
                          color: Colors.red,
                        ),
                        Text('delete'.tr()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _buildRestoreBackupDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    return showDanteDialog(
      context,
      barrierDismissible: true,
      leading: const Icon(Icons.devices_other_outlined),
      title: 'book_management.restore_strategy'.tr(),
      content: Text('book_management.restore_detail'.tr()),
      actions: <DanteDialogAction>[
        DanteDialogAction(
          action: (_) async {
            unawaited(
              // Fetch the list of backups books.
              ref
                  .read(googleDriveClientProvider)
                  .fetchBackup(backupData.id)
                  // Then overwrite the existing books with the backup.
                  .then((books) {
                ref.read(bookRepositoryProvider).mergeBooks(books);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('book_management.merge_complete'.tr()),
                  ),
                );
              }),
            );

            // Close the dialog.
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          name: 'book_management.merge'.tr(),
          iconData: Icons.call_merge_outlined,
        ),
        DanteDialogAction(
          action: (_) async {
            unawaited(
              // Fetch the list of backups books.
              ref
                  .read(googleDriveClientProvider)
                  .fetchBackup(backupData.id)
                  // Then overwrite the existing books with the backup.
                  .then((books) {
                ref.read(bookRepositoryProvider).overwriteBooks(books);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('book_management.overwrite_complete'.tr()),
                  ),
                );
              }),
            );

            // Close the dialog.
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          name: 'book_management.overwrite'.tr(),
          isPrimary: false,
          iconData: Icons.content_copy_outlined,
        ),
      ],
    );
  }
}
