// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

typedef DefDefTypeGen7 = ffi.Int32 Function(PtrVoid, ffi.Int32);
typedef DartDefDefTypeGen7 = int Function(PtrVoid, int);
typedef _c_sqlite3_busy_handler = Nint32 Function(PtrSqlite3, PtrDefDefTypeGen7, PtrVoid);
typedef _d_sqlite3_busy_handler = int Function(PtrSqlite3, PtrDefDefTypeGen7, PtrVoid);
typedef _c_sqlite3_busy_timeout = Nint32 Function(PtrSqlite3, Nint32);
typedef _d_sqlite3_busy_timeout = int Function(PtrSqlite3, int);
typedef _c_sqlite3_changes = Nint32 Function(PtrSqlite3);
typedef _d_sqlite3_changes = int Function(PtrSqlite3);
typedef _c_sqlite3_close = Nint32 Function(PtrSqlite3);
typedef _d_sqlite3_close = int Function(PtrSqlite3);
typedef _c_sqlite3_close_v2 = Nint32 Function(PtrSqlite3);
typedef _d_sqlite3_close_v2 = int Function(PtrSqlite3);
typedef _c_sqlite3_db_cacheflush = Nint32 Function(PtrSqlite3);
typedef _d_sqlite3_db_cacheflush = int Function(PtrSqlite3);
typedef _c_sqlite3_db_filename = PtrString Function(PtrSqlite3, PtrString);
typedef _d_sqlite3_db_filename = PtrString Function(PtrSqlite3, PtrString);
typedef _c_sqlite3_db_mutex = PtrMutex Function(PtrSqlite3);
typedef _d_sqlite3_db_mutex = PtrMutex Function(PtrSqlite3);
typedef _c_sqlite3_db_readonly = Nint32 Function(PtrSqlite3, PtrString);
typedef _d_sqlite3_db_readonly = int Function(PtrSqlite3, PtrString);
typedef _c_sqlite3_db_release_memory = Nint32 Function(PtrSqlite3);
typedef _d_sqlite3_db_release_memory = int Function(PtrSqlite3);
typedef _c_sqlite3_db_status = Nint32 Function(PtrSqlite3, Nint32, PtrInt32, PtrInt32, Nint32);
typedef _d_sqlite3_db_status = int Function(PtrSqlite3, int, PtrInt32, PtrInt32, int);
typedef _c_sqlite3_deserialize = Nint32 Function(
    PtrSqlite3, PtrString, ffi.Pointer<ffi.Uint8>, Nint64, Nint64, Nuint32);
typedef _d_sqlite3_deserialize = int Function(
    PtrSqlite3, PtrString, ffi.Pointer<ffi.Uint8>, int, int, int);
typedef _c_sqlite3_enable_load_extension = Nint32 Function(PtrSqlite3, Nint32);
typedef _d_sqlite3_enable_load_extension = int Function(PtrSqlite3, int);
typedef _c_sqlite3_errcode = Nint32 Function(PtrSqlite3);
typedef _d_sqlite3_errcode = int Function(PtrSqlite3);
typedef _c_sqlite3_extended_errcode = Nint32 Function(PtrSqlite3);
typedef _d_sqlite3_extended_errcode = int Function(PtrSqlite3);
typedef _c_sqlite3_errmsg = PtrString Function(PtrSqlite3);
typedef _d_sqlite3_errmsg = PtrString Function(PtrSqlite3);
typedef _c_sqlite3_errmsg16 = PtrVoid Function(PtrSqlite3);
typedef _d_sqlite3_errmsg16 = PtrVoid Function(PtrSqlite3);
typedef _c_sqlite3_errstr = PtrString Function(Nint32);
typedef _d_sqlite3_errstr = PtrString Function(int);
typedef Defcallback = ffi.Int32 Function(PtrVoid, ffi.Int32, PtrPtrUtf8, PtrPtrUtf8);
typedef DartDefcallback = int Function(PtrVoid, int, PtrPtrUtf8, PtrPtrUtf8);
typedef _c_sqlite3_exec = Nint32 Function(
    PtrSqlite3, PtrString, PtrDefcallback, PtrVoid, PtrPtrUtf8);
typedef _d_sqlite3_exec = int Function(PtrSqlite3, PtrString, PtrDefcallback, PtrVoid, PtrPtrUtf8);
typedef _c_sqlite3_extended_result_codes = Nint32 Function(PtrSqlite3, Nint32);
typedef _d_sqlite3_extended_result_codes = int Function(PtrSqlite3, int);
typedef _c_sqlite3_file_control = Nint32 Function(PtrSqlite3, PtrString, Nint32, PtrVoid);
typedef _d_sqlite3_file_control = int Function(PtrSqlite3, PtrString, int, PtrVoid);
typedef _c_sqlite3_get_table = Nint32 Function(
    PtrSqlite3, PtrString, PtrPtrPtrUtf8, PtrInt32, PtrInt32, PtrPtrUtf8);
typedef _d_sqlite3_get_table = int Function(
    PtrSqlite3, PtrString, PtrPtrPtrUtf8, PtrInt32, PtrInt32, PtrPtrUtf8);
