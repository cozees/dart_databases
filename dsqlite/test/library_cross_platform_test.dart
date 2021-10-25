library cross_apis.test;

import 'package:database_sql/database_sql.dart' as sqldb;
import 'package:dsqlite/dsqlite.dart' as dsqlite;
import 'package:dsqlite/sqlite.dart' as sqlite;
import 'package:logging/logging.dart';
import 'package:test/test.dart';

import 'common/common.dart';

final counts = <int>[];
final inColumns = <String>[];
final inValues = <String>[];

int callback(sqlite.PtrVoid _, int count, sqlite.PtrPtrUtf8 values, sqlite.PtrPtrUtf8 columns) {
  counts.add(count);
  inColumns.add(columns[0].toDartString());
  inValues.add(values[0].toDartString());
  return sqlite.OK;
}

int cmpCallCount = 0;

int cmp(sqlite.PtrVoid _, int al, sqlite.PtrVoid a, int bl, sqlite.PtrVoid b) {
  final da = a.cast<sqlite.Utf16>().toDartString(length: sqlite.isNative ? al ~/ 2 : al);
  final db = b.cast<sqlite.Utf16>().toDartString(length: sqlite.isNative ? bl ~/ 2 : bl);
  cmpCallCount++;
  return da.compareTo(db);
}

class ExpectedValue {
  ExpectedValue(this.val, this.getter);

  final dynamic val;
  final dynamic Function(sqlite.PtrSqlite3, sqldb.Row?) getter;
}

const errorMsg = 'dummy error only';
final expected = <dynamic, ExpectedValue>{
  0: ExpectedValue(sqlite.NOMEM, (ndb, _) => dsqlite.Driver.binder.errcode(ndb)),
  1: ExpectedValue(sqlite.TOOBIG, (ndb, _) => dsqlite.Driver.binder.errcode(ndb)),
  2: ExpectedValue(1010, (ndb, _) => dsqlite.Driver.binder.errcode(ndb)),
  3: ExpectedValue(
    dsqlite.SQLiteException.withCode(
      code: sqlite.ERROR,
      message: errorMsg,
      detail: '${dsqlite.Driver.binder.errstr(sqlite.ERROR)} (code ${sqlite.ERROR})',
    ),
    (_, __) => throw Exception('Must catch exception'),
  ),
  // none error
  4: ExpectedValue(1, (_, row) => row!.intValueBy('result')),
  'data': ExpectedValue('4::8::data', (_, row) => row!.stringValueBy('result')),
};

void func(sqlite.PtrContext ctx, int count, sqlite.PtrPtrValue values) {
  final binder = dsqlite.Driver.binder;
  final type = binder.value_type(values[0]);
  if (type == sqlite.INTEGER) {
    if (binder.value_int(values[0]) == 0) {
      binder.result_error_nomem(ctx);
    } else if (binder.value_int(values[0]) == 1) {
      binder.result_error_toobig(ctx);
    } else if (binder.value_int(values[0]) == 2) {
      binder.result_error_code(ctx, 1010);
    } else if (binder.value_int(values[0]) == 3) {
      binder.result_error16(ctx, errorMsg);
    } else if (binder.value_int(values[0]) == 4) {
      dsqlite.applyIntResult(ctx, 1);
    }
  } else if (type == sqlite.TEXT) {
    final i1 = binder.value_bytes(values[0]);
    final i2 = binder.value_bytes16(values[0]);
    binder.result_text16(ctx, '$i1::$i2::${binder.value_text16(values[0])!}');
  } else {
    final nt = binder.value_numeric_type(values[0]);
    final fb = binder.value_frombind(values[0]);
    if (nt == sqlite.FLOAT) {
      binder.result_text(ctx, '$nt::$fb::${binder.value_double(values[0])}');
    } else {
      binder.result_text(ctx, '$nt::$fb');
    }
  }
}

