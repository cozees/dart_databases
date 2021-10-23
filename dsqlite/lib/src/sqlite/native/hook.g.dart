// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

typedef _c_sqlite3_commit_hook = PtrVoid Function(PtrSqlite3, PtrDefxSize, PtrVoid);
typedef _d_sqlite3_commit_hook = PtrVoid Function(PtrSqlite3, PtrDefxSize, PtrVoid);
typedef _c_sqlite3_rollback_hook = PtrVoid Function(PtrSqlite3, PtrDefxFree, PtrVoid);
typedef _d_sqlite3_rollback_hook = PtrVoid Function(PtrSqlite3, PtrDefxFree, PtrVoid);
typedef DefxPreUpdate = ffi.Void Function(
    PtrVoid, PtrSqlite3, ffi.Int32, PtrString, PtrString, ffi.Int64, ffi.Int64);
typedef DartDefxPreUpdate = void Function(PtrVoid, PtrSqlite3, int, PtrString, PtrString, int, int);
typedef _c_sqlite3_preupdate_hook = PtrVoid Function(PtrSqlite3, PtrDefxPreUpdate, PtrVoid);
typedef _d_sqlite3_preupdate_hook = PtrVoid Function(PtrSqlite3, PtrDefxPreUpdate, PtrVoid);
typedef _c_sqlite3_preupdate_old = Nint32 Function(PtrSqlite3, Nint32, PtrPtrValue);
typedef _d_sqlite3_preupdate_old = int Function(PtrSqlite3, int, PtrPtrValue);
typedef _c_sqlite3_preupdate_count = Nint32 Function(PtrSqlite3);
typedef _d_sqlite3_preupdate_count = int Function(PtrSqlite3);
typedef _c_sqlite3_preupdate_depth = Nint32 Function(PtrSqlite3);
typedef _d_sqlite3_preupdate_depth = int Function(PtrSqlite3);
typedef _c_sqlite3_preupdate_new = Nint32 Function(PtrSqlite3, Nint32, PtrPtrValue);
typedef _d_sqlite3_preupdate_new = int Function(PtrSqlite3, int, PtrPtrValue);
typedef _c_sqlite3_preupdate_blobwrite = Nint32 Function(PtrSqlite3);
typedef _d_sqlite3_preupdate_blobwrite = int Function(PtrSqlite3);
typedef DefDefTypeGen10 = ffi.Void Function(PtrVoid, ffi.Int32, PtrString, PtrString, ffi.Int64);
typedef DartDefDefTypeGen10 = void Function(PtrVoid, int, PtrString, PtrString, int);
typedef _c_sqlite3_update_hook = PtrVoid Function(PtrSqlite3, PtrDefDefTypeGen10, PtrVoid);
typedef _d_sqlite3_update_hook = PtrVoid Function(PtrSqlite3, PtrDefDefTypeGen10, PtrVoid);

