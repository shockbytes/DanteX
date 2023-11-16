import 'package:dantex/src/data/google_drive/entity/backup_data.dart';
import 'package:dantex/src/providers/google_drive.dart';
import 'package:dantex/src/ui/core/generic_error_widget.dart';
import 'package:dantex/src/ui/core/themed_app_bar.dart';
import 'package:dantex/src/ui/management/backup_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookManagementPage extends ConsumerWidget {
  const BookManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backUps = ref.watch(listGoogleDriveBackupsProvider);

    return Scaffold(
      appBar: ThemedAppBar(
        title: Text('book_management.title'.tr()),
      ),
      body: RestoreWidget(backUps),
    );
  }
}

class RestoreWidget extends ConsumerWidget {
  final AsyncValue<List<BackupData>> backUps;
  const RestoreWidget(this.backUps, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return backUps.when(
      data: (backupList) {
        return ListView.separated(
          padding: const EdgeInsets.all(16.0),
          physics: const BouncingScrollPhysics(),
          itemCount: backupList.length,
          itemBuilder: (context, index) => BackupItemWidget(backupList[index]),
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 16),
        );
      },
      error: (error, stackTrace) {
        return GenericErrorWidget(error);
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }
}
