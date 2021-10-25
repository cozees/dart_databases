@TestOn('vm')
library native_database_test;

import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
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

const driverName = 'sqlite';
const delayInsert = 5;
final simples = Simple.generate(100);

void main() {
  final dbFiles = <Future Function()>[];
  final ds = IncrementalDataSource.ds('backup');
  final dsrc = ds.next(dbFiles);
  late final dsqlite.Database db;

  setUpAll(() async {
    sqldb.registerDriver(
      driverName,
      await dsqlite.Driver.initialize(
        path: dLibraries.first.libraryPath,
        webMountPath: dLibraries.first.mountPoint,
        logLevel: Level.ALL,
      ),
    );
    db = sqldb.open(driverName, dsrc) as dsqlite.Database;
    ffiNative = dsqlite.Driver.binder.nativeLibrary;
    await db.exec(simpleTable);
    for (var simple in simples) {
      await db.exec(simpleTableInsertBindName, parameters: [
        dsqlite.NameParameter('name', simple.name, prefix: ':'),
        dsqlite.NameParameter('alias', simple.alias, prefix: '\$'),
        dsqlite.NameParameter('serial_no', simple.serialNo, prefix: '@'),
        dsqlite.NameParameter('level', simple.level, prefix: ':'),
        dsqlite.NameParameter('classification', simple.classification, prefix: ':'),
      ]);
    }
  });

  tearDownAll(() async {
    db.close();
    ffiNative.shutdown();
    for (var f in dbFiles) {
      await f();
    }
  });

  test('Test Busy Handler', () async {
    final dataSrc = ds.next(dbFiles);
    var r = ReceivePort();
    // spawn isolated
    final i1 = await Isolate.spawn<IsolateMeta>(writeData, IsolateMeta(dataSrc, r.sendPort, false));
    final i2 = await Isolate.spawn<IsolateMeta>(readData, IsolateMeta(dataSrc, r.sendPort, false));
    final result1 = await r.take(2).toList();
    expect(result1, [1, 1]);
    r.close();
    i1.kill();
    i2.kill();
    r = ReceivePort();
    final i3 = await Isolate.spawn<IsolateMeta>(writeData, IsolateMeta(dataSrc, r.sendPort, false));
    final i4 = await Isolate.spawn<IsolateMeta>(readData, IsolateMeta(dataSrc, r.sendPort, true));
    final result2 = await r.take(2).toList();
    expect(result2, [1, 1]);
    r.close();
    i3.kill();
    i4.kill();
  });

  test('Test DB Method', () async {
    expect(ffiNative.db_cacheflush(db.native), native.OK);
    expect(ffiNative.db_filename(db.native, 'main'), dsrc.name);
    expect(ffiNative.db_mutex(db.native), isNotNull);
    expect(ffiNative.db_readonly(db.native, 'main'), 0);
    expect(ffiNative.db_release_memory(db.native), native.OK);
    expect(ffiNative.enable_load_extension(db.native, 0), native.OK);
    expect(ffiNative.enable_load_extension(db.native, 1), native.OK);
    expect(ffiNative.txn_state(db.native, 'main'), native.TXN_NONE);
    expect(ffiNative.get_autocommit(db.native), isNot(0));
    await db.protectTransaction(block: (_, tx) async {
      expect(ffiNative.get_autocommit(db.native), 0);
    });
    ffiNative.set_last_insert_rowid(db.native, 2021);
    expect(ffiNative.last_insert_rowid(db.native), 2021);
    // test status
    final pCur = native.malloc<Int32>();
    final pHW = native.malloc<Int32>();
    expect(ffiNative.db_status(db.native, native.DBSTATUS_CACHE_USED, pCur, pHW, 0), native.OK);
    expect(pCur.value, greaterThanOrEqualTo(0));
    expect(pHW.value, greaterThanOrEqualTo(0));
    native.free(pCur);
    native.free(pHW);
    // serialize and deserialize
    final dbSize = native.malloc<Int64>();
    final ptrBin = ffiNative.serialize(db.native, 'main', dbSize, 0);
    expect(ptrBin, isNotNull);
    expect(ptrBin, isNot(nullptr));
    final db1 = sqldb.open(driverName, ds.next(dbFiles)) as dsqlite.Database;
    expect(
      ffiNative.deserialize(db1.native, 'main', ptrBin!, dbSize.value, dbSize.value,
          native.DESERIALIZE_FREEONCLOSE | native.DESERIALIZE_READONLY),
      native.OK,
    );
    db1.close();
    // test authorizer
    expect(
      ffiNative.set_authorizer(db.native, Pointer.fromFunction(authorizer, native.FAIL), nullptr),
      native.OK,
    );
    await db.protectQuery<sqldb.Row>('SELECT name FROM simple LIMIT 1;', block: (rows) async {
      expect(rows.moveNext(), true);
      expect(rows.current.stringValueAt(0), isNull);
    });
    await db.protectQuery<sqldb.Row>('SELECT level FROM simple LIMIT 1;', block: (rows) async {
      expect(rows.moveNext(), true);
      expect(rows.current.intValueAt(0), simples.first.level);
    });
    // test error
    expect(() async => await db.exec('SELECT * FROM notexist;'), throwsException);
    final ptrErrMsg = ffiNative.errmsg16(db.native).cast<Utf16>();
    expect(ptrErrMsg.toDartString(), 'no such table: notexist');
    expect(ffiNative.system_errno(db.native), 0);
    // test progress handler
    ffiNative.progress_handler(
        db.native, 1, Pointer.fromFunction(progressHandler, native.FAIL), nullptr);
    progressH = 0;
    await db.protectQuery('SELECT * FROM simple LIMIT 1;', block: (rows) async {
      expect(rows.moveNext(), true);
      expect(progressH, greaterThan(0));
    });
    ffiNative.progress_handler(
        db.native, 0, Pointer.fromFunction(progressHandler, native.FAIL), nullptr);
    // test profile and trace
    final sql = 'SELECT * FROM simple LIMIT 1;';
    ffiNative.profile(db.native, Pointer.fromFunction(profile), nullptr);
    await db.protectQuery(sql, block: (rows) async => expect(rows.moveNext(), true));
    expect(profileCalled, 1);
    expect(profileDuration, greaterThanOrEqualTo(0));
    ffiNative.trace(db.native, Pointer.fromFunction(trace), nullptr);
    await db.protectQuery(sql, block: (rows) async => expect(rows.moveNext(), true));
    expect(traceCalled, 1);
    expect(traceSql, sql);
    ffiNative.trace_v2(
        db.native, native.TRACE_STMT, Pointer.fromFunction(traceV2, native.FAIL), nullptr);
    await db.protectQuery(sql, block: (rows) async => expect(rows.moveNext(), true));
    expect(traceV2Called, 1);
    expect(traceV2Sql, sql);
    // legacy api
    final ptrTbResult = native.malloc<Pointer<Pointer<native.Utf8>>>();
    final ptrNumRow = native.malloc<Int32>();
    final ptrNumCol = native.malloc<Int32>();
    expect(
      ffiNative.get_table(
          db.native, 'SELECT * FROM simple LIMIT 1;', ptrTbResult, ptrNumRow, ptrNumCol, nullptr),
      native.OK,
    );
    expect(ptrNumRow.value, 1);
    expect(ptrNumCol.value, 8);
    expect(ptrTbResult.value, isNot(nullptr));
    ffiNative.free_table(ptrTbResult.value);
    native.free(ptrTbResult);
    native.free(ptrNumRow);
    native.free(ptrNumCol);
    // just test if calling native is ok
    ffiNative.interrupt(db.native);
    expect(
        ffiNative.unlock_notify(db.native, Pointer.fromFunction(unlockNotify), nullptr), native.OK);
  });

  test('Test Utility APIs', () async {
    final ptrEntry = Pointer.fromFunction<native.sqlite3_syscall_ptr>(extensionEntry);
    expect(ffiNative.auto_extension(ptrEntry), native.OK);
    extEntryCalled = 0;
    sqldb.open(driverName, ds.next(dbFiles)).close();
    expect(extEntryCalled, 1);
    expect(ffiNative.cancel_auto_extension(ptrEntry), 1);
    sqldb.open(driverName, ds.next(dbFiles)).close();
    expect(extEntryCalled, 1);
    ffiNative.reset_auto_extension(); // disable all change to auto_extension
    // test compile option
    expect(ffiNative.compileoption_used('ENABLE_MEMORY_MANAGEMENT'), 1);
    expect(ffiNative.compileoption_used('ENABLE_PREUPDATE_HOOK'), 1);
    expect(ffiNative.compileoption_used('OMIT_COMPILEOPTION_DIAGS'), 0);
    final compileOptions = <String>[];
    for (var i = 0; true; i++) {
      var opt = ffiNative.compileoption_get(i);
      if (opt == null) break;
      compileOptions.add(opt);
    }
    expect(compileOptions.contains('ENABLE_COLUMN_METADATA'), true);
    expect(compileOptions.contains('ENABLE_NORMALIZE'), true);
    // test complete api
    final failedResult = [0, native.NOMEM];
    expect(failedResult.contains(ffiNative.complete('SELECT * FROM test;')), false);
    expect(failedResult.contains(ffiNative.complete('SELECT * FROM test')), true);
    expect(ffiNative.initialize(), native.OK);
    expect(
        failedResult.contains(ffiNative.complete16('SELECT * FROM test;'.toNativeUtf16().cast())),
        false);
    expect(failedResult.contains(ffiNative.complete16('SELECT * FROM test'.toNativeUtf16().cast())),
        true);
    // legacy share mode See https://www.sqlite.org/c3ref/enable_shared_cache.html for best pratice
    expect(ffiNative.enable_shared_cache(1), native.OK);
    expect(ffiNative.enable_shared_cache(0), native.OK);
    // general purpose
    expect(ffiNative.soft_heap_limit64(-1), greaterThanOrEqualTo(0));
    expect(ffiNative.hard_heap_limit64(-1), greaterThanOrEqualTo(0));
    final a = DateTime.now();
    ffiNative.sleep(200);
    expect(DateTime.now().difference(a).inMilliseconds, greaterThanOrEqualTo(200));
    expect(ffiNative.threadsafe(), greaterThan(0));
    expect(ffiNative.release_memory(10), greaterThanOrEqualTo(0));
    expect(ffiNative.strlike('%abc', 'abc', 0), 0);
    expect(ffiNative.strlike('%abc%', 'abc', 0), 0);
    expect(ffiNative.strlike('abc%', 'abc', 0), 0);
    expect(ffiNative.strlike('ab', 'abc', 0), isNot(0));
    expect(ffiNative.strglob('*abc', '123abc'), 0);
    expect(ffiNative.strglob('*abc', 'abc'), 0);
    expect(ffiNative.strglob('*abc', 'bc'), isNot(0));
    expect(ffiNative.stricmp('abc', 'abc'), 0);
    expect(ffiNative.stricmp('axc', 'abc'), isNot(0));
    expect(ffiNative.strnicmp('abc', 'abcxyz', 3), 0);
    expect(ffiNative.strnicmp('abc', 'abcxyz', 0), 0);
    expect(ffiNative.strnicmp('abc', 'abcxyz', -1), 0);
    expect(ffiNative.strnicmp('abc', 'abcxyz', 4), isNot(0));
    expect(ffiNative.keyword_count(), greaterThan(0));
    // test keyword api
    final keywordCount = ffiNative.keyword_count();
    expect(keywordCount, greaterThan(0));
    final allKeyword = <String>[];
    final ptrKeyword = native.malloc<native.PtrString>();
    final ptrSize = native.malloc<native.Int32>();
    for (var i = 0; i < keywordCount; i++) {
      expect(ffiNative.keyword_name(i, ptrKeyword, ptrSize), native.OK);
      allKeyword.add(ptrKeyword.value.toDartString(length: ptrSize.value));
    }
    for (var keyword in allKeyword) {
      expect(ffiNative.keyword_check(keyword), isNot(0));
    }
    native.free(ptrSize);
    native.free(ptrKeyword);
    // test randomness
    final buf = native.malloc<Uint8>(8);
    final unInitialVal = buf.toUint8List(length: 8).toList();
    ffiNative.randomness(8, buf.cast());
    expect(buf.toUint8List(length: 8).toList(), isNot(unInitialVal));
    native.free(buf);
    // test status
    final pCur = native.malloc<Int32>();
    final pHW = native.malloc<Int32>();
    expect(ffiNative.status(native.STATUS_MALLOC_COUNT, pCur, pHW, 0), native.OK);
    expect(pCur.value, greaterThanOrEqualTo(0));
    expect(pHW.value, greaterThanOrEqualTo(0));
    native.free(pCur);
    native.free(pHW);
    final pCur64 = native.malloc<Int64>();
    final pHW64 = native.malloc<Int64>();
    expect(ffiNative.status64(native.STATUS_MALLOC_COUNT, pCur64, pHW64, 0), native.OK);
    expect(pCur.value, greaterThanOrEqualTo(0));
    expect(pHW.value, greaterThanOrEqualTo(0));
    native.free(pCur64);
    native.free(pHW64);
    // malloc test
    expect(ffiNative.memory_highwater(1), greaterThanOrEqualTo(0));
    final currentUse = ffiNative.memory_used(); // there are internal allocation already done.
    expect(currentUse, greaterThan(0));
    final ptr1 = ffiNative.malloc(4)!, ptr1Size = ffiNative.msize(ptr1);
    expect(ptr1Size, greaterThanOrEqualTo(8));
    final ptr2 = ffiNative.malloc64(8)!, ptr2Size = ffiNative.msize(ptr2);
    expect(ptr2Size, greaterThanOrEqualTo(8));
    final ptr3 = ffiNative.realloc(ptr1, 8), ptr3Size = ffiNative.msize(ptr3!);
    expect(ptr3Size, greaterThanOrEqualTo(8));
    final ptr4 = ffiNative.realloc64(ptr2, 16), ptr4Size = ffiNative.msize(ptr4!);
    expect(ptr4Size, greaterThanOrEqualTo(16));
    expect(ffiNative.memory_highwater(1), greaterThan(0));
    expect(ffiNative.memory_used(), currentUse + ptr3Size + ptr4Size);
    native.free(ptr1);
    native.free(ptr2);
  });

  test('Test blob api', () async {
    final dbBlob = sqldb.open(driverName, ds.next(dbFiles)) as dsqlite.Database;
    await dbBlob.exec('CREATE TABLE test(id INTEGER PRIMARY KEY AUTOINCREMENT, bin BLOB);');
    final original = [
      Uint8List.fromList(List.generate(20, (index) => index + 1)),
      Uint8List.fromList(List.generate(33, (index) => index + 1)),
    ];
    await dbBlob.exec('INSERT INTO test(bin) VALUES(?),(?);', parameters: original);
    await dbBlob.protectQuery<sqldb.Row>('SELECT bin FROM test;', block: (rows) async {
      for (var i = 0; i < original.length; i++) {
        expect(rows.moveNext(), true);
        expect(rows.current.blobValueAt(0), original[i]);
      }
    });
    // open direct blob api
    final replace = [
      Uint8List.fromList(List.generate(20, (index) => Simple.rand.nextInt((index + 1) * 35))),
      Uint8List.fromList(List.generate(33, (index) => Simple.rand.nextInt((index + 1) * 35))),
    ];
    final ptrBlob = native.malloc<native.PtrBlob>();
    expect(ffiNative.blob_open(dbBlob.native, 'main', 'test', 'bin1', 1, 0, ptrBlob), native.ERROR);
    // open blob read only
    expect(ffiNative.blob_open(dbBlob.native, 'main', 'test', 'bin', 1, 0, ptrBlob), native.OK);
    expect(ptrBlob.value, isNot(nullptr));
    expect(ffiNative.blob_bytes(ptrBlob.value), original[0].length);
    var ptrData = native.malloc<Uint8>(original[0].length);
    expect(ffiNative.blob_read(ptrBlob.value, ptrData.cast(), original[0].length, 0), native.OK);
    expect(ptrData.toUint8List(length: original[0].length), original[0]);
    native.free(ptrData);
    ptrData = replace.first.toNative().cast<Uint8>();
    expect(
      ffiNative.blob_write(ptrBlob.value, ptrData.cast(), replace.first.length, 0),
      native.READONLY,
    );
    expect(ffiNative.blob_close(ptrBlob.value), native.READONLY);
    // open blob read write
    expect(ffiNative.blob_open(dbBlob.native, 'main', 'test', 'bin', 1, 1, ptrBlob), native.OK);
    expect(ffiNative.blob_write(ptrBlob.value, ptrData.cast(), replace.first.length, 0), native.OK);
    native.free(ptrData);
    await dbBlob.protectQuery<sqldb.Row>('SELECT bin FROM test;', block: (rows) async {
      expect(rows.moveNext(), true);
      expect(rows.current.blobValueAt(0), replace.first);
      expect(rows.moveNext(), true);
      expect(rows.current.blobValueAt(0), original.last);
    });
    // -- reopen
    expect(ffiNative.blob_reopen(ptrBlob.value, 2), native.OK);
    ptrData = replace.last.toNative().cast<Uint8>();
    expect(ffiNative.blob_write(ptrBlob.value, ptrData.cast(), replace.last.length, 0), native.OK);
    native.free(ptrData);
    expect(ffiNative.blob_close(ptrBlob.value), native.OK);
    await dbBlob.protectQuery<sqldb.Row>('SELECT bin FROM test;', block: (rows) async {
      expect(rows.moveNext(), true);
      expect(rows.current.blobValueAt(0), replace.first);
      expect(rows.moveNext(), true);
      expect(rows.current.blobValueAt(0), replace.last);
    });
    //
    native.free(ptrBlob);
    dbBlob.close();
  });

  test('Test Snapshot', () async {
    final dsSrc = ds.next(dbFiles, flags: native.OPEN_READWRITE | native.OPEN_CREATE);
    final dbInit = sqldb.open(driverName, dsSrc) as dsqlite.Database;
    // popular data
    final original = Simple.generate(2);
    await dbInit.exec(simpleTable);
    await popularSimpleData(dbInit, original);
    dbInit.close();
    // test snapshot
    final dbSnap = sqldb.open(driverName, dsSrc) as dsqlite.Database;
    await dbSnap.exec('PRAGMA journal_mode=WAL;');
    // keep wal to test recover
    final lopt = native.malloc<Int32>();
    lopt.value = 1;
    expect(ffiNative.db_config(dbSnap.native, native.DBCONFIG_NO_CKPT_ON_CLOSE, [1]), native.OK);
    native.free(lopt);
    expect(ffiNative.wal_autocheckpoint(dbSnap.native, -1), native.OK);
    // test snapshot open
    final sqlReadCount = 'SELECT count(*) FROM simple;';
    final snapshot = native.malloc<native.PtrSnapshot>();
    final simpleInWal = Simple.generate(2);
    await popularSimpleData(dbSnap, simpleInWal);
    expect(ffiNative.snapshot_get(dbSnap.native, 'main', snapshot), native.ERROR);
    await dbSnap.protectTransaction(block: (db, tx) async {
      await dbSnap.protectQuery<sqldb.Row>(sqlReadCount, block: (rows) async {
        rows.moveNext();
        expect(rows.current.intValueAt(0), original.length + simpleInWal.length);
      });
      expect(ffiNative.snapshot_get(dbSnap.native, 'main', snapshot), native.OK);
      expect(snapshot.value, isNot(nullptr));
    });
    // add extra row
    final newSimples = Simple.generate(1);
    await popularSimpleData(dbSnap, newSimples);
    // verify that snapshot does not contain the last insert
    final dbSnapRead = sqldb.open(driverName, dsSrc) as dsqlite.Database;
    await dbSnapRead.protectTransaction(block: (_, txt) async {
      // simple, original + simpleInWal + newSimples
      await dbSnapRead.protectQuery<sqldb.Row>(sqlReadCount,
          block: (rows) async => expect((rows..moveNext()).current.intValueAt(0),
              original.length + simpleInWal.length + newSimples.length));
      // get new snapshot
      final snapshot2 = native.malloc<native.PtrSnapshot>();
      expect(ffiNative.snapshot_get(dbSnapRead.native, 'main', snapshot2), native.OK);
      expect(ffiNative.snapshot_cmp(snapshot.value, snapshot2.value), lessThan(0));
      ffiNative.snapshot_free(snapshot2.value);
      native.free(snapshot2);
      // open snapshot to access previous log record. expect simple only, original + simpleInWal
      expect(ffiNative.snapshot_open(dbSnapRead.native, 'main', snapshot.value), native.OK);
      await dbSnapRead.protectQuery<sqldb.Row>(sqlReadCount,
          block: (rows) async => expect(
              (rows..moveNext()).current.intValueAt(0), original.length + simpleInWal.length));
    });
    // free snapshot
    ffiNative.snapshot_free(snapshot.value);
    native.free(snapshot);
    dbSnap.close();
    dbSnapRead.close();
    // open database on isolate and failed it purposely
    final r = ReceivePort();
    final isl = await Isolate.spawn(openSimpleDB, IsolateMeta(dsSrc, r.sendPort, false));
    await r.take(1).toList();
    // kill isolate to cause database not close and wal file remain uncheck
    isl.kill();
    // open database and try to get persisted snapshot
    final db1 = sqldb.open(driverName, dsSrc) as dsqlite.Database;
    expect(ffiNative.snapshot_recover(db1.native, 'main'), native.OK);
    final totalSimple = original.length + simpleInWal.length + newSimples.length + 2;
    final snapshot3 = native.malloc<native.PtrSnapshot>();
    await db1.protectTransaction(block: (_, tx) async {
      await db1.protectQuery<sqldb.Row>(sqlReadCount, block: (rows) async {
        rows.moveNext();
        expect(
          rows.current.intValueAt(0),
          totalSimple,
        );
      });
      expect(ffiNative.snapshot_get(db1.native, 'main', snapshot3), native.OK);
      expect(snapshot3.value, isNot(nullptr));
    });
    await popularSimpleData(db1, Simple.generate(1));
    await db1.protectTransaction(block: (_, tx) async {
      await db1.protectQuery<sqldb.Row>(sqlReadCount,
          block: (rows) async => expect((rows..moveNext()).current.intValueAt(0), totalSimple + 1));
      expect(ffiNative.snapshot_open(db1.native, 'main', snapshot3.value), native.OK);
      await db1.protectQuery<sqldb.Row>(sqlReadCount,
          block: (rows) async => expect((rows..moveNext()).current.intValueAt(0), totalSimple));
    });
    // free source
    ffiNative.snapshot_free(snapshot3.value);
    native.free(snapshot3);
    db1.close();
  });
}

