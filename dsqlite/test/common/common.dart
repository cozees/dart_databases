import 'dart:convert';
import 'dart:math';

import 'package:database_sql/database_sql.dart' as sqldb;
import 'package:dsqlite/dsqlite.dart' as dsqlite;
import 'package:dsqlite/sqlite.dart';

import 'dlibrary_native.dart'
    if (dart.library.io) 'dlibrary_native.dart'
    if (dart.library.js) 'dlibrary_web.dart'
    if (dart.library.html) 'dlibrary_web.dart';

/// native and web support
abstract class PlatformLibrary {
  String get libraryPath;
  String? get mountPoint;
}

final dLibraries = [
  platformLibraries('latest'),
  platformLibraries('3017000'),
];

abstract class IncrementalDataSource {
  static const name = '_sample';

  IncrementalDataSource(this.root, this.test) : count = 0;

  /// platform independent
  factory IncrementalDataSource.ds(String test) => createDataSource(test);

  final String root;

  final String test;

  int count;

  dsqlite.DataSource next(List<Future Function()> registered,
      {int flags = OPEN_CREATE | OPEN_READWRITE, String? modName});
}

class TestData1 {
  static TestData1 from(String raw) {
    final index = raw.indexOf(':');
    if (index == -1) throw Exception('invalid data $raw is not TestData1');
    return TestData1(int.parse(raw.substring(0, index)), raw.substring(index + 1));
  }

  static int binder(dsqlite.Statement stmt, TestData1? value, int index) {
    if (value == null) return dsqlite.bindNull(stmt, index);
    return dsqlite.bindString(stmt, value.toString(), index);
  }

  TestData1(this.a, this.b);

  final int a;
  final String b;

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() => '$a:$b';

  @override
  bool operator ==(covariant TestData1 other) => a == other.a && b == other.b;
}

class Simple {
  static final rand = Random();

  static const _alias = [
    'Melvin Boyer',
    'Vanessa Moon',
    'Mable Mcconnell',
    'Etta Mccall',
    'Eddie Ali',
    'Colin George',
    'Darwin Atkinson',
    'Keisha Dodson',
    'Greg Drake',
    'Drew Cain',
    'Eula Love',
    'Delia Cole',
    'Loren Small',
    'Orville Maddox',
    'Rudy Barker',
    'Ellen Hines',
    'Janie Compton',
    'Mavis Hopkins',
    'Patsy Hicks',
    'Stewart Watson',
  ];

  static const _name = [
    'Leticia Faulkner',
    'Jennie Bennett',
    'Nikki Russo',
    'Helga Gilbert',
    'Wendy Riddle',
    'Landon Santos',
    'Jeannie Haney',
    'Norberto Murillo',
    'Taylor Waller',
    'Jamie Grimes',
    'Sonny Steele',
    'Andre Camacho',
    'Forest Spence',
    'Stacy Frey',
    'Debra Duarte',
    'Kerry Shea',
    'Leta Molina',
    'Autumn Williams',
    'Nadia Harmon',
    'Sharlene Dillon',
  ];

  static T? _nullable<T>(List<T> ii) {
    final i = rand.nextInt(ii.length * 3);
    return i < ii.length ? ii[i] : null;
  }

  static String _pureRandom(int length, {String? prefix, String? suffix}) {
    final buffer = StringBuffer(prefix ?? '');
    buffer.write(
        base64Encode(List.generate(length, (index) => rand.nextInt(256))).substring(0, length));
    if (suffix != null) buffer.write(suffix);
    return buffer.toString();
  }

  static List<Simple> generate(int count) {
    return [
      for (; count > 0; count--)
        Simple(
          _name[rand.nextInt(_name.length)],
          _nullable<String>(_alias),
          _pureRandom(12, prefix: 'IEEDF'),
          rand.nextInt(10),
          rand.nextInt(20),
        ),
    ];
  }

  Simple(
    this.name,
    this.alias,
    this.serialNo,
    this.level,
    this.classification,
  );

  factory Simple.db(sqldb.RowReader reader) {
    return Simple(
      reader.stringValueBy('name')!,
      reader.stringValueBy('alias'),
      reader.stringValueBy('serial_no')!,
      reader.intValueBy('level')!,
      reader.intValueBy('classification')!,
    )
      ..id = reader.intValueBy('id')!
      ..createdAt = DateTime.parse(reader.stringValueBy('created_at')!)
      ..updatedAt = DateTime.parse(reader.stringValueBy('updated_at')!);
  }

  List<dsqlite.NameParameter> toParameter() => [
        dsqlite.NameParameter<String>('name', name, prefix: '@', paramBinder: dsqlite.bindString),
        dsqlite.NameParameter<String>('alias', alias, prefix: '@', paramBinder: dsqlite.bindString),
        dsqlite.NameParameter<int>('level', level, prefix: '@', paramBinder: dsqlite.bindInt),
        dsqlite.NameParameter<String>('serial_no', serialNo,
            prefix: '@', paramBinder: dsqlite.bindString),
        dsqlite.NameParameter<int>('classification', classification,
            prefix: '@', paramBinder: dsqlite.bindInt),
      ];

  int? id;
  final String name;
  final String? alias;
  final String serialNo;
  final int level;
  final int classification;
  DateTime? createdAt;
  DateTime? updatedAt;

