import 'dart:typed_data';

import 'package:database_sql/orm.dart';

/// An integer data type for sqlite
const integer = _SQLiteDataType(int, 'INTEGER');

/// A string data type for sqlite
const text = _SQLiteDataType(String, 'TEXT');

/// A binary data type for sqlite
const blob = _SQLiteDataType(Uint8List, 'BLOB');

/// A double number data type for sqlite
const real = _SQLiteDataType(double, 'REAL');

/// A general numeric data type for sqlite
const numeric = _SQLiteDataType(int, 'NUMERIC');

/// A boolean numeric data type for sqlite, provide concrete dart type as boolean.
const boolean = _SQLiteDataType(int, 'NUMERIC', bool);

/// A date time numeric data type for sqlite, provide String reader rather than int.
const datetime = _SQLiteDataType(String, 'NUMERIC', DateTime);

// representation of sql data type annotation
class _SQLiteDataType extends SQLDataType {
  const _SQLiteDataType(Type dartTypeAffinity, this.type, [Type? dartType])
      : super(dartTypeAffinity, dartType);

  final String type;

  @override
  String sqlDataType() => type;
}

/// An additional to tell generator to add `WITHOUT ROWID` to the end of create table query.
const withoutROWID = _WithoutROWID();

// class to output without rowid for sqlite create table
class _WithoutROWID extends SQLTableAdditionalDefinition {
  const _WithoutROWID();

  @override
  String definition() => 'WITHOUT ROWID';
}

/// Pre-defined default value of SQLite
final defaultValues = <PredefinedDefaultValue>[
  PredefinedDefaultValue('NULL', 'null', 'null', '*'),
  PredefinedDefaultValue('TRUE', 'true', 'bool', 'BOOL'),
  PredefinedDefaultValue('FALSE', 'false', 'bool', 'BOOL'),
  PredefinedDefaultValue('CURRENT_TIME', DateTime.now(), 'DateTime', 'NUMERIC'),
  PredefinedDefaultValue('CURRENT_DATE', DateTime.now(), 'DateTime', 'NUMERIC'),
  PredefinedDefaultValue('CURRENT_TIMESTAMP', DateTime.now(), 'DateTime', 'NUMERIC'),
];