Future<void> openSimpleDB(IsolateMeta meta) async {
  sqldb.registerDriver(
    driverName,
    await dsqlite.Driver.initialize(
      path: dLibraries.first.libraryPath,
      webMountPath: dLibraries.first.mountPoint,
      logLevel: Level.ALL,
    ),
  );
  final db1 = sqldb.open(driverName, meta.dsrc) as dsqlite.Database;
  await db1.exec('PRAGMA journal_mode=WAL;');
  await popularSimpleData(db1, Simple.generate(2));
  meta.port.send(1);
}

Future<void> popularSimpleData(sqldb.Database db, List<Simple> simples) async {
  await db.protectTransaction(block: (_, tx) async {
    var stmt = await db.prepare(simpleTableInsertBindName).write();
    final stmtRead =
        await db.prepare('SELECT created_at, updated_at FROM simple WHERE id=?').read();
    for (var simple in simples) {
      var changes = await stmt.exec(parameters: [
        dsqlite.NameParameter('name', simple.name, prefix: ':'),
        dsqlite.NameParameter('alias', simple.alias, prefix: '\$'),
        dsqlite.NameParameter('serial_no', simple.serialNo, prefix: '@'),
        dsqlite.NameParameter('level', simple.level, prefix: ':'),
        dsqlite.NameParameter('classification', simple.classification, prefix: ':'),
      ], reusable: true);
      stmt.reset();
      var rows = await stmtRead.query<sqldb.Row>(parameters: [changes.lastInsertId]);
      rows.moveNext();
      simple.id = changes.lastInsertId;
      simple.createdAt = rows.current.valueAt(0);
      simple.updatedAt = rows.current.valueAt(1);
      stmtRead.reset();
    }
    stmtRead.close();
    stmt.close();
  });
}

