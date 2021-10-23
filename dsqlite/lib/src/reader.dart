part of 'database.dart';

// extension declare additional converter method that convert SQLite value to an
// appropriate Dart value. A complex data type should handle by developer themselves.
extension _AppopriateConversionInt on int {
  dynamic toAppropriateTypeValue(String? declType, Type type) {
    if (declType == 'BOOLEAN' && (type == bool || type == dynamic)) return this == 1;
    if (type == Duration) return Duration(microseconds: this);
    if (type == int || type == num || type == dynamic) return this;
    throw sql.DatabaseException('unsupported sqlite value $this for dart $type');
  }
}

// extension declare additional converter method that convert SQLite value to an
// appropriate Dart value. A complex data type should handle by developer themselves.
extension _AppopriateConversionString on String {
  dynamic toAppropriateTypeValue(String? declType, Type type) {
    try {
      if ((declType == 'DATE' || declType == 'DATETIME' || declType == 'NUMERIC') &&
          (type == DateTime || type == dynamic)) {
        return DateTime.parse(this);
      }
      if (type == Uri) return Uri.parse(this);
      if (type == num) return num.parse(this);
    } catch (e) {
      throw sql.DatabaseException('invalid data format: unable to convert data $this to $type.');
    }
    if (type == RegExp) return RegExp(this);
    if (type == String || type == dynamic) return this;
    throw sql.DatabaseException('unsupported sqlite value $this for dart $type');
  }
}

/// A class provide a method to read value SQLite Value or Column from select query.
class ValueReader implements sql.ValueReader {
  // create value reader
  ValueReader(this.values);

  // sqlite value
  final sqlite.PtrPtrValue values;

  /// Read binary value by [index].
  @override
  Uint8List? blobValueAt(int index, [int? type]) {
    type ??= valueType(index);
    if (values.address == 0 || type == sqlite.NULL) return null;
    return Driver.binder.value_blob(values[index]);
  }

  /// Read a double value by [index].
  @override
  double? doubleValueAt(int index, [int? type]) {
    type ??= valueType(index);
    if (values[index].address == 0 || type == sqlite.NULL) return null;
    return Driver.binder.value_double(values[index]);
  }

  /// Read an integer value by [index].
  @override
  int? intValueAt(int index, [bool bit32 = false, int? type]) {
    type ??= valueType(index);
    if (values[index].address == 0 || type == sqlite.NULL) return null;
    return Driver.binder.value_int64(values[index]);
  }

  /// Read a string value by [index].
  @override
  String? stringValueAt(int index, [int? type]) {
    type ??= valueType(index);
    if (values[index].address == 0 || type == sqlite.NULL) return null;
    return Driver.binder.value_text(values[index]);
  }

  /// get value type
  int valueType(int index) => Driver.binder.value_type(values[index]);

  /// Read an appropriate value from SQLite Value or Column based on SQLite type affinity by [index].
  ///
  /// When the method is used to read value from select query, the returned value is also determine
  /// based on type declaration such as DateTime, bool ...etc.
  @override
  T? valueAt<T>(int index) {
    final type = valueType(index);
    switch (type) {
      case sqlite.TEXT:
        final val = stringValueAt(index);
        if (val == null) return null;
        try {
          if (T == Uri) return Uri.parse(val) as T;
          if (T == num) return num.parse(val) as T;
          if (T == DateTime) return DateTime.parse(val) as T;
          // bigint web case
          if (T == Duration) return Duration(microseconds: int.parse(val)) as T;
        } catch (e) {
          throw sql.DatabaseException('invalid data format: unable to convert data $val to $T.');
        }
        if (T == String || T == dynamic) return val as T;
        if (T == RegExp) return RegExp(val) as T;
        // unsupported type.
        break;
      case sqlite.INTEGER:
        final val = intValueAt(index);
        if (val == null) return null;
        if (T == bool) return (val == 1) as T;
        if (T == Duration) return Duration(microseconds: val) as T;
        if (T == int || T == num || T == dynamic) return val as T;
        // unsupported type.
        break;
      case sqlite.FLOAT:
        if (T == double || T == num || T == dynamic) return doubleValueAt(index) as T?;
        // unsupported type.
        break;
      case sqlite.BLOB:
        if (T == Uint8List || T == dynamic) return blobValueAt(index) as T?;
        // unsupported type.
        break;
      case sqlite.NULL:
        return null;
    }
    throw sql.DatabaseException('unsupported sqlite value of data type $type.');
  }
}

// -- pre-define default argument converter

/// Default string argument converter
String? stringArg(int i, sql.ValueReader reader) => reader.stringValueAt(i);

