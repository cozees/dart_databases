// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

import 'dart:async' as _async;
import 'dart:typed_data' as typed;

import 'native/library.g.dart'
    if (dart.library.js) 'web/library.g.dart'
    if (dart.library.html) 'web/library.g.dart'
    if (dart.library.io) 'native/library.g.dart' as cpf;

export 'native/library.g.dart'
    if (dart.library.js) 'web/library.g.dart'
    if (dart.library.html) 'web/library.g.dart'
    if (dart.library.io) 'native/library.g.dart'
    show
        isNative,
        nullptr,
        Pointer,
        Utf8,
        Utf16,
        Int8,
        Int32,
        Int64,
        Void,
        PtrVoid,
        Utf8Pointer,
        Utf16Pointer,
        Int32Pointer,
        Int64Pointer,
        PointerPointer,
        PtrPtrUtf8,
        malloc,
        free,
        AllocatorAlloc,
        PtrSqlite3,
        PtrPtrSqlite3,
        PtrStmt,
        PtrPtrStmt,
        PtrValue,
        PtrPtrValue,
        PtrContext,
        DefpxFunc,
        DartDefpxFunc,
        DefxFinal,
        DartDefxFinal,
        DefxFree,
        DartDefxFree,
        DefxSize,
        DartDefxSize,
        DefDefTypeGen10,
        DartDefDefTypeGen10,
        DefxCompare,
        DartDefxCompare,
        Defcallback,
        DartDefcallback;

part 'apis_ext.dart';

/// Cross platform interface for native and web.
class SQLiteLibrary {
  SQLiteLibrary._(this._sqlite);

  final cpf.SQLiteLibrary _sqlite;

  static _async.Future<SQLiteLibrary> instance([String? path]) async {
    return SQLiteLibrary._(await cpf.SQLiteLibrary.instance(path));
  }

  /// Return the current version of current sqlite3 library in number
  int get libVersionNumber => _sqlite.libVersionNumber;

  /// Return the current version of current sqlite3 library in String
  String get libVersion => _sqlite.libVersion;

  /// Return the hash source id of current sqlite3 library.
  String get sourceId => _sqlite.sourceId;

  /// Cross platform interface api for sqlite3_aggregate_context
  cpf.PtrVoid? aggregate_context(cpf.PtrContext arg1, int nBytes) =>
      _sqlite.aggregate_context(arg1, nBytes);

  /// Cross platform interface api for sqlite3_bind_blob
  int bind_blob(cpf.PtrStmt arg1, int arg2, typed.Uint8List? arg3) =>
      _sqlite.bind_blob(arg1, arg2, arg3);

  /// Cross platform interface api for sqlite3_bind_double
  int bind_double(cpf.PtrStmt arg1, int arg2, double arg3) => _sqlite.bind_double(arg1, arg2, arg3);

  /// Cross platform interface api for sqlite3_bind_int
  int bind_int(cpf.PtrStmt arg1, int arg2, int arg3) => _sqlite.bind_int(arg1, arg2, arg3);

  /// Cross platform interface api for sqlite3_bind_int64
  int bind_int64(cpf.PtrStmt arg1, int arg2, int arg3) => _sqlite.bind_int64(arg1, arg2, arg3);

  /// Cross platform interface api for sqlite3_bind_null
  int bind_null(cpf.PtrStmt arg1, int arg2) => _sqlite.bind_null(arg1, arg2);

  /// Cross platform interface api for sqlite3_bind_text
  int bind_text(cpf.PtrStmt arg1, int arg2, String? arg3) => _sqlite.bind_text(arg1, arg2, arg3);

  /// Cross platform interface api for sqlite3_bind_text16
  int bind_text16(cpf.PtrStmt arg1, int arg2, String? arg3) =>
      _sqlite.bind_text16(arg1, arg2, arg3);

  /// Cross platform interface api for sqlite3_bind_parameter_count
  int bind_parameter_count(cpf.PtrStmt arg1) => _sqlite.bind_parameter_count(arg1);

  /// Cross platform interface api for sqlite3_bind_parameter_index
  int bind_parameter_index(cpf.PtrStmt arg1, String zName) =>
      _sqlite.bind_parameter_index(arg1, zName);

  /// Cross platform interface api for sqlite3_bind_parameter_name
  String? bind_parameter_name(cpf.PtrStmt arg1, int arg2) =>
      _sqlite.bind_parameter_name(arg1, arg2);