int extEntryCalled = 0;

void extensionEntry() => extEntryCalled++;

// just dummy callback
void unlockNotify(native.PtrPtrVoid pv, int nArg) {}

int profileDuration = 0;
int profileCalled = 0;

void profile(native.PtrVoid _, native.PtrString sql, int d) {
  profileCalled++;
  profileDuration = d;
}

String traceSql = '';
int traceCalled = 0;

void trace(native.PtrVoid _, native.PtrString a) {
  traceSql = a.toDartString();
  traceCalled++;
}

String traceV2Sql = '';
int traceV2Called = 0;

int traceV2(int mask, native.PtrVoid _, native.PtrVoid a, native.PtrVoid b) {
  traceV2Called++;
  if (mask == native.TRACE_STMT) traceV2Sql = b.cast<Utf8>().toDartString();
  // it's ignored at moment https://www.sqlite.org/c3ref/trace_v2.html
  return 0;
}

var progressH = 0;

int progressHandler(native.PtrVoid _) {
  progressH++;
  return native.OK;
}

int authorizer(native.PtrVoid _, int ac, native.PtrString a, native.PtrString b, native.PtrString c,
    native.PtrString d) {
  if (ac == native.READ) {
    return a.toDartString() == 'simple' && b.toDartString() == 'level' ? native.OK : native.IGNORE;
  }
  return native.OK;
}