typedef _c_sqlite3_free_table = NVoid Function(PtrPtrUtf8);
typedef _d_sqlite3_free_table = void Function(PtrPtrUtf8);
typedef _c_sqlite3_get_autocommit = Nint32 Function(PtrSqlite3);
typedef _d_sqlite3_get_autocommit = int Function(PtrSqlite3);
typedef _c_sqlite3_interrupt = NVoid Function(PtrSqlite3);
typedef _d_sqlite3_interrupt = void Function(PtrSqlite3);
typedef _c_sqlite3_last_insert_rowid = Nint64 Function(PtrSqlite3);
typedef _d_sqlite3_last_insert_rowid = int Function(PtrSqlite3);
typedef _c_sqlite3_limit = Nint32 Function(PtrSqlite3, Nint32, Nint32);
typedef _d_sqlite3_limit = int Function(PtrSqlite3, int, int);
typedef _c_sqlite3_load_extension = Nint32 Function(PtrSqlite3, PtrString, PtrString, PtrPtrUtf8);
typedef _d_sqlite3_load_extension = int Function(PtrSqlite3, PtrString, PtrString, PtrPtrUtf8);
typedef _c_sqlite3_open = Nint32 Function(PtrString, PtrPtrSqlite3);
typedef _d_sqlite3_open = int Function(PtrString, PtrPtrSqlite3);
typedef _c_sqlite3_open16 = Nint32 Function(PtrString16, PtrPtrSqlite3);
typedef _d_sqlite3_open16 = int Function(PtrString16, PtrPtrSqlite3);
typedef _c_sqlite3_open_v2 = Nint32 Function(PtrString, PtrPtrSqlite3, Nint32, PtrString);
typedef _d_sqlite3_open_v2 = int Function(PtrString, PtrPtrSqlite3, int, PtrString);
typedef _c_sqlite3_overload_function = Nint32 Function(PtrSqlite3, PtrString, Nint32);
typedef _d_sqlite3_overload_function = int Function(PtrSqlite3, PtrString, int);
typedef DefxTrace = ffi.Void Function(PtrVoid, PtrString);
typedef DartDefxTrace = void Function(PtrVoid, PtrString);
typedef _c_sqlite3_trace = PtrVoid Function(PtrSqlite3, PtrDefxTrace, PtrVoid);
typedef _d_sqlite3_trace = PtrVoid Function(PtrSqlite3, PtrDefxTrace, PtrVoid);
typedef DefxProfile = ffi.Void Function(PtrVoid, PtrString, ffi.Uint64);
typedef DartDefxProfile = void Function(PtrVoid, PtrString, int);
typedef _c_sqlite3_profile = PtrVoid Function(PtrSqlite3, PtrDefxProfile, PtrVoid);
typedef _d_sqlite3_profile = PtrVoid Function(PtrSqlite3, PtrDefxProfile, PtrVoid);
typedef _c_sqlite3_progress_handler = NVoid Function(PtrSqlite3, Nint32, PtrDefxSize, PtrVoid);
typedef _d_sqlite3_progress_handler = void Function(PtrSqlite3, int, PtrDefxSize, PtrVoid);
typedef _c_sqlite3_serialize = ffi.Pointer<ffi.Uint8>? Function(
    PtrSqlite3, PtrString, PtrInt64, Nuint32);
typedef _d_sqlite3_serialize = ffi.Pointer<ffi.Uint8>? Function(
    PtrSqlite3, PtrString, PtrInt64, int);
typedef DefxAuth = ffi.Int32 Function(
    PtrVoid, ffi.Int32, PtrString, PtrString, PtrString, PtrString);
typedef DartDefxAuth = int Function(PtrVoid, int, PtrString, PtrString, PtrString, PtrString);
typedef _c_sqlite3_set_authorizer = Nint32 Function(PtrSqlite3, PtrDefxAuth, PtrVoid);
typedef _d_sqlite3_set_authorizer = int Function(PtrSqlite3, PtrDefxAuth, PtrVoid);
typedef _c_sqlite3_set_last_insert_rowid = NVoid Function(PtrSqlite3, Nint64);
typedef _d_sqlite3_set_last_insert_rowid = void Function(PtrSqlite3, int);
typedef _c_sqlite3_system_errno = Nint32 Function(PtrSqlite3);
typedef _d_sqlite3_system_errno = int Function(PtrSqlite3);
typedef _c_sqlite3_table_column_metadata = Nint32 Function(PtrSqlite3, PtrString, PtrString,
    PtrString, PtrPtrUtf8, PtrPtrUtf8, PtrInt32, PtrInt32, PtrInt32);
typedef _d_sqlite3_table_column_metadata = int Function(PtrSqlite3, PtrString, PtrString, PtrString,
    PtrPtrUtf8, PtrPtrUtf8, PtrInt32, PtrInt32, PtrInt32);
