import 'package:dantex/models/backup_data.dart';
import 'package:dantex/providers/backup.dart';
import 'package:dantex/widgets/subtitle_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class BackupListCard extends ConsumerStatefulWidget {
  const BackupListCard({
    required this.backup,
    required this.onTap,
    this.onRemove,
    super.key,
  });

  final BackupData backup;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  @override
  ConsumerState<BackupListCard> createState() => _BackupListCardState();
}

class _BackupListCardState extends ConsumerState<BackupListCard> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: InkWell(
        key: ValueKey('backup_${widget.backup.id}_card'),
        borderRadius: BorderRadius.circular(8),
        onTap: widget.onTap,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                'assets/images/google_drive_logo.svg',
                width: 40,
              ),
              Column(
                children: [
                  Text(
                    DateFormat('dd MMM y - HH:mm')
                        .format(widget.backup.timeStamp),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SubtitleIcon(
                        icon: Icons.book_outlined,
                        subtitle: 'book_management.books_count'
                            .tr(args: [widget.backup.bookCount.toString()]),
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      SubtitleIcon(
                        icon: Icons.smartphone_outlined,
                        subtitle: widget.backup.device,
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                key: ValueKey('delete_backup_${widget.backup.id}_button'),
                onPressed: () async {
                  setState(() => _loading = true);
                  await ref.read(
                    deleteGoogleDriveBackupProvider(widget.backup.id).future,
                  );
                  widget.onRemove?.call();
                  setState(() => _loading = false);
                },
                icon: _loading
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