// Mixin for Hook
mixin _MixinHook on _SQLiteLibrary {
  late final _d_sqlite3_commit_hook _h_sqlite3_commit_hook =
      library.lookupFunction<_c_sqlite3_commit_hook, _d_sqlite3_commit_hook>('sqlite3_commit_hook');

  late final _d_sqlite3_rollback_hook _h_sqlite3_rollback_hook = library
      .lookupFunction<_c_sqlite3_rollback_hook, _d_sqlite3_rollback_hook>('sqlite3_rollback_hook');

  late final _d_sqlite3_preupdate_hook? _h_sqlite3_preupdate_hook = _nullable(() =>
      library.lookupFunction<_c_sqlite3_preupdate_hook, _d_sqlite3_preupdate_hook>(
          'sqlite3_preupdate_hook'));

  late final _d_sqlite3_preupdate_old? _h_sqlite3_preupdate_old = _nullable(() => library
      .lookupFunction<_c_sqlite3_preupdate_old, _d_sqlite3_preupdate_old>('sqlite3_preupdate_old'));

  late final _d_sqlite3_preupdate_count? _h_sqlite3_preupdate_count = _nullable(() =>
      library.lookupFunction<_c_sqlite3_preupdate_count, _d_sqlite3_preupdate_count>(
          'sqlite3_preupdate_count'));

  late final _d_sqlite3_preupdate_depth? _h_sqlite3_preupdate_depth = _nullable(() =>
      library.lookupFunction<_c_sqlite3_preupdate_depth, _d_sqlite3_preupdate_depth>(
          'sqlite3_preupdate_depth'));

  late final _d_sqlite3_preupdate_new? _h_sqlite3_preupdate_new = _nullable(() => library
      .lookupFunction<_c_sqlite3_preupdate_new, _d_sqlite3_preupdate_new>('sqlite3_preupdate_new'));

  late final _d_sqlite3_preupdate_blobwrite? _h_sqlite3_preupdate_blobwrite = _nullable(() =>
      library.lookupFunction<_c_sqlite3_preupdate_blobwrite, _d_sqlite3_preupdate_blobwrite>(
          'sqlite3_preupdate_blobwrite'));

  late final _d_sqlite3_update_hook _h_sqlite3_update_hook =
      library.lookupFunction<_c_sqlite3_update_hook, _d_sqlite3_update_hook>('sqlite3_update_hook');

  PtrVoid? commit_hook(PtrSqlite3 arg1, PtrDefxSize ptrDefxSize, PtrVoid arg2) {
    var result = _h_sqlite3_commit_hook(arg1, ptrDefxSize, arg2);
    return result == ffi.nullptr ? null : result;
  }

  PtrVoid? rollback_hook(PtrSqlite3 arg1, PtrDefxFree ptrDefxFree, PtrVoid arg2) {
    var result = _h_sqlite3_rollback_hook(arg1, ptrDefxFree, arg2);
    return result == ffi.nullptr ? null : result;
  }

  PtrVoid preupdate_hook(PtrSqlite3 db, PtrDefxPreUpdate xPreUpdate, PtrVoid arg1) {
    if (_h_sqlite3_preupdate_hook == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_preupdate_hook is not available, You need to enable it during library build.');
    }
    return _h_sqlite3_preupdate_hook!(db, xPreUpdate, arg1);
  }

  int preupdate_old(PtrSqlite3 arg1, int arg2, PtrPtrValue arg3) {
    if (_h_sqlite3_preupdate_old == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_preupdate_old is not available, You need to enable it during library build.');
    }
    return _h_sqlite3_preupdate_old!(arg1, arg2, arg3);
  }

  int preupdate_count(PtrSqlite3 arg1) {
    if (_h_sqlite3_preupdate_count == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_preupdate_count is not available, You need to enable it during library build.');
    }
    return _h_sqlite3_preupdate_count!(arg1);
  }

  int preupdate_depth(PtrSqlite3 arg1) {
    if (_h_sqlite3_preupdate_depth == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_preupdate_depth is not available, You need to enable it during library build.');
    }
    return _h_sqlite3_preupdate_depth!(arg1);
  }

  int preupdate_new(PtrSqlite3 arg1, int arg2, PtrPtrValue arg3) {
    if (_h_sqlite3_preupdate_new == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_preupdate_new is not available, You need to enable it during library build.');
    }
    return _h_sqlite3_preupdate_new!(arg1, arg2, arg3);
  }

  int preupdate_blobwrite(PtrSqlite3 arg1) {
    if (_h_sqlite3_preupdate_blobwrite == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_preupdate_blobwrite is not available, You need to enable it during library build.');
    }
    return _h_sqlite3_preupdate_blobwrite!(arg1);
  }

  PtrVoid? update_hook(PtrSqlite3 arg1, PtrDefDefTypeGen10 ptrDefDefTypeGen10, PtrVoid arg2) {
    var result = _h_sqlite3_update_hook(arg1, ptrDefDefTypeGen10, arg2);
    return result == ffi.nullptr ? null : result;
  }
}
