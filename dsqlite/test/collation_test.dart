library cross_apis.test;

import 'package:database_sql/database_sql.dart' as sqldb;
import 'package:dsqlite/dsqlite.dart' as dsqlite;
import 'package:logging/logging.dart';
import 'package:test/test.dart';

import 'common/common.dart';

void main() async {
  const driverName = 'sqlite';
  final dbFiles = <Future Function()>[];
  final ds = IncrementalDataSource.ds('collation');

  setUpAll(() async {
    sqldb.registerDriver(
      driverName,
      await dsqlite.Driver.initialize(
        path: dLibraries.first.libraryPath,
        webMountPath: dLibraries.first.mountPoint,
        logLevel: Level.ALL,
        connectHook: (driver, db, ds) {
          db.registerCollation('DART_STRING', (a, b) => a.compareTo(b));
        },
      ),
    );
  });

  tearDownAll(() async {
    for (var f in dbFiles) {
      f();
    }
  });

  test('Test collation', () async {
    await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
      final data = [
        ['test', 'abc', 123],
        ['xyz', 'ghi', 325],
        ['mno', 'rst', 216],
      ];
      await db.exec('CREATE TABLE IF NOT EXISTS `sample`('
          '`name` TEXT COLLATE DART_STRING,'
          '`detail` TEXT NOT NULL,'
          '`info` INTEGER COLLATE DART_STRING'
          ');');
      await db.exec(
        'INSERT INTO `sample` VALUES(?,?,?),(?,?,?),(?,?,?);',
        parameters: data.expand((e) => e),
      );
      await db.protectQuery<sqldb.Row>(
        'SELECT info,detail FROM `sample` WHERE name=?',
        parameters: [data[0][0]],
        block: (rows) async {
          expect(rows.moveNext(), true);
          expect(rows.current.intValueAt(0), data[0][2]);
          expect(rows.current.stringValueAt(1), data[0][1]);
        },
      );
      await db.protectQuery<sqldb.Row>(
        'SELECT name,detail FROM `sample` WHERE info=?',
        parameters: [data[2][2]],
        block: (rows) async {
          expect(rows.moveNext(), true);
          expect(rows.current.stringValueAt(0), data[2][0]);
          expect(rows.current.stringValueAt(1), data[2][1]);
        },
      );
      // test replace collation with reverse ordered
      final _ = db as dsqlite.Database;
      db.registerCollation('DART_STRING', (a, b) {
        final r = a.compareTo(b);
        return r == 0 ? r : r * -1;
      });
      await db.protectQuery<sqldb.Row>(
        'SELECT info,detail FROM `sample` WHERE name>?',
        parameters: [data[0][0]],
        block: (rows) async {
          expect(rows.moveNext(), true);
          expect(rows.current.intValueAt(0), data[2][2]);
          expect(rows.current.stringValueAt(1), data[2][1]);
        },
      );
    });
  });

  test('Test error routine collation', () async {
    await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
      final data = ['test', 'abc', 'xyz'];
      final _ = db as dsqlite.Database;
      expect(
        () async => await db.exec('CREATE TABLE IF NOT EXISTS `sample_err`('
            '`name` TEXT COLLATE MISSING_ME,'
            ');'),
        throwsException,
      );
      // create table and add data
      await db.exec('CREATE TABLE IF NOT EXISTS `sample_err`('
          '`name` TEXT COLLATE DART_STRING'
          ');');
      await db.exec('INSERT INTO `sample_err` VALUES(?),(?),(?);', parameters: data);
      // expect exception after removing collation
      db.unregisterCollation('DART_STRING');
      expect(
        () async =>
            await db.query('SELECT * FROM `sample_err` WHERE name=?;', parameters: ['test']),
        throwsA(TypeMatcher<dsqlite.SQLiteException>().having(
          (e) => e.message,
          'message',
          'no such collation sequence: DART_STRING',
        )),
      );
      // compare throw an error
      db.registerCollation('DART_STRING', (a, b) {
        throw sqldb.DatabaseException('force error');
      });
      final rows = await db
          .query<sqldb.Row>('SELECT * FROM `sample_err` WHERE name=?;', parameters: ['test']);
      // See https://www.sqlite.org/c3ref/create_collation.html
      // There is mention how it handle error while perform comparision. So logging is only way to
      // trace error. the return value is being trait by SQLite as a result instead of error.
      expect(rows.moveNext(), false);
      rows.close();
    });
  });
}
