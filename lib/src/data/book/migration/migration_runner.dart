import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/migration/migration_score.dart';

/// Runs the migration from the old Android app to the new cross platform app.
/// The runner essentially fetches all data from Realm and pipes it to Firebase.
class MigrationRunner {
  final BookRepository _target;
  final BookRepository _source;

  MigrationRunner(
    BookRepository target,
    BookRepository source,
  )   : _target = target,
        _source = source;

  Future<MigrationStatus> migrationStatus() async {
    // TODO Check if a migration need to be performed
    return MigrationStatus.required;
  }

  Future<MigrationScore> migrate() async {
    ({int migratedBooks, int booksToMigrate}) booksStat = await _migrateBooks();

    ({int migratedPageRecords, int pageRecordsToMigrate}) pageRecordsStats = await _migratePageRecords();

    return MigrationScore(
      booksToMigrate: booksStat.booksToMigrate,
      migratedBooks: booksStat.migratedBooks,
      pageRecordsToMigrate: pageRecordsStats.pageRecordsToMigrate,
      migratedPageRecords: pageRecordsStats.migratedPageRecords,
    );
  }

  /// Returns no. of migrated instances and potential no. of migrations
  Future<({int migratedBooks, int booksToMigrate})> _migrateBooks() async {
    List<Book> booksToMigrate = await _source.getAllBooks();

    int migratedBooks = 0;
    for (int i = 0; i < booksToMigrate.length; i++) {
      Book book = booksToMigrate[i];

      try {
        await _target.create(book);
        migratedBooks++;
      } catch (e) {
        // TODO Log error
      }
    }

    return (
      migratedBooks: migratedBooks,
      booksToMigrate: booksToMigrate.length,
    );
  }

  /// Returns no. of migrated instances and potential no. of migrations
  Future<({int migratedPageRecords, int pageRecordsToMigrate})> _migratePageRecords() async {
    // TODO
    return (
      migratedPageRecords: 0,
      pageRecordsToMigrate: 0,
    );
  }
}

enum MigrationStatus {
  required,
  doneButFailed,
  done,
}