  /// Cross platform interface api for sqlite3_changes
  int changes(cpf.PtrSqlite3 arg1) => _sqlite.changes(arg1);

  /// Cross platform interface api for sqlite3_clear_bindings
  int clear_bindings(cpf.PtrStmt arg1) => _sqlite.clear_bindings(arg1);

  /// Cross platform interface api for sqlite3_close
  int close(cpf.PtrSqlite3 arg1) => _sqlite.close(arg1);

  /// Cross platform interface api for sqlite3_close_v2
  int close_v2(cpf.PtrSqlite3 arg1) => _sqlite.close_v2(arg1);

  /// Cross platform interface api for sqlite3_column_blob
  typed.Uint8List? column_blob(cpf.PtrStmt arg1, int iCol) => _sqlite.column_blob(arg1, iCol);

  /// Cross platform interface api for sqlite3_column_double
  double column_double(cpf.PtrStmt arg1, int iCol) => _sqlite.column_double(arg1, iCol);

  /// Cross platform interface api for sqlite3_column_int
  int column_int(cpf.PtrStmt arg1, int iCol) => _sqlite.column_int(arg1, iCol);

  /// Cross platform interface api for sqlite3_column_int64
  int column_int64(cpf.PtrStmt arg1, int iCol) => _sqlite.column_int64(arg1, iCol);

  /// Cross platform interface api for sqlite3_column_text
  String? column_text(cpf.PtrStmt arg1, int iCol) => _sqlite.column_text(arg1, iCol);

  /// Cross platform interface api for sqlite3_column_text16
  String? column_text16(cpf.PtrStmt arg1, int iCol) => _sqlite.column_text16(arg1, iCol);

  /// Cross platform interface api for sqlite3_column_bytes
  int column_bytes(cpf.PtrStmt arg1, int iCol) => _sqlite.column_bytes(arg1, iCol);

  /// Cross platform interface api for sqlite3_column_bytes16
  int column_bytes16(cpf.PtrStmt arg1, int iCol) => _sqlite.column_bytes16(arg1, iCol);

  /// Cross platform interface api for sqlite3_column_type
  int column_type(cpf.PtrStmt arg1, int iCol) => _sqlite.column_type(arg1, iCol);

  /// Cross platform interface api for sqlite3_column_count
  int column_count(cpf.PtrStmt pStmt) => _sqlite.column_count(pStmt);

  /// Cross platform interface api for sqlite3_column_database_name
  String? column_database_name(cpf.PtrStmt arg1, int arg2) =>
      _sqlite.column_database_name(arg1, arg2);

  /// Cross platform interface api for sqlite3_column_database_name16
  String? column_database_name16(cpf.PtrStmt arg1, int arg2) =>
      _sqlite.column_database_name16(arg1, arg2);

  /// Cross platform interface api for sqlite3_column_table_name
  String? column_table_name(cpf.PtrStmt arg1, int arg2) => _sqlite.column_table_name(arg1, arg2);

  /// Cross platform interface api for sqlite3_column_table_name16
  String? column_table_name16(cpf.PtrStmt arg1, int arg2) =>
      _sqlite.column_table_name16(arg1, arg2);

  /// Cross platform interface api for sqlite3_column_origin_name
  String? column_origin_name(cpf.PtrStmt arg1, int arg2) => _sqlite.column_origin_name(arg1, arg2);

  /// Cross platform interface api for sqlite3_column_origin_name16
  String? column_origin_name16(cpf.PtrStmt arg1, int arg2) =>
      _sqlite.column_origin_name16(arg1, arg2);

  /// Cross platform interface api for sqlite3_column_decltype
  String? column_decltype(cpf.PtrStmt arg1, int arg2) => _sqlite.column_decltype(arg1, arg2);

  /// Cross platform interface api for sqlite3_column_decltype16
  String? column_decltype16(cpf.PtrStmt arg1, int arg2) => _sqlite.column_decltype16(arg1, arg2);

  /// Cross platform interface api for sqlite3_column_name
  String? column_name(cpf.PtrStmt arg1, int N) => _sqlite.column_name(arg1, N);

  /// Cross platform interface api for sqlite3_column_name16
  String? column_name16(cpf.PtrStmt arg1, int N) => _sqlite.column_name16(arg1, N);