  @override
  int get hashCode => toString().hashCode;

  @override
  bool operator ==(covariant Simple other) {
    return id == other.id &&
        name == other.name &&
        alias == other.alias &&
        serialNo == other.serialNo &&
        level == other.level &&
        classification == other.classification &&
        createdAt?.compareTo(other.createdAt!) == 0 &&
        updatedAt?.compareTo(other.updatedAt!) == 0;
  }

  @override
  String toString() =>
      '$id, $name, $alias, $serialNo, $level, $classification, $createdAt, $updatedAt';
}

final simpleTable = 'CREATE TABLE IF NOT EXISTS `simple` ('
    '`id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'
    '`name` TEXT NOT NULL,'
    '`alias` TEXT,'
    '`serial_no` TEXT NOT NULL UNIQUE,'
    '`level` INTEGER NOT NULL DEFAULT 1,'
    '`classification` INTEGER NOT NULL DEFAULT 1,'
    '`created_at` NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,'
    '`updated_at` NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP'
    ');';

final simpleColumns = [
  dsqlite.ColumnInfo('id', 'INTEGER', 'BINARY', false, null, true, true),
  dsqlite.ColumnInfo('name', 'TEXT', 'BINARY', false, null, false, false),
  dsqlite.ColumnInfo('alias', 'TEXT', 'BINARY', true, null, false, false),
  dsqlite.ColumnInfo('serial_no', 'TEXT', 'BINARY', false, null, false, false),
  dsqlite.ColumnInfo('level', 'INTEGER', 'BINARY', false, '1', false, false),
  dsqlite.ColumnInfo('classification', 'INTEGER', 'BINARY', false, '1', false, false),
  dsqlite.ColumnInfo('created_at', 'NUMERIC', 'BINARY', false, 'CURRENT_TIMESTAMP', false, false),
  dsqlite.ColumnInfo('updated_at', 'NUMERIC', 'BINARY', false, 'CURRENT_TIMESTAMP', false, false),
];

final simpleTableInsertBindName = 'INSERT INTO `simple`'
    '(`name`,`alias`,`serial_no`,`level`,`classification`)'
    'VALUES(:name, \$alias, @serial_no, :level, :classification);';

final simpleTableInsertBindNameU = 'INSERT INTO `simple`'
    '(`name`,`alias`,`serial_no`,`level`,`classification`)'
    'VALUES(@name, @alias, @serial_no, @level, @classification);';

final simpleTableInsertBindIndex = 'INSERT INTO `simple`'
    '(`name`,`alias`,`serial_no`,`level`,`classification`)'
    'VALUES(?, ?, ?, ?, ?);';

final simpleTableInsertBindNI = 'INSERT INTO `simple`'
    '(`name`,`alias`,`serial_no`,`level`,`classification`)'
    'VALUES(?, @alias, ?4, ?3, ?);';

final allTypeColumnTable = 'CREATE TABLE `data_test` ('
    'id INTEGER,'
    'txt TEXT,'
    'logic BOOLEAN,'
    'distance REAL,'
    'at DATETIME,'
    'binary BLOB,'
    'location TEXT,' // Uri
    'matcher TEXT,' // RegExp
    'point DECIMAL(10,5),' // num
    'amount INTEGER' // Duration
    ');';

final allTypeColumns = [
  dsqlite.ColumnInfo('id', 'INTEGER', 'BINARY', true, null, false, false),
  dsqlite.ColumnInfo('txt', 'TEXT', 'BINARY', true, null, false, false),
  dsqlite.ColumnInfo('logic', 'BOOLEAN', 'BINARY', true, null, false, false),
  dsqlite.ColumnInfo('distance', 'REAL', 'BINARY', true, null, false, false),
  dsqlite.ColumnInfo('at', 'DATETIME', 'BINARY', true, null, false, false),
  dsqlite.ColumnInfo('binary', 'BLOB', 'BINARY', true, null, false, false),
  dsqlite.ColumnInfo('location', 'TEXT', 'BINARY', true, null, false, false),
  dsqlite.ColumnInfo('matcher', 'TEXT', 'BINARY', true, null, false, false),
  dsqlite.ColumnInfo('point', 'DECIMAL(10,5)', 'BINARY', true, null, false, false),
  dsqlite.ColumnInfo('amount', 'INTEGER', 'BINARY', true, null, false, false),
];

List<dynamic> allTypeTableReadFromRow(sqldb.Row row, bool byIndex) {
  if (byIndex) {
    return [
      row.valueAt(0),
      row.valueAt(1),
      row.valueAt(2),
      row.valueAt(3),
      row.valueAt(4), // DateTime (numeric)
      row.valueAt(5), // Uint8List (blob)
      row.valueAt<Uri>(6), // Uri (text)
      row.valueAt<RegExp>(7), // RegExp (text)
      row.valueAt<num>(8), // num (numeric)
      row.valueAt<Duration>(9), // Duration (integer)
    ];
  }
  return [
    row.valueBy('id'),
    row.valueBy('txt'),
    row.valueBy('logic'),
    row.valueBy('distance'),
    row.valueBy('at'),
    row.valueBy('binary'),
    row.valueBy<Uri>('location'),
    row.valueBy<RegExp>('matcher'),
    row.valueBy<num>('point'),
    row.valueBy<Duration>('amount'),
  ];
}
