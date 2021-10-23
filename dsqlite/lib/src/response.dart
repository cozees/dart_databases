part of 'database.dart';

// default row creator
Row _defaultRowCreator(RowReader reader) => Row(reader);

/// A result when execute a select query.
class Rows<T> implements sql.Rows<T> {
  // create row data with the creator
  Rows._(Statement stmt, [sql.RowCreator<T>? creator])
      : _stmt = stmt,
        _creator = creator {
    _reader = RowReader._(stmt._columnIndexes, stmt._stmt!, stmt._declTypes);
  }

  // custom creator function
  final sql.RowCreator<T>? _creator;

  // reader use to read data from the statement.
  late final RowReader _reader;

  // native pointer to c statement, null if this result set is closed.
  Statement? _stmt;

  // current row result.
  T? _currentRow;

  /// Close current cursor.
  @override
  void close() {
    _stmt?.close();
    _stmt = null;
  }

  /// return the number of column in result set from select query.
  @override
  int get columnCount {
    Statement._ensureStatementAndDatabaseOpen(_stmt);
    return _stmt!._columnCount;
  }

  /// return a list of column available in the result set from select query.
  @override
  List<String> get columns {
    Statement._ensureStatementAndDatabaseOpen(_stmt);
    return _stmt!._columns;
  }

  /// return a list of declaration type correspond to each column in result set.
  @override
  List<String?> get declarationTypes {
    Statement._ensureStatementAndDatabaseOpen(_stmt);
    return _stmt!._declTypes;
  }

  /// return current row in the result set.
  @override
  T get current => _currentRow!;

  /// move cursor to the next row.
  @override
  bool moveNext() {
    Statement._ensureStatementAndDatabaseOpen(_stmt);
    if (_currentRow is RowMixin) (_currentRow as RowMixin?)?._setNotCurrent();
    var stepResult = Driver.binder.step(_stmt!._stmt!);
    if (stepResult != sqlite.ROW) {
      if (stepResult == sqlite.ERROR) {
        final cdb = _stmt!._db._db!;
        close();
        throw SQLiteException(cdb: cdb, returnCode: stepResult);
      }
      return false;
    }
    final rowCreator = _creator ?? _defaultRowCreator;
    _currentRow = rowCreator(_reader) as T;
    return true;
  }
}

/// A mixin for row data in the result from select query.
mixin RowMixin on sql.Row {
  // mark whether the current object is a current row in result set of select query.
  bool _isCurrentRow = true;

  /// Read binary value from SQLite statement result by [index].
  @override
  Uint8List? blobValueAt(int index) {
    _checkIsCurrentRow();
    return dataReader.blobValueAt(index);
  }

  /// Read binary value from SQLite statement result by [name].
  @override
  Uint8List? blobValueBy(String name) {
    _checkIsCurrentRow();
    return dataReader.blobValueBy(name);
  }

  /// Read a double value from SQLite statement result by [index].
  @override
  double? doubleValueAt(int index) {
    _checkIsCurrentRow();
    return dataReader.doubleValueAt(index);
  }

  /// Read a double value from SQLite statement result by [name].
  @override
  double? doubleValueBy(String name) {
    _checkIsCurrentRow();
    return dataReader.doubleValueBy(name);
  }

  /// Read an integer value from SQLite statement result by [index].
  @override
  int? intValueAt(int index, [bool bit32 = false]) {
    _checkIsCurrentRow();
    return dataReader.intValueAt(index, bit32);
  }

  /// Read an integer value from SQLite statement result by [name].
  @override
  int? intValueBy(String name, [bool bit32 = false]) {
    _checkIsCurrentRow();
    return dataReader.intValueBy(name, bit32);
  }

  /// Read a string value from SQLite statement result by [index].
  @override
  String? stringValueAt(int index) {
    _checkIsCurrentRow();
    return dataReader.stringValueAt(index);
  }

  /// Read a string value from SQLite statement result by [name].
  @override
  String? stringValueBy(String name) {
    _checkIsCurrentRow();
    return dataReader.stringValueBy(name);
  }

  /// Read an appropriate value from SQLite statement result by [index].
  @override
  T? valueAt<T>(int index) {
    _checkIsCurrentRow();
    return dataReader.valueAt(index);
  }

  /// Read an appropriate value from SQLite statement result by [name].
  @override
  T? valueBy<T>(String name) {
    _checkIsCurrentRow();
    return dataReader.valueBy(name);
  }

  // check whether the current object is bound to current row of a result set from select query.
  void _checkIsCurrentRow() {
    if (!_isCurrentRow) {
      throw sql.DatabaseException('This row is not the current row, reading data from the'
          ' non-current row is not supported by sqlite.');
    }
  }

  void _setNotCurrent() => _isCurrentRow = false;
}

/// Default row object represent row data of the result set from select query.
class Row extends sql.Row with RowMixin {
  Row(sql.RowReader dataReader) : super(dataReader);
}

/// A result when execute a query to insert/delete/update the database.
class Changes implements sql.Changes {
  // create changes response
  Changes._(Database db) {
    _lastInsertRowId = Driver.binder.last_insert_rowid(db._db!);
    _rowsAffected = Driver.binder.changes(db._db!);
  }

  late final int _lastInsertRowId;
  late final int _rowsAffected;

  /// The most recent successful INSERT into table or virtual table.
  ///
  /// The value of this property will only be available on the table that create with a rowid, those
  /// table that create with `WITHOUT ROWID` will has value set to zero.
  /// See https://www.sqlite.org/capi3ref.html#sqlite3_last_insert_rowid for more information
  @override
  int get lastInsertId => _lastInsertRowId;

  /// The number of rows modified, inserted or deleted by the most recently completed INSERT, UPDATE
  /// or DELETE statement.
  ///
  /// Only changes made directly by the INSERT, UPDATE or DELETE statement are considered - auxiliary
  /// changes caused by triggers, foreign key actions or REPLACE constraint resolution are not counted.
  /// Changes to a view that are intercepted by INSTEAD OF triggers are not counted. The value returned
  /// by sqlite3_changes() immediately after an INSERT, UPDATE or DELETE statement run on a view is
  /// always zero. Only changes made to real tables are counted.
  /// See https://www.sqlite.org/capi3ref.html#sqlite3_changes for more information.
  @override
  int get rowsAffected => _rowsAffected;
}
