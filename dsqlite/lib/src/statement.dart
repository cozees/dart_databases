part of 'database.dart';

/// A statement interface provide general high level api to access common SQLite C API.
class Statement implements sql.Statement, sql.ReadStatement, sql.WriteStatement {
  // create statement object
  Statement._(this._db, String query, [int flags = 0]) {
    var statementOut = sqlite.malloc<sqlite.PtrStmt>();
    final tail = sqlite.malloc<sqlite.Pointer<sqlite.Utf8>>();
    var resultCode = Driver.binder.prepare_compat(_db._db!, query, flags, statementOut, tail);
    _stmt = statementOut.value;
    sqlite.free(statementOut);
    // throw error sqlite api failed
    if (resultCode != sqlite.OK) {
      Driver.binder.finalize(_stmt!);
      throw SQLiteException(cdb: _db._db!, returnCode: resultCode);
    }

    // throw error for multiple select query statement
    if (tail.value.address != 0) {
      final txt = tail.value.toDartString().trim();
      if (txt.isNotEmpty) {
        sqlite.free(tail);
        Driver.binder.finalize(_stmt!);
        throw sql.DatabaseException('Driver does not support execute multiple statement,'
            ' tail query \'$txt\'');
      }
    }
    sqlite.free(tail);

    // read column count
    _columnCount = Driver.binder.column_count(_stmt!);

    // read list column
    _columns = List.generate(_columnCount, (index) {
      final n = Driver.binder.column_name(_stmt!, index);
      if (n == null) throw SQLiteException(cdb: _db._db!);
      return n;
    }, growable: false);

    // read declare type
    _declTypes = List.generate(_columnCount, (index) {
      final dc = Driver.binder.column_decltype(_stmt!, index);
      return dc;
    }, growable: false);

    // create mapping between column name and column index
    _columnIndexes = <String, int>{};
    for (var i = 0; i < _columnCount; i++) {
      var columnName = Driver.binder.column_name(_stmt!, i)!;
      _columnIndexes[columnName] = i;
    }

    _paramCount = Driver.binder.bind_parameter_count(_stmt!);
    _db._onStatementUpdate(true);
  }

  // reference to current connection
  final Database _db;

  // pointer to sqlite c statement. null if statement as been finalized.
  sqlite.PtrStmt? _stmt;

  // statement of this statement
  bool _initState = true;

  // number of parameter in the statement
  late final int _paramCount;

  // total column count
  late final int _columnCount;

  // list of column in the result set
  late final List<String> _columns;

  // list of type of each columns
  late final List<String?> _declTypes;

  // column name and index mapping
  late final Map<String, int> _columnIndexes;

  @override
  int get parameterCount => _paramCount;

  static void _ensureStatementAndDatabaseOpen(Statement? stmt) {
    if (stmt == null || stmt.isClosed) throw sql.DatabaseException('Statement has been closed.');
    stmt._db._ensureDatabaseOpen();
  }

  /// Provide an access to c native pointer database in expose api is not enough.
  Future<void> withNative(Future<void> Function(sqlite.PtrStmt) block) {
    _ensureStatementAndDatabaseOpen(this);
    return block(_stmt!);
  }

  /// get access to native c pointer
  sqlite.PtrStmt get native {
    _ensureStatementAndDatabaseOpen(this);
    return _stmt!;
  }

  @override
  bool get isClosed => _stmt == null;

  @override
  Future<void> close() async {
    _ensureStatementAndDatabaseOpen(this);
    Driver.binder.finalize(_stmt!);
    _db._onStatementUpdate(false);
    _stmt = null;
  }

  @override
  bool get initialState => _initState;

  @override
  Future<void> reset() async {
    _ensureStatementAndDatabaseOpen(this);
    Driver.binder.reset(_stmt!);
    Driver.binder.clear_bindings(_stmt!);
    _initState = true;
  }

  @override
  sql.ReadStatement read() => this;

  @override
  sql.WriteStatement write() => this;

  @override
  Future<sql.Changes> exec({Iterable<dynamic>? parameters, bool reusable = false}) async {
    Statement._ensureStatementAndDatabaseOpen(this);
    // bind parameter is available
    if (parameters != null && parameters.isNotEmpty || parameterCount > 0) {
      Statement._bindParameters(this, parameters);
    }

    int resultCode;
    do {
      resultCode = Driver.binder.step(_stmt!);
    } while (resultCode == sqlite.ROW || resultCode == sqlite.OK);
    _initState = false;

    // something wrong
    if (resultCode != sqlite.DONE) {
      // close right away when user specified once
      close();
      throw SQLiteException(cdb: _db._db!, returnCode: resultCode);
    } else if (!reusable) {
      close();
    }
    return Changes._(_db);
  }

  @override
  Future<sql.Rows<T>> query<T>({Iterable<dynamic>? parameters, sql.RowCreator<T>? creator}) async {
    Statement._ensureStatementAndDatabaseOpen(this);
    // bind parameter is available
    if (parameters != null && parameters.isNotEmpty || parameterCount > 0) {
      Statement._bindParameters(this, parameters);
    }
    _initState = false;
    return Rows._(this, creator);
  }

  // bind the statement with the parameters
  static void _bindParameters(Statement stmt, Iterable<dynamic>? parameters) {
    if ((parameters?.length ?? 0) < stmt.parameterCount) {
      throw sql.DatabaseException('Not enough parameter required ${stmt.parameterCount} '
          'but given ${parameters?.length}.');
    } else if ((parameters?.length ?? 0) > stmt.parameterCount) {
      throw sql.DatabaseException('Too many parameter required ${stmt.parameterCount} '
          'but given ${parameters?.length}.');
    }

    var resultCode = -1;
    final set = Set.from(List<int>.generate(parameters!.length, (index) => index + 1));
    final remains = [];
    for (var i = 0; i < parameters.length; i++) {
      final param = parameters.elementAt(i);
      if (param is NameParameter) {
        final index = NameParameter.indexOf(stmt, param);
        set.remove(index);
        resultCode = param._bind(stmt, index);
        if (resultCode != sqlite.OK) {
          throw SQLiteException(cdb: stmt._db._db!, returnCode: resultCode);
        }
      } else if (param is IndexParameter) {
        set.remove(param.index);
        resultCode = param._bind(stmt, param.index);
        if (resultCode != sqlite.OK) {
          throw SQLiteException(cdb: stmt._db._db!, returnCode: resultCode);
        }
      } else {
        remains.add(param);
      }
    }
    for (var i = 0; i < set.length; i++) {
      resultCode = defaultBindingHandler(stmt, remains[i], set.elementAt(i));
      if (resultCode != sqlite.OK) {
        throw SQLiteException(
          cdb: stmt._db._db!,
          message: 'bind failed at index $i ${set.elementAt(i)} with ${remains[i]}, '
              'max index ${stmt.parameterCount}',
          returnCode: resultCode,
        );
      }
    }
  }
}
