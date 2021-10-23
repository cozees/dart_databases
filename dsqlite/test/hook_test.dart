library cross_apis.test;

import 'package:database_sql/database_sql.dart' as sqldb;
import 'package:dsqlite/dsqlite.dart' as dsqlite;
import 'package:dsqlite/sqlite.dart' as sqlite;
import 'package:logging/logging.dart';
import 'package:test/test.dart';

import 'common/common.dart';

class UpdateLog {
  UpdateLog(this.dbName, this.tbName, this.operation, this.id);

  final String dbName;
  final String tbName;
  final int operation;
  final int id;

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() => '$dbName, $tbName, $operation, $id';

  @override
  bool operator ==(covariant UpdateLog other) =>
      dbName == other.dbName &&
      tbName == other.tbName &&
      operation == other.operation &&
      id == other.id;
}

void main() async {
  const driverName = 'sqlite_hook';
  final dbFiles = <Future Function()>[];
  final ds = IncrementalDataSource.ds('hook');

  tearDownAll(() async {
    for (var f in dbFiles) {
      await f();
    }
  });

  setUpAll(() async {
    sqldb.registerDriver(
      driverName,
      await dsqlite.Driver.initialize(
        path: dLibraries.first,
        logLevel: Level.ALL,
        connectHook: (driver, db, ds) {
          /* Register hook over here */
        },
      ),
    );
  });

  test('Test commit and rollback hook', () async {
    await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
      final _ = db as dsqlite.Database;
      var commit = 0, rollback = 0;
      db.registerCommitHook(() {
        commit++;
        return sqlite.OK;
      });
      db.registerRollbackHook(() => rollback++);
      await db.protectTransaction(block: (sqldb.Database db, tx) async => await db.exec(simpleTable));
      expect([commit, rollback], [1, 0]);
      await db.protectTransaction(block: (sqldb.Database db, tx) async {
        final simples = Simple.generate(10);
        final stmt = await db.prepare(simpleTableInsertBindNameU).write();
        for (var simple in simples) {
          stmt.exec(parameters: simple.toParameter(), reusable: true);
          stmt.reset();
        }
        stmt.close();
        throw Exception('let it burn');
      }).catchError((e, s) => false);
      expect([commit, rollback], [1, 1]);
      db.unregisterCommitHook();
      await db.protectTransaction(
          block: (sqldb.Database db, tx) async => await db.exec('CREATE TABLE `tb1`(name TEXT);'));
      expect([commit, rollback], [1, 1]);
      db.unregisterRollbackHook();
      await db.protectTransaction(block: (sqldb.Database db, tx) async {
        await db.exec('CREATE TABLE `tb1`(name TEXT);');
        throw Exception('let it burn, the second');
      }).catchError((e, s) => false);
      expect([commit, rollback], [1, 1]);
    });
  });

  test('Test update hook', () async {
    await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
      final _ = db as dsqlite.Database;
      final logs = <UpdateLog>[];
      db.registerUpdateHook(
          (operation, dbName, tbName, id) => logs.add(UpdateLog(dbName, tbName, operation, id)));
      await db.exec(simpleTable);
      final simples = Simple.generate(2);
      await db.exec(simpleTableInsertBindNameU, parameters: simples.first.toParameter());
      await db.exec(simpleTableInsertBindNameU, parameters: simples.last.toParameter());
      expect(logs, [
        UpdateLog('main', 'simple', sqlite.INSERT, 1),
        UpdateLog('main', 'simple', sqlite.INSERT, 2),
      ]);
      await db.exec('DELETE FROM `simple` WHERE id=?', parameters: [2]);
      expect(logs.last, UpdateLog('main', 'simple', sqlite.DELETE, 2));
      await db.exec('UPDATE `simple` SET `name`=? WHERE id=?', parameters: ['newName', 1]);
      expect(logs.last, UpdateLog('main', 'simple', sqlite.UPDATE, 1));
      var overrideHook = 0;
      expect(logs.length, 4);
      db.registerUpdateHook((operation, databaseName, tableName, id) => overrideHook++);
      await db.exec(simpleTableInsertBindNameU, parameters: simples.last.toParameter());
      expect(logs.length, 4);
      expect(overrideHook, 1);
      db.unregisterUpdateHook();
      await db.exec('DELETE FROM `simple` WHERE id=?', parameters: [2]);
      expect(logs.length, 4);
      expect(overrideHook, 1);
    });
  });
}
