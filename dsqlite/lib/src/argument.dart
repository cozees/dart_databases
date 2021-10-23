part of 'database.dart';

/// A function which responsible to bind input argument of the statement query.
typedef ParameterBinder<T> = int Function(Statement stmt, T? value, int index);

/// Base class represent parameter
abstract class Parameter<T> {
  /// create Parameter
  Parameter(this.value, [this.paramBinder]);

  /// value to bind to the statement
  final T? value;

  /// Custom binder to bind value to the statement
  final ParameterBinder<T>? paramBinder;

  /// bind value to the statement
  int _bind(Statement stmt, int index) {
    if (paramBinder != null) return paramBinder!(stmt, value, index);
    return defaultBindingHandler(stmt, value, index);
  }
}

/// SQLite named parameter
class NameParameter<T> extends Parameter<T> {
  /// Create SQLite named parameter
  NameParameter(this.name, dynamic value, {this.prefix, ParameterBinder<T>? paramBinder})
      : assert(prefix == null || prefix == '\$' || prefix == ':' || prefix == '@',
            'prefix should be either null or once of :, \$ and @'),
        super(value, paramBinder);

  /// name of the parameter
  final String name;

  /// prefix of indicate the name of parameter in statement query.
  final String? prefix;

  /// Eligible prefix use to identify name parameter in sqlite query.
  static const prefixes = [':', '@', '\$'];

  /// find an index of named parameter
  ///
  /// Return -1 if not found otherwise all index is always greater than 0
  static int indexOf(Statement stmt, NameParameter np) {
    for (var prefix in np.prefix == null ? prefixes : [np.prefix]) {
      final index = Driver.binder.bind_parameter_index(stmt._stmt!, '$prefix${np.name}');
      if (index > 0) return index;
    }
    return -1;
  }
}

/// SQLite indexed parameter
class IndexParameter<T> extends Parameter<T> {
  /// Create indexed parameter
  IndexParameter(this.index, dynamic value, [ParameterBinder<T>? paramBinder])
      : super(value, paramBinder);

  /// An explicit index for a parameter
  final int index;
}

/// Utility to help convert a map into NameParameter
extension MapToNameParameter on Map<String, dynamic> {
  /// Convert map into name parameter
  List<Parameter> toNameParameter([String? prefix]) {
    return [for (var k in keys) NameParameter(k, this[k], prefix: prefix)];
  }

  /// Convert map into name parameter with provided binding method
  List<Parameter> toTypedNameParameter([String? prefix]) {
    return [
      for (var k in keys)
        if (this[k] is int)
          NameParameter<int>(k, this[k], prefix: prefix, paramBinder: bindInt)
        else if (this[k] is String)
          NameParameter<String>(k, this[k], prefix: prefix, paramBinder: bindString)
        else if (this[k] is double)
          NameParameter<double>(k, this[k], prefix: prefix, paramBinder: bindDouble)
        else if (this[k] is bool)
          NameParameter<bool>(k, this[k], prefix: prefix, paramBinder: bindBool)
        else if (this[k] is DateTime)
          NameParameter<DateTime>(k, this[k], prefix: prefix, paramBinder: bindDateTime)
        else if (this[k] is Uri)
          NameParameter<Uri>(k, this[k], prefix: prefix, paramBinder: bindUri)
        else if (this[k] is Duration)
          NameParameter<Duration>(k, this[k], prefix: prefix, paramBinder: bindDuration)
        else if (this[k] is RegExp)
          NameParameter<RegExp>(k, this[k], prefix: prefix, paramBinder: bindRegExp)
        else if (this[k] is Uint8List)
          NameParameter<Uint8List>(k, this[k], prefix: prefix, paramBinder: bindBlob)
        else
          NameParameter(k, this[k], prefix: prefix)
    ];
  }
}

/// The default argument binder.
///
/// [defaultBindingHandler] support a few type that can be translate or convert into a datatype that
/// supported by SQLite below is the support Dart type that can be convert into SQLite supported type.
///
/// 1. NULL
/// 2. bool
/// 3. int
/// 4. double
/// 5. String
/// 6. Uint8List
/// 7. DateTime
/// 8. Uri
/// 9. Duration
/// 10. num
/// 11. RegExp
/// 12. Argument
int defaultBindingHandler(Statement stmt, dynamic value, int index) {
  if (value is bool?) return bindBool(stmt, value, index);
  if (value is int?) return bindInt(stmt, value, index);
  if (value is double?) return bindDouble(stmt, value, index);
  if (value is String?) return bindString(stmt, value, index);
  if (value is Uint8List?) return bindBlob(stmt, value, index);
  if (value is DateTime?) return bindDateTime(stmt, value, index);
  if (value is Uri?) return bindUri(stmt, value, index);
  if (value is Duration?) return bindDuration(stmt, value, index);
  if (value is RegExp?) return bindRegExp(stmt, value, index);
  // not supported
  throw sql.DatabaseException('Unsupported binding value $value. Try implement Argument instead.');
}

/// Bind a [Statement] [stmt] with a String [value] at the given [index].
int bindString(Statement stmt, String? value, int index) {
  if (value == null) return bindNull(stmt, index);
  return Driver.binder.bind_text(stmt._stmt!, index, value);
}

/// Bind a [Statement] [iStmt] with a integer [value] at the given [index].
int bindInt(Statement stmt, int? value, int index) {
  if (value == null) return bindNull(stmt, index);
  if (value.bitLength > 32) return Driver.binder.bind_int64(stmt._stmt!, index, value);
  return Driver.binder.bind_int(stmt._stmt!, index, value);
}

/// Bind a [Statement] [stmt] with a double [value] at the given [index].
int bindDouble(Statement stmt, double? value, int index) {
  if (value == null) return bindNull(stmt, index);
  return Driver.binder.bind_double(stmt._stmt!, index, value);
}

/// Bind a [Statement] [stmt] with a bool [value] at the given [index].
int bindBool(Statement stmt, bool? value, int index) {
  if (value == null) return bindNull(stmt, index);
  return Driver.binder.bind_int(stmt._stmt!, index, value ? 1 : 0);
}

/// Bind a [Statement] [stmt] with a DateTime [value] at the given [index].
int bindDateTime(Statement stmt, DateTime? value, int index) =>
    bindString(stmt, value?.toIso8601String(), index);

/// Bind a [Statement] [stmt] with a Uri [value] at the given [index].
int bindUri(Statement stmt, Uri? value, int index) => bindString(stmt, value?.toString(), index);

/// Bind a [Statement] [stmt] with a Duration [value] at the given [index].
int bindDuration(Statement stmt, Duration? value, int index) =>
    bindInt(stmt, value?.inMicroseconds, index);

/// Bind a [Statement] [stmt] with a RegExp [value] at the given [index].
int bindRegExp(Statement stmt, RegExp? value, int index) => bindString(stmt, value?.pattern, index);

/// Bind a [Statement] [stmt] with null value at the given [index].
int bindNull(Statement stmt, int index) => Driver.binder.bind_null(stmt._stmt!, index);

/// Bind a [Statement] [stmt] with a binary list [value] at the given [index].
///
/// A void using huge blob data
int bindBlob(Statement stmt, Uint8List? value, int index) {
  if (value == null) return bindNull(stmt, index);
  return Driver.binder.bind_blob(stmt._stmt!, index, value);
}
