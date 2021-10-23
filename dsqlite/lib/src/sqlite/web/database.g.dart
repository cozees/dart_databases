// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

typedef _def_sqlite3_changes = int Function(int);
typedef _def_sqlite3_close = int Function(int);
typedef _def_sqlite3_close_v2 = int Function(int);
typedef _def_sqlite3_errcode = int Function(int);
typedef _def_sqlite3_extended_errcode = int Function(int);
typedef _def_sqlite3_errmsg = int Function(int);
typedef _def_sqlite3_errmsg16 = int Function(int);
typedef _def_sqlite3_errstr = int Function(int);
typedef Defcallback = Nint32 Function(PtrVoid, Nint32, PtrPtrUtf8, PtrPtrUtf8);
typedef DartDefcallback = int Function(PtrVoid, int, PtrPtrUtf8, PtrPtrUtf8);
typedef _def_sqlite3_exec = int Function(int, int, int, int, int);
typedef _def_sqlite3_extended_result_codes = int Function(int, int);
typedef _def_sqlite3_last_insert_rowid = dynamic Function(int);
typedef _def_sqlite3_limit = int Function(int, int, int);
typedef _def_sqlite3_open = int Function(int, int);
typedef _def_sqlite3_open16 = int Function(int, int);
typedef _def_sqlite3_open_v2 = int Function(int, int, int, int);
typedef _def_sqlite3_table_column_metadata = int Function(
    int, int, int, int, int, int, int, int, int);
typedef _def_sqlite3_total_changes = int Function(int);