  /// Cross platform interface api for sqlite3_commit_hook
  cpf.PtrVoid? commit_hook(cpf.PtrSqlite3 arg1, cpf.PtrDefxSize ptrDefxSize, cpf.PtrVoid arg2) =>
      _sqlite.commit_hook(arg1, ptrDefxSize, arg2);

  /// Cross platform interface api for sqlite3_rollback_hook
  cpf.PtrVoid? rollback_hook(cpf.PtrSqlite3 arg1, cpf.PtrDefxFree ptrDefxFree, cpf.PtrVoid arg2) =>
      _sqlite.rollback_hook(arg1, ptrDefxFree, arg2);

  /// Cross platform interface api for sqlite3_create_collation
  int create_collation(cpf.PtrSqlite3 arg1, String zName, int eTextRep, cpf.PtrVoid pArg,
          cpf.PtrDefxCompare xCompare) =>
      _sqlite.create_collation(arg1, zName, eTextRep, pArg, xCompare);

  /// Cross platform interface api for sqlite3_create_collation_v2
  int create_collation_v2(cpf.PtrSqlite3 arg1, String zName, int eTextRep, cpf.PtrVoid pArg,
          cpf.PtrDefxCompare xCompare, cpf.PtrDefxFree xDestroy) =>
      _sqlite.create_collation_v2(arg1, zName, eTextRep, pArg, xCompare, xDestroy);

  /// Cross platform interface api for sqlite3_create_function
  int create_function(
          cpf.PtrSqlite3 db,
          String zFunctionName,
          int nArg,
          int eTextRep,
          cpf.PtrVoid pApp,
          cpf.PtrDefpxFunc xFunc,
          cpf.PtrDefpxFunc xStep,
          cpf.PtrDefxFinal xFinal) =>
      _sqlite.create_function(db, zFunctionName, nArg, eTextRep, pApp, xFunc, xStep, xFinal);

  /// Cross platform interface api for sqlite3_create_function16
  int create_function16(
          cpf.PtrSqlite3 db,
          String zFunctionName,
          int nArg,
          int eTextRep,
          cpf.PtrVoid pApp,
          cpf.PtrDefpxFunc xFunc,
          cpf.PtrDefpxFunc xStep,
          cpf.PtrDefxFinal xFinal) =>
      _sqlite.create_function16(db, zFunctionName, nArg, eTextRep, pApp, xFunc, xStep, xFinal);

  /// Cross platform interface api for sqlite3_create_function_v2
  int create_function_v2(
          cpf.PtrSqlite3 db,
          String zFunctionName,
          int nArg,
          int eTextRep,
          cpf.PtrVoid pApp,
          cpf.PtrDefpxFunc xFunc,
          cpf.PtrDefpxFunc xStep,
          cpf.PtrDefxFinal xFinal,
          cpf.PtrDefxFree xDestroy) =>
      _sqlite.create_function_v2(
          db, zFunctionName, nArg, eTextRep, pApp, xFunc, xStep, xFinal, xDestroy);

  /// Cross platform interface api for sqlite3_data_count
  int data_count(cpf.PtrStmt pStmt) => _sqlite.data_count(pStmt);

  /// Cross platform interface api for sqlite3_errcode
  int errcode(cpf.PtrSqlite3 db) => _sqlite.errcode(db);

  /// Cross platform interface api for sqlite3_extended_errcode
  int extended_errcode(cpf.PtrSqlite3 db) => _sqlite.extended_errcode(db);

  /// Cross platform interface api for sqlite3_errmsg
  String errmsg(cpf.PtrSqlite3 arg1) => _sqlite.errmsg(arg1);

  /// Cross platform interface api for sqlite3_errmsg16
  cpf.PtrVoid errmsg16(cpf.PtrSqlite3 arg1) => _sqlite.errmsg16(arg1);

  /// Cross platform interface api for sqlite3_errstr
  String errstr(int arg1) => _sqlite.errstr(arg1);

  /// Cross platform interface api for sqlite3_exec
  int exec(cpf.PtrSqlite3 arg1, String sql, cpf.PtrDefcallback callback, cpf.PtrVoid arg2,
          cpf.PtrPtrUtf8 errmsg) =>
      _sqlite.exec(arg1, sql, callback, arg2, errmsg);