typedef _c_sqlite3_total_changes = Nint32 Function(PtrSqlite3);
typedef _d_sqlite3_total_changes = int Function(PtrSqlite3);
typedef DefxCallback = ffi.Int32 Function(ffi.Uint32, PtrVoid, PtrVoid, PtrVoid);
typedef DartDefxCallback = int Function(int, PtrVoid, PtrVoid, PtrVoid);
typedef _c_sqlite3_trace_v2 = Nint32 Function(PtrSqlite3, Nuint32, PtrDefxCallback, PtrVoid);
typedef _d_sqlite3_trace_v2 = int Function(PtrSqlite3, int, PtrDefxCallback, PtrVoid);
typedef _c_sqlite3_txn_state = Nint32 Function(PtrSqlite3, PtrString);
typedef _d_sqlite3_txn_state = int Function(PtrSqlite3, PtrString);
typedef DefxNotify = ffi.Void Function(PtrPtrVoid, ffi.Int32);
typedef DartDefxNotify = void Function(PtrPtrVoid, int);
typedef _c_sqlite3_unlock_notify = Nint32 Function(PtrSqlite3, PtrDefxNotify, PtrVoid);
typedef _d_sqlite3_unlock_notify = int Function(PtrSqlite3, PtrDefxNotify, PtrVoid);
typedef _c_sqlite3_wal_autocheckpoint = Nint32 Function(PtrSqlite3, Nint32);
typedef _d_sqlite3_wal_autocheckpoint = int Function(PtrSqlite3, int);
typedef _c_sqlite3_wal_checkpoint = Nint32 Function(PtrSqlite3, PtrString);
typedef _d_sqlite3_wal_checkpoint = int Function(PtrSqlite3, PtrString);
typedef _c_sqlite3_wal_checkpoint_v2 = Nint32 Function(
    PtrSqlite3, PtrString, Nint32, PtrInt32, PtrInt32);
typedef _d_sqlite3_wal_checkpoint_v2 = int Function(PtrSqlite3, PtrString, int, PtrInt32, PtrInt32);
typedef DefDefTypeGen11 = ffi.Int32 Function(PtrVoid, PtrSqlite3, PtrString, ffi.Int32);
typedef DartDefDefTypeGen11 = int Function(PtrVoid, PtrSqlite3, PtrString, int);
typedef _c_sqlite3_wal_hook = PtrVoid Function(PtrSqlite3, PtrDefDefTypeGen11, PtrVoid);
typedef _d_sqlite3_wal_hook = PtrVoid Function(PtrSqlite3, PtrDefDefTypeGen11, PtrVoid);

