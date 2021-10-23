part of 'database.dart';

/// savepoint creator function
///
/// If name is not given then a new name will be generated
sql.TransactionCreator<SavePoint> savePointCreator([String? name]) =>
    ((sql.Database db) => SavePoint._(db as Database, name));

/// SQLite SavePoint for nested transaction
///
/// By default, the [sql.Database.begin] will create a default [Transaction] class instead of SavePoint.
/// To create the SavePoint transaction pass [sql.TransactionCreator] return from [savePointCreator].
class SavePoint implements sql.Transaction {
  // incremental index of each name
  static var _nameIndex = 0;

  /// create a new savepoint name
  static String get newName => 'savepoint${++_nameIndex}';

  // Create save pointer transaction.
  SavePoint._(this.db, [String? name]) : name = name ?? newName {
    db.exec('SAVEPOINT ${this.name}');
    // increase number of count
    db._onSavePointUpdate(true);
  }

  /// database connection, It should be a class [Database]
  final Database db;

  /// Name of current save pointer.
  final String name;

  // use to trace whether savepoint has finalize
  var _finalize = false;

  // ensure that save has not yet apply or cancel
  void _ensureNotFinalize() {
    if (_finalize) throw sql.DatabaseException('SavePoint have been finalized.');
  }

  @override
  Future<void> apply() async {
    _ensureNotFinalize();
    db.exec('RELEASE SAVEPOINT $name');
    db._onSavePointUpdate(false);
    _finalize = true;
    _nameIndex--;
  }

  @override
  Future<void> cancel() async {
    _ensureNotFinalize();
    db.exec('ROLLBACK TRANSACTION TO SAVEPOINT $name');
    db._onSavePointUpdate(false);
    _finalize = true;
    _nameIndex--;
  }

  @override
  Future<sql.Changes> exec(String sql, {Iterable<dynamic>? parameters}) {
    _ensureNotFinalize();
    return db.exec(sql, parameters: parameters);
  }

  @override
  Future<sql.Statement> prepare(String query, [dynamic option]) {
    _ensureNotFinalize();
    return db.prepare(query, option);
  }

  @override
  Future<sql.Rows<T>> query<T>(String query,
      {Iterable<dynamic>? parameters, sql.RowCreator<T>? creator}) {
    _ensureNotFinalize();
    return db.query(query, parameters: parameters, creator: creator);
  }
}

/// SQLite transaction control
///
/// See https://sqlite.org/lang_transaction.html for more information
enum SQLiteTransactionControl {
  deferred,
  immediate,
  exclusive,
}

const _sqlTransactionControl = [
  'DEFERRED',
  'IMMEDIATE',
  'EXCLUSIVE',
];

/// transaction creator function to apply the control
///
/// If the [control] is not given then it will omit when begin transaction and the default behavior
/// is depend on how SQLite engine to determine. It suppose to be one of [SQLiteTransactionControl].
/// More information see https://www.sqlite.org/lang_transaction.html
sql.TransactionCreator<Transaction> transactionCreator([SQLiteTransactionControl? control]) =>
    ((sql.Database db) => Transaction._(db as Database, control));

/// Default SQLite transaction
///
/// By default, the [sql.Database.begin] will create a default [Transaction] without transaction control.
/// To create the transaction with specific control pass [sql.TransactionCreator] return from [transactionCreator].
class Transaction implements sql.Transaction {
  /// Create default transaction
  Transaction._(this.db, [SQLiteTransactionControl? control]) {
    final sqlControl = control == null ? '' : _sqlTransactionControl[control.index];
    db.exec('BEGIN $sqlControl TRANSACTION');
    db._onTransactionUpdate(true);
  }

  /// database connection, It should be a class [Database]
  final Database db;

  // use to trace whether savepoint has finalize
  var _finalize = false;

  // ensure that save has not yet apply or cancel
  void _ensureNotFinalize() {
    if (_finalize) throw sql.DatabaseException('Transaction have been finalized.');
  }

  @override
  Future<void> apply() async {
    _ensureNotFinalize();
    db.exec('COMMIT TRANSACTION');
    db._onTransactionUpdate(false);
    _finalize = true;
  }

  @override
  Future<void> cancel() async {
    _ensureNotFinalize();
    db.exec('ROLLBACK TRANSACTION');
    db._onTransactionUpdate(false);
    _finalize = true;
  }

  @override
  Future<sql.Changes> exec(String sql, {Iterable<dynamic>? parameters}) {
    _ensureNotFinalize();
    return db.exec(sql, parameters: parameters);
  }

  @override
  Future<sql.Statement> prepare(String query, [dynamic option]) {
    _ensureNotFinalize();
    return db.prepare(query, option);
  }

  @override
  Future<sql.Rows<T>> query<T>(String query,
      {Iterable<dynamic>? parameters, sql.RowCreator<T>? creator}) {
    _ensureNotFinalize();
    return db.query(query, parameters: parameters, creator: creator);
  }
}
