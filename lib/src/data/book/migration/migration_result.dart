class MigrationResult {
  final int booksToMigrate;
  final int migratedBooks;
  final int pageRecordsToMigrate;
  final int migratedPageRecords;

  MigrationResult({
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
  required, // A migration needs to run
  migrated, // A migration has been executed
  failed, // The migration failed
  unsupportedPlatform, // Migrations will only run on Android
}