// Mixin for Database
mixin _MixinDatabase on _SQLiteLibrary {
  late final _d_sqlite3_busy_handler _h_sqlite3_busy_handler = library
      .lookupFunction<_c_sqlite3_busy_handler, _d_sqlite3_busy_handler>('sqlite3_busy_handler');

  late final _d_sqlite3_busy_timeout _h_sqlite3_busy_timeout = library
      .lookupFunction<_c_sqlite3_busy_timeout, _d_sqlite3_busy_timeout>('sqlite3_busy_timeout');

  late final _d_sqlite3_changes _h_sqlite3_changes =
      library.lookupFunction<_c_sqlite3_changes, _d_sqlite3_changes>('sqlite3_changes');

  late final _d_sqlite3_close _h_sqlite3_close =
      library.lookupFunction<_c_sqlite3_close, _d_sqlite3_close>('sqlite3_close');

  late final _d_sqlite3_close_v2? _h_sqlite3_close_v2 = libVersionNumber < 3007014
      ? null
      : library.lookupFunction<_c_sqlite3_close_v2, _d_sqlite3_close_v2>('sqlite3_close_v2');

  late final _d_sqlite3_db_cacheflush? _h_sqlite3_db_cacheflush = libVersionNumber < 3010000
      ? null
      : library.lookupFunction<_c_sqlite3_db_cacheflush, _d_sqlite3_db_cacheflush>(
          'sqlite3_db_cacheflush');

  late final _d_sqlite3_db_filename? _h_sqlite3_db_filename = libVersionNumber < 3007010
      ? null
      : library
          .lookupFunction<_c_sqlite3_db_filename, _d_sqlite3_db_filename>('sqlite3_db_filename');

  late final _d_sqlite3_db_mutex? _h_sqlite3_db_mutex = libVersionNumber < 3006005
      ? null
      : library.lookupFunction<_c_sqlite3_db_mutex, _d_sqlite3_db_mutex>('sqlite3_db_mutex');

  late final _d_sqlite3_db_readonly? _h_sqlite3_db_readonly = libVersionNumber < 3007011
      ? null
      : library
          .lookupFunction<_c_sqlite3_db_readonly, _d_sqlite3_db_readonly>('sqlite3_db_readonly');

  late final _d_sqlite3_db_release_memory? _h_sqlite3_db_release_memory = libVersionNumber < 3007010
      ? null
      : library.lookupFunction<_c_sqlite3_db_release_memory, _d_sqlite3_db_release_memory>(
          'sqlite3_db_release_memory');

  late final _d_sqlite3_db_status? _h_sqlite3_db_status = libVersionNumber < 3006001
      ? null
      : library.lookupFunction<_c_sqlite3_db_status, _d_sqlite3_db_status>('sqlite3_db_status');

  late final _d_sqlite3_deserialize? _h_sqlite3_deserialize = libVersionNumber < 3023000
      ? null
      : library
          .lookupFunction<_c_sqlite3_deserialize, _d_sqlite3_deserialize>('sqlite3_deserialize');

  late final _d_sqlite3_enable_load_extension _h_sqlite3_enable_load_extension =
      library.lookupFunction<_c_sqlite3_enable_load_extension, _d_sqlite3_enable_load_extension>(
          'sqlite3_enable_load_extension');

  late final _d_sqlite3_errcode _h_sqlite3_errcode =
      library.lookupFunction<_c_sqlite3_errcode, _d_sqlite3_errcode>('sqlite3_errcode');

  late final _d_sqlite3_extended_errcode? _h_sqlite3_extended_errcode = libVersionNumber < 3006005
      ? null
      : library.lookupFunction<_c_sqlite3_extended_errcode, _d_sqlite3_extended_errcode>(
          'sqlite3_extended_errcode');

  late final _d_sqlite3_errmsg _h_sqlite3_errmsg =
      library.lookupFunction<_c_sqlite3_errmsg, _d_sqlite3_errmsg>('sqlite3_errmsg');

  late final _d_sqlite3_errmsg16 _h_sqlite3_errmsg16 =
      library.lookupFunction<_c_sqlite3_errmsg16, _d_sqlite3_errmsg16>('sqlite3_errmsg16');

  late final _d_sqlite3_errstr? _h_sqlite3_errstr = libVersionNumber < 3007015
      ? null
      : library.lookupFunction<_c_sqlite3_errstr, _d_sqlite3_errstr>('sqlite3_errstr');

  late final _d_sqlite3_exec _h_sqlite3_exec =
      library.lookupFunction<_c_sqlite3_exec, _d_sqlite3_exec>('sqlite3_exec');

  late final _d_sqlite3_extended_result_codes _h_sqlite3_extended_result_codes =
      library.lookupFunction<_c_sqlite3_extended_result_codes, _d_sqlite3_extended_result_codes>(
          'sqlite3_extended_result_codes');

  late final _d_sqlite3_file_control _h_sqlite3_file_control = library
      .lookupFunction<_c_sqlite3_file_control, _d_sqlite3_file_control>('sqlite3_file_control');

  late final _d_sqlite3_get_table _h_sqlite3_get_table =
      library.lookupFunction<_c_sqlite3_get_table, _d_sqlite3_get_table>('sqlite3_get_table');

  late final _d_sqlite3_free_table _h_sqlite3_free_table =
      library.lookupFunction<_c_sqlite3_free_table, _d_sqlite3_free_table>('sqlite3_free_table');

  late final _d_sqlite3_get_autocommit? _h_sqlite3_get_autocommit = libVersionNumber < 3002002
      ? null
      : library.lookupFunction<_c_sqlite3_get_autocommit, _d_sqlite3_get_autocommit>(
          'sqlite3_get_autocommit');

  late final _d_sqlite3_interrupt _h_sqlite3_interrupt =
      library.lookupFunction<_c_sqlite3_interrupt, _d_sqlite3_interrupt>('sqlite3_interrupt');

  late final _d_sqlite3_last_insert_rowid _h_sqlite3_last_insert_rowid =
      library.lookupFunction<_c_sqlite3_last_insert_rowid, _d_sqlite3_last_insert_rowid>(
          'sqlite3_last_insert_rowid');

  late final _d_sqlite3_limit? _h_sqlite3_limit = libVersionNumber < 3005008
      ? null
      : library.lookupFunction<_c_sqlite3_limit, _d_sqlite3_limit>('sqlite3_limit');

  late final _d_sqlite3_load_extension _h_sqlite3_load_extension =
      library.lookupFunction<_c_sqlite3_load_extension, _d_sqlite3_load_extension>(
          'sqlite3_load_extension');

  late final _d_sqlite3_open _h_sqlite3_open =
      library.lookupFunction<_c_sqlite3_open, _d_sqlite3_open>('sqlite3_open');

  late final _d_sqlite3_open16 _h_sqlite3_open16 =
      library.lookupFunction<_c_sqlite3_open16, _d_sqlite3_open16>('sqlite3_open16');

  late final _d_sqlite3_open_v2? _h_sqlite3_open_v2 = libVersionNumber < 3005000
      ? null
      : library.lookupFunction<_c_sqlite3_open_v2, _d_sqlite3_open_v2>('sqlite3_open_v2');

  late final _d_sqlite3_overload_function _h_sqlite3_overload_function =
      library.lookupFunction<_c_sqlite3_overload_function, _d_sqlite3_overload_function>(
          'sqlite3_overload_function');

  late final _d_sqlite3_trace _h_sqlite3_trace =
      library.lookupFunction<_c_sqlite3_trace, _d_sqlite3_trace>('sqlite3_trace');

  late final _d_sqlite3_profile _h_sqlite3_profile =
      library.lookupFunction<_c_sqlite3_profile, _d_sqlite3_profile>('sqlite3_profile');

  late final _d_sqlite3_progress_handler _h_sqlite3_progress_handler =
      library.lookupFunction<_c_sqlite3_progress_handler, _d_sqlite3_progress_handler>(
          'sqlite3_progress_handler');

  late final _d_sqlite3_serialize? _h_sqlite3_serialize = libVersionNumber < 3023000
      ? null
      : library.lookupFunction<_c_sqlite3_serialize, _d_sqlite3_serialize>('sqlite3_serialize');

  late final _d_sqlite3_set_authorizer _h_sqlite3_set_authorizer =
      library.lookupFunction<_c_sqlite3_set_authorizer, _d_sqlite3_set_authorizer>(
          'sqlite3_set_authorizer');

  late final _d_sqlite3_set_last_insert_rowid? _h_sqlite3_set_last_insert_rowid = libVersionNumber <
          3018000
      ? null
      : library.lookupFunction<_c_sqlite3_set_last_insert_rowid, _d_sqlite3_set_last_insert_rowid>(
          'sqlite3_set_last_insert_rowid');

  late final _d_sqlite3_system_errno? _h_sqlite3_system_errno = libVersionNumber < 3012000
      ? null
      : library
          .lookupFunction<_c_sqlite3_system_errno, _d_sqlite3_system_errno>('sqlite3_system_errno');

  late final _d_sqlite3_table_column_metadata _h_sqlite3_table_column_metadata =
      library.lookupFunction<_c_sqlite3_table_column_metadata, _d_sqlite3_table_column_metadata>(
          'sqlite3_table_column_metadata');

  late final _d_sqlite3_total_changes _h_sqlite3_total_changes = library
      .lookupFunction<_c_sqlite3_total_changes, _d_sqlite3_total_changes>('sqlite3_total_changes');

  late final _d_sqlite3_trace_v2? _h_sqlite3_trace_v2 = libVersionNumber < 3014000
      ? null
      : library.lookupFunction<_c_sqlite3_trace_v2, _d_sqlite3_trace_v2>('sqlite3_trace_v2');

  late final _d_sqlite3_txn_state? _h_sqlite3_txn_state = libVersionNumber < 3034000
      ? null
      : library.lookupFunction<_c_sqlite3_txn_state, _d_sqlite3_txn_state>('sqlite3_txn_state');

  late final _d_sqlite3_unlock_notify? _h_sqlite3_unlock_notify = libVersionNumber < 3006012
      ? null
      : _nullable(() => library.lookupFunction<_c_sqlite3_unlock_notify, _d_sqlite3_unlock_notify>(
          'sqlite3_unlock_notify'));

  late final _d_sqlite3_wal_autocheckpoint _h_sqlite3_wal_autocheckpoint =
      library.lookupFunction<_c_sqlite3_wal_autocheckpoint, _d_sqlite3_wal_autocheckpoint>(
          'sqlite3_wal_autocheckpoint');

  late final _d_sqlite3_wal_checkpoint _h_sqlite3_wal_checkpoint =
      library.lookupFunction<_c_sqlite3_wal_checkpoint, _d_sqlite3_wal_checkpoint>(
          'sqlite3_wal_checkpoint');

  late final _d_sqlite3_wal_checkpoint_v2? _h_sqlite3_wal_checkpoint_v2 = libVersionNumber < 3007006
      ? null
      : library.lookupFunction<_c_sqlite3_wal_checkpoint_v2, _d_sqlite3_wal_checkpoint_v2>(
          'sqlite3_wal_checkpoint_v2');

  late final _d_sqlite3_wal_hook _h_sqlite3_wal_hook =
      library.lookupFunction<_c_sqlite3_wal_hook, _d_sqlite3_wal_hook>('sqlite3_wal_hook');

  int busy_handler(PtrSqlite3 arg1, PtrDefDefTypeGen7 ptrDefDefTypeGen7, PtrVoid arg2) {
    return _h_sqlite3_busy_handler(arg1, ptrDefDefTypeGen7, arg2);
  }

  int busy_timeout(PtrSqlite3 arg1, int ms) {
    return _h_sqlite3_busy_timeout(arg1, ms);
  }

  int changes(PtrSqlite3 arg1) {
    return _h_sqlite3_changes(arg1);
  }

  int close(PtrSqlite3 arg1) {
    return _h_sqlite3_close(arg1);
  }

  int close_v2(PtrSqlite3 arg1) {
    if (libVersionNumber < 3007014) {
      throw dbsql.DatabaseException('API sqlite3_close_v2 is not available before 3.7.14');
    }
    return _h_sqlite3_close_v2!(arg1);
  }

  int db_cacheflush(PtrSqlite3 arg1) {
    if (libVersionNumber < 3010000) {
      throw dbsql.DatabaseException('API sqlite3_db_cacheflush is not available before 3.10.0');
    }
    return _h_sqlite3_db_cacheflush!(arg1);
  }

  String? db_filename(PtrSqlite3 db, String zDbName) {
    if (libVersionNumber < 3007010) {
      throw dbsql.DatabaseException('API sqlite3_db_filename is not available before 3.7.10');
    }
    final zDbNameMeta = zDbName._metaNativeUtf8();
    final ptrZDbName = zDbNameMeta.ptr;
    PtrString result = ffi.nullptr;
    try {
      var result = _h_sqlite3_db_filename!(db, ptrZDbName);
      return result == ffi.nullptr ? null : result.toDartString();
    } finally {
      pkgffi.malloc.free(ptrZDbName);
      pkgffi.malloc.free(result);
    }
  }

  PtrMutex? db_mutex(PtrSqlite3 arg1) {
    if (libVersionNumber < 3006005) {
      throw dbsql.DatabaseException('API sqlite3_db_mutex is not available before 3.6.5');
    }
    var result = _h_sqlite3_db_mutex!(arg1);
    return result == ffi.nullptr ? null : result;
  }

  int db_readonly(PtrSqlite3 db, String zDbName) {
    if (libVersionNumber < 3007011) {
      throw dbsql.DatabaseException('API sqlite3_db_readonly is not available before 3.7.11');
    }
    final zDbNameMeta = zDbName._metaNativeUtf8();
    final ptrZDbName = zDbNameMeta.ptr;
    try {
      return _h_sqlite3_db_readonly!(db, ptrZDbName);
    } finally {
      pkgffi.malloc.free(ptrZDbName);
    }
  }

  int db_release_memory(PtrSqlite3 arg1) {
    if (libVersionNumber < 3007010) {
      throw dbsql.DatabaseException('API sqlite3_db_release_memory is not available before 3.7.10');
    }
    return _h_sqlite3_db_release_memory!(arg1);
  }

  int db_status(PtrSqlite3 arg1, int op, PtrInt32 pCur, PtrInt32 pHiwtr, int resetFlg) {
    if (libVersionNumber < 3006001) {
      throw dbsql.DatabaseException('API sqlite3_db_status is not available before 3.6.1');
    }
    return _h_sqlite3_db_status!(arg1, op, pCur, pHiwtr, resetFlg);
  }

  int deserialize(
      PtrSqlite3 db, String zSchema, ffi.Pointer<ffi.Uint8> pData, int szDb, int szBuf, int arg1) {
    if (libVersionNumber < 3023000) {
      throw dbsql.DatabaseException('API sqlite3_deserialize is not available before 3.23.0');
    }
    final zSchemaMeta = zSchema._metaNativeUtf8();
    final ptrZSchema = zSchemaMeta.ptr;
    try {
      return _h_sqlite3_deserialize!(db, ptrZSchema, pData, szDb, szBuf, arg1);
    } finally {
      pkgffi.malloc.free(ptrZSchema);
    }
  }

  int enable_load_extension(PtrSqlite3 db, int onoff) {
    return _h_sqlite3_enable_load_extension(db, onoff);
  }

  int errcode(PtrSqlite3 db) {
    return _h_sqlite3_errcode(db);
  }

  int extended_errcode(PtrSqlite3 db) {
    if (libVersionNumber < 3006005) {
      throw dbsql.DatabaseException('API sqlite3_extended_errcode is not available before 3.6.5');
    }
    return _h_sqlite3_extended_errcode!(db);
  }

  String errmsg(PtrSqlite3 arg1) {
    PtrString result = ffi.nullptr;
    try {
      var result = _h_sqlite3_errmsg(arg1);
      return result.toDartString();
    } finally {
      pkgffi.malloc.free(result);
    }
  }

  PtrVoid errmsg16(PtrSqlite3 arg1) {
    return _h_sqlite3_errmsg16(arg1);
  }

  String errstr(int arg1) {
    if (libVersionNumber < 3007015) {
      throw dbsql.DatabaseException('API sqlite3_errstr is not available before 3.7.15');
    }
    PtrString result = ffi.nullptr;
    try {
      var result = _h_sqlite3_errstr!(arg1);
      return result.toDartString();
    } finally {
      pkgffi.malloc.free(result);
    }
  }

  int exec(PtrSqlite3 arg1, String sql, PtrDefcallback callback, PtrVoid arg2, PtrPtrUtf8 errmsg) {
    final sqlMeta = sql._metaNativeUtf8();
    final ptrSql = sqlMeta.ptr;
    try {
      return _h_sqlite3_exec(arg1, ptrSql, callback, arg2, errmsg);
    } finally {
      pkgffi.malloc.free(ptrSql);
    }
  }

  int extended_result_codes(PtrSqlite3 arg1, int onoff) {
    return _h_sqlite3_extended_result_codes(arg1, onoff);
  }

  int file_control(PtrSqlite3 arg1, String? zDbName, int op, PtrVoid arg2) {
    final zDbNameMeta = zDbName?._metaNativeUtf8();
    final ptrZDbName = zDbNameMeta?.ptr ?? ffi.nullptr;
    try {
      return _h_sqlite3_file_control(arg1, ptrZDbName, op, arg2);
    } finally {
      pkgffi.malloc.free(ptrZDbName);
    }
  }

  int get_table(PtrSqlite3 db, String zSql, PtrPtrPtrUtf8 pazResult, PtrInt32 pnRow,
      PtrInt32 pnColumn, PtrPtrUtf8 pzErrmsg) {
    final zSqlMeta = zSql._metaNativeUtf8();
    final ptrZSql = zSqlMeta.ptr;
    try {
      return _h_sqlite3_get_table(db, ptrZSql, pazResult, pnRow, pnColumn, pzErrmsg);
    } finally {
      pkgffi.malloc.free(ptrZSql);
    }
  }

  void free_table(PtrPtrUtf8 result) {
    return _h_sqlite3_free_table(result);
  }

  int get_autocommit(PtrSqlite3 arg1) {
    if (libVersionNumber < 3002002) {
      throw dbsql.DatabaseException('API sqlite3_get_autocommit is not available before 3.2.2');
    }
    return _h_sqlite3_get_autocommit!(arg1);
  }

  void interrupt(PtrSqlite3 arg1) {
    return _h_sqlite3_interrupt(arg1);
  }

  int last_insert_rowid(PtrSqlite3 arg1) {
    return _h_sqlite3_last_insert_rowid(arg1);
  }

  int limit(PtrSqlite3 arg1, int id, int newVal) {
    if (libVersionNumber < 3005008) {
      throw dbsql.DatabaseException('API sqlite3_limit is not available before 3.5.8');
    }
    return _h_sqlite3_limit!(arg1, id, newVal);
  }

  int load_extension(PtrSqlite3 db, String zFile, String? zProc, PtrPtrUtf8 pzErrMsg) {
    final zFileMeta = zFile._metaNativeUtf8();
    final ptrZFile = zFileMeta.ptr;
    final zProcMeta = zProc?._metaNativeUtf8();
    final ptrZProc = zProcMeta?.ptr ?? ffi.nullptr;
    try {
      return _h_sqlite3_load_extension(db, ptrZFile, ptrZProc, pzErrMsg);
    } finally {
      pkgffi.malloc.free(ptrZFile);
      pkgffi.malloc.free(ptrZProc);
    }
  }

  int open(String filename, PtrPtrSqlite3 ppDb) {
    final filenameMeta = filename._metaNativeUtf8();
    final ptrFilename = filenameMeta.ptr;
    try {
      return _h_sqlite3_open(ptrFilename, ppDb);
    } finally {
      pkgffi.malloc.free(ptrFilename);
    }
  }

  int open16(String filename, PtrPtrSqlite3 ppDb) {
    final filenameMeta = filename._metaNativeUtf16();
    final ptrFilename = filenameMeta.ptr;
    try {
      return _h_sqlite3_open16(ptrFilename, ppDb);
    } finally {
      pkgffi.malloc.free(ptrFilename);
    }
  }

  int open_v2(String filename, PtrPtrSqlite3 ppDb, int flags, String? zVfs) {
    if (libVersionNumber < 3005000) {
      throw dbsql.DatabaseException('API sqlite3_open_v2 is not available before 3.5.0');
    }
    final filenameMeta = filename._metaNativeUtf8();
    final ptrFilename = filenameMeta.ptr;
    final zVfsMeta = zVfs?._metaNativeUtf8();
    final ptrZVfs = zVfsMeta?.ptr ?? ffi.nullptr;
    try {
      return _h_sqlite3_open_v2!(ptrFilename, ppDb, flags, ptrZVfs);
    } finally {
      pkgffi.malloc.free(ptrFilename);
      pkgffi.malloc.free(ptrZVfs);
    }
  }

  int overload_function(PtrSqlite3 arg1, String zFuncName, int nArg) {
    final zFuncNameMeta = zFuncName._metaNativeUtf8();
    final ptrZFuncName = zFuncNameMeta.ptr;
    try {
      return _h_sqlite3_overload_function(arg1, ptrZFuncName, nArg);
    } finally {
      pkgffi.malloc.free(ptrZFuncName);
    }
  }

  PtrVoid trace(PtrSqlite3 arg1, PtrDefxTrace xTrace, PtrVoid arg2) {
    return _h_sqlite3_trace(arg1, xTrace, arg2);
  }

  PtrVoid profile(PtrSqlite3 arg1, PtrDefxProfile xProfile, PtrVoid arg2) {
    return _h_sqlite3_profile(arg1, xProfile, arg2);
  }

  void progress_handler(PtrSqlite3 arg1, int arg2, PtrDefxSize ptrDefxSize, PtrVoid arg3) {
    return _h_sqlite3_progress_handler(arg1, arg2, ptrDefxSize, arg3);
  }

  ffi.Pointer<ffi.Uint8>? serialize(PtrSqlite3 db, String zSchema, PtrInt64 piSize, int mFlags) {
    if (libVersionNumber < 3023000) {
      throw dbsql.DatabaseException('API sqlite3_serialize is not available before 3.23.0');
    }
    final zSchemaMeta = zSchema._metaNativeUtf8();
    final ptrZSchema = zSchemaMeta.ptr;
    try {
      var result = _h_sqlite3_serialize!(db, ptrZSchema, piSize, mFlags);
      return result == ffi.nullptr ? null : result;
    } finally {
      pkgffi.malloc.free(ptrZSchema);
    }
  }

  int set_authorizer(PtrSqlite3 arg1, PtrDefxAuth xAuth, PtrVoid pUserData) {
    return _h_sqlite3_set_authorizer(arg1, xAuth, pUserData);
  }

  void set_last_insert_rowid(PtrSqlite3 arg1, int arg2) {
    if (libVersionNumber < 3018000) {
      throw dbsql.DatabaseException(
          'API sqlite3_set_last_insert_rowid is not available before 3.18.0');
    }
    return _h_sqlite3_set_last_insert_rowid!(arg1, arg2);
  }

  int system_errno(PtrSqlite3 arg1) {
    if (libVersionNumber < 3012000) {
      throw dbsql.DatabaseException('API sqlite3_system_errno is not available before 3.12.0');
    }
    return _h_sqlite3_system_errno!(arg1);
  }

  int table_column_metadata(
      PtrSqlite3 db,
      String? zDbName,
      String zTableName,
      String? zColumnName,
      PtrPtrUtf8 pzDataType,
      PtrPtrUtf8 pzCollSeq,
      PtrInt32 pNotNull,
      PtrInt32 pPrimaryKey,
      PtrInt32 pAutoinc) {
    final zDbNameMeta = zDbName?._metaNativeUtf8();
    final ptrZDbName = zDbNameMeta?.ptr ?? ffi.nullptr;
    final zTableNameMeta = zTableName._metaNativeUtf8();
    final ptrZTableName = zTableNameMeta.ptr;
    final zColumnNameMeta = zColumnName?._metaNativeUtf8();
    final ptrZColumnName = zColumnNameMeta?.ptr ?? ffi.nullptr;
    try {
      return _h_sqlite3_table_column_metadata(db, ptrZDbName, ptrZTableName, ptrZColumnName,
          pzDataType, pzCollSeq, pNotNull, pPrimaryKey, pAutoinc);
    } finally {
      pkgffi.malloc.free(ptrZDbName);
      pkgffi.malloc.free(ptrZTableName);
      pkgffi.malloc.free(ptrZColumnName);
    }
  }

  int total_changes(PtrSqlite3 arg1) {
    return _h_sqlite3_total_changes(arg1);
  }

  int trace_v2(PtrSqlite3 arg1, int arg2, PtrDefxCallback xCallback, PtrVoid pCtx) {
    if (libVersionNumber < 3014000) {
      throw dbsql.DatabaseException('API sqlite3_trace_v2 is not available before 3.14');
    }
    return _h_sqlite3_trace_v2!(arg1, arg2, xCallback, pCtx);
  }

  int txn_state(PtrSqlite3 arg1, String? zSchema) {
    if (libVersionNumber < 3034000) {
      throw dbsql.DatabaseException('API sqlite3_txn_state is not available before 3.34.0');
    }
    final zSchemaMeta = zSchema?._metaNativeUtf8();
    final ptrZSchema = zSchemaMeta?.ptr ?? ffi.nullptr;
    try {
      return _h_sqlite3_txn_state!(arg1, ptrZSchema);
    } finally {
      pkgffi.malloc.free(ptrZSchema);
    }
  }

  int unlock_notify(PtrSqlite3 pBlocked, PtrDefxNotify xNotify, PtrVoid pNotifyArg) {
    if (libVersionNumber < 3006012) {
      throw dbsql.DatabaseException('API sqlite3_unlock_notify is not available before 3.6.12');
    }
    if (_h_sqlite3_unlock_notify! == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_unlock_notify is not available, You need to enable it during library build.');
    }
    return _h_sqlite3_unlock_notify!(pBlocked, xNotify, pNotifyArg);
  }

  int wal_autocheckpoint(PtrSqlite3 db, int N) {
    return _h_sqlite3_wal_autocheckpoint(db, N);
  }

  int wal_checkpoint(PtrSqlite3 db, String zDb) {
    final zDbMeta = zDb._metaNativeUtf8();
    final ptrZDb = zDbMeta.ptr;
    try {
      return _h_sqlite3_wal_checkpoint(db, ptrZDb);
    } finally {
      pkgffi.malloc.free(ptrZDb);
    }
  }

  int wal_checkpoint_v2(PtrSqlite3 db, String? zDb, int eMode, PtrInt32 pnLog, PtrInt32 pnCkpt) {
    if (libVersionNumber < 3007006) {
      throw dbsql.DatabaseException('API sqlite3_wal_checkpoint_v2 is not available before 3.7.6');
    }
    final zDbMeta = zDb?._metaNativeUtf8();
    final ptrZDb = zDbMeta?.ptr ?? ffi.nullptr;
    try {
      return _h_sqlite3_wal_checkpoint_v2!(db, ptrZDb, eMode, pnLog, pnCkpt);
    } finally {
      pkgffi.malloc.free(ptrZDb);
    }
  }

  PtrVoid wal_hook(PtrSqlite3 arg1, PtrDefDefTypeGen11 ptrDefDefTypeGen11, PtrVoid arg2) {
    return _h_sqlite3_wal_hook(arg1, ptrDefDefTypeGen11, arg2);
  }
}