void main() async {
  const driverName = 'sqlite';
  final dbFiles = <Future Function()>[];
  final ds = IncrementalDataSource.ds('cross_lib');

  setUpAll(() async {
    expect(() => dsqlite.Driver.binder, throwsException);
    sqldb.registerDriver(
      driverName,
      await dsqlite.Driver.initialize(
        path: dLibraries.first.libraryPath,
        webMountPath: dLibraries.first.mountPoint,
        logLevel: Level.ALL,
      ),
    );
  });

  tearDownAll(() async {
    for (var f in dbFiles) {
      await f();
    }
  });

  test('Test open and close api', () {
    final dsource = ds.next(dbFiles);
    final ppDb = sqlite.malloc<sqlite.PtrSqlite3>();
    expect(dsqlite.Driver.binder.open(dsource.name, ppDb), sqlite.OK);
    expect(ppDb.value, isNot(sqlite.nullptr));
    dsqlite.Driver.binder.close(ppDb.value);
    sqlite.free(ppDb);
  });

  test('Test exec callback', () {
    final dsource = ds.next(dbFiles);
    final ppDb = sqlite.malloc<sqlite.PtrSqlite3>();
    expect(dsqlite.Driver.binder.open(dsource.name, ppDb), sqlite.OK);
    final exec = dsqlite.Driver.binder.exec;
    final nullptr = sqlite.nullptr;
    expect(
      exec(ppDb.value, 'CREATE TABLE test(id int);', nullptr, nullptr, nullptr),
      sqlite.OK,
    );
    expect(
      exec(ppDb.value, 'INSERT INTO test VALUES(1),(2);', nullptr, nullptr, nullptr),
      sqlite.OK,
    );
    final ptr = sqlite.Pointer.fromFunction<sqlite.Defcallback>(callback, sqlite.FAIL);
    expect(exec(ppDb.value, 'SELECT * FROM test;', ptr, nullptr, nullptr), sqlite.OK);
    expect(counts, [1, 1]);
    expect(inColumns, ['id', 'id']);
    expect(inValues, ['1', '2']);
    dsqlite.Driver.binder.close(ppDb.value);
    sqlite.free(ppDb);
  });

  test('Test prepare statement', () {
    final dsource = ds.next(dbFiles);
    final ppDb = sqlite.malloc<sqlite.PtrSqlite3>();
    expect(dsqlite.Driver.binder.open(dsource.name, ppDb), sqlite.OK);
    final ppStmt = sqlite.malloc<sqlite.PtrStmt>();
    final tail = sqlite.malloc<sqlite.Pointer<sqlite.Utf8>>();
    expect(
      dsqlite.Driver.binder.exec(
          ppDb.value, 'CREATE TABLE test(id int);', sqlite.nullptr, sqlite.nullptr, sqlite.nullptr),
      sqlite.OK,
    );
    // test v1
    expect(
        dsqlite.Driver.binder.prepare(ppDb.value, 'SELECT * FROM test;', ppStmt, tail), sqlite.OK);
    expect(ppStmt.value, isNot(sqlite.nullptr));
    expect(tail.value.address, 0);
    dsqlite.Driver.binder.finalize(ppStmt.value);
    // test v2
    expect(dsqlite.Driver.binder.prepare_v2(ppDb.value, 'SELECT * FROM test;', ppStmt, tail),
        sqlite.OK);
    expect(ppStmt.value, isNot(sqlite.nullptr));
    expect(tail.value.address, 0);
    dsqlite.Driver.binder.finalize(ppStmt.value);
    // close connection and free resource
    dsqlite.Driver.binder.close(ppDb.value);
    sqlite.free(ppStmt);
    sqlite.free(tail);
    sqlite.free(ppDb);
  });

  test('Test column raw api', () async {
    await sqldb.protect(driverName, ds.next(dbFiles), block: (sqldb.Database db) async {
      final _ = db as dsqlite.Database;
      final binder = dsqlite.Driver.binder;
      // create table and add data
      final simples = Simple.generate(10);
      await db.exec(simpleTable);
      final stmtWrite = await db.prepare(simpleTableInsertBindNameU).write();
      await stmtWrite.exec(parameters: simples.first.toParameter(), reusable: true);
      stmtWrite.reset();
      await stmtWrite.exec(parameters: simples.last.toParameter(), reusable: true);
      stmtWrite.close();
      // check parameter name
      await db.withNative((ndb) async {
        expect(binder.total_changes(ndb), 2);
        expect(binder.changes(ndb), 1);
        var stmt = await db.prepare('SELECT * FROM `simple` WHERE id=@id AND name=@name;');
        var _ = stmt as dsqlite.Statement;
        await stmt.withNative((nStmt) async {
          expect(binder.bind_parameter_count(nStmt), 2);
          expect(binder.bind_parameter_name(nStmt, 1), '@id');
          expect(binder.bind_parameter_name(nStmt, 2), '@name');
        });
        stmt.close();
        // check column value
        stmt = await db.prepare('SELECT name as ns, level as lvl  FROM `simple` as stb LIMIT 2;');
        _ = stmt as dsqlite.Statement;
        final rows = await stmt.read().query<sqldb.Row>();
        expect(rows.moveNext(), true);
        expect(rows.current.intValueBy('lvl', true), simples.first.level);
        stmt.reset();
        await stmt.withNative((nStmt) async {
          expect(binder.step(nStmt), sqlite.ROW);
          expect(binder.data_count(nStmt), 2);
          expect(binder.column_name(nStmt, 0), 'ns');
          expect(binder.column_name16(nStmt, 0), 'ns');
          expect(binder.column_name(nStmt, 1), 'lvl');
          expect(binder.column_name16(nStmt, 1), 'lvl');
          expect(binder.column_int(nStmt, 1), simples.first.level);
          expect(binder.column_bytes(nStmt, 0), simples.first.name.length);
          expect(binder.column_text(nStmt, 0), simples.first.name);
          expect(binder.column_database_name(nStmt, 0), 'main');
          expect(binder.column_database_name16(nStmt, 0), 'main');
          expect(binder.column_table_name(nStmt, 0), 'simple');
          expect(binder.column_table_name16(nStmt, 0), 'simple');
          expect(binder.column_origin_name(nStmt, 0), 'name');
          expect(binder.column_origin_name16(nStmt, 0), 'name');
          expect(binder.column_origin_name(nStmt, 1), 'level');
          expect(binder.column_origin_name16(nStmt, 1), 'level');
          // special case for utf16
          expect(binder.column_bytes16(nStmt, 0), simples.first.name.length * 2);
          expect(binder.column_text16(nStmt, 0), simples.first.name);
        });
        stmt.close();
      });
    });
    // test initial content text with utf16
    await sqldb.protect(driverName, ds.next(dbFiles), block: (sqldb.Database db) async {
      final binder = dsqlite.Driver.binder;
      // ignore: prefer_function_declarations_over_variables
      final binderTxT16 = (dsqlite.Statement stmt, String? value, int index) {
        return binder.bind_text16(stmt.native, index, value);
      };
      final data = ['test123', 'abcdef'];
      await db.exec('CREATE TABLE abc(id INTEGER, txt TEXT);');
      await db.exec('INSERT INTO abc VALUES(1, ?),(2, ?);', parameters: [
        dsqlite.IndexParameter(1, data[0], binderTxT16),
        dsqlite.IndexParameter(2, data[1], binderTxT16),
      ]);
      final stmt = await db.prepare('SELECT * FROM abc;');
      final _ = stmt as dsqlite.Statement;
      await stmt.withNative((nStmt) async {
        expect(binder.step(nStmt), sqlite.ROW);
        expect(binder.column_type(nStmt, 1), sqlite.TEXT);
        expect(binder.column_decltype16(nStmt, 1), 'TEXT');
        expect(binder.column_bytes16(nStmt, 1), data[0].codeUnits.length * 2);
        expect(binder.column_text16(nStmt, 1), data[0]);
        expect(binder.step(nStmt), sqlite.ROW);
        expect(binder.column_bytes16(nStmt, 1), data[1].codeUnits.length * 2);
        expect(binder.column_text16(nStmt, 1), data[1]);
      });
      stmt.close();
    });
  });

  test('Test utf16 open and prepare', () {
    final nullptr = sqlite.nullptr;
    final binder = dsqlite.Driver.binder;
    final dsource = ds.next(dbFiles);
    final ppDb = sqlite.malloc<sqlite.PtrSqlite3>();
    expect(binder.open16(dsource.name, ppDb), sqlite.OK);
    expect(ppDb.value, isNot(sqlite.nullptr));
    binder.exec(ppDb.value, 'CREATE TABLE abc(id INTEGER, txt TEXT);', nullptr, nullptr, nullptr);
    // prepare16
    final ppStmt = sqlite.malloc<sqlite.PtrStmt>();
    final tail = sqlite.malloc<sqlite.Pointer<sqlite.Void>>();
    expect(binder.prepare16(ppDb.value, 'SELECT * FROM abc WHERE id=?;', ppStmt, tail), sqlite.OK);
    expect(tail.value.address, 0);
    binder.finalize(ppStmt.value);
    // prepare16_v2
    expect(
        binder.prepare16_v2(ppDb.value, 'SELECT * FROM abc WHERE id=?', ppStmt, tail), sqlite.OK);
    expect(tail.value.address, 0);
    binder.finalize(ppStmt.value);
    // prepare16_v2
    expect(
      binder.prepare16_v3(ppDb.value, 'SELECT * FROM abc WHERE id=?',
          sqlite.PREPARE_NO_VTAB | sqlite.PREPARE_PERSISTENT, ppStmt, tail),
      sqlite.OK,
    );
    expect(tail.value.address, 0);
    binder.finalize(ppStmt.value);
    // close database and free resource
    binder.close(ppDb.value);
    sqlite.free(ppStmt);
    sqlite.free(ppDb);
  });

  test('Test function', () async {
    await sqldb.protect(driverName, ds.next(dbFiles), block: (sqldb.Database db) async {
      final binder = dsqlite.Driver.binder;
      final nullptr = sqlite.nullptr;
      var _ = db as dsqlite.Database;
      await db.withNative((ndb) async {
        final ptr = sqlite.Pointer.fromFunction<sqlite.DefxCompare>(cmp, sqlite.FAIL);
        cmpCallCount = 0;
        binder.create_collation_v2(ndb, 'sample', sqlite.UTF16, nullptr, ptr, nullptr);
        await db.exec('CREATE TABLE test(val DOUBLE, name TEXT COLLATE sample);');
        expect(
          (await db.exec("INSERT INTO test VALUES(1.1, 'abc'),(2.3, 'test123');")).rowsAffected,
          2,
        );
        await db.protectQuery<sqldb.Row>(
          "SELECT name FROM test WHERE name='123'",
          block: (rows) async => expect(rows.moveNext(), false),
        );
        await db.protectQuery<sqldb.Row>(
          "SELECT name FROM test WHERE name='abc'",
          block: (rows) async => expect(rows.moveNext(), true),
        );
        expect(cmpCallCount, 3);
        // create collation with utf16
        final ptrFunc = sqlite.Pointer.fromFunction<sqlite.DefpxFunc>(func);
        binder.create_function16(ndb, 'func', -1, sqlite.UTF16, nullptr, ptrFunc, nullptr, nullptr);
        for (var input in expected.keys) {
          final expVal = expected[input]!;
          await db.protectQuery<sqldb.Row>(
            'SELECT func(@input) as result;',
            parameters: [dsqlite.NameParameter('input', input, prefix: '@')],
            block: (rows) async {
              if (expVal.val is Exception) {
                expect(
                    () => rows.moveNext(),
                    throwsA(TypeMatcher<dsqlite.SQLiteException>().having(
                      (e) => e.toString(),
                      'Function error',
                      expVal.val.toString(),
                    )));
              } else {
                expect(expVal.getter(ndb, rows.moveNext() ? rows.current : null), expVal.val);
              }
            },
          );
        }
        await db.protectQuery<sqldb.Row>('SELECT func(1.2) as result;', block: (rows) async {
          expect(rows.moveNext(), true);
          expect(rows.current.stringValueAt(0), '${sqlite.FLOAT}::0::1.2');
        });
        await db.protectQuery<sqldb.Row>('SELECT func(val) as result FROM test;',
            block: (rows) async {
          expect(rows.moveNext(), true);
          expect(rows.current.stringValueAt(0), '${sqlite.FLOAT}::0::1.1');
        });
        await db.protectQuery<sqldb.Row>('SELECT func(@val) as result;',
            parameters: [dsqlite.NameParameter('val', 23.2, prefix: '@')], block: (rows) async {
          expect(rows.moveNext(), true);
          expect(rows.current.stringValueAt(0), '${sqlite.FLOAT}::1::23.2');
        });
      });
    });
  });
}
