part of 'database.dart';

/// Query prepare statement.
abstract class Statement {
  /// The number of placeholder parameters in query.
  int get parameterCount;

  /// Check whether the statement is closed
  bool get isClosed;

  /// Closes the statement.
  Future<void> close();

  /// return true if statement is reset back to a state after prepare from database.
  bool get initialState;

  /// Reset statement back to it initialize state.
  ///
  /// Some database does not support reset its state therefore it throw exception when call this
  /// method.
  Future<void> reset();

  /// To a write statement
  WriteStatement write();

  /// To a read statement
  ReadStatement read();
}

/// A statement use for SELECT query or query data in general
abstract class ReadStatement implements Statement {
  /// Executes a query such as SELECT with or without parameter.
  Future<Rows<T>> query<T>(
      {Iterable<dynamic>? parameters, RowCreator<T>? creator});
}

/// A statement use for write query such as INSERT, DELETE, UPDATE ...etc.
abstract class WriteStatement implements Statement {
  /// Executes a query such as INSERT or UPDATE with or without parameter.
  Future<Changes> exec({Iterable<dynamic>? parameters, bool reusable = false});
}

/// Utility to helper to get read/write statement
extension FutureStatement on Future<Statement> {
  /// return write statement future
  Future<WriteStatement> write() => then((Statement stmt) => stmt.write());

  /// return write statement future
  Future<ReadStatement> read() => then((Statement stmt) => stmt.read());
}
