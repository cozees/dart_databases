library cross_apis.test;

import 'dart:typed_data';

import 'package:database_sql/database_sql.dart' as sqldb;
import 'package:dsqlite/dsqlite.dart' as dsqlite;

import 'package:dsqlite/sqlite.dart' as sqlite;
import 'package:logging/logging.dart';
import 'package:test/test.dart';

import 'common/common.dart';

void main() async {
  const driverName = 'sqlite';
  final dbFiles = <Future Function()>[];
  final ds = IncrementalDataSource.ds('general');

  setUpAll(() async {
    expect(() => dsqlite.Driver.binder, throwsException);
    sqldb.registerDriver(
      driverName,
      await dsqlite.Driver.initialize(path: dLibraries.first, logLevel: Level.ALL),
    );
  });

  tearDownAll(() async {
    for (var f in dbFiles) {
      await f();
    }
  });

  test('Test Open Database', () async {
    // open read write by default
    try {
      final db = sqldb.open(driverName, ds.next(dbFiles));
      expect(db.isClosed, false);
      await db.close();
    } catch (e) {
      fail('Open database failed with Exception: $e');
    }
  });

  test('Test Open Protect Database', () async {
    try {
      sqldb.Database? ndb;
      await sqldb.protect(driverName, ds.next(dbFiles), block: (sqldb.Database db) async {
        ndb = db;
        expect(db.isClosed, false);
      });
      expect(ndb, isNotNull);
      expect(ndb!.isClosed, true);
    } catch (e) {
      fail('Open Protect database failed with Exception: $e');
    }
  });

  test('Test Create Table', () async {
    await sqldb.protect(driverName, ds.next(dbFiles), block: (sqldb.Database db) async {
      final changes = await db.exec('CREATE TABLE IF NOT EXISTS `student` ('
          '`student_id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'
          '`first_name` TEXT NOT NULL,'
          '`middle_name` TEXT,'
          '`last_name` TEXT NOT NULL,'
          '`clazz` TEXT NOT NULL,'
          '`student_no` TEXT NOT NULL UNIQUE,'
          '`student_rec` TEXT NOT NULL,'
          '`age` INTEGER NOT NULL,'
          '`birthday` NUMERIC NOT NULL,'
          '`created_at` NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,'
          '`updated_at` NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,'
          'UNIQUE (`student_no`, `student_rec`)'
          ');');
      expect(changes.rowsAffected, 0);
      expect(changes.lastInsertId, 0);
      final tbInfo = await dsqlite.TableInfo.show(db, 'student');
      expect(tbInfo, isNotNull);
      expect(tbInfo!.columns.length, 11);
      expect(tbInfo.columns, [
        dsqlite.ColumnInfo('student_id', 'INTEGER', 'BINARY', false, null, true, true),
        dsqlite.ColumnInfo('first_name', 'TEXT', 'BINARY', false, null, false, false),
        dsqlite.ColumnInfo('middle_name', 'TEXT', 'BINARY', true, null, false, false),
        dsqlite.ColumnInfo('last_name', 'TEXT', 'BINARY', false, null, false, false),
        dsqlite.ColumnInfo('clazz', 'TEXT', 'BINARY', false, null, false, false),
        dsqlite.ColumnInfo('student_no', 'TEXT', 'BINARY', false, null, false, false),
        dsqlite.ColumnInfo('student_rec', 'TEXT', 'BINARY', false, null, false, false),
        dsqlite.ColumnInfo('age', 'INTEGER', 'BINARY', false, null, false, false),
        dsqlite.ColumnInfo('birthday', 'NUMERIC', 'BINARY', false, null, false, false),
        dsqlite.ColumnInfo(
            'created_at', 'NUMERIC', 'BINARY', false, 'CURRENT_TIMESTAMP', false, false),
        dsqlite.ColumnInfo(
            'updated_at', 'NUMERIC', 'BINARY', false, 'CURRENT_TIMESTAMP', false, false),
      ]);
    });
  });

  test('Test Transaction', () async {
    await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
      final t = await db.begin();
      await db.exec(simpleTable);
      await t.cancel();
      expect(await dsqlite.TableInfo.show(db, 'simple'), isNull);
      await db.protectTransaction(block: (db, tx) async => await db.exec(simpleTable));
      final tbInfo = await dsqlite.TableInfo.show(db, 'simple');
      expect(tbInfo, isNotNull);
      expect(tbInfo!.columns, simpleColumns);
      // test redirect method
      try {
        await db.protectTransaction<dsqlite.Transaction>(
            block: (db, tx) async => await tx.exec('CREATE TABLE `simple`(id INTEGER);'));
        fail('Expected transaction throw exception.');
        // ignore: empty_catches
      } catch (e) {}
      await db.protectTransaction<dsqlite.Transaction>(
        block: (db, tx) async =>
            expect((await tx.prepare('DELETE FROM `simple` WHERE id=1;'))..close(), isNotNull),
      );
      await db.protectTransaction<dsqlite.Transaction>(
        block: (db, tx) async =>
            expect((await tx.prepare('SELECT * FROM `simple`;'))..close(), isNotNull),
      );
      await db.protectTransaction<dsqlite.Transaction>(
        block: (db, tx) async =>
            expect((await tx.query('SELECT * FROM `simple`;'))..close(), isNotNull),
      );
    });
  });

  test('Test Transaction Custom Control', () async {
    await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
      for (var stc in [
        dsqlite.SQLiteTransactionControl.deferred,
        dsqlite.SQLiteTransactionControl.immediate,
        dsqlite.SQLiteTransactionControl.exclusive,
      ]) {
        await db.protectTransaction(
          creator: dsqlite.transactionCreator(stc),
          block: (db, tx) async => await db.exec(simpleTable),
        );
        final tbInfo = await dsqlite.TableInfo.show(db, 'simple');
        expect(tbInfo, isNotNull);
        expect(tbInfo!.columns, simpleColumns);
      }
    });
  });

  test('Test Save Point', () async {
    await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
      final t = await db.begin<dsqlite.SavePoint>(creator: dsqlite.savePointCreator());
      await db.exec(simpleTable);
      await t.cancel();
      expect(await dsqlite.TableInfo.show(db, 'simple'), isNull);
      await db.protectTransaction<dsqlite.SavePoint>(
        creator: dsqlite.savePointCreator('save2'),
        block: (db, tx) async => await db.exec(simpleTable),
      );
      final tbInfo = await dsqlite.TableInfo.show(db, 'simple');
      expect(tbInfo, isNotNull);
      expect(tbInfo!.columns, simpleColumns);
      // test redirect method
      expect(
        () async => await db.protectTransaction<dsqlite.SavePoint>(
          creator: dsqlite.savePointCreator(),
          block: (db, t) async => await t.exec('CREATE TABLE `simple`(id INTEGER);'),
        ),
        throwsException,
      );
      await db.protectTransaction<dsqlite.SavePoint>(
        creator: dsqlite.savePointCreator(),
        block: (db, t) async =>
            expect((await t.prepare('DELETE FROM `simple` WHERE id=1;'))..close(), isNotNull),
      );
      await db.protectTransaction<dsqlite.SavePoint>(
        creator: dsqlite.savePointCreator(),
        block: (db, t) async =>
            expect((await t.prepare('SELECT * FROM `simple`;'))..close(), isNotNull),
      );
      await db.protectTransaction<dsqlite.SavePoint>(
        creator: dsqlite.savePointCreator(),
        block: (db, t) async =>
            expect((await t.query('SELECT * FROM `simple`;'))..close(), isNotNull),
      );
    });
  });

  group('Test Insert Binding', () {
    test('Test Insert Binding with default index', () async {
      await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
        await db.exec(simpleTable);
        final simple = Simple.generate(1).first;
        final statement = await db.prepare(simpleTableInsertBindIndex).write();
        final changes = await statement.exec(parameters: [
          simple.name,
          simple.alias,
          simple.serialNo,
          simple.level,
          simple.classification,
        ]);
        expect(changes.rowsAffected, 1);
        expect(changes.lastInsertId, 1);
      });
    });

    test('Test Insert Binding with Name Parameter', () async {
      await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
        await db.exec(simpleTable);
        final simple = Simple.generate(1).first;
        final statement = await db.prepare(simpleTableInsertBindName).write();
        final changes = await statement.exec(parameters: [
          dsqlite.NameParameter('name', simple.name, prefix: ':'),
          dsqlite.NameParameter('alias', simple.alias, prefix: '\$'),
          dsqlite.NameParameter('serial_no', simple.serialNo, prefix: '@'),
          dsqlite.NameParameter('level', simple.level, prefix: ':'),
          dsqlite.NameParameter('classification', simple.classification, prefix: ':'),
        ]);
        expect(changes.rowsAffected, 1);
        expect(changes.lastInsertId, 1);
      });
    });

    test('Test Insert Binding Mix', () async {
      await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
        await db.exec(simpleTable);
        final simple = Simple.generate(1).first;
        final statement = await db.prepare(simpleTableInsertBindNI).write();
        final changes = await statement.exec(parameters: [
          dsqlite.NameParameter('alias', simple.alias, prefix: '@'),
          dsqlite.IndexParameter(3, simple.serialNo),
          simple.name,
          dsqlite.IndexParameter(4, simple.level),
          simple.classification,
        ]);
        expect(changes.rowsAffected, 1);
        expect(changes.lastInsertId, 1);
      });
    });

    test('Test db exec statement wrapper', () async {
      await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
        await db.exec('CREATE TABLE `tdbesw_ss1`(name TEXT);');
        final change = await db.exec('INSERT INTO `tdbesw_ss1`(name)VALUES(:name);',
            parameters: [dsqlite.NameParameter('name', 'tdbesw_ss1')]);
        expect(change.rowsAffected, 1);
        expect(change.lastInsertId, 1);
      });
    });
  });

  group('Test Data', () {
    /// db connection
    late final sqldb.Database db;
    late final List<Simple> simples;
    setUpAll(() async {
      db = sqldb.open(driverName, ds.next(dbFiles));
      await db.exec(simpleTable);
      simples = Simple.generate(100);
      final statement = await db.prepare(simpleTableInsertBindIndex).write();
      final dtStmt =
          await db.prepare('SELECT created_at, updated_at FROM `simple` WHERE id=?').read();
      for (var simple in simples) {
        final change = await statement.exec(parameters: [
          simple.name,
          simple.alias,
          simple.serialNo,
          simple.level,
          simple.classification,
        ], reusable: true);
        simple.id = change.lastInsertId;
        final rows = await dtStmt.query<sqldb.Row>(parameters: [simple.id]);
        expect(rows.moveNext(), true);
        simple.createdAt = DateTime.parse(rows.current.stringValueBy('created_at')!);
        simple.updatedAt = DateTime.parse(rows.current.stringValueBy('updated_at')!);
        // reset to it can bind again with different value
        dtStmt.reset();
        statement.reset();
      }
      dtStmt.close();
      statement.close();
    });

    tearDownAll(() async => await db.close());

    test('Test Get All(*) with db.query', () async {
      final rows = await db.query<Simple>(
        'SELECT * FROM `simple`;',
        creator: (reader) => Simple.db(reader),
      );
      var i = 0;
      for (; rows.moveNext(); i++) {
        expect(rows.current, simples[i]);
      }
      expect(i, simples.length);
      rows.close();
    });

    test('Test Get All(*) with statement.query', () async {
      // get first 5
      final statement = await db.prepare('SELECT * FROM `simple` WHERE id < :id').read();
      var rows = await statement.query<Simple>(
        parameters: [dsqlite.NameParameter('id', 6, prefix: ':')],
        creator: (reader) => Simple.db(reader),
      );
      var i = 0;
      for (; rows.moveNext(); i++) {
        expect(rows.current, simples[i]);
      }
      expect(i, 5);
      statement.reset();
      // get first 30
      rows = await statement.query<Simple>(
        parameters: [dsqlite.NameParameter('id', 31, prefix: ':')],
        creator: (reader) => Simple.db(reader),
      );
      for (i = 0; rows.moveNext(); i++) {
        expect(rows.current, simples[i]);
      }
      expect(i, 30);
      rows.close();
    });

    test('Test Custom Selection', () async {
      // first try
      var statement =
          await db.prepare('SELECT `id`,`name`,`level` FROM `simple` WHERE id < :id').read();
      var rows = await statement.query<sqldb.Row>(
        parameters: [dsqlite.NameParameter('id', 3, prefix: ':')],
      );
      var i = 0;
      for (; rows.moveNext(); i++) {
        expect(rows.current.intValueBy('id'), simples[i].id);
        expect(rows.current.stringValueBy('name'), simples[i].name);
        expect(rows.current.intValueBy('level'), simples[i].level);
      }
      expect(i, 2);
      rows.close();
      // last try
      statement = await db
          .prepare('SELECT `id`,`name`,`level` FROM `simple` WHERE :ids < id AND id < :idg')
          .read();
      rows = await statement.query<sqldb.Row>(
        parameters: [
          dsqlite.NameParameter('ids', 3, prefix: ':'),
          dsqlite.NameParameter('idg', 6, prefix: ':')
        ],
      );
      for (i = 3; rows.moveNext(); i++) {
        expect(rows.current.intValueBy('id'), simples[i].id);
        expect(rows.current.stringValueBy('name'), simples[i].name);
        expect(rows.current.intValueBy('level'), simples[i].level);
        // will throw exception
        expect(() => rows.current.stringValueBy('alias'), throwsException);
        expect(() => rows.current.stringValueBy('serial_no'), throwsException);
        expect(() => rows.current.intValueBy('classification'), throwsException);
        expect(() => rows.current.stringValueBy('created_at'), throwsException);
        expect(() => rows.current.stringValueBy('updated_at'), throwsException);
      }
      expect(i - 3, 2);
      rows.close();
    });
  });

  group('Test Statement', () {
    late final sqldb.Database db;
    late final List<Simple> simples;
    setUpAll(() async {
      db = sqldb.open(driverName, ds.next(dbFiles));
      await db.exec(simpleTable);
      simples = Simple.generate(5);
    });

    tearDownAll(() async => await db.close());

    test('Test Reset', () async {
      // *** write statement ***
      final stmtWrite = await db.prepare(simpleTableInsertBindNameU).write();
      expect(stmtWrite.initialState, true);
      var changes = await stmtWrite.exec(parameters: simples.first.toParameter(), reusable: true);
      expect(changes.lastInsertId, 1);
      expect(changes.rowsAffected, 1);
      simples.first.id = changes.lastInsertId;
      // sqlite throw an error when trying to bind on unreset statement
      expect(() async => await stmtWrite.exec(parameters: simples.last.toParameter()),
          throwsException);
      expect(stmtWrite.initialState, false);
      stmtWrite.reset();
      expect(stmtWrite.initialState, true);
      // reusable set to false, statement has close as soon as it return.
      changes = await stmtWrite.exec(parameters: simples.last.toParameter());
      expect(changes.lastInsertId, 2);
      expect(changes.rowsAffected, 1);
      simples.last.id = changes.lastInsertId;
      // *** read statement ***
      final stmtRead = await db.prepare('SELECT * FROM `simple` WHERE id=?;').read();
      expect(stmtRead.initialState, true);
      var rows = await stmtRead.query<sqldb.Row>(parameters: [simples.first.id]);
      expect(rows.moveNext(), true);
      // sqlite throw an error when trying to bind on unreset statement
      expect(() async => await stmtRead.query(parameters: [simples.last.id]), throwsException);
      expect(stmtRead.initialState, false);
      stmtRead.reset();
      expect(stmtRead.initialState, true);
      rows = await stmtRead.query<sqldb.Row>(parameters: [simples.last.id]);
      expect(rows.moveNext(), true);
      rows.close();
    });

    test('Test Error', () async {
      // test statement error
      final query = 'SELECT * FROM `simple`;SELECT name FROM `simple`;';
      expect(
        () async => await db.prepare(query).read(),
        throwsA(TypeMatcher<sqldb.DatabaseException>().having((e) => e.message, 'message',
            'Driver does not support execute multiple statement, tail query \'SELECT name FROM `simple`;\'')),
      );
      final stmtRead = await db.prepare('SELECT * FROM `simple` WHERE id=:id;').read();
      // not found index
      expect(
        dsqlite.NameParameter.indexOf(
          stmtRead as dsqlite.Statement,
          dsqlite.NameParameter('notFound', 1),
        ),
        -1,
      );
      expect(() async => stmtRead.query(), throwsException, reason: 'no argument');
      expect(() async => stmtRead.query(parameters: [1, 2]), throwsException,
          reason: 'too many argument');
      stmtRead.close();
      expect(() async => await db.prepare('SELECT notExistFun(*) FROM `simple`;').read(),
          throwsException,
          reason: 'SQL error');
      // test database error
      try {
        sqldb.open(driverName, ds.next(dbFiles, flags: 0));
        fail('Driver open did throw exception.');
      } catch (e) {
        dbFiles.removeLast();
      }
      final stmt1 = await db.prepare('SELECT * FROM `simple` WHERE id=:id;').read();
      expect(() async => await db.close(), throwsException);
      expect(
          () async => await stmt1.query(parameters: [
                {1}
              ]),
          throwsException);
      stmt1.close();
      final t = await db.begin();
      expect(() async => await db.close(), throwsException);
      t.cancel();
      final s = await db.begin(creator: dsqlite.savePointCreator());
      expect(() async => await db.close(), throwsException);
      s.cancel();
      expect(() async => await db.prepare('???', 'must be int or null'), throwsException);
    });
  });

  test('Test row reader', () async {
    await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
      await db.exec(allTypeColumnTable);
      final data = [
        [
          1100,
          'sample text 1',
          true,
          124.58,
          DateTime.now(),
          Uint8List.fromList(List.generate(30, (index) => index)),
          Uri.parse('https://www.example.com'),
          RegExp(r'\d+'),
          num.parse('1375.2874'),
          Duration(days: 150, microseconds: 6),
        ],
        [
          1200,
          'sample text 2',
          false,
          562.58,
          DateTime.now(),
          Uint8List.fromList(List.generate(50, (index) => index)),
          Uri.parse('https://www.example.com/any'),
          RegExp(r'\w+\d+'),
          num.parse('565.1546'),
          Duration(hours: 20, microseconds: 5),
        ],
        [
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
        ]
      ];
      for (var d in data) {
        final changes = await db.exec(
          'INSERT INTO `data_test` VALUES(?,?,?,?,?,?,?,?,?,?)',
          parameters: d,
        );
        expect(changes.rowsAffected, 1);
      }
      final col = allTypeColumns.map((e) => e.name).join(',');
      final rows = await db.query<sqldb.Row>('SELECT $col FROM `data_test`;');
      expect(rows.moveNext(), true);
      final row = rows.current;
      // ***************************************************************************************************
      // Important note: For regular expression, the class the not provide custom equal operator ==
      // Therefore the comparision of 2 instance is not guarantee and likely not working especially in
      // Web thus, we can dummy class to hold pattern only because we only store pattern not other
      // property around for cross compatible for all other language.
      // ***************************************************************************************************
      // test read with dynamic default type via name
      var tmp = data[0][7];
      data[0][7] = (tmp as RegExp).pattern;
      var res = allTypeTableReadFromRow(row, false);
      res[7] = (res[7] as RegExp).pattern;
      expect(res, data[0]);
      // test read with dynamic default type via index
      res = allTypeTableReadFromRow(row, true);
      res[7] = (res[7] as RegExp).pattern;
      expect(res, data[0]);
      // assign pattern regexp back
      data[0][7] = tmp;
      // read value by type via name
      expect(row.intValueBy(allTypeColumns[0].name), data[0][0]);
      expect(row.stringValueBy(allTypeColumns[1].name), data[0][1]);
      expect(row.intValueBy(allTypeColumns[2].name), data[0][2] == true ? 1 : 0);
      expect(row.doubleValueBy(allTypeColumns[3].name), data[0][3]);
      expect(row.stringValueBy(allTypeColumns[4].name), (data[0][4] as DateTime).toIso8601String());
      expect(row.blobValueBy(allTypeColumns[5].name), data[0][5]);
      expect(row.stringValueBy(allTypeColumns[6].name), (data[0][6] as Uri).toString());
      expect(row.stringValueBy(allTypeColumns[7].name), (data[0][7] as RegExp).pattern);
      expect(row.stringValueBy(allTypeColumns[8].name), (data[0][8] as num).toString());
      expect(row.intValueBy(allTypeColumns[9].name), (data[0][9] as Duration).inMicroseconds);
      // read value by type via index
      expect(row.intValueAt(0), data[0][0]);
      expect(row.stringValueAt(1), data[0][1]);
      expect(row.intValueAt(2), data[0][2] == true ? 1 : 0);
      expect(row.doubleValueAt(3), data[0][3]);
      expect(row.stringValueAt(4), (data[0][4] as DateTime).toIso8601String());
      expect(row.blobValueAt(5), data[0][5]);
      expect(row.stringValueAt(6), (data[0][6] as Uri).toString());
      expect(row.stringValueAt(7), (data[0][7] as RegExp).pattern);
      expect(row.stringValueAt(8), (data[0][8] as num).toString());
      expect(row.intValueAt(9), (data[0][9] as Duration).inMicroseconds);
      // test metadata
      expect(rows.columnCount, allTypeColumns.length);
      expect(rows.columns.join(','), col);
      expect(rows.declarationTypes.join(','), allTypeColumns.map((e) => e.dataType).join(','));
      // test access row after moving cursor
      expect(rows.moveNext(), true);
      expect(() => row.valueBy('id'), throwsException);
      rows.close();
      // test binding parameter via binding method and dynamic
      final paramNames = allTypeColumns.map((e) => '@${e.name}').join(',');
      for (var i = 0; i < 2; i++) {
        for (var d in data) {
          final m = Map.fromIterables(allTypeColumns.map((e) => e.name), d);
          final changes = await db.exec(
            'INSERT INTO `data_test` VALUES($paramNames)',
            parameters: i == 0 ? m.toTypedNameParameter('@') : m.toNameParameter('@'),
          );
          expect(changes.rowsAffected, 1);
        }
      }
      // force nullable
      final statement = await db.prepare('INSERT INTO `data_test` VALUES($paramNames)').write();
      final changes = await statement.exec(
        parameters: [
          dsqlite.NameParameter(allTypeColumns[0].name, data[2][0],
              prefix: '@', paramBinder: dsqlite.bindInt),
          dsqlite.NameParameter(allTypeColumns[1].name, data[2][1],
              prefix: '@', paramBinder: dsqlite.bindString),
          dsqlite.NameParameter(allTypeColumns[2].name, data[2][2],
              prefix: '@', paramBinder: dsqlite.bindBool),
          dsqlite.NameParameter(allTypeColumns[3].name, data[2][3],
              prefix: '@', paramBinder: dsqlite.bindDouble),
          dsqlite.NameParameter(allTypeColumns[5].name, data[2][4],
              prefix: '@', paramBinder: dsqlite.bindDateTime),
          dsqlite.NameParameter(allTypeColumns[4].name, data[2][5],
              prefix: '@', paramBinder: dsqlite.bindBlob),
          dsqlite.NameParameter(allTypeColumns[6].name, data[2][6],
              prefix: '@', paramBinder: dsqlite.bindUri),
          dsqlite.NameParameter(allTypeColumns[7].name, data[2][7],
              prefix: '@', paramBinder: dsqlite.bindRegExp),
          dsqlite.NameParameter(allTypeColumns[8].name, data[2][8],
              prefix: '@', paramBinder: data[2][8] is int ? dsqlite.bindInt : dsqlite.bindDouble),
          dsqlite.NameParameter(allTypeColumns[9].name, data[2][9],
              prefix: '@', paramBinder: dsqlite.bindDuration),
        ],
      );
      expect(changes.rowsAffected, 1);
    });
  });

  test('Test limit', () async {
    await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
      final _ = db as dsqlite.Database;
      await db.exec(simpleTable);
      db.setLimit(sqlite.LIMIT_SQL_LENGTH, 10);
      expect(() async => await db.prepare('SELECT * FROM `simple`;'), throwsException);
      db.setLimit(sqlite.LIMIT_SQL_LENGTH, 100);
      final stmt = (await db.prepare('SELECT * FROM `simple`;'))..close();
      expect(stmt, isNotNull);
    });
  });

  test('Test attach and detach', () async {
    await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
      final _ = db as dsqlite.Database;
      final n1 = ds.next(dbFiles);
      final d1 = [
        [1, 'test'],
        [2, 'abc'],
        [3, 'xyz']
      ];
      final n2 = ds.next(dbFiles);
      final d2 = [
        [5, 'tset'],
        [6, 'cba'],
        [7, 'zyx']
      ];
      await sqldb.protect(driverName, n1, block: (db) async {
        await db.exec('CREATE TABLE `table1`(id INTEGER, name TEXT);');
        await db.exec('INSERT INTO `table1` VALUES(?,?),(?,?),(?,?);',
            parameters: d1.expand((e) => e));
      });
      await sqldb.protect(driverName, n2, block: (db) async {
        await db.exec('CREATE TABLE `table2`(id INTEGER, name TEXT);');
        await db.exec('INSERT INTO `table2` VALUES(?,?),(?,?),(?,?);',
            parameters: d2.expand((e) => e));
      });
      await db.attach(n1.name, 'dbN1');
      await db.attach(n2.name, 'dbN2');
      // test select query
      await db.protectQuery<sqldb.Row>('SELECT * FROM `table1`;', block: (rows) async {
        expect(rows.moveNext(), true);
        expect([rows.current.intValueBy('id'), rows.current.stringValueBy('name')], d1[0]);
      });
      await db.protectQuery<sqldb.Row>('SELECT * FROM dbN1.`table1`;', block: (rows) async {
        expect(rows.moveNext(), true);
        expect([rows.current.intValueBy('id'), rows.current.stringValueBy('name')], d1[0]);
      });
      await db.protectQuery<sqldb.Row>('SELECT * FROM `table2`;', block: (rows) async {
        expect(rows.moveNext(), true);
        expect([rows.current.intValueBy('id'), rows.current.stringValueBy('name')], d2[0]);
      });
      await db.protectQuery<sqldb.Row>('SELECT * FROM dbN2.`table2`;', block: (rows) async {
        expect(rows.moveNext(), true);
        expect([rows.current.intValueBy('id'), rows.current.stringValueBy('name')], d2[0]);
      });
      await db.detach('dbN2');
      expect(() async => await db.prepare('SELECT * FROM `table2`;'), throwsException);
      expect(() async => await db.prepare('SELECT * FROM dbN2.`table2`;'), throwsException);
    });
  });
}
