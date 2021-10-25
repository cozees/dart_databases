@TestOn('vm')
library native_test;

import 'dart:ffi';
import 'dart:typed_data';

import 'package:database_sql/database_sql.dart' as sqldb;
import 'package:dsqlite/dsqlite.dart' as dsqlite;
import 'package:dsqlite/sqlite.dart';
import 'package:dsqlite/sqlite_native.dart' as native;
import 'package:ffi/ffi.dart';
import 'package:logging/logging.dart';
import 'package:test/scaffolding.dart';
import 'package:test/test.dart';

import 'common/common.dart';

// global access to binding c api
late final native.SQLiteLibrary ffiNative;

void main() {
  const driverName = 'sqlite';
  final dbFiles = <Future Function()>[];
  final ds = IncrementalDataSource.ds('backup');
  final simples = Simple.generate(1000);
  late final dsqlite.Database db;

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
    ffiNative = dsqlite.Driver.binder.nativeLibrary;
    // populate database
    db = sqldb.open(driverName, ds.next(dbFiles)) as dsqlite.Database;
    await db.exec(simpleTable);
    final statement = await db.prepare(simpleTableInsertBindIndex).write();
    final readStmt =
        await db.prepare('SELECT created_at, updated_at FROM simple WHERE id=?').read();
    for (var simple in simples) {
      var change = await statement.exec(reusable: true, parameters: [
        simple.name,
        simple.alias,
        simple.serialNo,
        simple.level,
        simple.classification,
      ]);
      simple.id = change.lastInsertId;
      var rows = await readStmt.query<sqldb.Row>(parameters: [simple.id]);
      expect(rows.moveNext(), true);
      simple.createdAt = rows.current.valueAt(0);
      simple.updatedAt = rows.current.valueAt(1);
      readStmt.reset();
      statement.reset();
    }
    readStmt.close();
    statement.close();
  });

  tearDownAll(() async {
    db.close();
    for (var f in dbFiles) {
      await f();
    }
  });

  test('Test Backup', () async {
    await sqldb.protect(driverName, ds.next(dbFiles), block: (backupDB) async {
      final _ = backupDB as dsqlite.Database;
      final pb = ffiNative.backup_init(backupDB.native, 'main', db.native, 'main');
      expect(pb, isNotNull);
      var pageCopied = 0;
      while (true) {
        var result = ffiNative.backup_step(pb!, 1);
        if (result == native.DONE) {
          ffiNative.backup_finish(pb);
          break;
        }
        expect(result, native.OK);
        pageCopied++;
        var total = ffiNative.backup_pagecount(pb);
        expect(ffiNative.backup_remaining(pb), total - pageCopied);
      }
      // check if data copied
      await backupDB.protectQuery<Simple>(
        'SELECT * FROM simple;',
        creator: (r) => Simple.db(r),
        block: (rows) async {
          int count = 0;
          while (rows.moveNext()) {
            expect(rows.current, simples[count]);
            count++;
          }
          expect(count, simples.length);
        },
      );
    });
  });

  test('Test Binding', () async {
    final stmt = await db.prepare('SELECT * FROM simple WHERE serial_no=@sn').read();
    final rows = await stmt.query<Simple>(creator: (r) => Simple.db(r), parameters: [
      dsqlite.NameParameter<String>(
        'sn',
        simples.first.serialNo,
        prefix: '@',
        paramBinder: (stmt, val, i) => ffiNative.bind_text64(stmt.native, i, val, native.UTF8),
      )
    ]);
    expect(rows.moveNext(), true);
    expect(rows.current, simples.first);
    stmt.close();
    final data = [
      Uint8List.fromList([1, 2, 3, 4, 5, 6]),
      Uint8List.fromList(List.filled(5, 0)),
      Uint8List.fromList(List.filled(10, 0)),
    ];
    await db.exec('CREATE TABLE blobtest(bin BLOB);');
    await db.exec('INSERT INTO blobtest VALUES(?),(?),(?);', parameters: [
      dsqlite.IndexParameter<Uint8List>(
        1,
        data[0],
        (stmt, val, i) => ffiNative.bind_blob64(stmt.native, i, val),
      ),
      dsqlite.IndexParameter<Uint8List>(
        2,
        null,
        (stmt, val, i) => ffiNative.bind_zeroblob(stmt.native, i, 5),
      ),
      dsqlite.IndexParameter<Uint8List>(
        3,
        null,
        (stmt, val, i) => ffiNative.bind_zeroblob64(stmt.native, i, 10),
      ),
    ]);
    await db.protectQuery<sqldb.Row>('SELECT * FROM blobtest', block: (rows) async {
      expect(rows.moveNext(), true);
      expect(rows.current.blobValueAt(0), data[0]);
      expect(rows.moveNext(), true);
      expect(rows.current.blobValueAt(0), data[1]);
      expect(rows.moveNext(), true);
      expect(rows.current.blobValueAt(0), data[2]);
    });
  });

  test('Test Context', () async {
    final nullptr = native.nullptr;
    final binder = dsqlite.Driver.binder;
    final ptr = native.malloc<native.Int32>();
    ptr.value = 110011;
    binder.create_function_compat(db.native, 'aaa', 1, native.UTF8, ptr.cast(),
        native.Pointer.fromFunction(aaaFunc), nullptr, nullptr, nullptr);
    await db.protectQuery<sqldb.Row>(
      'SELECT aaa(2);',
      block: (rows) async {
        expect(rows.moveNext(), true);
        expect(rows.current.stringValueAt(0), '>>>2::110011::${db.native.address}<<<');
      },
    );
    native.free(ptr);
  });

  final queries = [
    [
      'SELECT * FROM simple WHERE serial_no=@sn;',
      'SELECT * FROM simple WHERE serial_no=\'${simples.first.serialNo}\';',
    ],
    [
      'SELECT * FROM simple WHERE level=@lvl;',
      'SELECT * FROM simple WHERE level=${simples.first.level};',
    ],
    [
      'DELETE FROM simple WHERE level=@lvl;',
    ]
  ];

  test('Test Statement APIs', () async {
    final pName = dsqlite.NameParameter<String>('sn', simples.first.serialNo, prefix: '@');
    final stmt1 = (await db.prepare(queries[0][0]).read()) as dsqlite.Statement;
    final stmt2 = (await db.prepare(queries[1][0]).read()) as dsqlite.Statement;
    final stmt3 = (await db.prepare(queries[2][0]).write()) as dsqlite.Statement;
    // next_stmt api, this api is version dependent
    expect(ffiNative.next_stmt(db.native, native.nullptr), stmt3.native);
    expect(ffiNative.next_stmt(db.native, stmt3.native), stmt2.native);
    expect(ffiNative.next_stmt(db.native, stmt2.native), stmt1.native);
    expect(ffiNative.next_stmt(db.native, stmt1.native), null);
    // db_handle api, this api is version dependent
    expect(ffiNative.db_handle(stmt1.native), db.native);
    expect(ffiNative.db_handle(stmt2.native), db.native);
    // sql api
    expect(ffiNative.sql(stmt1.native), queries[0][0]);
    expect(ffiNative.sql(stmt2.native), queries[1][0]);
    expect(ffiNative.bind_text(stmt1.native, 1, simples.first.serialNo), native.OK);
    expect(ffiNative.bind_int(stmt2.native, 1, simples.first.level), native.OK);
    expect(ffiNative.expanded_sql(stmt1.native), queries[0][1]);
    expect(ffiNative.expanded_sql(stmt2.native), queries[1][1]);
    // See: https://www.sqlite.org/capi3ref.html#sqlite3_expanded_sql
    // sqlite3_normalized_sql is unspecified and subject to chance thus now only care if it return
    // any string and null.
    expect(ffiNative.normalized_sql(stmt1.native), isNotNull);
    expect(ffiNative.normalized_sql(stmt2.native), isNotNull);
    // test general api related to statment
    expect(ffiNative.stmt_isexplain(stmt1.native), 0);
    expect(ffiNative.stmt_isexplain(native.nullptr), 0);
    expect(ffiNative.stmt_readonly(stmt1.native), isNot(0));
    expect(ffiNative.stmt_readonly(stmt3.native), 0);
    expect(ffiNative.stmt_status(stmt1.native, native.STMTSTATUS_RUN, 0), 0);
    expect(ffiNative.stmt_busy(stmt1.native), 0);
    final rows1 = await stmt1.query(parameters: [pName]);
    expect(ffiNative.stmt_busy(stmt1.native), 0);
    expect(rows1.moveNext(), true);
    expect(ffiNative.stmt_status(stmt1.native, native.STMTSTATUS_RUN, 0), 1);
    expect(ffiNative.stmt_busy(stmt1.native), greaterThan(0));
    // scan status
    final pOut = native.malloc<native.Int32>();
    expect(ffiNative.stmt_scanstatus(stmt2.native, 0, native.SCANSTAT_SELECTID, pOut.cast()),
        native.OK);
    expect(pOut.value, 2);
    ffiNative.stmt_scanstatus_reset(stmt2.native);
    expect(ffiNative.stmt_scanstatus(stmt2.native, 0, native.SCANSTAT_SELECTID, pOut.cast()),
        native.OK);
    expect(pOut.value, 2);
    native.free(pOut);
    // free result
    stmt1.close();
    stmt2.close();
    stmt3.close();
  });

  test('Test raw reader api', () async {
    ffiNative.create_function(db.native, 'mmmvv', -1, native.UTF8, native.nullptr,
        native.Pointer.fromFunction(mmmFunc), native.nullptr, native.nullptr);
    ffiNative.create_function(db.native, 'mmmle', -1, native.UTF16LE, native.nullptr,
        native.Pointer.fromFunction(mmm16leFunc), native.nullptr, native.nullptr);
    ffiNative.create_function(db.native, 'mmmbe', -1, native.UTF16BE, native.nullptr,
        native.Pointer.fromFunction(mmm16beFunc), native.nullptr, native.nullptr);
    await db.protectQuery<sqldb.Row>("SELECT mmmvv('why'),mmmle('abc'),mmmbe('xyz');",
        block: (rows) async {
      expect(rows.moveNext(), true);
      expect(rows.current.stringValueAt(0), 'true::0::0');
      expect(rows.current.stringValueAt(1), 'abc');
      expect(rows.current.stringValueAt(2), 'xyz');
    });
  });

  test('Test result api', () async {
    ffiNative.create_function(db.native, 'resultTest', -1, native.UTF8, native.nullptr,
        native.Pointer.fromFunction(resultTest), native.nullptr, native.nullptr);
    for (var i = 0; i < result.length; i++) {
      await db.protectQuery<sqldb.Row>('SELECT resultTest($i);', block: (rows) async {
        expect(rows.moveNext(), true);
        if (i == result.length - 1) {
          expect(rows.current.stringValueAt(0), '${result[i]}');
        } else if (result[i] is String) {
          expect(rows.current.stringValueAt(0), result[i]);
        } else if (result[i] is Uint8List) {
          expect(rows.current.blobValueAt(0), result[i]);
        } else {
          throw Exception('Illegal state test.');
        }
      });
    }
  });

  test('Test collation Function', () async {
    ffiNative.collation_needed(db.native, nullptr, Pointer.fromFunction(collationNeedUtf8));
    await db.exec('CREATE TABLE test(txt TEXT COLLATE COLLATION_TEST);');
    await db.exec("INSERT INTO test VALUES('test'), ('xyz'), ('abc')");
    await db.protectQuery<sqldb.Row>("SELECT * FROM test WHERE txt='abc' OR txt='test';",
        block: (rows) async {
      expect(rows.moveNext(), true);
      expect(rows.current.stringValueAt(0), 'test');
      expect(rows.moveNext(), true);
      expect(rows.current.stringValueAt(0), 'abc');
    });
    // remove utf8 needed
    ffiNative.collation_needed(db.native, nullptr, nullptr);
    // register utf16 need
    ffiNative.collation_needed16(db.native, nullptr, Pointer.fromFunction(collationNeed));
    await db.exec('CREATE TABLE abc(txt TEXT COLLATE COLLATION_ABC);');
    await db.exec("INSERT INTO test VALUES('123'), ('iom'), ('7u3')");
    await db.protectQuery<sqldb.Row>("SELECT * FROM test WHERE txt='7u3' OR txt='123';",
        block: (rows) async {
      expect(rows.moveNext(), true);
      expect(rows.current.stringValueAt(0), '123');
      expect(rows.moveNext(), true);
      expect(rows.current.stringValueAt(0), '7u3');
    });
  });

  test('Test Window Function', () async {
    expect(
        ffiNative.create_window_function(
            db.native,
            'sumint',
            1,
            native.UTF8,
            native.nullptr,
            WindowFunction.ptrStep,
            WindowFunction.ptrFinal,
            WindowFunction.ptrValue,
            WindowFunction.ptrInverse,
            native.nullptr),
        native.OK);
    await db.exec('CREATE TABLE t3(x, y);');
    await db.exec("INSERT INTO t3 VALUES('a', 4),('b', 5),('c', 3);");
    await db.protectQuery<ValXY>(
        'SELECT x, sumint(y) OVER ('
        'ORDER BY x ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING'
        ') AS sum_y '
        'FROM t3 ORDER BY x;',
        creator: ValXY.creator, block: (rows) async {
      expect(rows.moveNext(), true);
      expect(rows.current, ValXY('a', null, 9));
      expect(rows.moveNext(), true);
      expect(rows.current, ValXY('b', null, 12));
      expect(rows.moveNext(), true);
      expect(rows.current, ValXY('c', null, 8));
    });
  });

  test('Test extension', () async {
    final origin = Uint8List.fromList(List.generate(10, (index) => index + 1));
    var cptr = origin.toNative(zeroTerminate: true);
    expect(cptr, isNot(nullptr));
    final bin = cptr.cast<Uint8>();
    expect(bin.length, origin.length);
    expect(bin.toUint8List(), origin);
    free(cptr);
    cptr = origin.toNative();
    expect(cptr, isNot(nullptr));
    expect(cptr.cast<Uint8>().toUint8List(length: origin.length), origin);
    free(cptr);
  });

  test('Test Pre-udpate hook', () async {
    expect(
        ffiNative.preupdate_hook(db.native, Pointer.fromFunction(preUpdateHook), nullptr), nullptr);
    await db.exec('DELETE FROM simple WHERE serial_no=?;', parameters: [simples.first.serialNo]);
    await db.exec('UPDATE simple SET level=1010 WHERE serial_no=?;', parameters: [
      simples.last.serialNo,
    ]);
    simples.add(Simple.generate(1).first);
    final changes = await db.exec(simpleTableInsertBindName, parameters: [
      dsqlite.NameParameter('name', simples.last.name, prefix: ':'),
      dsqlite.NameParameter('alias', simples.last.alias, prefix: '\$'),
      dsqlite.NameParameter('serial_no', simples.last.serialNo, prefix: '@'),
      dsqlite.NameParameter('level', simples.last.level, prefix: ':'),
      dsqlite.NameParameter('classification', simples.last.classification, prefix: ':'),
    ]);
    simples.last.id = changes.lastInsertId;
    await db.protectQuery<Simple>('SELECT * FROM simple WHERE id=${changes.lastInsertId}',
        creator: (r) => Simple.db(r),
        block: (rows) async {
          rows.moveNext();
          simples.last.createdAt = rows.current.createdAt;
          simples.last.updatedAt = rows.current.updatedAt;
        });
    expect(preChanges[native.DELETE]!.length, 1);
    expect(preChanges[native.DELETE]!.first, AZ(8, 0, -1, simples.first));
    expect(preChanges[native.UPDATE]!.length, 1);
    expect(preChanges[native.UPDATE]!.first, AZ(8, 0, -1, simples[simples.length - 2]));
    expect(preChanges[native.INSERT]!.length, 1);
    expect(preChanges[native.INSERT]!.first, AZ(8, 0, -1, simples.last));
  });
}