  /// Cross platform interface api for sqlite3_extended_result_codes
  int extended_result_codes(cpf.PtrSqlite3 arg1, int onoff) =>
      _sqlite.extended_result_codes(arg1, onoff);

  /// Cross platform interface api for sqlite3_finalize
  int finalize(cpf.PtrStmt pStmt) => _sqlite.finalize(pStmt);

  /// Cross platform interface api for sqlite3_last_insert_rowid
  int last_insert_rowid(cpf.PtrSqlite3 arg1) => _sqlite.last_insert_rowid(arg1);

  /// Cross platform interface api for sqlite3_limit
  int limit(cpf.PtrSqlite3 arg1, int id, int newVal) => _sqlite.limit(arg1, id, newVal);

  /// Cross platform interface api for sqlite3_open
  int open(String filename, cpf.PtrPtrSqlite3 ppDb) => _sqlite.open(filename, ppDb);

  /// Cross platform interface api for sqlite3_open16
  int open16(String filename, cpf.PtrPtrSqlite3 ppDb) => _sqlite.open16(filename, ppDb);

  /// Cross platform interface api for sqlite3_open_v2
  int open_v2(String filename, cpf.PtrPtrSqlite3 ppDb, int flags, String? zVfs) =>
      _sqlite.open_v2(filename, ppDb, flags, zVfs);

  /// Cross platform interface api for sqlite3_prepare
  int prepare(cpf.PtrSqlite3 db, String zSql, cpf.PtrPtrStmt ppStmt, cpf.PtrPtrUtf8 pzTail) =>
      _sqlite.prepare(db, zSql, ppStmt, pzTail);

  /// Cross platform interface api for sqlite3_prepare_v2
  int prepare_v2(cpf.PtrSqlite3 db, String zSql, cpf.PtrPtrStmt ppStmt, cpf.PtrPtrUtf8 pzTail) =>
      _sqlite.prepare_v2(db, zSql, ppStmt, pzTail);

  /// Cross platform interface api for sqlite3_prepare_v3
  int prepare_v3(cpf.PtrSqlite3 db, String zSql, int prepFlags, cpf.PtrPtrStmt ppStmt,
          cpf.PtrPtrUtf8 pzTail) =>
      _sqlite.prepare_v3(db, zSql, prepFlags, ppStmt, pzTail);

  /// Cross platform interface api for sqlite3_prepare16
  int prepare16(cpf.PtrSqlite3 db, String zSql, cpf.PtrPtrStmt ppStmt, cpf.PtrPtrVoid pzTail) =>
      _sqlite.prepare16(db, zSql, ppStmt, pzTail);

  /// Cross platform interface api for sqlite3_prepare16_v2
  int prepare16_v2(cpf.PtrSqlite3 db, String zSql, cpf.PtrPtrStmt ppStmt, cpf.PtrPtrVoid pzTail) =>
      _sqlite.prepare16_v2(db, zSql, ppStmt, pzTail);

  /// Cross platform interface api for sqlite3_prepare16_v3
  int prepare16_v3(cpf.PtrSqlite3 db, String zSql, int prepFlags, cpf.PtrPtrStmt ppStmt,
          cpf.PtrPtrVoid pzTail) =>
      _sqlite.prepare16_v3(db, zSql, prepFlags, ppStmt, pzTail);

  /// Cross platform interface api for sqlite3_reset
  int reset(cpf.PtrStmt pStmt) => _sqlite.reset(pStmt);

  /// Cross platform interface api for sqlite3_result_blob
  void result_blob(cpf.PtrContext arg1, typed.Uint8List arg2) => _sqlite.result_blob(arg1, arg2);

  /// Cross platform interface api for sqlite3_result_double
  void result_double(cpf.PtrContext arg1, double arg2) => _sqlite.result_double(arg1, arg2);

  /// Cross platform interface api for sqlite3_result_error
  void result_error(cpf.PtrContext arg1, String arg2) => _sqlite.result_error(arg1, arg2);

  /// Cross platform interface api for sqlite3_result_error16
  void result_error16(cpf.PtrContext arg1, String arg2) => _sqlite.result_error16(arg1, arg2);

  /// Cross platform interface api for sqlite3_result_error_toobig
  void result_error_toobig(cpf.PtrContext arg1) => _sqlite.result_error_toobig(arg1);

