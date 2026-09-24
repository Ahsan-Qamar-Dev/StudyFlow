import 'package:sqflite/sqflite.dart';

import 'schema.dart';

typedef Migration = Future<void> Function(DatabaseExecutor database);

abstract final class Migrations {
  /// Never edit a released migration. Append a new version instead.
  static final Map<int, Migration> steps = {
    1: (database) async {
      for (final statement in Schema.statements) {
        await database.execute(statement);
      }
    },
  };

  /// sqflite wraps onCreate/onUpgrade in a transaction. Any failure rolls back.
  static Future<void> run(
    DatabaseExecutor database,
    int from,
    int to, {
    Map<int, Migration>? migrations,
  }) async {
    if (to < from) throw StateError('Database downgrade is not supported.');
    final available = migrations ?? steps;
    for (var version = from + 1; version <= to; version++) {
      if (!available.containsKey(version)) {
        throw StateError('Missing migration for version $version');
      }
    }
    for (var version = from + 1; version <= to; version++) {
      await available[version]!(database);
    }
  }
}
