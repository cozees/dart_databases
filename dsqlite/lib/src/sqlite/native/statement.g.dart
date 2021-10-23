// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

typedef _c_sqlite3_bind_parameter_count = Nint32 Function(PtrStmt);
typedef _d_sqlite3_bind_parameter_count = int Function(PtrStmt);
typedef _c_sqlite3_bind_parameter_index = Nint32 Function(PtrStmt, PtrString);
typedef _d_sqlite3_bind_parameter_index = int Function(PtrStmt, PtrString);
typedef _c_sqlite3_bind_parameter_name = PtrString Function(PtrStmt, Nint32);
typedef _d_sqlite3_bind_parameter_name = PtrString Function(PtrStmt, int);
typedef _c_sqlite3_clear_bindings = Nint32 Function(PtrStmt);
typedef _d_sqlite3_clear_bindings = int Function(PtrStmt);
typedef _c_sqlite3_data_count = Nint32 Function(PtrStmt);
typedef _d_sqlite3_data_count = int Function(PtrStmt);
typedef _c_sqlite3_db_handle = PtrSqlite3 Function(PtrStmt);
typedef _d_sqlite3_db_handle = PtrSqlite3 Function(PtrStmt);
typedef _c_sqlite3_sql = PtrString Function(PtrStmt);
typedef _d_sqlite3_sql = PtrString Function(PtrStmt);
typedef _c_sqlite3_expanded_sql = PtrString Function(PtrStmt);
typedef _d_sqlite3_expanded_sql = PtrString Function(PtrStmt);
typedef _c_sqlite3_normalized_sql = PtrString Function(PtrStmt);
typedef _d_sqlite3_normalized_sql = PtrString Function(PtrStmt);
typedef _c_sqlite3_finalize = Nint32 Function(PtrStmt);
typedef _d_sqlite3_finalize = int Function(PtrStmt);
typedef _c_sqlite3_next_stmt = PtrStmt Function(PtrSqlite3, PtrStmt);
typedef _d_sqlite3_next_stmt = PtrStmt Function(PtrSqlite3, PtrStmt);
typedef _c_sqlite3_prepare = Nint32 Function(PtrSqlite3, PtrString, Nint32, PtrPtrStmt, PtrPtrUtf8);
typedef _d_sqlite3_prepare = int Function(PtrSqlite3, PtrString, int, PtrPtrStmt, PtrPtrUtf8);
typedef _c_sqlite3_prepare_v2 = Nint32 Function(
    PtrSqlite3, PtrString, Nint32, PtrPtrStmt, PtrPtrUtf8);
typedef _d_sqlite3_prepare_v2 = int Function(PtrSqlite3, PtrString, int, PtrPtrStmt, PtrPtrUtf8);
typedef _c_sqlite3_prepare_v3 = Nint32 Function(
    PtrSqlite3, PtrString, Nint32, Nuint32, PtrPtrStmt, PtrPtrUtf8);
typedef _d_sqlite3_prepare_v3 = int Function(
    PtrSqlite3, PtrString, int, int, PtrPtrStmt, PtrPtrUtf8);
typedef _c_sqlite3_prepare16 = Nint32 Function(
    PtrSqlite3, PtrString16, Nint32, PtrPtrStmt, PtrPtrVoid);
typedef _d_sqlite3_prepare16 = int Function(PtrSqlite3, PtrString16, int, PtrPtrStmt, PtrPtrVoid);
typedef _c_sqlite3_prepare16_v2 = Nint32 Function(
    PtrSqlite3, PtrString16, Nint32, PtrPtrStmt, PtrPtrVoid);
typedef _d_sqlite3_prepare16_v2 = int Function(
    PtrSqlite3, PtrString16, int, PtrPtrStmt, PtrPtrVoid);
typedef _c_sqlite3_prepare16_v3 = Nint32 Function(
    PtrSqlite3, PtrString16, Nint32, Nuint32, PtrPtrStmt, PtrPtrVoid);
typedef _d_sqlite3_prepare16_v3 = int Function(
    PtrSqlite3, PtrString16, int, int, PtrPtrStmt, PtrPtrVoid);