class AZ {
  AZ(this.count, this.depth, this.write, this.simple);

  final int count;
  final int depth;
  final int write;
  final Simple simple;

  @override
  int get hashCode => toString().hashCode;

  @override
  bool operator ==(covariant AZ other) =>
      count == other.count &&
      depth == other.depth &&
      write == other.write &&
      simple == other.simple;

  @override
  String toString() => '$count::$depth::$write::${simple.toString()}';
}

final preChanges = {
  native.INSERT: <AZ>[],
  native.DELETE: <AZ>[],
  native.UPDATE: <AZ>[],
};

void preUpdateHook(
  native.PtrVoid _,
  native.PtrSqlite3 db,
  int op,
  native.PtrString dbName,
  native.PtrString tbName,
  int duId,
  int nId,
) {
  late final updateDate;
  if (op == native.UPDATE || op == native.DELETE) {
    updateDate = ffiNative.preupdate_old;
  } else if (op == native.INSERT) {
    updateDate = ffiNative.preupdate_new;
  } else {
    throw Exception('Should never reach');
  }
  final ptrPtrVal = native.malloc<native.PtrValue>();
  final count = ffiNative.preupdate_count(db);
  assert(count == 8);
  final values = [];
  for (var i = 0; i < count; i++) {
    expect(updateDate(db, i, ptrPtrVal), native.OK);
    if (i == 0) {
      values.add(ffiNative.value_int64(ptrPtrVal.value));
    } else if (i < 4) {
      values.add(ffiNative.value_text(ptrPtrVal.value));
    } else if (i < 6) {
      values.add(ffiNative.value_int(ptrPtrVal.value));
    } else {
      values.add(DateTime.parse(ffiNative.value_text(ptrPtrVal.value)!));
    }
  }
  preChanges[op]!.add(AZ(
    count,
    ffiNative.preupdate_depth(db),
    ffiNative.preupdate_blobwrite(db),
    Simple(
      values[1],
      values[2],
      values[3],
      values[4],
      values[5],
    )
      ..id = values[0]
      ..updatedAt = values[6]
      ..createdAt = values[7],
  ));
  native.free(ptrPtrVal);
}

