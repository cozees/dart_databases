part of 'database.dart';

/// A class define a method to convert the dart class into SQL supported value.
abstract class SQLValue {
  /// Return the value that as String, int, double, Uint8List or null which represent that current state of the object.
  ///
  /// The value return must be an SQL supported value otherwise an exception is throw. It also
  /// important not return a value of [SQLValue] too. It only expected once of above data type.
  dynamic value();
}

/// A class provide a method to read value SQL Value or Column from select query.
abstract class ValueReader {
  /// Read an appropriate value from SQL Value or Column based on SQL type affinity by [index].
  ///
  /// When the method is used to read value from select query, the returned value is also determine
  /// based on type declaration such as DateTime, bool ...etc.
  T? valueAt<T>(int index);

  /// Read an integer value by [index].
  int? intValueAt(int index);

  /// Read a string value by [index].
  String? stringValueAt(int index);

  /// Read a double value by [index].
  double? doubleValueAt(int index);

  /// Read binary value by [index].
  Uint8List? blobValueAt(int index);
}

/// A class provide a method to read data from select query.
abstract class RowReader implements ValueReader {
  /// Read an appropriate value from SQL statement result by [name].
  T? valueBy<T>(String name);

  /// Read an integer value by [name].
  int? intValueBy(String name);

  /// Read a string value by [name].
  String? stringValueBy(String name);

  /// Read a double value by [name].
  double? doubleValueBy(String name);

  /// Read binary value by [name].
  Uint8List? blobValueBy(String name);
}