typedef _c_sqlite3_reset = Nint32 Function(PtrStmt);
typedef _d_sqlite3_reset = int Function(PtrStmt);
typedef _c_sqlite3_step = Nint32 Function(PtrStmt);
typedef _d_sqlite3_step = int Function(PtrStmt);
typedef _c_sqlite3_stmt_busy = Nint32 Function(PtrStmt);
typedef _d_sqlite3_stmt_busy = int Function(PtrStmt);
typedef _c_sqlite3_stmt_isexplain = Nint32 Function(PtrStmt);
typedef _d_sqlite3_stmt_isexplain = int Function(PtrStmt);
typedef _c_sqlite3_stmt_readonly = Nint32 Function(PtrStmt);
typedef _d_sqlite3_stmt_readonly = int Function(PtrStmt);
typedef _c_sqlite3_stmt_scanstatus = Nint32 Function(PtrStmt, Nint32, Nint32, PtrVoid);
typedef _d_sqlite3_stmt_scanstatus = int Function(PtrStmt, int, int, PtrVoid);
typedef _c_sqlite3_stmt_scanstatus_reset = NVoid Function(PtrStmt);
typedef _d_sqlite3_stmt_scanstatus_reset = void Function(PtrStmt);
typedef _c_sqlite3_stmt_status = Nint32 Function(PtrStmt, Nint32, Nint32);
typedef _d_sqlite3_stmt_status = int Function(PtrStmt, int, int);