/// Default int argument converter
int? intArg(int i, sql.ValueReader reader) => reader.intValueAt(i);

/// Default double argument converter
double? doubleArg(int i, sql.ValueReader reader) => reader.doubleValueAt(i);

/// Default boolean [bool] argument converter
bool? boolArg(int i, sql.ValueReader reader) {
  final val = reader.intValueAt(i);
  return val == null ? null : val == 1;
}

/// Default binary [Uint8List] argument converter
Uint8List? blobArg(int i, sql.ValueReader reader) => reader.blobValueAt(i);

/// Default [DateTime] argument converter
DateTime? datetimeArg(int i, sql.ValueReader reader) {
  final raw = reader.stringValueAt(i);
  return raw == null ? null : DateTime.parse(raw);
}

/// Default [RegExp] argument converter
RegExp? regexpArg(int i, sql.ValueReader reader) {
  final raw = reader.stringValueAt(i);
  return raw == null ? null : RegExp(raw);
}

/// Default [Uri] argument converter
Uri? uriArg(int i, sql.ValueReader reader) {
  final raw = reader.stringValueAt(i);
  return raw == null ? null : Uri.parse(raw);
}

/// Default [Duration] argument converter
Duration? durationArg(int i, sql.ValueReader reader) {
  final raw = reader.intValueAt(i);
  return raw == null ? null : Duration(microseconds: raw);
}

/// A class provide a method to read data from select query.
class RowReader implements sql.RowReader, sql.ValueReader {
  // create row reader
  RowReader._(this._columnIndexes, this._stmt, this._declareType);

  // a mapping between column name and index value
  final Map<String, int> _columnIndexes;

  // a pointer to sqlite statment
  final sqlite.PtrStmt _stmt;

  // list of declared type of each column in the rows
  final List<String?> _declareType;

  /// Read binary value by [index].
  @override
  Uint8List? blobValueAt(int index) {
    if (_ensureValueNotNull(index)) {
      return Driver.binder.column_blob(_stmt, index);
    }
  }

  /// Read binary value by [name].
  @override
  Uint8List? blobValueBy(String name) => blobValueAt(_ensureIndexExisted(name));

  /// Read a double value by [index].
  @override
  double? doubleValueAt(int index) =>
      _ensureValueNotNull(index) ? Driver.binder.column_double(_stmt, index) : null;

  /// Read a double value by [name].
  @override
  double? doubleValueBy(String name) => doubleValueAt(_ensureIndexExisted(name));

  /// Read an integer value by [index].
  @override
  int? intValueAt(int index, [bool bit32 = false]) => _ensureValueNotNull(index)
      ? (bit32 ? Driver.binder.column_int(_stmt, index) : Driver.binder.column_int64(_stmt, index))
      : null;

  /// Read an integer value by [name].
  @override
  int? intValueBy(String name, [bool bit32 = false]) =>
      intValueAt(_ensureIndexExisted(name), bit32);

  /// Read a string value by [index].
  @override
  String? stringValueAt(int index) =>
      _ensureValueNotNull(index) ? Driver.binder.column_text(_stmt, index) : null;

  /// Read a string value by [name].
  @override
  String? stringValueBy(String name) => stringValueAt(_ensureIndexExisted(name));

  /// Read an appropriate value from SQLite Value or Column based on SQLite type affinity by [index].
  ///
  /// When the method is used to read value from select query, the returned value is also determine
  /// based on type declaration such as DateTime, bool ...etc.
  @override
  T? valueAt<T>(int index) {
    final type = Driver.binder.column_type(_stmt, index);
    switch (type) {
      case sqlite.NULL:
        return null;
      case sqlite.INTEGER:
        return intValueAt(index)?.toAppropriateTypeValue(_declareType[index], T);
      case sqlite.FLOAT:
        if (T == double || T == num || T == dynamic) return doubleValueAt(index) as T?;
        break;
      case sqlite.TEXT:
        return stringValueAt(index)?.toAppropriateTypeValue(_declareType[index], T);
      case sqlite.BLOB:
        if (T == Uint8List || T == dynamic) return blobValueAt(index) as T?;
        break;
    }
    throw sql.DatabaseException('unsupported sqlite value of data type $type at index $index.');
  }

  /// Read an appropriate value from SQLite statement result by [name].
  @override
  T? valueBy<T>(String name) => valueAt<T>(_ensureIndexExisted(name));

  int _ensureIndexExisted(String name) {
    final index = _columnIndexes[name];
    if (index == null) throw sql.DatabaseException('column name $name does not exist.');
    return index;
  }

  bool _ensureValueNotNull(int index) => Driver.binder.column_type(_stmt, index) != sqlite.NULL;
}
