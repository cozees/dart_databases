// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

typedef DefDefTypeGen8 = ffi.Void Function(PtrVoid, PtrSqlite3, ffi.Int32, PtrString);
typedef DartDefDefTypeGen8 = void Function(PtrVoid, PtrSqlite3, int, PtrString);
typedef _c_sqlite3_collation_needed = Nint32 Function(PtrSqlite3, PtrVoid, PtrDefDefTypeGen8);
typedef _d_sqlite3_collation_needed = int Function(PtrSqlite3, PtrVoid, PtrDefDefTypeGen8);
typedef DefDefTypeGen9 = ffi.Void Function(PtrVoid, PtrSqlite3, ffi.Int32, PtrVoid);
typedef DartDefDefTypeGen9 = void Function(PtrVoid, PtrSqlite3, int, PtrVoid);
typedef _c_sqlite3_collation_needed16 = Nint32 Function(PtrSqlite3, PtrVoid, PtrDefDefTypeGen9);
typedef _d_sqlite3_collation_needed16 = int Function(PtrSqlite3, PtrVoid, PtrDefDefTypeGen9);
typedef DefxCompare = ffi.Int32 Function(PtrVoid, ffi.Int32, PtrVoid, ffi.Int32, PtrVoid);
typedef DartDefxCompare = int Function(PtrVoid, int, PtrVoid, int, PtrVoid);
typedef _c_sqlite3_create_collation = Nint32 Function(
    PtrSqlite3, PtrString, Nint32, PtrVoid, PtrDefxCompare);
typedef _d_sqlite3_create_collation = int Function(
    PtrSqlite3, PtrString, int, PtrVoid, PtrDefxCompare);
typedef _c_sqlite3_create_collation_v2 = Nint32 Function(
    PtrSqlite3, PtrString, Nint32, PtrVoid, PtrDefxCompare, PtrDefxFree);
typedef _d_sqlite3_create_collation_v2 = int Function(
    PtrSqlite3, PtrString, int, PtrVoid, PtrDefxCompare, PtrDefxFree);
typedef _c_sqlite3_create_collation16 = Nint32 Function(
    PtrSqlite3, PtrVoid, Nint32, PtrVoid, PtrDefxCompare);
typedef _d_sqlite3_create_collation16 = int Function(
    PtrSqlite3, PtrVoid, int, PtrVoid, PtrDefxCompare);
typedef DefxFinal = ffi.Void Function(PtrContext);
typedef DartDefxFinal = void Function(PtrContext);
typedef _c_sqlite3_create_function = Nint32 Function(
    PtrSqlite3, PtrString, Nint32, Nint32, PtrVoid, PtrDefpxFunc, PtrDefpxFunc, PtrDefxFinal);
typedef _d_sqlite3_create_function = int Function(
    PtrSqlite3, PtrString, int, int, PtrVoid, PtrDefpxFunc, PtrDefpxFunc, PtrDefxFinal);
typedef _c_sqlite3_create_function16 = Nint32 Function(
    PtrSqlite3, PtrString16, Nint32, Nint32, PtrVoid, PtrDefpxFunc, PtrDefpxFunc, PtrDefxFinal);
typedef _d_sqlite3_create_function16 = int Function(
    PtrSqlite3, PtrString16, int, int, PtrVoid, PtrDefpxFunc, PtrDefpxFunc, PtrDefxFinal);
typedef _c_sqlite3_create_function_v2 = Nint32 Function(PtrSqlite3, PtrString, Nint32, Nint32,
    PtrVoid, PtrDefpxFunc, PtrDefpxFunc, PtrDefxFinal, PtrDefxFree);
typedef _d_sqlite3_create_function_v2 = int Function(PtrSqlite3, PtrString, int, int, PtrVoid,
    PtrDefpxFunc, PtrDefpxFunc, PtrDefxFinal, PtrDefxFree);
typedef _c_sqlite3_create_window_function = Nint32 Function(PtrSqlite3, PtrString, Nint32, Nint32,
    PtrVoid, PtrDefpxFunc, PtrDefxFinal, PtrDefxFinal, PtrDefpxFunc, PtrDefxFree);
typedef _d_sqlite3_create_window_function = int Function(PtrSqlite3, PtrString, int, int, PtrVoid,
    PtrDefpxFunc, PtrDefxFinal, PtrDefxFinal, PtrDefpxFunc, PtrDefxFree);