void collationNeedUtf8(native.PtrVoid _, native.PtrSqlite3 db, int encode, Pointer<Utf8> txt) {
  ffiNative.create_collation_v2(db, txt.cast<Utf8>().toDartString(), native.UTF8, nullptr,
      Pointer.fromFunction(collationUtf81, native.FAIL), nullptr);
}

void collationNeed(native.PtrVoid _, native.PtrSqlite3 db, int encode, native.PtrVoid txt) {
  ffiNative.create_collation16(
      db, txt, native.UTF8, nullptr, Pointer.fromFunction(collationUtf81, native.FAIL));
}

int collationUtf81(native.PtrVoid _, int al, native.PtrVoid a, int bl, native.PtrVoid b) {
  final da = a.cast<Utf8>().toDartString(length: al);
  final db = b.cast<Utf8>().toDartString(length: bl);
  return da.compareTo(db);
}

final result = [
  Uint8List.fromList(List.generate(20, (index) => index)),
  'text64 utf8',
  'text64 utf16',
  'test utf16le',
  'test utf16be',
  Uint8List.fromList(List.filled(10, 0)),
  Uint8List.fromList(List.filled(20, 0)),
  123,
];

void resultTest(native.PtrContext ctx, int c, native.PtrPtrValue values) {
  if (ffiNative.value_type(values[0]) == native.INTEGER) {
    final val = ffiNative.value_int(values[0]);
    if (0 <= val && val < result.length) {
      switch (val) {
        case 0:
          ffiNative.result_blob64(ctx, result[val] as Uint8List);
          break;
        case 1:
          ffiNative.result_text64(ctx, result[val] as String, native.UTF8);
          break;
        case 2:
          ffiNative.result_text64(ctx, result[val] as String, native.UTF16);
          break;
        case 3:
          final txt = result[val] as String;
          ffiNative.result_text16le(ctx, encode16From(txt, Endian.little).cast(), txt.length * 2,
              Pointer.fromFunction(releaseResource));
          break;
        case 4:
          final txt = result[val] as String;
          ffiNative.result_text16be(ctx, encode16From(txt, Endian.big).cast(), txt.length * 2,
              Pointer.fromFunction(releaseResource));
          break;
        case 5:
          ffiNative.result_zeroblob(ctx, (result[val] as Uint8List).length);
          break;
        case 6:
          ffiNative.result_zeroblob64(ctx, (result[val] as Uint8List).length);
          break;
        case 7:
          ffiNative.result_int(ctx, result[val] as int);
          ffiNative.result_subtype(ctx, native.TEXT);
          break;
      }
      return;
    }
  }
  ffiNative.result_error(ctx, 'unsupported argument');
}