// Mixin for Statement
mixin _MixinStatement on _SQLiteLibrary {
  late final _d_sqlite3_bind_parameter_count _h_sqlite3_bind_parameter_count =
      library.lookupFunction<_c_sqlite3_bind_parameter_count, _d_sqlite3_bind_parameter_count>(
          'sqlite3_bind_parameter_count');

  late final _d_sqlite3_bind_parameter_index _h_sqlite3_bind_parameter_index =
      library.lookupFunction<_c_sqlite3_bind_parameter_index, _d_sqlite3_bind_parameter_index>(
          'sqlite3_bind_parameter_index');

  late final _d_sqlite3_bind_parameter_name? _h_sqlite3_bind_parameter_name =
      libVersionNumber < 3000005
          ? null
          : library.lookupFunction<_c_sqlite3_bind_parameter_name, _d_sqlite3_bind_parameter_name>(
              'sqlite3_bind_parameter_name');

  late final _d_sqlite3_clear_bindings _h_sqlite3_clear_bindings =
      library.lookupFunction<_c_sqlite3_clear_bindings, _d_sqlite3_clear_bindings>(
          'sqlite3_clear_bindings');

  late final _d_sqlite3_data_count _h_sqlite3_data_count =
      library.lookupFunction<_c_sqlite3_data_count, _d_sqlite3_data_count>('sqlite3_data_count');

  late final _d_sqlite3_db_handle? _h_sqlite3_db_handle = libVersionNumber < 3002002
      ? null
      : library.lookupFunction<_c_sqlite3_db_handle, _d_sqlite3_db_handle>('sqlite3_db_handle');

  late final _d_sqlite3_sql _h_sqlite3_sql =
      library.lookupFunction<_c_sqlite3_sql, _d_sqlite3_sql>('sqlite3_sql');

  late final _d_sqlite3_expanded_sql? _h_sqlite3_expanded_sql = libVersionNumber < 3014000
      ? null
      : library
          .lookupFunction<_c_sqlite3_expanded_sql, _d_sqlite3_expanded_sql>('sqlite3_expanded_sql');

  late final _d_sqlite3_normalized_sql? _h_sqlite3_normalized_sql = libVersionNumber < 3026000
      ? null
      : _nullable(() =>
          library.lookupFunction<_c_sqlite3_normalized_sql, _d_sqlite3_normalized_sql>(
              'sqlite3_normalized_sql'));

  late final _d_sqlite3_finalize _h_sqlite3_finalize =
      library.lookupFunction<_c_sqlite3_finalize, _d_sqlite3_finalize>('sqlite3_finalize');

  late final _d_sqlite3_next_stmt? _h_sqlite3_next_stmt = libVersionNumber < 3006000
      ? null
      : library.lookupFunction<_c_sqlite3_next_stmt, _d_sqlite3_next_stmt>('sqlite3_next_stmt');

  late final _d_sqlite3_prepare _h_sqlite3_prepare =
      library.lookupFunction<_c_sqlite3_prepare, _d_sqlite3_prepare>('sqlite3_prepare');

  late final _d_sqlite3_prepare_v2? _h_sqlite3_prepare_v2 = libVersionNumber < 3003009
      ? null
      : library.lookupFunction<_c_sqlite3_prepare_v2, _d_sqlite3_prepare_v2>('sqlite3_prepare_v2');

  late final _d_sqlite3_prepare_v3? _h_sqlite3_prepare_v3 = libVersionNumber < 3020000
      ? null
      : library.lookupFunction<_c_sqlite3_prepare_v3, _d_sqlite3_prepare_v3>('sqlite3_prepare_v3');

  late final _d_sqlite3_prepare16 _h_sqlite3_prepare16 =
      library.lookupFunction<_c_sqlite3_prepare16, _d_sqlite3_prepare16>('sqlite3_prepare16');

  late final _d_sqlite3_prepare16_v2? _h_sqlite3_prepare16_v2 = libVersionNumber < 3003009
      ? null
      : library
          .lookupFunction<_c_sqlite3_prepare16_v2, _d_sqlite3_prepare16_v2>('sqlite3_prepare16_v2');

  late final _d_sqlite3_prepare16_v3? _h_sqlite3_prepare16_v3 = libVersionNumber < 3020000
      ? null
      : library
          .lookupFunction<_c_sqlite3_prepare16_v3, _d_sqlite3_prepare16_v3>('sqlite3_prepare16_v3');

  late final _d_sqlite3_reset _h_sqlite3_reset =
      library.lookupFunction<_c_sqlite3_reset, _d_sqlite3_reset>('sqlite3_reset');

  late final _d_sqlite3_step _h_sqlite3_step =
      library.lookupFunction<_c_sqlite3_step, _d_sqlite3_step>('sqlite3_step');

  late final _d_sqlite3_stmt_busy? _h_sqlite3_stmt_busy = libVersionNumber < 3007010
      ? null
      : library.lookupFunction<_c_sqlite3_stmt_busy, _d_sqlite3_stmt_busy>('sqlite3_stmt_busy');

  late final _d_sqlite3_stmt_isexplain? _h_sqlite3_stmt_isexplain = libVersionNumber < 3028000
      ? null
      : library.lookupFunction<_c_sqlite3_stmt_isexplain, _d_sqlite3_stmt_isexplain>(
          'sqlite3_stmt_isexplain');

  late final _d_sqlite3_stmt_readonly? _h_sqlite3_stmt_readonly = libVersionNumber < 3007004
      ? null
      : library.lookupFunction<_c_sqlite3_stmt_readonly, _d_sqlite3_stmt_readonly>(
          'sqlite3_stmt_readonly');

  late final _d_sqlite3_stmt_scanstatus? _h_sqlite3_stmt_scanstatus = libVersionNumber < 3008008
      ? null
      : _nullable(() =>
          library.lookupFunction<_c_sqlite3_stmt_scanstatus, _d_sqlite3_stmt_scanstatus>(
              'sqlite3_stmt_scanstatus'));

  late final _d_sqlite3_stmt_scanstatus_reset? _h_sqlite3_stmt_scanstatus_reset = _nullable(() =>
      library.lookupFunction<_c_sqlite3_stmt_scanstatus_reset, _d_sqlite3_stmt_scanstatus_reset>(
          'sqlite3_stmt_scanstatus_reset'));

  late final _d_sqlite3_stmt_status? _h_sqlite3_stmt_status = libVersionNumber < 3006004
      ? null
      : library
          .lookupFunction<_c_sqlite3_stmt_status, _d_sqlite3_stmt_status>('sqlite3_stmt_status');

  int bind_parameter_count(PtrStmt arg1) {
    return _h_sqlite3_bind_parameter_count(arg1);
  }

  int bind_parameter_index(PtrStmt arg1, String zName) {
    final zNameMeta = zName._metaNativeUtf8();
    final ptrZName = zNameMeta.ptr;
    try {
      return _h_sqlite3_bind_parameter_index(arg1, ptrZName);
    } finally {
      pkgffi.malloc.free(ptrZName);
    }
  }

  String? bind_parameter_name(PtrStmt arg1, int arg2) {
    if (libVersionNumber < 3000005) {
      throw dbsql.DatabaseException(
          'API sqlite3_bind_parameter_name is not available before 3.0.5 beta');
    }
    PtrString result = ffi.nullptr;
    try {
      var result = _h_sqlite3_bind_parameter_name!(arg1, arg2);
      return result == ffi.nullptr ? null : result.toDartString();
    } finally {
      pkgffi.malloc.free(result);
    }
  }

  int clear_bindings(PtrStmt arg1) {
    return _h_sqlite3_clear_bindings(arg1);
  }

  int data_count(PtrStmt pStmt) {
    return _h_sqlite3_data_count(pStmt);
  }

  PtrSqlite3 db_handle(PtrStmt arg1) {
    if (libVersionNumber < 3002002) {
      throw dbsql.DatabaseException('API sqlite3_db_handle is not available before 3.2.2');
    }
    return _h_sqlite3_db_handle!(arg1);
  }

  String sql(PtrStmt pStmt) {
    var result = _h_sqlite3_sql(pStmt);
    return result.toDartString();
  }

  String? expanded_sql(PtrStmt pStmt) {
    if (libVersionNumber < 3014000) {
      throw dbsql.DatabaseException('API sqlite3_expanded_sql is not available before 3.14');
    }
    PtrString result = ffi.nullptr;
    try {
      var result = _h_sqlite3_expanded_sql!(pStmt);
      return result == ffi.nullptr ? null : result.toDartString();
    } finally {
      _h_sqlite3_free(result.cast());
    }
  }

  String normalized_sql(PtrStmt pStmt) {
    if (libVersionNumber < 3026000) {
      throw dbsql.DatabaseException('API sqlite3_normalized_sql is not available before 3.26.0');
    }
    if (_h_sqlite3_normalized_sql! == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_normalized_sql is not available, You need to enable it during library build.');
    }
    var result = _h_sqlite3_normalized_sql!(pStmt);
    return result.toDartString();
  }

  int finalize(PtrStmt pStmt) {
    return _h_sqlite3_finalize(pStmt);
  }

  PtrStmt? next_stmt(PtrSqlite3 pDb, PtrStmt pStmt) {
    if (libVersionNumber < 3006000) {
      throw dbsql.DatabaseException('API sqlite3_next_stmt is not available before 3.6.0 beta');
    }
    var result = _h_sqlite3_next_stmt!(pDb, pStmt);
    return result == ffi.nullptr ? null : result;
  }

  int prepare(PtrSqlite3 db, String zSql, PtrPtrStmt ppStmt, PtrPtrUtf8 pzTail) {
    final zSqlMeta = zSql._metaNativeUtf8();
    final ptrZSql = zSqlMeta.ptr;
    try {
      var result = _h_sqlite3_prepare(db, ptrZSql, zSqlMeta.length, ppStmt, pzTail);
      if (pzTail.value.address - ptrZSql.address == zSqlMeta.length) {
        pzTail.value = ffi.nullptr;
      }
      return result;
    } finally {
      pkgffi.malloc.free(ptrZSql);
    }
  }

  int prepare_v2(PtrSqlite3 db, String zSql, PtrPtrStmt ppStmt, PtrPtrUtf8 pzTail) {
    if (libVersionNumber < 3003009) {
      throw dbsql.DatabaseException('API sqlite3_prepare_v2 is not available before 3.3.9');
    }
    final zSqlMeta = zSql._metaNativeUtf8();
    final ptrZSql = zSqlMeta.ptr;
    try {
      var result = _h_sqlite3_prepare_v2!(db, ptrZSql, zSqlMeta.length, ppStmt, pzTail);
      if (pzTail.value.address - ptrZSql.address == zSqlMeta.length) {
        pzTail.value = ffi.nullptr;
      }
      return result;
    } finally {
      pkgffi.malloc.free(ptrZSql);
    }
  }

  int prepare_v3(PtrSqlite3 db, String zSql, int prepFlags, PtrPtrStmt ppStmt, PtrPtrUtf8 pzTail) {
    if (libVersionNumber < 3020000) {
      throw dbsql.DatabaseException('API sqlite3_prepare_v3 is not available before 3.20.0');
    }
    final zSqlMeta = zSql._metaNativeUtf8();
    final ptrZSql = zSqlMeta.ptr;
    try {
      var result = _h_sqlite3_prepare_v3!(db, ptrZSql, zSqlMeta.length, prepFlags, ppStmt, pzTail);
      if (pzTail.value.address - ptrZSql.address == zSqlMeta.length) {
        pzTail.value = ffi.nullptr;
      }
      return result;
    } finally {
      pkgffi.malloc.free(ptrZSql);
    }
  }

  int prepare16(PtrSqlite3 db, String zSql, PtrPtrStmt ppStmt, PtrPtrVoid pzTail) {
    final zSqlMeta = zSql._metaNativeUtf16();
    final ptrZSql = zSqlMeta.ptr;
    try {
      var result = _h_sqlite3_prepare16(db, ptrZSql, zSqlMeta.length, ppStmt, pzTail);
      if (pzTail.value.address - ptrZSql.address == zSqlMeta.length) {
        pzTail.value = ffi.nullptr;
      }
      return result;
    } finally {
      pkgffi.malloc.free(ptrZSql);
    }
  }

  int prepare16_v2(PtrSqlite3 db, String zSql, PtrPtrStmt ppStmt, PtrPtrVoid pzTail) {
    if (libVersionNumber < 3003009) {
      throw dbsql.DatabaseException('API sqlite3_prepare16_v2 is not available before 3.3.9');
    }
    final zSqlMeta = zSql._metaNativeUtf16();
    final ptrZSql = zSqlMeta.ptr;
    try {
      var result = _h_sqlite3_prepare16_v2!(db, ptrZSql, zSqlMeta.length, ppStmt, pzTail);
      if (pzTail.value.address - ptrZSql.address == zSqlMeta.length) {
        pzTail.value = ffi.nullptr;
      }
      return result;
    } finally {
      pkgffi.malloc.free(ptrZSql);
    }
  }

  int prepare16_v3(
      PtrSqlite3 db, String zSql, int prepFlags, PtrPtrStmt ppStmt, PtrPtrVoid pzTail) {
    if (libVersionNumber < 3020000) {
      throw dbsql.DatabaseException('API sqlite3_prepare16_v3 is not available before 3.20.0');
    }
    final zSqlMeta = zSql._metaNativeUtf16();
    final ptrZSql = zSqlMeta.ptr;
    try {
      var result =
          _h_sqlite3_prepare16_v3!(db, ptrZSql, zSqlMeta.length, prepFlags, ppStmt, pzTail);
      if (pzTail.value.address - ptrZSql.address == zSqlMeta.length) {
        pzTail.value = ffi.nullptr;
      }
      return result;
    } finally {
      pkgffi.malloc.free(ptrZSql);
    }
  }

  int reset(PtrStmt pStmt) {
    return _h_sqlite3_reset(pStmt);
  }

  int step(PtrStmt arg1) {
    return _h_sqlite3_step(arg1);
  }

  int stmt_busy(PtrStmt arg1) {
    if (libVersionNumber < 3007010) {
      throw dbsql.DatabaseException('API sqlite3_stmt_busy is not available before 3.7.10');
    }
    return _h_sqlite3_stmt_busy!(arg1);
  }

  int stmt_isexplain(PtrStmt pStmt) {
    if (libVersionNumber < 3028000) {
      throw dbsql.DatabaseException('API sqlite3_stmt_isexplain is not available before 3.28.0');
    }
    return _h_sqlite3_stmt_isexplain!(pStmt);
  }

  int stmt_readonly(PtrStmt pStmt) {
    if (libVersionNumber < 3007004) {
      throw dbsql.DatabaseException('API sqlite3_stmt_readonly is not available before 3.7.4');
    }
    return _h_sqlite3_stmt_readonly!(pStmt);
  }

  int stmt_scanstatus(PtrStmt pStmt, int idx, int iScanStatusOp, PtrVoid pOut) {
    if (libVersionNumber < 3008008) {
      throw dbsql.DatabaseException('API sqlite3_stmt_scanstatus is not available before 3.8.8');
    }
    if (_h_sqlite3_stmt_scanstatus! == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_stmt_scanstatus is not available, You need to enable it during library build.');
    }
    return _h_sqlite3_stmt_scanstatus!(pStmt, idx, iScanStatusOp, pOut);
  }

  void stmt_scanstatus_reset(PtrStmt arg1) {
    if (_h_sqlite3_stmt_scanstatus_reset == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_stmt_scanstatus_reset is not available, You need to enable it during library build.');
    }
    return _h_sqlite3_stmt_scanstatus_reset!(arg1);
  }

  int stmt_status(PtrStmt arg1, int op, int resetFlg) {
    if (libVersionNumber < 3006004) {
      throw dbsql.DatabaseException('API sqlite3_stmt_status is not available before 3.6.4');
    }
    return _h_sqlite3_stmt_status!(arg1, op, resetFlg);
  }
}