// Mixin for Function
mixin _MixinFunction on _SQLiteLibrary {
  late final _d_sqlite3_collation_needed _h_sqlite3_collation_needed =
      library.lookupFunction<_c_sqlite3_collation_needed, _d_sqlite3_collation_needed>(
          'sqlite3_collation_needed');

  late final _d_sqlite3_collation_needed16 _h_sqlite3_collation_needed16 =
      library.lookupFunction<_c_sqlite3_collation_needed16, _d_sqlite3_collation_needed16>(
          'sqlite3_collation_needed16');

  late final _d_sqlite3_create_collation _h_sqlite3_create_collation =
      library.lookupFunction<_c_sqlite3_create_collation, _d_sqlite3_create_collation>(
          'sqlite3_create_collation');

  late final _d_sqlite3_create_collation_v2? _h_sqlite3_create_collation_v2 =
      libVersionNumber < 3004000
          ? null
          : library.lookupFunction<_c_sqlite3_create_collation_v2, _d_sqlite3_create_collation_v2>(
              'sqlite3_create_collation_v2');

  late final _d_sqlite3_create_collation16 _h_sqlite3_create_collation16 =
      library.lookupFunction<_c_sqlite3_create_collation16, _d_sqlite3_create_collation16>(
          'sqlite3_create_collation16');

  late final _d_sqlite3_create_function _h_sqlite3_create_function =
      library.lookupFunction<_c_sqlite3_create_function, _d_sqlite3_create_function>(
          'sqlite3_create_function');

  late final _d_sqlite3_create_function16 _h_sqlite3_create_function16 =
      library.lookupFunction<_c_sqlite3_create_function16, _d_sqlite3_create_function16>(
          'sqlite3_create_function16');

  late final _d_sqlite3_create_function_v2? _h_sqlite3_create_function_v2 =
      libVersionNumber < 3007003
          ? null
          : library.lookupFunction<_c_sqlite3_create_function_v2, _d_sqlite3_create_function_v2>(
              'sqlite3_create_function_v2');

  late final _d_sqlite3_create_window_function _h_sqlite3_create_window_function =
      library.lookupFunction<_c_sqlite3_create_window_function, _d_sqlite3_create_window_function>(
          'sqlite3_create_window_function');

  int collation_needed(PtrSqlite3 arg1, PtrVoid arg2, PtrDefDefTypeGen8 ptrDefDefTypeGen8) {
    return _h_sqlite3_collation_needed(arg1, arg2, ptrDefDefTypeGen8);
  }

  int collation_needed16(PtrSqlite3 arg1, PtrVoid arg2, PtrDefDefTypeGen9 ptrDefDefTypeGen9) {
    return _h_sqlite3_collation_needed16(arg1, arg2, ptrDefDefTypeGen9);
  }

  int create_collation(
      PtrSqlite3 arg1, String zName, int eTextRep, PtrVoid pArg, PtrDefxCompare xCompare) {
    final zNameMeta = zName._metaNativeUtf8();
    final ptrZName = zNameMeta.ptr;
    try {
      return _h_sqlite3_create_collation(arg1, ptrZName, eTextRep, pArg, xCompare);
    } finally {
      pkgffi.malloc.free(ptrZName);
    }
  }

  int create_collation_v2(PtrSqlite3 arg1, String zName, int eTextRep, PtrVoid pArg,
      PtrDefxCompare xCompare, PtrDefxFree xDestroy) {
    if (libVersionNumber < 3004000) {
      throw dbsql.DatabaseException(
          'API sqlite3_create_collation_v2 is not available before 3.4.0');
    }
    final zNameMeta = zName._metaNativeUtf8();
    final ptrZName = zNameMeta.ptr;
    try {
      return _h_sqlite3_create_collation_v2!(arg1, ptrZName, eTextRep, pArg, xCompare, xDestroy);
    } finally {
      pkgffi.malloc.free(ptrZName);
    }
  }

  int create_collation16(
      PtrSqlite3 arg1, PtrVoid zName, int eTextRep, PtrVoid pArg, PtrDefxCompare xCompare) {
    return _h_sqlite3_create_collation16(arg1, zName, eTextRep, pArg, xCompare);
  }

  int create_function(PtrSqlite3 db, String zFunctionName, int nArg, int eTextRep, PtrVoid pApp,
      PtrDefpxFunc xFunc, PtrDefpxFunc xStep, PtrDefxFinal xFinal) {
    final zFunctionNameMeta = zFunctionName._metaNativeUtf8();
    final ptrZFunctionName = zFunctionNameMeta.ptr;
    try {
      return _h_sqlite3_create_function(
          db, ptrZFunctionName, nArg, eTextRep, pApp, xFunc, xStep, xFinal);
    } finally {
      pkgffi.malloc.free(ptrZFunctionName);
    }
  }

  int create_function16(PtrSqlite3 db, String zFunctionName, int nArg, int eTextRep, PtrVoid pApp,
      PtrDefpxFunc xFunc, PtrDefpxFunc xStep, PtrDefxFinal xFinal) {
    final zFunctionNameMeta = zFunctionName._metaNativeUtf16();
    final ptrZFunctionName = zFunctionNameMeta.ptr;
    try {
      return _h_sqlite3_create_function16(
          db, ptrZFunctionName, nArg, eTextRep, pApp, xFunc, xStep, xFinal);
    } finally {
      pkgffi.malloc.free(ptrZFunctionName);
    }
  }

  int create_function_v2(PtrSqlite3 db, String zFunctionName, int nArg, int eTextRep, PtrVoid pApp,
      PtrDefpxFunc xFunc, PtrDefpxFunc xStep, PtrDefxFinal xFinal, PtrDefxFree xDestroy) {
    if (libVersionNumber < 3007003) {
      throw dbsql.DatabaseException('API sqlite3_create_function_v2 is not available before 3.7.3');
    }
    final zFunctionNameMeta = zFunctionName._metaNativeUtf8();
    final ptrZFunctionName = zFunctionNameMeta.ptr;
    try {
      return _h_sqlite3_create_function_v2!(
          db, ptrZFunctionName, nArg, eTextRep, pApp, xFunc, xStep, xFinal, xDestroy);
    } finally {
      pkgffi.malloc.free(ptrZFunctionName);
    }
  }

  int create_window_function(
      PtrSqlite3 db,
      String zFunctionName,
      int nArg,
      int eTextRep,
      PtrVoid pApp,
      PtrDefpxFunc xStep,
      PtrDefxFinal xFinal,
      PtrDefxFinal xValue,
      PtrDefpxFunc xInverse,
      PtrDefxFree xDestroy) {
    final zFunctionNameMeta = zFunctionName._metaNativeUtf8();
    final ptrZFunctionName = zFunctionNameMeta.ptr;
    try {
      return _h_sqlite3_create_window_function(
          db, ptrZFunctionName, nArg, eTextRep, pApp, xStep, xFinal, xValue, xInverse, xDestroy);
    } finally {
      pkgffi.malloc.free(ptrZFunctionName);
    }
  }
}
