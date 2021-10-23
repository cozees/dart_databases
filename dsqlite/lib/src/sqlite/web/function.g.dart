// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

typedef DefxCompare = Nint32 Function(PtrVoid, Nint32, PtrVoid, Nint32, PtrVoid);
typedef DartDefxCompare = int Function(PtrVoid, int, PtrVoid, int, PtrVoid);
typedef _def_sqlite3_create_collation = int Function(int, int, int, int, int);
typedef _def_sqlite3_create_collation_v2 = int Function(int, int, int, int, int, int);
typedef DefpxFunc = NVoid Function(PtrContext, Nint32, PtrPtrValue);
typedef DartDefpxFunc = void Function(PtrContext, int, PtrPtrValue);
typedef DefxFinal = NVoid Function(PtrContext);
typedef DartDefxFinal = void Function(PtrContext);
typedef _def_sqlite3_create_function = int Function(int, int, int, int, int, int, int, int);
typedef _def_sqlite3_create_function16 = int Function(int, int, int, int, int, int, int, int);
typedef _def_sqlite3_create_function_v2 = int Function(int, int, int, int, int, int, int, int, int);

// Mixin for Function
mixin _MixinFunction on _SQLiteLibrary {
  late final _def_sqlite3_create_collation _h_sqlite3_create_collation = _wasm.cwrap(
      'sqlite3_create_collation', 'number', ['number', 'number', 'number', 'number', 'number']);

  late final _def_sqlite3_create_collation_v2? _h_sqlite3_create_collation_v2 =
      libVersionNumber < 3004000
          ? null
          : _wasm.cwrap('sqlite3_create_collation_v2', 'number',
              ['number', 'number', 'number', 'number', 'number', 'number']);

  late final _def_sqlite3_create_function _h_sqlite3_create_function = _wasm.cwrap(
      'sqlite3_create_function',
      'number',
      ['number', 'number', 'number', 'number', 'number', 'number', 'number', 'number']);

  late final _def_sqlite3_create_function16 _h_sqlite3_create_function16 = _wasm.cwrap(
      'sqlite3_create_function16',
      'number',
      ['number', 'number', 'number', 'number', 'number', 'number', 'number', 'number']);

  late final _def_sqlite3_create_function_v2? _h_sqlite3_create_function_v2 =
      libVersionNumber < 3007003
          ? null
          : _wasm.cwrap('sqlite3_create_function_v2', 'number', [
              'number',
              'number',
              'number',
              'number',
              'number',
              'number',
              'number',
              'number',
              'number'
            ]);

  int create_collation(
      PtrSqlite3 arg1, String zName, int eTextRep, PtrVoid pArg, PtrDefxCompare xCompare) {
    final zNameMeta = zName._metaNativeUtf8();
    final ptrzName = zNameMeta.ptr.address;
    try {
      return _h_sqlite3_create_collation(
          arg1.address, ptrzName, eTextRep, pArg.address, xCompare.address);
    } finally {
      _wasm._free(ptrzName);
    }
  }

  int create_collation_v2(PtrSqlite3 arg1, String zName, int eTextRep, PtrVoid pArg,
      PtrDefxCompare xCompare, PtrDefxFree xDestroy) {
    if (_h_sqlite3_create_collation_v2 == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_create_collation_v2 is not available before 3.4.0');
    }
    final zNameMeta = zName._metaNativeUtf8();
    final ptrzName = zNameMeta.ptr.address;
    try {
      return _h_sqlite3_create_collation_v2!(
          arg1.address, ptrzName, eTextRep, pArg.address, xCompare.address, xDestroy.address);
    } finally {
      _wasm._free(ptrzName);
    }
  }

  int create_function(PtrSqlite3 db, String zFunctionName, int nArg, int eTextRep, PtrVoid pApp,
      PtrDefpxFunc xFunc, PtrDefpxFunc xStep, PtrDefxFinal xFinal) {
    final zFunctionNameMeta = zFunctionName._metaNativeUtf8();
    final ptrzFunctionName = zFunctionNameMeta.ptr.address;
    try {
      return _h_sqlite3_create_function(db.address, ptrzFunctionName, nArg, eTextRep, pApp.address,
          xFunc.address, xStep.address, xFinal.address);
    } finally {
      _wasm._free(ptrzFunctionName);
    }
  }

  int create_function16(PtrSqlite3 db, String zFunctionName, int nArg, int eTextRep, PtrVoid pApp,
      PtrDefpxFunc xFunc, PtrDefpxFunc xStep, PtrDefxFinal xFinal) {
    final zFunctionNameMeta = zFunctionName._metaNativeUtf16();
    final ptrzFunctionName = zFunctionNameMeta.ptr.address;
    try {
      return _h_sqlite3_create_function16(db.address, ptrzFunctionName, nArg, eTextRep,
          pApp.address, xFunc.address, xStep.address, xFinal.address);
    } finally {
      _wasm._free(ptrzFunctionName);
    }
  }

  int create_function_v2(PtrSqlite3 db, String zFunctionName, int nArg, int eTextRep, PtrVoid pApp,
      PtrDefpxFunc xFunc, PtrDefpxFunc xStep, PtrDefxFinal xFinal, PtrDefxFree xDestroy) {
    if (_h_sqlite3_create_function_v2 == null) {
      throw dbsql.DatabaseException('API sqlite3_create_function_v2 is not available before 3.7.3');
    }
    final zFunctionNameMeta = zFunctionName._metaNativeUtf8();
    final ptrzFunctionName = zFunctionNameMeta.ptr.address;
    try {
      return _h_sqlite3_create_function_v2!(db.address, ptrzFunctionName, nArg, eTextRep,
          pApp.address, xFunc.address, xStep.address, xFinal.address, xDestroy.address);
    } finally {
      _wasm._free(ptrzFunctionName);
    }
  }
}
