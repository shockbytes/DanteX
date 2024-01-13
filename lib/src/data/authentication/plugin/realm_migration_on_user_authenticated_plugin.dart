import 'dart:async';

import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:dantex/src/data/authentication/on_user_authenticated_plugin.dart';
import 'package:dantex/src/data/book/migration/migration_runner.dart';

class RealmMigrationOnUserAuthenticatedPlugin
    implements OnUserAuthenticatedPlugin {
  final MigrationRunner _migrationRunner;

  RealmMigrationOnUserAuthenticatedPlugin(
    this._migrationRunner,
  );

  @override
  void onUserAuthenticated(DanteUser user) {
    unawaited(
      _migrationRunner.migrateIfRequired(),
    );
  }
}
