import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/migration/migration_runner.dart';
import 'package:dantex/src/data/book/page_record_repository.dart';
import 'package:dantex/src/data/book/realm/realm_book.dart';
import 'package:dantex/src/data/book/realm/realm_book_repository.dart';
import 'package:dantex/src/data/book/realm/realm_page_record_repository.dart';
import 'package:dantex/src/providers/repository.dart';
import 'package:dantex/src/providers/service.dart';
import 'package:realm/realm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'migration.g.dart';

@riverpod
MigrationRunner migrationRunner(MigrationRunnerRef ref) => MigrationRunner(
      ref.watch(loggerProvider),
      ref.watch(settingsRepositoryProvider),
      ref.watch(bookRepositoryProvider),
      ref.watch(_legacyBookRepositoryProvider),
      ref.watch(pageRecordRepositoryProvider),
      ref.watch(_legacyPageRecordRepositoryProvider),
    );

@riverpod
BookRepository _legacyBookRepository(_LegacyBookRepositoryRef ref) =>
    RealmBookRepository(
      ref.watch(_realmProvider),
    );

@riverpod
PageRecordRepository _legacyPageRecordRepository(
  _LegacyPageRecordRepositoryRef ref,
) =>
    RealmPageRecordRepository(
      ref.watch(_realmProvider),
    );

@riverpod
Realm _realm(_RealmRef ref) => Realm(
      Configuration.local(
        [
          RealmBook.schema,
          RealmBookLabel.schema,
          RealmPageRecord.schema,
        ],
        // 9 is the current schema version of the old app.
        schemaVersion: 9,
      ),
    );
