import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../database/migrations.dart';
import '../database/schema.dart';

class DatabaseService {
  DatabaseService._(this.database);
  final Database database;

  static Future<DatabaseService> open({String? databasePath}) async {
    final location =
        databasePath ?? path.join(await getDatabasesPath(), 'studyflow.db');
    final database = await openDatabase(
      location,
      version: Schema.version,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) => Migrations.run(db, 0, version),
      onUpgrade: (db, oldVersion, newVersion) =>
          Migrations.run(db, oldVersion, newVersion),
      onDowngrade: (db, oldVersion, newVersion) async {
        throw StateError('This database needs a newer version of StudyFlow.');
      },
    );
    return DatabaseService._(database);
  }

  Future<void> close() => database.close();
}
