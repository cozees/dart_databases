// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

/// Each open SQLite database is represented by a pointer to an instance of the opaque structure named
/// "sqlite3".
///
/// It is useful to think of an sqlite3 pointer as an object. The [sqlite3_open()](https://www.sqlite.org/capi3ref.html#sqlite3_open),
/// [sqlite3_open16()](https://www.sqlite.org/capi3ref.html#sqlite3_open), and [sqlite3\_open\_v2()](https://www.sqlite.org/capi3ref.html#sqlite3_open)
/// interfaces are its constructors, and [sqlite3_close()](https://www.sqlite.org/capi3ref.html#sqlite3_close)
/// and [sqlite3\_close\_v2()](https://www.sqlite.org/capi3ref.html#sqlite3_close) are its destructors.
/// There are many other interfaces (such as [sqlite3\_prepare\_v2()](https://www.sqlite.org/capi3ref.html#sqlite3_prepare),
/// [sqlite3\_create\_function()](https://www.sqlite.org/capi3ref.html#sqlite3_create_function), and
/// [sqlite3\_busy\_timeout()](https://www.sqlite.org/capi3ref.html#sqlite3_busy_timeout) to name but
/// three) that are methods on an sqlite3 object.
class sqlite3 extends NativeType {}

/// The context in which an SQL function executes is stored in an sqlite3\_context object.
///
/// A pointer to an sqlite3\_context object is always first parameter to [application-defined SQL functions](https://www.sqlite.org/capi3ref.htmlappfunc.html).
/// The application-defined SQL function implementation will pass this pointer through into calls to
/// [sqlite3_result()](https://www.sqlite.org/capi3ref.html#sqlite3_result_blob), [sqlite3\_aggregate\_context()](https://www.sqlite.org/capi3ref.html#sqlite3_aggregate_context),
/// [sqlite3\_user\_data()](https://www.sqlite.org/capi3ref.html#sqlite3_user_data), [sqlite3\_context\_db_handle()](https://www.sqlite.org/capi3ref.html#sqlite3_context_db_handle),
/// [sqlite3\_get\_auxdata()](https://www.sqlite.org/capi3ref.html#sqlite3_get_auxdata), and/or [sqlite3\_set\_auxdata()](https://www.sqlite.org/capi3ref.html#sqlite3_get_auxdata).
class sqlite3_context extends NativeType {}

/// An instance of this object represents a single SQL statement that has been compiled into binary form
/// and is ready to be evaluated. Think of each SQL statement as a separate computer program.
///
/// The original SQL text is source code. A prepared statement object is the compiled object code. All
/// SQL must be converted into a prepared statement before it can be run. The life-cycle of a prepared
/// statement object usually goes like this:
class sqlite3_stmt extends NativeType {}

/// SQLite uses the sqlite3\_value object to represent all values that can be stored in a database table.
///
/// SQLite uses dynamic typing for the values it stores. Values stored in sqlite3\_value objects can
/// be integers, floating point values, strings, BLOBs, or NULL. An sqlite3\_value object may be either
/// "protected" or "unprotected". Some interfaces require a protected sqlite3\_value. Other interfaces
/// will accept either a protected or an unprotected sqlite3\_value. Every interface that accepts sqlite3\_value
/// arguments specifies whether or not it requires a protected sqlite3_value. The [sqlite3\_value\_dup()](https://www.sqlite.org/capi3ref.html#sqlite3_value_dup)
/// interface can be used to construct a new protected sqlite3\_value from an unprotected sqlite3\_value. The
/// terms "protected" and "unprotected" refer to whether or not a mutex is held. An internal mutex is
/// held for a protected sqlite3\_value object but no mutex is held for an unprotected sqlite3\_value
/// object. If SQLite is compiled to be single-threaded (with [SQLITE_THREADSAFE=0](https://www.sqlite.org/capi3ref.htmlcompile.html#threadsafe)
/// and with [sqlite3_threadsafe()](https://www.sqlite.org/capi3ref.html#sqlite3_threadsafe) returning
/// 0) or if SQLite is run in one of reduced mutex modes [SQLITE\_CONFIG\_SINGLETHREAD](https://www.sqlite.org/capi3ref.html#sqliteconfigsinglethread)
/// or [SQLITE\_CONFIG\_MULTITHREAD](https://www.sqlite.org/capi3ref.html#sqliteconfigmultithread) then
/// there is no distinction between protected and unprotected sqlite3\_value objects and they can be
/// used interchangeably. However, for maximum code portability it is recommended that applications still
/// make the distinction between protected and unprotected sqlite3\_value objects even when not strictly
/// required. The sqlite3_value objects that are passed as parameters into the implementation of [application-defined
/// SQL functions](https://www.sqlite.org/capi3ref.htmlappfunc.html) are protected. The sqlite3_value
/// object returned by [sqlite3\_column\_value()](https://www.sqlite.org/capi3ref.html#sqlite3_column_blob)
/// is unprotected. Unprotected sqlite3_value objects may only be used as arguments to [sqlite3\_result\_value()](https://www.sqlite.org/capi3ref.html#sqlite3_result_blob),
/// [sqlite3\_bind\_value()](https://www.sqlite.org/capi3ref.html#sqlite3_bind_blob), and [sqlite3\_value\_dup()](https://www.sqlite.org/capi3ref.html#sqlite3_value_dup).
/// The [sqlite3\_value\_type()](https://www.sqlite.org/capi3ref.html#sqlite3_value_blob) family of interfaces
/// require protected sqlite3_value objects.
class sqlite3_value extends NativeType {}
