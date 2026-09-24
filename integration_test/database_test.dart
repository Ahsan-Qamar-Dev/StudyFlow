import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:studyflow/database/migrations.dart';
import 'package:studyflow/services/database_service.dart';
import 'package:studyflow/services/preferences_service.dart';
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late String location;
  setUp(() async {
    location = path.join(
      await getDatabasesPath(),
      'studyflow_foundation_test.db',
    );
    await deleteDatabase(location);
  });
  tearDown(() => deleteDatabase(location));

  testWidgets('SQLite CRUD, reopen, foreign keys, and retained study history', (
    _,
  ) async {
    var service = await DatabaseService.open(databasePath: location);
    var db = service.database;
    final subject = await db.insert('subjects', {
      'name': 'Biology',
      'color': 1,
      'created_at': 0,
    });
    final topic = await db.insert('topics', {
      'subject_id': subject,
      'name': 'Cells',
      'estimated_minutes': 25,
      'created_at': 0,
    });
    await db.update(
      'topics',
      {'completed': 1, 'completed_at': 1},
      where: 'id = ?',
      whereArgs: [topic],
    );
    await db.insert('study_sessions', {
      'subject_id': subject,
      'topic_id': topic,
      'start_time': 0,
      'end_time': 1500000,
      'duration_seconds': 1500,
      'completed': 1,
    });
    await service.close();
    service = await DatabaseService.open(databasePath: location);
    db = service.database;
    expect((await db.query('topics')).single['completed'], 1);
    expect((await db.query('subjects')).single['name'], 'Biology');
    await expectLater(
      db.insert('topics', {
        'subject_id': 999,
        'name': 'Invalid',
        'estimated_minutes': 25,
        'created_at': 0,
      }),
      throwsA(isA<DatabaseException>()),
    );
    await db.transaction(
      (tx) => tx.delete('subjects', where: 'id = ?', whereArgs: [subject]),
    );
    expect(await db.query('topics'), isEmpty);
    expect((await db.query('study_sessions')).single['subject_id'], isNull);
    expect((await db.query('study_sessions')).single['duration_seconds'], 1500);
    expect(await db.rawQuery('PRAGMA foreign_key_check'), isEmpty);
    await service.close();
  });

  testWidgets(
    'A failed future migration rolls back without losing existing data',
    (_) async {
      var service = await DatabaseService.open(databasePath: location);
      await service.database.insert('subjects', {
        'name': 'Keep me',
        'color': 1,
        'created_at': 0,
      });
      await service.close();
      await expectLater(
        openDatabase(
          location,
          version: 2,
          onUpgrade: (db, from, to) => Migrations.run(
            db,
            from,
            to,
            migrations: {
              2: (db) async {
                await db.execute(
                  'ALTER TABLE subjects ADD COLUMN temporary_value TEXT',
                );
                throw StateError('Simulated migration failure');
              },
            },
          ),
        ),
        throwsA(anything),
      );
      service = await DatabaseService.open(databasePath: location);
      expect(
        (await service.database.query('subjects')).single['name'],
        'Keep me',
      );
      expect(await service.database.getVersion(), 1);
      final columns = await service.database.rawQuery(
        'PRAGMA table_info(subjects)',
      );
      expect(
        columns.any((column) => column['name'] == 'temporary_value'),
        isFalse,
      );
      await service.close();
    },
  );

  testWidgets('Successful future migration preserves records', (_) async {
    final service = await DatabaseService.open(databasePath: location);
    await service.database.insert('subjects', {
      'name': 'Keep me',
      'color': 1,
      'created_at': 0,
    });
    await service.close();
    final upgraded = await openDatabase(
      location,
      version: 2,
      onUpgrade: (db, from, to) => Migrations.run(
        db,
        from,
        to,
        migrations: {
          2: (db) => db.execute('ALTER TABLE subjects ADD COLUMN extra TEXT'),
        },
      ),
    );
    expect(await upgraded.getVersion(), 2);
    expect((await upgraded.query('subjects')).single['name'], 'Keep me');
    await upgraded.close();
  });

  testWidgets('Theme preference survives service recreation', (_) async {
    final preferences = await PreferencesService.load();
    final original = preferences.themeMode;
    try {
      await preferences.saveTheme(ThemeMode.dark);
      expect((await PreferencesService.load()).themeMode, ThemeMode.dark);
    } finally {
      await preferences.saveTheme(original);
    }
  });
}
