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

  /// Returns a prepared statement for writing data.
  Future<WriteStatement> prepareToWrite(String query, [dynamic option]);

  /// Quick execution of sql query without holding any statment object.
  Future<Changes> exec(String sql, {Iterable<dynamic>? parameters});

  /// Returns a prepared statement for reading data.
  Future<ReadStatement> prepareToRead(String query, [dynamic option]);

  /// A wrapped method around statement to execute a statement select query
  Future<Rows<T>> query<T>(String query, {Iterable<dynamic>? parameters, RowCreator<T>? creator});
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
  Future<T> begin<T extends Transaction>([TransactionCreator<T>? creator]);

  /// Returns a prepared statement for writing data.
  Future<WriteStatement> prepareToWrite(String query, [dynamic option]);

  /// Quick execution of sql query without holding any statment object.
  Future<Changes> exec(String sql, {Iterable<dynamic>? parameters});

  /// Returns a prepared statement for reading data.
  Future<ReadStatement> prepareToRead(String query, [dynamic option]);

  /// A wrapped method around statement to execute a statement select query
  Future<Rows<T>> query<T>(String query, {Iterable<dynamic>? parameters, RowCreator<T>? creator});

  /// A wrapper method to sure that [Rows] will always close at the after exit the function.
  Future<void> protectQuery<T>(
    String query, {
    Iterable<dynamic>? parameters,
    RowCreator<T>? creator,
    required Future<void> Function(Rows<T>) block,
  });
}

/// Transaction block style
extension DatabaseTransaction on Database {
  /// Execute a transaction in block as soon as block finish or failed because of exception the
  /// the transaction will apply or cancel accordingly.
  ///
  /// Important: Do not apply or cancel transaction manually within the block.
  Future<void> beginWithProtect<T extends Transaction>({
    required Future<void> Function(Database, T) block,
    TransactionCreator<T>? creator,
  }) async {
    final tx = await begin<T>(creator);
    try {
      await block(this, tx);
      await tx.apply();
    } catch (e) {
      await tx.cancel();
      rethrow;
    }
  }
}
