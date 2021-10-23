// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

typedef _def_sqlite3_bind_parameter_count = int Function(int);
typedef _def_sqlite3_bind_parameter_index = int Function(int, int);
typedef _def_sqlite3_bind_parameter_name = int Function(int, int);
typedef _def_sqlite3_clear_bindings = int Function(int);
typedef _def_sqlite3_data_count = int Function(int);
typedef _def_sqlite3_finalize = int Function(int);
typedef _def_sqlite3_prepare = int Function(int, int, int, int, int);
typedef _def_sqlite3_prepare_v2 = int Function(int, int, int, int, int);
typedef _def_sqlite3_prepare_v3 = int Function(int, int, int, int, int, int);
typedef _def_sqlite3_prepare16 = int Function(int, int, int, int, int);
typedef _def_sqlite3_prepare16_v2 = int Function(int, int, int, int, int);
typedef _def_sqlite3_prepare16_v3 = int Function(int, int, int, int, int, int);
typedef _def_sqlite3_reset = int Function(int);
typedef _def_sqlite3_step = int Function(int);

// Mixin for Statement
mixin _MixinStatement on _SQLiteLibrary {
  late final _def_sqlite3_bind_parameter_count _h_sqlite3_bind_parameter_count =
      _wasm.cwrap('sqlite3_bind_parameter_count', 'number', ['number']);

  late final _def_sqlite3_bind_parameter_index _h_sqlite3_bind_parameter_index =
      _wasm.cwrap('sqlite3_bind_parameter_index', 'number', ['number', 'number']);

  late final _def_sqlite3_bind_parameter_name? _h_sqlite3_bind_parameter_name =
      libVersionNumber < 3000005
          ? null
          : _wasm.cwrap('sqlite3_bind_parameter_name', 'number', ['number', 'number']);

  late final _def_sqlite3_clear_bindings _h_sqlite3_clear_bindings =
      _wasm.cwrap('sqlite3_clear_bindings', 'number', ['number']);

  late final _def_sqlite3_data_count _h_sqlite3_data_count =
      _wasm.cwrap('sqlite3_data_count', 'number', ['number']);

  late final _def_sqlite3_finalize _h_sqlite3_finalize =
      _wasm.cwrap('sqlite3_finalize', 'number', ['number']);

  late final _def_sqlite3_prepare _h_sqlite3_prepare =
      _wasm.cwrap('sqlite3_prepare', 'number', ['number', 'number', 'number', 'number', 'number']);

  late final _def_sqlite3_prepare_v2? _h_sqlite3_prepare_v2 = libVersionNumber < 3003009
      ? null
      : _wasm.cwrap(
          'sqlite3_prepare_v2', 'number', ['number', 'number', 'number', 'number', 'number']);

  late final _def_sqlite3_prepare_v3? _h_sqlite3_prepare_v3 = libVersionNumber < 3020000
      ? null
      : _wasm.cwrap('sqlite3_prepare_v3', 'number',
          ['number', 'number', 'number', 'number', 'number', 'number']);

  late final _def_sqlite3_prepare16 _h_sqlite3_prepare16 = _wasm
      .cwrap('sqlite3_prepare16', 'number', ['number', 'number', 'number', 'number', 'number']);

  late final _def_sqlite3_prepare16_v2? _h_sqlite3_prepare16_v2 = libVersionNumber < 3003009
      ? null
      : _wasm.cwrap(
          'sqlite3_prepare16_v2', 'number', ['number', 'number', 'number', 'number', 'number']);

  late final _def_sqlite3_prepare16_v3? _h_sqlite3_prepare16_v3 = libVersionNumber < 3020000
      ? null
      : _wasm.cwrap('sqlite3_prepare16_v3', 'number',
          ['number', 'number', 'number', 'number', 'number', 'number']);

  late final _def_sqlite3_reset _h_sqlite3_reset =
      _wasm.cwrap('sqlite3_reset', 'number', ['number']);

  late final _def_sqlite3_step _h_sqlite3_step = _wasm.cwrap('sqlite3_step', 'number', ['number']);

  int bind_parameter_count(PtrStmt arg1) {
    return _h_sqlite3_bind_parameter_count(arg1.address);
  }

  int bind_parameter_index(PtrStmt arg1, String zName) {
    final zNameMeta = zName._metaNativeUtf8();
    final ptrzName = zNameMeta.ptr.address;
    try {
      return _h_sqlite3_bind_parameter_index(arg1.address, ptrzName);
    } finally {
      _wasm._free(ptrzName);
    }
  }

  String? bind_parameter_name(PtrStmt arg1, int arg2) {
    if (_h_sqlite3_bind_parameter_name == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_bind_parameter_name is not available before 3.0.5 beta');
    }
    int result = 0;
    try {
      var result = _h_sqlite3_bind_parameter_name!(arg1.address, arg2);
      return result == 0 ? null : Pointer<Utf8>.fromAddress(result).toDartString();
    } finally {
      _wasm._free(result);
    }
  }

  int clear_bindings(PtrStmt arg1) {
    return _h_sqlite3_clear_bindings(arg1.address);
  }

  int data_count(PtrStmt pStmt) {
    return _h_sqlite3_data_count(pStmt.address);
  }

  int finalize(PtrStmt pStmt) {
    return _h_sqlite3_finalize(pStmt.address);
  }

  int prepare(PtrSqlite3 db, String zSql, PtrPtrStmt ppStmt, PtrPtrUtf8 pzTail) {
    final zSqlMeta = zSql._metaNativeUtf8();
    final ptrzSql = zSqlMeta.ptr.address;
    try {
      var result =
          _h_sqlite3_prepare(db.address, ptrzSql, zSqlMeta.length, ppStmt.address, pzTail.address);
      if (pzTail.value.address - ptrzSql == zSqlMeta.length) {
        pzTail.value = nullptr;
      }
      return result;
    } finally {
      _wasm._free(ptrzSql);
    }
  }

  int prepare_v2(PtrSqlite3 db, String zSql, PtrPtrStmt ppStmt, PtrPtrUtf8 pzTail) {
    if (_h_sqlite3_prepare_v2 == null) {
      throw dbsql.DatabaseException('API sqlite3_prepare_v2 is not available before 3.3.9');
    }
    final zSqlMeta = zSql._metaNativeUtf8();
    final ptrzSql = zSqlMeta.ptr.address;
    try {
      var result = _h_sqlite3_prepare_v2!(
          db.address, ptrzSql, zSqlMeta.length, ppStmt.address, pzTail.address);
      if (pzTail.value.address - ptrzSql == zSqlMeta.length) {
        pzTail.value = nullptr;
      }
      return result;
    } finally {
      _wasm._free(ptrzSql);
    }
  }

  int prepare_v3(PtrSqlite3 db, String zSql, int prepFlags, PtrPtrStmt ppStmt, PtrPtrUtf8 pzTail) {
    if (_h_sqlite3_prepare_v3 == null) {
      throw dbsql.DatabaseException('API sqlite3_prepare_v3 is not available before 3.20.0');
    }
    final zSqlMeta = zSql._metaNativeUtf8();
    final ptrzSql = zSqlMeta.ptr.address;
    try {
      var result = _h_sqlite3_prepare_v3!(
          db.address, ptrzSql, zSqlMeta.length, prepFlags, ppStmt.address, pzTail.address);
      if (pzTail.value.address - ptrzSql == zSqlMeta.length) {
        pzTail.value = nullptr;
      }
      return result;
    } finally {
      _wasm._free(ptrzSql);
    }
  }

  int prepare16(PtrSqlite3 db, String zSql, PtrPtrStmt ppStmt, PtrPtrVoid pzTail) {
    final zSqlMeta = zSql._metaNativeUtf16();
    final ptrzSql = zSqlMeta.ptr.address;
    try {
      var result = _h_sqlite3_prepare16(
          db.address, ptrzSql, zSqlMeta.length, ppStmt.address, pzTail.address);
      if (pzTail.value.address - ptrzSql == zSqlMeta.length) {
        pzTail.value = nullptr;
      }
      return result;
    } finally {
      _wasm._free(ptrzSql);
    }
  }

  int prepare16_v2(PtrSqlite3 db, String zSql, PtrPtrStmt ppStmt, PtrPtrVoid pzTail) {
    if (_h_sqlite3_prepare16_v2 == null) {
      throw dbsql.DatabaseException('API sqlite3_prepare16_v2 is not available before 3.3.9');
    }
    final zSqlMeta = zSql._metaNativeUtf16();
    final ptrzSql = zSqlMeta.ptr.address;
    try {
      var result = _h_sqlite3_prepare16_v2!(
          db.address, ptrzSql, zSqlMeta.length, ppStmt.address, pzTail.address);
      if (pzTail.value.address - ptrzSql == zSqlMeta.length) {
        pzTail.value = nullptr;
      }
      return result;
    } finally {
      _wasm._free(ptrzSql);
    }
  }

  int prepare16_v3(
      PtrSqlite3 db, String zSql, int prepFlags, PtrPtrStmt ppStmt, PtrPtrVoid pzTail) {
    if (_h_sqlite3_prepare16_v3 == null) {
      throw dbsql.DatabaseException('API sqlite3_prepare16_v3 is not available before 3.20.0');
    }
    final zSqlMeta = zSql._metaNativeUtf16();
    final ptrzSql = zSqlMeta.ptr.address;
    try {
      var result = _h_sqlite3_prepare16_v3!(
          db.address, ptrzSql, zSqlMeta.length, prepFlags, ppStmt.address, pzTail.address);
      if (pzTail.value.address - ptrzSql == zSqlMeta.length) {
        pzTail.value = nullptr;
      }
      return result;
    } finally {
      _wasm._free(ptrzSql);
    }
  }

  int reset(PtrStmt pStmt) {
    return _h_sqlite3_reset(pStmt.address);
  }

  int step(PtrStmt arg1) {
    return _h_sqlite3_step(arg1.address);
  }
}
