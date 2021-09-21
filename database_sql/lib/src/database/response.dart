part of 'database.dart';

/// Result is the result of a INSERT/DELETE/UPDATE query's execution.
abstract class Changes {
  /// the database's auto-generated ID after an INSERT into a table with primary key.
  int get lastInsertId;

  /// The number of rows affected by the query.
  int get rowsAffected;
}

/// Rows is the result of a SELECT query's execution.
abstract class Rows<T> implements Iterator<T> {
  /// The names of the columns in query result.
  List<String> get columns;

  /// The declaration type of each column in the result.
  List<String?> get declarationTypes;

  /// The number of column in the query result.
  int get columnCount;

  /// closes the rows iterator.
  void close();
}

/// A default Object represent row database.
abstract class Row implements RowReader {
  /// create a row data
  Row(this.dataReader);

  /// reader to read value from SQL result set.
  final RowReader dataReader;
}

/// A function which responsible to create Row database from select query.
typedef RowCreator<T> = T Function(RowReader reader);
