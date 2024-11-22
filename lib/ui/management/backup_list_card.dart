import 'package:dantex/data/google/backup_data.dart';
import 'package:dantex/ui/core/list_card.dart';
import 'package:dantex/ui/core/subtitle_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class BackupListCard extends ConsumerWidget {
  const BackupListCard({required this.backup, required this.onTap, super.key});

  final BackupData backup;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListCard(
      onTap: onTap,
      leading: SvgPicture.asset(
        'assets/images/google_drive_logo.svg',
        width: 40,
      ),
      body: Column(
        children: [
          Text(
            DateFormat('dd MMM y - HH:mm').format(backup.timeStamp),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SubtitleIcon(
                icon: Icons.book_outlined,
                subtitle: 'books_count'.tr(args: [backup.bookCount.toString()]),
                size: 24,
              ),
              SubtitleIcon(
                icon: Icons.smartphone_outlined,
                subtitle: backup.device,
                size: 24,
              ),
            ],
          ),
        ],
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.delete_outline, size: 32),
      ),
    );
  }
}
