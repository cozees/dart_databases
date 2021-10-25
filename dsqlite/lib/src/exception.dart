// coverage:ignore-file
part of 'database.dart';

/// SQLite Exception
///
/// This Exception is raise whenever SQLite error occurred.
class SQLiteException extends sql.DatabaseException {
  factory SQLiteException({
    required sqlite.PtrSqlite3 cdb,
    String? message,
    int? returnCode,
  }) {
    final binder = Driver.binder;
    final dbMessage = message ?? binder.errmsg(cdb);
    final extendedCode = binder.extended_errcode(cdb);
    final errStr = returnCode != null ? binder.errstr(returnCode) : '';
    final explanation = '$errStr (code $extendedCode)';
    return SQLiteException.withCode(
      code: returnCode,
      message: dbMessage,
      detail: explanation,
    );
  }

  SQLiteException.withCode({required this.code, required String message, required this.detail})
      : super(message);

  /// The SQLite result code
  final int? code;

  /// The SQLite message explain about the error code.
  final String detail;

  @override
  String toString() {
    Object? message = this.message;
    return 'SQLiteException: $message\n\t$detail';
  }
}
