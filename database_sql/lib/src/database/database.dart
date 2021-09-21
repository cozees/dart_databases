library database;

import 'dart:typed_data';

part 'common.dart';

part 'driver.dart';

part 'exception.dart';

part 'function.dart';

part 'response.dart';

part 'statement.dart';

/// Default transaction class
abstract class Transaction {
  /// Commit to persist data
  Future<void> apply();

  /// Discard any change happen in current transaction
  Future<void> cancel();

  /// Returns a prepared statement for read/write.
  Future<Statement> prepare(String query, [dynamic option]);

  /// Quick execution of sql query without holding any statment object.
  Future<Changes> exec(String sql, {Iterable<dynamic>? parameters});

  /// A wrapped method around statement to execute a statement select query
  Future<Rows<T>> query<T>(String query, {Iterable<dynamic>? parameters, RowCreator<T>? creator});
}

/// provide ability to ensure the result from query api will be closed even when an exception occurred.
extension SafeTransaction on Transaction {
  /// A wrapper method to sure that [Rows] will always close at the after exit the function.
  Future<void> protectQuery<T>(
    String query, {
    Iterable<dynamic>? parameters,
    RowCreator<T>? creator,
    required Future<void> Function(Rows<T>) block,
  }) async {
    Rows<T>? rows;
    try {
      rows = await this.query(query, parameters: parameters, creator: creator);
      await block(rows);
    } finally {
      rows?.close();
    }
  }
}

/// provide custom function to create custom transaction.
///
/// In database engine where multiple type of transaction available the create can be use to provide
/// other kind of transaction which is different than the default transaction.
typedef TransactionCreator<T> = T Function(Database db);

/// A connection to a database.
abstract class Database {
  /// Return true if connection has been close otherwise false.
  ///
  /// Closed connection are not reusable and the connection pool will discard it.
  bool get isClosed;

  /// Ping verifies a connection to the database is still alive, establishing a connection if necessary.
  Future<void> ping();

  /// Close invalidates and potentially stops any current prepared statements and transactions,
  /// marking this connection as no longer in use.
  Future<void> close();

  /// Begin starts and returns a new transaction.
  ///
  /// Depend on database engine, when open a transaction, the api might block the execution until
  /// the transaction is available again. If the [timeout] is provided the api will throw an error
  /// timeout when waiting exceed the duration provide the [timeout].
  Future<T> begin<T extends Transaction>({TransactionCreator<T>? creator, Duration? timeout});

  /// Returns a prepared statement for read or write.
  Future<Statement> prepare(String query, [dynamic option]);

  /// Quick execution of sql query without holding any statment object.
  Future<Changes> exec(String sql, {Iterable<dynamic>? parameters});

  /// A wrapped method around statement to execute a statement select query
  Future<Rows<T>> query<T>(String query, {Iterable<dynamic>? parameters, RowCreator<T>? creator});
}

/// provide ability to ensure the result from query api will be closed even when an exception occurred.
extension SafeDatabaseQuery on Database {
  /// A wrapper method to sure that [Rows] will always close at the after exit the function.
  Future<void> protectQuery<T>(
    String query, {
    Iterable<dynamic>? parameters,
    RowCreator<T>? creator,
    required Future<void> Function(Rows<T>) block,
  }) async {
    Rows<T>? rows;
    try {
      rows = await this.query(query, parameters: parameters, creator: creator);
      await block(rows);
    } finally {
      rows?.close();
    }
  }
}

/// Transaction block style
extension DatabaseTransaction on Database {
  /// Execute a transaction in block as soon as block finish or failed because of exception the
  /// the transaction will apply or cancel accordingly.
  ///
  /// Important: Do not apply or cancel transaction manually within the block. Although the api is
  /// ensure transaction to be apply or cancel after [block] execution done however it does not
  /// silent the exception thus developer must catch the error and handle error properly.
  /// See [Database.begin] for more info.
  Future<void> protectTransaction<T extends Transaction>({
    required Future<void> Function(Database, T) block,
    TransactionCreator<T>? creator,
    Duration? timeout,
  }) async {
    final tx = await begin<T>(creator: creator, timeout: timeout);
    try {
      await block(this, tx);
      await tx.apply();
    } catch (e) {
      await tx.cancel();
      rethrow;
    }
  }
}
