library cross_apis.test;

import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:database_sql/database_sql.dart' as sqldb;
import 'package:dsqlite/dsqlite.dart' as dsqlite;
import 'package:logging/logging.dart';
import 'package:test/test.dart';

import 'common/common.dart';

class SampleAggregateSum implements sqldb.AggregateHandler {
  int val = 0;

  @override
  finalize() => val;

  void sumStep(int a) => val += a;

  @override
  Function get step => sumStep;
}

class SignatureAggregate implements sqldb.AggregateHandler {
  SignatureAggregate() {
    output = AccumulatorSink<Digest>();
    input = sha1.startChunkedConversion(output);
  }

  late final AccumulatorSink<Digest> output;
  late final ByteConversionSink input;

  @override
  finalize() {
    input.close();
    return Uint8List.fromList(output.events.single.bytes);
  }

  void hashStep(String a) => input.add(utf8.encode(a));

  @override
  Function get step => hashStep;
}

class SimpleErrorAggregate implements sqldb.AggregateHandler {
  int sum = 0;

  @override
  finalize() => throw Exception('Error throw finalize');

  void simpleThrow(int a, dynamic b, [dynamic c, dynamic d]) =>
      a == 0 ? sum += 1 : throw Exception('Error throw step');

  @override
  Function get step => simpleThrow;
}

void main() async {
  const driverName = 'sqlite-aggregate-1';
  final dbFiles = <Future Function()>[];
  final ds = IncrementalDataSource.ds('aggregate');
  final simples = Simple.generate(100);
  late final sqldb.Database db;

  tearDownAll(() async {
    await db.close();
    for (var f in dbFiles) {
      await f();
    }
  });

  setUpAll(() async {
    sqldb.registerDriver(
      driverName,
      await dsqlite.Driver.initialize(
        path: dLibraries.first.libraryPath,
        webMountPath: dLibraries.first.mountPoint,
        logLevel: Level.ALL,
        connectHook: (driver, db, ds) {
          db.registerAggregate(
            'somulit',
            dsqlite.AggregatorFunction(() => SampleAggregateSum(), argumentsNumber: 1),
          );
          db.registerAggregate(
            'hashlit',
            dsqlite.AggregatorFunction(() => SignatureAggregate(), argumentsNumber: 1),
          );
          db.registerAggregate(
            'errlit',
            dsqlite.AggregatorFunction(
              () => SimpleErrorAggregate(),
              argumentsNumber: 4,
              optionalArgument: 2,
              dbArgument: -1,
            ),
          );
        },
      ),
    );
    // populate data
    db = sqldb.open(driverName, ds.next(dbFiles));
    await db.exec(simpleTable);
    final rwStmt = await db.prepare(simpleTableInsertBindIndex).write();
    for (var simple in simples) {
      final change = await rwStmt.exec(parameters: [
        simple.name,
        simple.alias,
        simple.serialNo,
        simple.level,
        simple.classification,
      ], reusable: true);
      simple.id = change.lastInsertId;
      rwStmt.reset();
    }
    rwStmt.close();
  });

  test('Test Sample sum aggregate', () async {
    await db.protectQuery<sqldb.Row>(
      'SELECT somulit(`level`),somulit(`classification`) FROM `simple`;',
      block: (rows) async {
        expect(rows.moveNext(), true);
        expect(rows.current.intValueAt(0), simples.fold<int>(0, (pv, e) => pv + e.level));
        expect(rows.current.intValueAt(1), simples.fold<int>(0, (pv, e) => pv + e.classification));
        expect(rows.moveNext(), false);
      },
    );
  });

  test('Test Sample Hash aggregate', () async {
    await db.protectQuery<sqldb.Row>(
      'SELECT hashlit(`name`),hashlit(`serial_no`) FROM `simple`;',
      block: (rows) async {
        final o1 = AccumulatorSink<Digest>(), i1 = sha1.startChunkedConversion(o1);
        expect(rows.moveNext(), true);
        simples.fold<ByteConversionSink>(i1, (pv, e) => pv..add(utf8.encode(e.name))).close();
        expect(rows.current.blobValueAt(0), Uint8List.fromList(o1.events.single.bytes));
        final o2 = AccumulatorSink<Digest>(), i2 = sha1.startChunkedConversion(o2);
        simples.fold<ByteConversionSink>(i2, (pv, e) => pv..add(utf8.encode(e.serialNo))).close();
        expect(rows.current.blobValueAt(1), Uint8List.fromList(o2.events.single.bytes));
        expect(rows.moveNext(), false);
      },
    );
  });

  test('Test error', () async {
    var rows = await db.query<sqldb.Row>('SELECT errlit(`name`) FROM `simple`;');
    expect(() => rows.moveNext(), throwsException);
    rows = await db.query<sqldb.Row>('SELECT errlit(`level`,`name`) FROM `simple`;');
    expect(
      () => rows.moveNext(),
      throwsA(TypeMatcher<dsqlite.SQLiteException>()
          .having((e) => e.message, 'message', 'Exception: Error throw step')),
    );
    rows = await db.query<sqldb.Row>('SELECT errlit(0,`name`) FROM `simple`;');
    expect(
      () => rows.moveNext(),
      throwsA(TypeMatcher<dsqlite.SQLiteException>()
          .having((e) => e.message, 'message', 'Exception: Error throw finalize')),
    );
    rows = await db.query<sqldb.Row>('SELECT errlit(0) FROM `simple`;');
    expect(
      () => rows.moveNext(),
      throwsA(TypeMatcher<dsqlite.SQLiteException>().having((e) => e.message, 'message',
          'Not enough argument (1) function required at least 2 argument(s).')),
    );
    rows = await db.query<sqldb.Row>('SELECT errlit(0,0,0,0,0) FROM `simple`;');
    expect(
      () => rows.moveNext(),
      throwsA(TypeMatcher<dsqlite.SQLiteException>().having((e) => e.message, 'message',
          'Too many argument (5) function only accept 4 argument(s).')),
    );
    // remove aggregate function
    final sdb = db as dsqlite.Database;
    sdb.unregisterAggregate('hashlit');
    expect(() async => await db.query('SELECT hashlit(`name`),hashlit(`serial_no`) FROM `simple`;'),
        throwsException);
    // replace aggregate function
    sdb.registerAggregate(
        'errlit', dsqlite.AggregatorFunction(() => SampleAggregateSum(), argumentsNumber: 1));
    rows = await db.query('SELECT errlit(`level`),errlit(`classification`) FROM `simple`;');
    expect(rows.moveNext(), true);
    expect(rows.current.intValueAt(0), simples.fold<int>(0, (pv, e) => pv + e.level));
    expect(rows.current.intValueAt(1), simples.fold<int>(0, (pv, e) => pv + e.classification));
    expect(rows.moveNext(), false);
    rows.close();
  });
}