  /// Cross platform interface api for sqlite3_result_error_nomem
  void result_error_nomem(cpf.PtrContext arg1) => _sqlite.result_error_nomem(arg1);

  /// Cross platform interface api for sqlite3_result_error_code
  void result_error_code(cpf.PtrContext arg1, int arg2) => _sqlite.result_error_code(arg1, arg2);

  /// Cross platform interface api for sqlite3_result_int
  void result_int(cpf.PtrContext arg1, int arg2) => _sqlite.result_int(arg1, arg2);

  /// Cross platform interface api for sqlite3_result_int64
  void result_int64(cpf.PtrContext arg1, int arg2) => _sqlite.result_int64(arg1, arg2);

  /// Cross platform interface api for sqlite3_result_null
  void result_null(cpf.PtrContext arg1) => _sqlite.result_null(arg1);

  /// Cross platform interface api for sqlite3_result_text
  void result_text(cpf.PtrContext arg1, String arg2) => _sqlite.result_text(arg1, arg2);

  /// Cross platform interface api for sqlite3_result_text16
  void result_text16(cpf.PtrContext arg1, String arg2) => _sqlite.result_text16(arg1, arg2);

  /// Cross platform interface api for sqlite3_step
  int step(cpf.PtrStmt arg1) => _sqlite.step(arg1);

  /// Cross platform interface api for sqlite3_table_column_metadata
  int table_column_metadata(
          cpf.PtrSqlite3 db,
          String? zDbName,
          String zTableName,
          String? zColumnName,
          cpf.PtrPtrUtf8 pzDataType,
          cpf.PtrPtrUtf8 pzCollSeq,
          cpf.PtrInt32 pNotNull,
          cpf.PtrInt32 pPrimaryKey,
          cpf.PtrInt32 pAutoinc) =>
      _sqlite.table_column_metadata(db, zDbName, zTableName, zColumnName, pzDataType, pzCollSeq,
          pNotNull, pPrimaryKey, pAutoinc);

  /// Cross platform interface api for sqlite3_total_changes
  int total_changes(cpf.PtrSqlite3 arg1) => _sqlite.total_changes(arg1);

  /// Cross platform interface api for sqlite3_update_hook
  cpf.PtrVoid? update_hook(
          cpf.PtrSqlite3 arg1, cpf.PtrDefDefTypeGen10 ptrDefDefTypeGen10, cpf.PtrVoid arg2) =>
      _sqlite.update_hook(arg1, ptrDefDefTypeGen10, arg2);

  /// Cross platform interface api for sqlite3_user_data
  cpf.PtrVoid? user_data(cpf.PtrContext arg1) => _sqlite.user_data(arg1);

  /// Cross platform interface api for sqlite3_value_blob
  typed.Uint8List? value_blob(cpf.PtrValue arg1) => _sqlite.value_blob(arg1);

  /// Cross platform interface api for sqlite3_value_double
  double value_double(cpf.PtrValue arg1) => _sqlite.value_double(arg1);

  /// Cross platform interface api for sqlite3_value_int
  int value_int(cpf.PtrValue arg1) => _sqlite.value_int(arg1);

  /// Cross platform interface api for sqlite3_value_int64
  int value_int64(cpf.PtrValue arg1) => _sqlite.value_int64(arg1);

  /// Cross platform interface api for sqlite3_value_text
  String? value_text(cpf.PtrValue arg1) => _sqlite.value_text(arg1);

  /// Cross platform interface api for sqlite3_value_text16
  String? value_text16(cpf.PtrValue arg1) => _sqlite.value_text16(arg1);

  /// Cross platform interface api for sqlite3_value_bytes
  int value_bytes(cpf.PtrValue arg1) => _sqlite.value_bytes(arg1);

  /// Cross platform interface api for sqlite3_value_bytes16
  int value_bytes16(cpf.PtrValue arg1) => _sqlite.value_bytes16(arg1);

  /// Cross platform interface api for sqlite3_value_type
  int value_type(cpf.PtrValue arg1) => _sqlite.value_type(arg1);

  /// Cross platform interface api for sqlite3_value_numeric_type
  int value_numeric_type(cpf.PtrValue arg1) => _sqlite.value_numeric_type(arg1);

  /// Cross platform interface api for sqlite3_value_frombind
  int value_frombind(cpf.PtrValue arg1) => _sqlite.value_frombind(arg1);
}