void releaseResource(Pointer<Void> ptr) => native.free(ptr);

void mmm16leFunc(native.PtrContext ctx, int c, native.PtrPtrValue values) {
  final binary = ffiNative.value_text16be(values[0])!.cast<Uint8>();
  ffiNative.result_text(ctx, readString16From(binary, Endian.little));
}

void mmm16beFunc(native.PtrContext ctx, int c, native.PtrPtrValue values) {
  final binary = ffiNative.value_text16le(values[0])!.cast<Uint8>();
  ffiNative.result_text(ctx, readString16From(binary, Endian.big));
}

String readString16From(native.Pointer<Uint8> bin, Endian ed) {
  final buffer = StringBuffer();
  final bd = ByteData(2);
  var i = 0;
  while (true) {
    bd.setUint8(1, bin.elementAt(i++).value);
    bd.setUint8(0, bin.elementAt(i++).value);
    final char = bd.getUint16(0, ed);
    if (char == 0) {
      return buffer.toString();
    }
    buffer.writeCharCode(char);
  }
}

native.Pointer<Uint16> encode16From(String it, Endian ed) {
  final units = it.codeUnits;
  final Pointer<Uint16> result = native.malloc<Uint16>(units.length + 1);
  final Uint16List nativeString = result.asTypedList(units.length + 1);
  if (Endian.little == ed) {
    nativeString.setRange(0, units.length, units);
    nativeString[units.length] = 0;
  } else {
    final bd = nativeString.buffer.asByteData();
    var i = 0;
    for (var ll in units) {
      bd.setUint16(i, ll);
      i += 2;
    }
    nativeString[units.length] = 0;
  }
  return result;
}