class IsolateMeta {
  IsolateMeta(this.dsrc, this.port, this.useCustomBusy);

  final dsqlite.DataSource dsrc;
  final SendPort port;
  final bool useCustomBusy;
}

// use with isolate
void writeData(IsolateMeta meta) async {
  // must initial driver on every isolate.
  sqldb.registerDriver(
    driverName,
    await dsqlite.Driver.initialize(
      path: dLibraries.first.libraryPath,
      webMountPath: dLibraries.first.mountPoint,
      logLevel: Level.ALL,
    ),
  );
  ffiNative = dsqlite.Driver.binder.nativeLibrary;
  final db = sqldb.open(driverName, meta.dsrc) as dsqlite.Database;
  await db.exec(simpleTable);
  await db.protectTransaction(
      creator: dsqlite.transactionCreator(dsqlite.SQLiteTransactionControl.exclusive),
      block: (db, tx) async {
        for (var i = 0; i < simples.length; i++) {
          var simple = simples[i];
          await db.exec(simpleTableInsertBindName, parameters: [
            dsqlite.NameParameter('name', simple.name, prefix: ':'),
            dsqlite.NameParameter('alias', simple.alias, prefix: '\$'),
            dsqlite.NameParameter('serial_no', simple.serialNo, prefix: '@'),
            dsqlite.NameParameter('level', simple.level, prefix: ':'),
            dsqlite.NameParameter('classification', simple.classification, prefix: ':'),
          ]);
          await Future.delayed(Duration(milliseconds: delayInsert));
        }
      });
  meta.port.send(1);
}

