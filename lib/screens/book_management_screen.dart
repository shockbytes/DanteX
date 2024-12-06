import 'package:dantex/widgets/backup/backup_list.dart';
import 'package:dantex/widgets/backup/create_backup_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookManagementScreen extends ConsumerStatefulWidget {
  const BookManagementScreen({super.key});

  static String get routeName => 'management';
  static String get routeLocation => '/management';

  @override
  ConsumerState<BookManagementScreen> createState() =>
      _BookManagementScreenState();
}

class _BookManagementScreenState extends ConsumerState<BookManagementScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('book_management.title').tr(),
        bottom: TabBar(
          controller: _tabController,
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          tabs: [
            Tab(text: 'book_management.backup'.tr()),
            Tab(text: 'book_management.restore'.tr()),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TabBarView(
            controller: _tabController,
            children: [
              CreateBackupWidget(
                onCreateBackup: () => _tabController.animateTo(1),
              ),
              const BackupList(),
            ],
          ),
        ),
      ),
    );
  }
}
