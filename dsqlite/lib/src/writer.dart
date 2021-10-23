part of 'database.dart';

/// Use by [Database] to response an error to SQLite.
void applyErrorResult(sqlite.PtrContext ctx, String message, [int? errorCode]) {
  Driver.binder.result_error(ctx, message);
  if (errorCode != null) Driver.binder.result_error_code(ctx, errorCode);
}

/// Default [sql.FunctionResultHandler] handler.
void applyResult(sqlite.PtrContext ctx, dynamic val) {
  // integer like value
  if (val == null) {
    applyNullResult(ctx);
  } else if (val is Duration) {
    applyIntResult(ctx, val.inMicroseconds);
  } else if (val is int) {
    applyIntResult(ctx, val);
  } else if (val is bool) {
    applyIntResult(ctx, val ? 1 : 0);
  } else
  // unique value
  if (val is double) {
    Driver.binder.result_double(ctx, val);
  } else if (val is Uint8List) {
    Driver.binder.result_blob(ctx, val);
  } else
  // string like value
  if (val is RegExp) {
    applyStringResult(ctx, val.pattern);
  } else if (val is Uri) {
    applyStringResult(ctx, val.toString());
  } else if (val is DateTime) {
    applyStringResult(ctx, val.toIso8601String());
  } else if (val is String) {
    applyStringResult(ctx, val);
  } else {
    applyErrorResult(ctx, 'Dart return unsupported value $val.');
  }
}

/// Default null result handler
void applyNullResult(sqlite.PtrContext ctx) => Driver.binder.result_null(ctx);

/// Default string result handler
void applyStringResult(sqlite.PtrContext ctx, String? val) =>
    val == null ? applyNullResult(ctx) : Driver.binder.result_text(ctx, val);

/// Default int result handler
void applyIntResult(sqlite.PtrContext ctx, int? val) => val == null
    ? applyNullResult(ctx)
    : (val.bitLength > 32
        ? Driver.binder.result_int64(ctx, val)
        : Driver.binder.result_int(ctx, val));

/// Default double result handler
void applyDoubleResult(sqlite.PtrContext ctx, double? val) =>
    val == null ? applyNullResult(ctx) : Driver.binder.result_double(ctx, val);

/// Default Uint8List result handler
void applyBlobResult(sqlite.PtrContext ctx, Uint8List? val) =>
    val == null ? applyNullResult(ctx) : Driver.binder.result_blob(ctx, val);

/// Default bool result handler
void applyBoolResult(sqlite.PtrContext ctx, bool? val) =>
    val == null ? applyNullResult(ctx) : Driver.binder.result_int(ctx, val ? 1 : 0);

/// Default Uri result handler
void applyUriResult(sqlite.PtrContext ctx, Uri? val) =>
    val == null ? applyNullResult(ctx) : applyStringResult(ctx, val.toString());

/// Default Duration result handler
void applyDurationResult(sqlite.PtrContext ctx, Duration? val) =>
    val == null ? applyNullResult(ctx) : applyIntResult(ctx, val.inMicroseconds);

/// Default RegExp result handler
void applyRegExpResult(sqlite.PtrContext ctx, RegExp? val) =>
    val == null ? applyNullResult(ctx) : applyStringResult(ctx, val.pattern);

/// Default DateTime result handler
void applyDateTimeResult(sqlite.PtrContext ctx, DateTime? val) =>
    val == null ? applyNullResult(ctx) : applyStringResult(ctx, val.toIso8601String());