void mmmFunc(native.PtrContext ctx, int c, native.PtrPtrValue values) {
  final dv = ffiNative.value_dup(values[0]);
  final ev = ffiNative.value_text(dv!) == ffiNative.value_text(values[0]);
  ffiNative.value_free(dv);
  final i = ffiNative.value_nochange(values[0]);
  final t = ffiNative.value_subtype(values[0]);
  ffiNative.result_text(ctx, '$ev::$i::$t');
}

void aaaFunc(native.PtrContext ctx, int c, native.PtrPtrValue values) {
  final i = dsqlite.Driver.binder.value_int(values[0]);
  final p = dsqlite.Driver.binder.user_data(ctx)?.cast<native.Int32>().value;
  final ndb = dsqlite.Driver.binder.nativeLibrary.context_db_handle(ctx);
  dsqlite.Driver.binder.result_text(ctx, '>>>$i::$p::${ndb.address}<<<');
}

class ValXY {
  ValXY(this.x, this.y, this.sumy);

  final String x;
  final int? y;
  final int? sumy;

  static ValXY creator(sqldb.RowReader r) =>
      ValXY(r.stringValueBy('x')!, null, r.intValueBy('sum_y'));

  @override
  int get hashCode => toString().hashCode;

  @override
  bool operator ==(covariant ValXY other) => x == other.x && y == other.y && sumy == other.sumy;