// use with isolate
void readData(IsolateMeta meta) async {
  // must initial driver on every isolate.
  sqldb.registerDriver(
    driverName,
    await dsqlite.Driver.initialize(
      path: dLibraries.first.libraryPath,
      webMountPath: dLibraries.first.mountPoint,
      logLevel: Level.ALL,
    ),
  );
  ffiNative = dsqlite.Driver.binder.nativeLibrary;
  final db = sqldb.open(driverName, meta.dsrc) as dsqlite.Database;
  if (meta.useCustomBusy) {
    ffiNative.busy_handler(db.native, Pointer.fromFunction(onBusy, native.FAIL), nullptr);
  } else {
    ffiNative.busy_timeout(db.native, (delayInsert + 10) * simples.length);
  }
  // delete 100ms to make write transaction start first
  await Future.delayed(Duration(milliseconds: 50));
  await db.protectTransaction(
      creator: dsqlite.transactionCreator(),
      block: (db, tx) async {
        await db.protectQuery<Simple>('SELECT * FROM simple LIMIT 10;',
            creator: (r) => Simple.db(r),
            block: (rows) async {
              while (rows.moveNext()) {}
            });
      });
  meta.port.send(1);
}

int onBusy(native.PtrVoid _, int time) {
  sleep(Duration(milliseconds: 80));
  return 1;
}
