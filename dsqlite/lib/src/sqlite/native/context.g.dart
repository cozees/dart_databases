// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

typedef _c_sqlite3_aggregate_context = PtrVoid Function(PtrContext, Nint32);
typedef _d_sqlite3_aggregate_context = PtrVoid Function(PtrContext, int);
typedef _c_sqlite3_context_db_handle = PtrSqlite3 Function(PtrContext);
typedef _d_sqlite3_context_db_handle = PtrSqlite3 Function(PtrContext);
typedef _c_sqlite3_user_data = PtrVoid Function(PtrContext);
typedef _d_sqlite3_user_data = PtrVoid Function(PtrContext);

// Mixin for Context
mixin _MixinContext on _SQLiteLibrary {
  late final _d_sqlite3_aggregate_context _h_sqlite3_aggregate_context =
      library.lookupFunction<_c_sqlite3_aggregate_context, _d_sqlite3_aggregate_context>(
          'sqlite3_aggregate_context');

  late final _d_sqlite3_context_db_handle? _h_sqlite3_context_db_handle = libVersionNumber < 3005008
      ? null
      : library.lookupFunction<_c_sqlite3_context_db_handle, _d_sqlite3_context_db_handle>(
          'sqlite3_context_db_handle');

  late final _d_sqlite3_user_data _h_sqlite3_user_data =
      library.lookupFunction<_c_sqlite3_user_data, _d_sqlite3_user_data>('sqlite3_user_data');

  PtrVoid? aggregate_context(PtrContext arg1, int nBytes) {
    var result = _h_sqlite3_aggregate_context(arg1, nBytes);
    return result == ffi.nullptr ? null : result;
  }

  PtrSqlite3 context_db_handle(PtrContext arg1) {
    if (libVersionNumber < 3005008) {
      throw dbsql.DatabaseException('API sqlite3_context_db_handle is not available before 3.5.8');
    }
    return _h_sqlite3_context_db_handle!(arg1);
  }

  PtrVoid? user_data(PtrContext arg1) {
    var result = _h_sqlite3_user_data(arg1);
    return result == ffi.nullptr ? null : result;
  }
}
