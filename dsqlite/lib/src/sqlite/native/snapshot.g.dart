// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

typedef _c_sqlite3_snapshot_cmp = Nint32 Function(PtrSnapshot, PtrSnapshot);
typedef _d_sqlite3_snapshot_cmp = int Function(PtrSnapshot, PtrSnapshot);
typedef _c_sqlite3_snapshot_free = NVoid Function(PtrSnapshot);
typedef _d_sqlite3_snapshot_free = void Function(PtrSnapshot);
typedef _c_sqlite3_snapshot_get = Nint32 Function(PtrSqlite3, PtrString, PtrPtrSnapshot);
typedef _d_sqlite3_snapshot_get = int Function(PtrSqlite3, PtrString, PtrPtrSnapshot);
typedef _c_sqlite3_snapshot_open = Nint32 Function(PtrSqlite3, PtrString, PtrSnapshot);
typedef _d_sqlite3_snapshot_open = int Function(PtrSqlite3, PtrString, PtrSnapshot);
typedef _c_sqlite3_snapshot_recover = Nint32 Function(PtrSqlite3, PtrString);
typedef _d_sqlite3_snapshot_recover = int Function(PtrSqlite3, PtrString);

// Mixin for Snapshot
mixin _MixinSnapshot on _SQLiteLibrary {
  late final _d_sqlite3_snapshot_cmp? _h_sqlite3_snapshot_cmp = _nullable(() => library
      .lookupFunction<_c_sqlite3_snapshot_cmp, _d_sqlite3_snapshot_cmp>('sqlite3_snapshot_cmp'));

  late final _d_sqlite3_snapshot_free? _h_sqlite3_snapshot_free = libVersionNumber < 3010000
      ? null
      : _nullable(() => library.lookupFunction<_c_sqlite3_snapshot_free, _d_sqlite3_snapshot_free>(
          'sqlite3_snapshot_free'));

  late final _d_sqlite3_snapshot_get? _h_sqlite3_snapshot_get = libVersionNumber < 3010000
      ? null
      : _nullable(() => library.lookupFunction<_c_sqlite3_snapshot_get, _d_sqlite3_snapshot_get>(
          'sqlite3_snapshot_get'));

  late final _d_sqlite3_snapshot_open? _h_sqlite3_snapshot_open = libVersionNumber < 3010000
      ? null
      : _nullable(() => library.lookupFunction<_c_sqlite3_snapshot_open, _d_sqlite3_snapshot_open>(
          'sqlite3_snapshot_open'));

  late final _d_sqlite3_snapshot_recover? _h_sqlite3_snapshot_recover = _nullable(() =>
      library.lookupFunction<_c_sqlite3_snapshot_recover, _d_sqlite3_snapshot_recover>(
          'sqlite3_snapshot_recover'));

  int snapshot_cmp(PtrSnapshot p1, PtrSnapshot p2) {
    if (_h_sqlite3_snapshot_cmp == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_snapshot_cmp is not available, You need to enable it during library build.');
    }
    return _h_sqlite3_snapshot_cmp!(p1, p2);
  }

  void snapshot_free(PtrSnapshot arg1) {
    if (libVersionNumber < 3010000) {
      throw dbsql.DatabaseException('API sqlite3_snapshot_free is not available before 3.10.0');
    }
    if (_h_sqlite3_snapshot_free! == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_snapshot_free is not available, You need to enable it during library build.');
    }
    return _h_sqlite3_snapshot_free!(arg1);
  }

  int snapshot_get(PtrSqlite3 db, String zSchema, PtrPtrSnapshot ppSnapshot) {
    if (libVersionNumber < 3010000) {
      throw dbsql.DatabaseException('API sqlite3_snapshot_get is not available before 3.10.0');
    }
    final zSchemaMeta = zSchema._metaNativeUtf8();
    final ptrZSchema = zSchemaMeta.ptr;
    if (_h_sqlite3_snapshot_get! == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_snapshot_get is not available, You need to enable it during library build.');
    }
    try {
      return _h_sqlite3_snapshot_get!(db, ptrZSchema, ppSnapshot);
    } finally {
      pkgffi.malloc.free(ptrZSchema);
    }
  }

  int snapshot_open(PtrSqlite3 db, String zSchema, PtrSnapshot pSnapshot) {
    if (libVersionNumber < 3010000) {
      throw dbsql.DatabaseException('API sqlite3_snapshot_open is not available before 3.10.0');
    }
    final zSchemaMeta = zSchema._metaNativeUtf8();
    final ptrZSchema = zSchemaMeta.ptr;
    if (_h_sqlite3_snapshot_open! == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_snapshot_open is not available, You need to enable it during library build.');
    }
    try {
      return _h_sqlite3_snapshot_open!(db, ptrZSchema, pSnapshot);
    } finally {
      pkgffi.malloc.free(ptrZSchema);
    }
  }

  int snapshot_recover(PtrSqlite3 db, String zDb) {
    final zDbMeta = zDb._metaNativeUtf8();
    final ptrZDb = zDbMeta.ptr;
    if (_h_sqlite3_snapshot_recover == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_snapshot_recover is not available, You need to enable it during library build.');
    }
    try {
      return _h_sqlite3_snapshot_recover!(db, ptrZDb);
    } finally {
      pkgffi.malloc.free(ptrZDb);
    }
  }
}