  @override
  String toString() => '$x::$y::$sumy';
}

class WindowFunction {
  static final ptrStep = Pointer.fromFunction<native.DefpxFunc>(step);
  static final ptrInverse = Pointer.fromFunction<native.DefpxFunc>(inverse);
  static final ptrFinal = Pointer.fromFunction<native.DefxFinal>(final$);
  static final ptrValue = Pointer.fromFunction<native.DefxFinal>(value);

  static void step(native.PtrContext ctx, int c, native.PtrPtrValue values) {
    if (ffiNative.value_type(values[0]) != native.INTEGER) {
      ffiNative.result_error(ctx, "invalid argument");
      return;
    }
    final pInt = ffiNative.aggregate_context(ctx, 8)!.cast<native.Int64>();
    if (pInt != native.nullptr) pInt.value += ffiNative.value_int64(values[0]);
  }

  static void inverse(native.PtrContext ctx, int c, native.PtrPtrValue values) {
    final pInt = ffiNative.aggregate_context(ctx, 8)!.cast<native.Int64>();
    if (pInt != native.nullptr) pInt.value -= ffiNative.value_int64(values[0]);
  }

  static void final$(native.PtrContext ctx) {
    final pInt = ffiNative.aggregate_context(ctx, 0);
    ffiNative.result_int64(ctx, pInt != null ? pInt.cast<native.Int64>().value : 0);
  }

  static void value(native.PtrContext ctx) {
    final pInt = ffiNative.aggregate_context(ctx, 0);
    ffiNative.result_int64(ctx, pInt != null ? pInt.cast<native.Int64>().value : 0);
  }
}
