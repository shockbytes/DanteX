import 'dart:async';

import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/page_record.dart';
import 'package:dantex/src/data/book/migration/migration_score.dart';
import 'package:dantex/src/data/book/page_record_repository.dart';
import 'package:dantex/src/data/settings/settings_repository.dart';
import 'package:logger/logger.dart';

/// Runs the migration from the old Android app to the new cross platform app.
/// The runner essentially fetches all data from Realm and pipes it to Firebase.
class MigrationRunner {
  final BookRepository _bookTarget;
  final BookRepository _bookSource;
  final PageRecordRepository _pageRecordTarget;
  final PageRecordRepository _pageRecordSource;
  final Logger _logger;
  final SettingsRepository _settingsRepository;

  MigrationRunner(
    this._logger,
    this._settingsRepository,
    BookRepository bookTarget,
    BookRepository bookSource,
    PageRecordRepository pageRecordTarget,
    PageRecordRepository pageRecordSource,
  )   : _bookTarget = bookTarget,
        _bookSource = bookSource,
        _pageRecordTarget = pageRecordTarget,
        _pageRecordSource = pageRecordSource;

  // TODO Call this method
  Future<MigrationStatus> migrateIfRequired() async {
    final MigrationStatus status = await _migrationStatus();

    // If status is not required, return the current status.
    if (status != MigrationStatus.required) {
      return status;
    }

    final MigrationScore score = await _migrate();
    final MigrationStatus newStatus = score.statusFromScore();
    _updateMigrationStatus(newStatus);
    return newStatus;
  }

  /// Load migration status from settings. If nothing is saved, return required.
  Future<MigrationStatus> _migrationStatus() async {
    return _settingsRepository.getRealmMigrationStatus() ??
        MigrationStatus.required;
  }

  Future<MigrationScore> _migrate() async {
    final ({int migratedBooks, int booksToMigrate}) booksStat =
        await _migrateBooks();

    final ({
      int migratedPageRecords,
      int pageRecordsToMigrate
    }) pageRecordsStats = await _migratePageRecords();

    return MigrationScore(
      booksToMigrate: booksStat.booksToMigrate,
      migratedBooks: booksStat.migratedBooks,
      pageRecordsToMigrate: pageRecordsStats.pageRecordsToMigrate,
      migratedPageRecords: pageRecordsStats.migratedPageRecords,
    );
  }

  /// Returns no. of migrated instances and potential no. of migrations
  Future<({int migratedBooks, int booksToMigrate})> _migrateBooks() async {
    final List<Book> booksToMigrate = await _bookSource.getAllBooks();

    int migratedBooks = 0;
    for (int i = 0; i < booksToMigrate.length; i++) {
      final Book book = booksToMigrate[i];

      try {
        await _bookTarget.create(book);
        migratedBooks++;
      } catch (e) {
        _logger.f(e);
      }
    }

    return (
      migratedBooks: migratedBooks,
      booksToMigrate: booksToMigrate.length,
    );
  }

  /// Returns no. of migrated instances and potential no. of migrations
  Future<({int migratedPageRecords, int pageRecordsToMigrate})>
      _migratePageRecords() async {
    final List<PageRecord> pageRecordsToMigrate =
        await _pageRecordSource.allPageRecords();

    int migratedPageRecords = 0;
    for (int i = 0; i < pageRecordsToMigrate.length; i++) {
      final PageRecord record = pageRecordsToMigrate[i];

      try {
        await _pageRecordTarget.insertPageRecordForBookId(
          record.bookId,
          record.fromPage,
          record.toPage,
          record.dateTime,
        );
        migratedPageRecords++;
      } catch (e) {
        _logger.f(e);
      }
    }

    return (
      migratedPageRecords: migratedPageRecords,
      pageRecordsToMigrate: pageRecordsToMigrate.length,
    );
  }

  void _updateMigrationStatus(MigrationStatus newStatus) {
    unawaited(_settingsRepository.setRealmMigrationStatus(newStatus));
  }
}