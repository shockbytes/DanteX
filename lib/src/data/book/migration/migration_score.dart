class MigrationScore {
  final int booksToMigrate;
  final int migratedBooks;
  final int pageRecordsToMigrate;
  final int migratedPageRecords;

  MigrationScore({
    required this.booksToMigrate,
    required this.migratedBooks,
    required this.pageRecordsToMigrate,
    required this.migratedPageRecords,
  });

  bool isSuccessful() {
    return booksToMigrate == migratedBooks &&
        pageRecordsToMigrate == migratedPageRecords;
  }

  MigrationStatus statusFromScore() {
    return isSuccessful() ? MigrationStatus.migrated : MigrationStatus.failed;
  }
}

enum MigrationStatus {
  required,
  migrated,
  failed,
}