// Mixin for Database
mixin _MixinDatabase on _SQLiteLibrary {
  late final _def_sqlite3_changes _h_sqlite3_changes =
      _wasm.cwrap('sqlite3_changes', 'number', ['number']);

  late final _def_sqlite3_close _h_sqlite3_close =
      _wasm.cwrap('sqlite3_close', 'number', ['number']);

  late final _def_sqlite3_close_v2? _h_sqlite3_close_v2 =
      libVersionNumber < 3007014 ? null : _wasm.cwrap('sqlite3_close_v2', 'number', ['number']);

  late final _def_sqlite3_errcode _h_sqlite3_errcode =
      _wasm.cwrap('sqlite3_errcode', 'number', ['number']);

  late final _def_sqlite3_extended_errcode? _h_sqlite3_extended_errcode = libVersionNumber < 3006005
      ? null
      : _wasm.cwrap('sqlite3_extended_errcode', 'number', ['number']);

  late final _def_sqlite3_errmsg _h_sqlite3_errmsg =
      _wasm.cwrap('sqlite3_errmsg', 'number', ['number']);

  late final _def_sqlite3_errmsg16 _h_sqlite3_errmsg16 =
      _wasm.cwrap('sqlite3_errmsg16', 'number', ['number']);

  late final _def_sqlite3_errstr? _h_sqlite3_errstr =
      libVersionNumber < 3007015 ? null : _wasm.cwrap('sqlite3_errstr', 'number', ['number']);

  late final _def_sqlite3_exec _h_sqlite3_exec =
      _wasm.cwrap('sqlite3_exec', 'number', ['number', 'number', 'number', 'number', 'number']);

  late final _def_sqlite3_extended_result_codes _h_sqlite3_extended_result_codes =
      _wasm.cwrap('sqlite3_extended_result_codes', 'number', ['number', 'number']);

  late final _def_sqlite3_last_insert_rowid _h_sqlite3_last_insert_rowid =
      _wasm.cwrap('sqlite3_last_insert_rowid', 'number', ['number']);

  late final _def_sqlite3_limit? _h_sqlite3_limit = libVersionNumber < 3005008
      ? null
      : _wasm.cwrap('sqlite3_limit', 'number', ['number', 'number', 'number']);

  late final _def_sqlite3_open _h_sqlite3_open =
      _wasm.cwrap('sqlite3_open', 'number', ['number', 'number']);

  late final _def_sqlite3_open16 _h_sqlite3_open16 =
      _wasm.cwrap('sqlite3_open16', 'number', ['number', 'number']);

  late final _def_sqlite3_open_v2? _h_sqlite3_open_v2 = libVersionNumber < 3005000
      ? null
      : _wasm.cwrap('sqlite3_open_v2', 'number', ['number', 'number', 'number', 'number']);

  late final _def_sqlite3_table_column_metadata _h_sqlite3_table_column_metadata = _wasm.cwrap(
      'sqlite3_table_column_metadata',
      'number',
      ['number', 'number', 'number', 'number', 'number', 'number', 'number', 'number', 'number']);

  late final _def_sqlite3_total_changes _h_sqlite3_total_changes =
      _wasm.cwrap('sqlite3_total_changes', 'number', ['number']);

  int changes(PtrSqlite3 arg1) {
    return _h_sqlite3_changes(arg1.address);
  }

  int close(PtrSqlite3 arg1) {
    return _h_sqlite3_close(arg1.address);
  }

  int close_v2(PtrSqlite3 arg1) {
    if (_h_sqlite3_close_v2 == null) {
      throw dbsql.DatabaseException('API sqlite3_close_v2 is not available before 3.7.14');
    }
    return _h_sqlite3_close_v2!(arg1.address);
  }

  int errcode(PtrSqlite3 db) {
    return _h_sqlite3_errcode(db.address);
  }

  int extended_errcode(PtrSqlite3 db) {
    if (_h_sqlite3_extended_errcode == null) {
      throw dbsql.DatabaseException('API sqlite3_extended_errcode is not available before 3.6.5');
    }
    return _h_sqlite3_extended_errcode!(db.address);
  }

  String errmsg(PtrSqlite3 arg1) {
    int result = 0;
    try {
      var result = _h_sqlite3_errmsg(arg1.address);
      return Pointer<Utf8>.fromAddress(result).toDartString();
    } finally {
      _wasm._free(result);
    }
  }

  PtrVoid errmsg16(PtrSqlite3 arg1) {
    var result = _h_sqlite3_errmsg16(arg1.address);
    return Pointer.fromAddress(result);
  }

  String errstr(int arg1) {
    if (_h_sqlite3_errstr == null) {
      throw dbsql.DatabaseException('API sqlite3_errstr is not available before 3.7.15');
    }
    int result = 0;
    try {
      var result = _h_sqlite3_errstr!(arg1);
      return Pointer<Utf8>.fromAddress(result).toDartString();
    } finally {
      _wasm._free(result);
    }
  }

  int exec(PtrSqlite3 arg1, String sql, PtrDefcallback callback, PtrVoid arg2, PtrPtrUtf8 errmsg) {
    final sqlMeta = sql._metaNativeUtf8();
    final ptrsql = sqlMeta.ptr.address;
    try {
      return _h_sqlite3_exec(arg1.address, ptrsql, callback.address, arg2.address, errmsg.address);
    } finally {
      _wasm._free(ptrsql);
    }
  }

  int extended_result_codes(PtrSqlite3 arg1, int onoff) {
    return _h_sqlite3_extended_result_codes(arg1.address, onoff);
  }

  int last_insert_rowid(PtrSqlite3 arg1) {
    if (isBigInt) {
      var result = _h_sqlite3_last_insert_rowid(arg1.address);
      return jsBigInt2DartInt(result);
    } else {
      return _h_sqlite3_last_insert_rowid(arg1.address);
    }
  }

  int limit(PtrSqlite3 arg1, int id, int newVal) {
    if (_h_sqlite3_limit == null) {
      throw dbsql.DatabaseException('API sqlite3_limit is not available before 3.5.8');
    }
    return _h_sqlite3_limit!(arg1.address, id, newVal);
  }

  int open(String filename, PtrPtrSqlite3 ppDb) {
    final filenameMeta = filename._metaNativeUtf8();
    final ptrfilename = filenameMeta.ptr.address;
    try {
      return _h_sqlite3_open(ptrfilename, ppDb.address);
    } finally {
      _wasm._free(ptrfilename);
    }
  }

  int open16(String filename, PtrPtrSqlite3 ppDb) {
    final filenameMeta = filename._metaNativeUtf16();
    final ptrfilename = filenameMeta.ptr.address;
    try {
      return _h_sqlite3_open16(ptrfilename, ppDb.address);
    } finally {
      _wasm._free(ptrfilename);
    }
  }

  int open_v2(String filename, PtrPtrSqlite3 ppDb, int flags, String? zVfs) {
    if (_h_sqlite3_open_v2 == null) {
      throw dbsql.DatabaseException('API sqlite3_open_v2 is not available before 3.5.0');
    }
    final filenameMeta = filename._metaNativeUtf8();
    final ptrfilename = filenameMeta.ptr.address;
    final zVfsMeta = zVfs?._metaNativeUtf8();
    final ptrzVfs = zVfsMeta?.ptr.address ?? 0;
    try {
      return _h_sqlite3_open_v2!(ptrfilename, ppDb.address, flags, ptrzVfs);
    } finally {
      _wasm._free(ptrfilename);
      _wasm._free(ptrzVfs);
    }
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
    final ptrzDbName = zDbNameMeta?.ptr.address ?? 0;
    final zTableNameMeta = zTableName._metaNativeUtf8();
    final ptrzTableName = zTableNameMeta.ptr.address;
    final zColumnNameMeta = zColumnName?._metaNativeUtf8();
    final ptrzColumnName = zColumnNameMeta?.ptr.address ?? 0;
    try {
      return _h_sqlite3_table_column_metadata(
          db.address,
          ptrzDbName,
          ptrzTableName,
          ptrzColumnName,
          pzDataType.address,
          pzCollSeq.address,
          pNotNull.address,
          pPrimaryKey.address,
          pAutoinc.address);
    } finally {
      _wasm._free(ptrzDbName);
      _wasm._free(ptrzTableName);
      _wasm._free(ptrzColumnName);
    }
  }

  int total_changes(PtrSqlite3 arg1) {
    return _h_sqlite3_total_changes(arg1.address);
  }
}
