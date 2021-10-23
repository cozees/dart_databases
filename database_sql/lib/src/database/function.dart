part of 'database.dart';

/// A function to allow the callback to be able to read appropriate data type of value for dart function argument.
typedef ArgumentConverter = dynamic Function(int index, ValueReader reader);

/// Default argument converter, it use when there is not argument converter provided to function.
dynamic defaultArgumentConverter(int index, ValueReader reader) =>
    reader.valueAt(index);

/// A function to convert value return by dart function to a compatible data type.
typedef FunctionResultConverter<T> = dynamic Function(T);

/// A function that handle write response back to database engine.
typedef FunctionResultHandler<A, R> = void Function(A, R?);

/// Database Function metadata
class DatabaseFunction<A, R> {
  /// create Database function metadata
  const DatabaseFunction({
    required this.func,
    required this.argumentsNumber,
    this.optionalArgument = 0,
    this.dbArgument,
    this.argConverter = defaultArgumentConverter,
    this.resultConverter,
    this.resultHandler,
  });

  /// A dart function that handle custom function call in query.
  ///
  /// Support custom function in the query which is not pre-define by Database Engine and can be register
  /// on the fly. For example, if we register the below function under a name `triple` then we can
  /// use this function in the query `SELECT triple(2);`.
  /// ```dart
  /// dynamic triple(dynamic val) {
  ///   if (val is int || val is double) return val * 3;
  /// }
  /// ```
  final Function func;

  /// A number of argument that given to database engine.
  ///
  /// Since dart support optional positional argument, to allow database engine to know that the
  /// custom registered function accept vary argument is to report to database engine with a specific
  /// value that known to database engine. For example most database engine known value is -1. If
  /// The argument is null then the [argumentsNumber] is use intstead.
  final int? dbArgument;

  /// The total number of argument that dart function accepted.
  ///
  /// As Dart does not support unlimited argument syntax when the value is set to -1, the argument
  /// given to function [func] will be single [List] of [dynamic] argument.
  final int argumentsNumber;

  /// The number of optional positional argument.
  ///
  /// The value is ignored when [argumentsNumber] is set to less than 1.
  final int optionalArgument;

  /// The converter which read the Value and convert them into appropriate dart type.
  ///
  /// By default, if the converter is null then the [defaultArgumentConverter()] is used. The default
  /// converter is relied on Database Engine Value data type to convert into the corresponded dart type.
  /// If the function required other data type as the argument then [argConverter] converter must be provided.
  /// ```dart
  /// int triple(dynamic val, bool addOne) {
  ///   return addOne ? (val * 3) + 1 : val * 3;
  /// }
  ///
  /// dynamic tripleArgConverter(int index, ValueReader reader) {
  ///   if (index == 0) return reader.intValueAt(0);
  ///   if (index == 1) return reader.stringValueAt(1) == 'TRUE';
  /// }
  /// ```
  /// Then in the query use `SELECT triple(5, TRUE);`
  final ArgumentConverter argConverter;

  /// The converter to handle unsupported database from the returned function.
  ///
  /// ```dart
  /// dynamic triple(int val) {
  ///   if (val < 100) return val * 100;
  ///   if (val < 1000) return Duration(seconds: val * 1000);
  ///   else return DateTime.now();
  /// }
  ///
  /// dynamic tripleReturnConverter(dynamic arg) {
  ///   if (arg is int) return '$arg';
  ///   if (arg is Duration) return arg.toString();
  ///   if (arg is DataTime) return arg.toIso8601String();
  ///   else throw Exception('Unsupported return value $arg');
  /// }
  /// ```
  final FunctionResultConverter? resultConverter;

  /// Custom function to write result back to database engine.
  final FunctionResultHandler<A, R>? resultHandler;

  /// Return [dbArgument] is not null other return [argumentsNumber].
  int get dbFunctionArgsCount => dbArgument ?? argumentsNumber;
}

/// A base class to handle aggregate call.
abstract class AggregateHandler {
  /// Return a step function to be called.
  Function get step;

  /// Call by Database Engine when aggregate function come to the conclusion
  dynamic finalize();
}

/// A class represent Aggregator Function handler.
abstract class AggregatorFunction<A, R> {
  /// Create aggregate function metadata
  const AggregatorFunction({
    this.argumentsNumber = 0,
    this.optionalArgument = 0,
    this.dbArgument,
    this.argConverter = defaultArgumentConverter,
    this.resultConverter,
    this.resultHandler,
  });

  /// The total number of argument that dart step function accepted.
  ///
  /// Although data [AggregatorFunction.step] accept a list of dynamic value as argument some
  /// database engine required the number of argument to be given for better optimization.
  /// As Dart does not support unlimited argument syntax when the value is set to -1, the argument
  /// given to function from [step] will be single [List] of [dynamic] argument.
  final int argumentsNumber;

  /// The number of optional positional argument.
  ///
  /// The value is ignored when [argumentsNumber] is set to less than 1.
  final int optionalArgument;

  /// A number of argument that given to database engine.
  ///
  /// Since dart support optional positional argument, to allow database engine to know that the
  /// custom registered function accept vary argument is to report to database engine with a specific
  /// value that known to database engine. For example most database engine known value is -1. If
  /// The argument is null then the [argumentsNumber] is use intstead.
  final int? dbArgument;

  /// The converter which read the Value and convert them into appropriate dart type.
  ///
  /// See [DatabaseFunction.argConverter]
  final ArgumentConverter argConverter;

  /// The converter which convert non-supported data type into once of String, int, double, Uint8List or null.
  ///
  /// See [DatabaseFunction.resultConverter]
  final FunctionResultConverter? resultConverter;

  /// Custom function to write result back to database engine.
  final FunctionResultHandler<A, R>? resultHandler;

  /// Return [dbArgument] is not null other return [argumentsNumber].
  int get dbFunctionArgsCount => dbArgument ?? argumentsNumber;
}
