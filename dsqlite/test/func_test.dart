library cross_apis.test;

import 'dart:typed_data';

import 'package:database_sql/database_sql.dart' as sqldb;
import 'package:dsqlite/dsqlite.dart' as dsqlite;
import 'package:dsqlite/sqlite.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

import 'common/common.dart';

void main() async {
  final dbFiles = <Future Function()>[];
  final ds = IncrementalDataSource.ds('function');

  tearDownAll(() async {
    for (var f in dbFiles) {
      await f();
    }
  });

  group('Test Function regular function', () {
    const driverName = 'sqlite-func-1';
    final iReaders = <sqldb.ArgumentConverter>[
      dsqlite.stringArg,
      dsqlite.intArg,
      dsqlite.doubleArg,
      dsqlite.blobArg,
      dsqlite.boolArg,
      dsqlite.durationArg,
      dsqlite.uriArg,
      dsqlite.regexpArg,
      dsqlite.datetimeArg,
      (i, reader) => reader.valueAt<num>(i),
      (i, reader) {
        final raw = reader.stringValueAt(i);
        return raw == null ? null : TestData1.from(raw);
      },
    ];
    final iReaderDynamic = <sqldb.ArgumentConverter>[
      (i, reader) => reader.valueAt<String>(i),
      (i, reader) => reader.valueAt<int>(i),
      (i, reader) => reader.valueAt<double>(i),
      (i, reader) => reader.valueAt<Uint8List>(i),
      (i, reader) => reader.valueAt<bool>(i),
      (i, reader) => reader.valueAt<Duration>(i),
      (i, reader) => reader.valueAt<Uri>(i),
      (i, reader) => reader.valueAt<RegExp>(i),
      (i, reader) => reader.valueAt<DateTime>(i),
      (i, reader) => reader.valueAt<num>(i),
      (i, reader) {
        final raw = reader.stringValueAt(i);
        return raw == null ? null : TestData1.from(raw);
      },
    ];
    var imc = iReaders;
    final data = <dynamic>[
      [
        'test',
        1,
        3.45,
        Uint8List.fromList([1, 2, 3]),
        true,
        Duration(days: 1),
        Uri.parse('https://www.example.com'),
        RegExp(r'\d+\s+'),
        DateTime.now().add(Duration(days: 4)),
        '123',
        TestData1(1, 'test-abc'),
      ],
      [
        'testa',
        3,
        0.98,
        Uint8List.fromList([10, 12, 31]),
        false,
        Duration(hours: 5),
        Uri.parse('https://www.example.com/test'),
        RegExp(r'\d+\w+'),
        DateTime.now().add(Duration(hours: 45)),
        '33.472',
        TestData1(349, 'test-123'),
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
        null,
      ],
    ];
    // ignore: prefer_function_declarations_over_variables
    final resultOffer = (int i) {
      if (i < data[0].length) return i == 9 ? num.parse(data[0][i] as String) : data[0][i];
      throw Exception('unsupported argument $i');
    };
    var resultHandlerIndex = -1;
    final resultHandler = [
      dsqlite.applyStringResult,
      dsqlite.applyIntResult,
      dsqlite.applyDoubleResult,
      dsqlite.applyBlobResult,
      dsqlite.applyBoolResult,
      dsqlite.applyDurationResult,
      dsqlite.applyUriResult,
      dsqlite.applyRegExpResult,
      dsqlite.applyDateTimeResult,
      (PtrContext ctx, num? val) => val is int?
          ? dsqlite.applyIntResult(ctx, val?.toInt())
          : dsqlite.applyDoubleResult(ctx, val.toDouble()),
      (PtrContext ctx, TestData1? val) => dsqlite.applyStringResult(ctx, val?.toString()),
    ];
    final rowValReader = <dynamic>[
      (sqldb.Row row, int i) => row.stringValueAt(i),
      (sqldb.Row row, int i) => row.intValueAt(i),
      (sqldb.Row row, int i) => row.doubleValueAt(i),
      (sqldb.Row row, int i) => row.blobValueAt(i),
      (sqldb.Row row, int i) => row.intValueAt(i) == 1,
      (sqldb.Row row, int i) => Duration(microseconds: row.intValueAt(i)!),
      (sqldb.Row row, int i) => Uri.parse(row.stringValueAt(i)!),
      (sqldb.Row row, int i) => RegExp(row.stringValueAt(i)!),
      (sqldb.Row row, int i) => DateTime.parse(row.stringValueAt(i)!),
      (sqldb.Row row, int i) => row.valueAt(i).toString(),
      (sqldb.Row row, int i) => TestData1.from(row.stringValueAt(i)!),
    ];

    setUpAll(() async {
      sqldb.registerDriver(
        driverName,
        await dsqlite.Driver.initialize(
          path: dLibraries.first,
          logLevel: Level.ALL,
          connectHook: (driver, db, ds) {
            // simple test
            db.registerFunction(
              'modilize',
              sqldb.DatabaseFunction(
                func: (String a, String b) {
                  final icmp = a.compareTo(b);
                  if (icmp == 0) return a;
                  if (icmp > 0) return '$b : $a';
                  return '$a : $b';
                },
                argumentsNumber: 2,
              ),
            );
            // argument converter test
            db.registerFunction(
              'nicefunc',
              sqldb.DatabaseFunction(
                argConverter: (i, reader) {
                  if (i < 11) return imc[i](i, reader);
                  throw Exception('invalid index $i must be 2 arguments only');
                },
                func: (String? a, int? i, double? d, Uint8List? bin, bool? b, Duration? dr, Uri? l,
                    RegExp? p, DateTime? dt, num? n, TestData1? td1) {
                  return '$a,$i,$d,$bin,$b,$dr,$l,$p,$dt,$n,$td1';
                },
                argumentsNumber: 11,
              ),
            );
            // result converter test
            db.registerFunction(
              'deflit',
              sqldb.DatabaseFunction(
                func: resultOffer,
                argumentsNumber: 1,
              ),
            );
            db.registerFunction(
              'reslit',
              sqldb.DatabaseFunction(
                func: resultOffer,
                resultConverter: (d) => d is TestData1 ? d.toString() : d,
                argumentsNumber: 1,
              ),
            );
            db.registerFunction(
              'hanlit',
              sqldb.DatabaseFunction(
                func: resultOffer,
                resultHandler: (ctx, res) =>
                    Function.apply(resultHandler[resultHandlerIndex], [ctx, res]),
                argumentsNumber: 1,
              ),
            );
            db.registerFunction(
              'nullit1',
              sqldb.DatabaseFunction(
                func: (dynamic d) => null,
                argumentsNumber: 1,
              ),
            );
            db.registerFunction(
              'nullit2',
              sqldb.DatabaseFunction(
                func: (dynamic d) => null,
                resultHandler: (ctx, res) =>
                    Function.apply(resultHandler[resultHandlerIndex], [ctx, res]),
                argumentsNumber: 1,
              ),
            );
            db.registerFunction(
              'failit',
              sqldb.DatabaseFunction(
                func: (dynamic d) => TestData1(1, 'failed'),
                argumentsNumber: 1,
              ),
            );
            // error
            db.registerFunction(
              'erlit1',
              sqldb.DatabaseFunction(
                dbArgument: -1,
                argumentsNumber: 4,
                optionalArgument: 2,
                func: (String r, double l, [int a = 0, int? b]) => 1,
              ),
            );
            db.registerFunction(
              // error when invoked with any value as sqlite doesn't support name variable
              'erlit2',
              sqldb.DatabaseFunction(
                argumentsNumber: -1,
                func: (String r, {required String name, int i = 0, int? b}) => 1,
              ),
            );
          },
        ),
      );
    });

    test('Test simple 2 argument', () async {
      await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
        var stmt = await db.prepare('SELECT modilize(:a, :b) as result;').read();
        for (var input in [
          ['test1', 'test1', 'test1'],
          ['Friday', 'Monday', 'Friday : Monday'],
          ['Monday', 'Friday', 'Friday : Monday'],
        ]) {
          final rows = await stmt.query<sqldb.Row>(parameters: [
            dsqlite.NameParameter('a', input[0], prefix: ':', paramBinder: dsqlite.bindString),
            dsqlite.NameParameter('b', input[1], prefix: ':', paramBinder: dsqlite.bindString),
          ]);
          expect(rows.moveNext(), true);
          expect(
            rows.current.stringValueBy('result'),
            input[2],
            reason: 'Failed test ${input.join(',')}',
          );
          expect(rows.moveNext(), false);
          stmt.reset();
        }
        stmt.close();
      });
    });

    test('Test argument converter', () async {
      await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
        final paramsHolder = '?'.padRight(11, ',?');
        var stmt = await db.prepare('SELECT nicefunc($paramsHolder) as result;').read();
        for (var input in data) {
          final rows = await stmt.query<sqldb.Row>(
            parameters: input
                .map((e) => (e is TestData1) ? dsqlite.IndexParameter(11, e, TestData1.binder) : e)
                .toList(),
          );
          expect(rows.moveNext(), true);
          expect(
            rows.current.valueBy('result'),
            input.join(','),
            reason: 'Failed test ${input.join(',')}',
          );
          expect(rows.moveNext(), false);
          stmt.reset();
          imc = imc == iReaders ? iReaderDynamic : iReaders;
        }
        stmt.close();
      });
    });

    test('Test result converter', () async {
      await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
        var stmt = await db.prepare('SELECT deflit(?) as result;').read();
        final skipLast = data[0].length - 1; // the last one is error in function 'deflit'
        for (var i = 0; i < skipLast; i++) {
          final rows = await stmt.query<sqldb.Row>(parameters: [i]);
          expect(rows.moveNext(), true);
          if (i == 7) {
            expect(
              rowValReader[i](rows.current, 0)?.pattern,
              data[0][i]?.pattern,
              reason: 'Failed test ${data[0][i]} $i',
            );
          } else {
            expect(
              rowValReader[i](rows.current, 0),
              data[0][i],
              reason: 'Failed test ${data[0][i]} $i',
            );
          }
          expect(rows.moveNext(), false);
          stmt.reset();
        }
        stmt.close();
        for (var fname in ['reslit', 'hanlit']) {
          stmt = await db.prepare('SELECT $fname(?) as result;').read();
          resultHandlerIndex = 0;
          for (var i = 0; i < data[0].length; i++) {
            final rows = await stmt.query<sqldb.Row>(parameters: [i]);
            expect(rows.moveNext(), true, reason: 'func: $fname');
            if (i == 7) {
              expect(
                rowValReader[i](rows.current, 0).pattern,
                data[0][i].pattern,
                reason: 'Failed test func: $fname, ${data[0][i]}',
              );
            } else {
              expect(
                rowValReader[i](rows.current, 0),
                data[0][i],
                reason: 'Failed test func: $fname, ${data[0][i]}',
              );
            }
            expect(rows.moveNext(), false, reason: 'func: $fname');
            stmt.reset();
            resultHandlerIndex++;
          }
          stmt.close();
        }
        // null test
        for (var fname in ['nullit1', 'nullit2']) {
          stmt = await db.prepare('SELECT $fname(?) as result;').read();
          resultHandlerIndex = 0;
          for (var i = 0; i < data.last.length; i++) {
            final rows = await stmt.query<sqldb.Row>(parameters: [i]);
            expect(rows.moveNext(), true, reason: 'func: $fname');
            expect(
              rows.current.valueAt(i),
              data.last[i],
              reason: 'Failed test func: $fname, ${data.last[i]}',
            );
            expect(rows.moveNext(), false, reason: 'func: $fname');
            stmt.reset();
            resultHandlerIndex++;
          }
          stmt.close();
        }
      });
    });

    test('Test Error converter', () async {
      await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
        var stmt = await db.prepare('SELECT deflit(?) as result;').read();
        var rows = await stmt.query(parameters: [20]);
        expect(() => rows.moveNext(), throwsException);
        stmt = await db.prepare('SELECT failit(?) as result;').read();
        rows = await stmt.query(parameters: [20]);
        expect(() => rows.moveNext(), throwsException);
      });
    });

    test('Test optional argument', () async {
      // ignore: prefer_function_declarations_over_variables
      final block = (rows) async {
        expect(rows.moveNext(), true);
        expect(rows.current.intValueAt(0), 1);
      };
      await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
        await db.protectQuery<sqldb.Row>(
          'SELECT erlit1(?,?) as result;',
          parameters: ['abc', 9.8],
          block: block,
        );
        await db.protectQuery<sqldb.Row>(
          'SELECT erlit1(?,?,?) as result;',
          parameters: ['abc', 3.6, 123],
          block: block,
        );
        await db.protectQuery<sqldb.Row>(
          'SELECT erlit1(?,?,?,?) as result;',
          parameters: ['abc', 2.0, 123, 876],
          block: block,
        );
      });
    });

    test('Test Error General', () async {
      await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
        var stmt = await db.prepare('SELECT erlit1(?,?,?,?,?) as result;').read();
        var rows = await stmt.query<sqldb.Row>(parameters: ['abc', 2.5, 1, 2, 3]);
        expect(() => rows.moveNext(), throwsException);
        stmt = await db.prepare('SELECT erlit1(?) as result;').read();
        rows = await stmt.query<sqldb.Row>(parameters: ['abc']);
        expect(() => rows.moveNext(), throwsException);
        stmt = await db.prepare('SELECT erlit2(?) as result;').read();
        rows = await stmt.query<sqldb.Row>(parameters: ['abc']);
        expect(() => rows.moveNext(), throwsException);
      });
    });

    test('Test Unregister & Replace', () async {
      final isSQLiteException = throwsA(TypeMatcher<dsqlite.SQLiteException>().having(
        (e) => e.message,
        'message',
        contains('no such function: oelit'),
      ));
      await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
        final _ = db as dsqlite.Database;
        expect(() async => await db.prepare("SELECT oelit('abc');"), isSQLiteException);
        var a = 0, b = 0;
        db.registerFunction(
          'oelit',
          sqldb.DatabaseFunction(dbArgument: -1, argumentsNumber: 1, func: (int i) => a++),
        );
        await db.protectQuery('SELECT oelit(1);', block: (rows) async => rows.moveNext());
        expect(a, 1);
        // replace
        db.registerFunction(
          'oelit',
          sqldb.DatabaseFunction(argumentsNumber: 1, func: (String s) => b++),
        );
        await db.protectQuery("SELECT oelit('abc');", block: (rows) async => rows.moveNext());
        expect([a, b], [1, 1]);
        db.unregisterFunction('oelit');
        expect(() async => await db.prepare("SELECT oelit('abc');"), isSQLiteException);
        expect([a, b], [1, 1]);
      });
    });
  });
}
