// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

typedef DefxSize = Nint32 Function(PtrVoid);
typedef DartDefxSize = int Function(PtrVoid);
typedef _def_sqlite3_commit_hook = int Function(int, int, int);
typedef _def_sqlite3_rollback_hook = int Function(int, int, int);
typedef DefDefTypeGen10 = NVoid Function(PtrVoid, Nint32, PtrString, PtrString, Nint64);
typedef DartDefDefTypeGen10 = void Function(PtrVoid, int, PtrString, PtrString, int);
typedef _def_sqlite3_update_hook = int Function(int, int, int);

// Mixin for Hook
mixin _MixinHook on _SQLiteLibrary {
  late final _def_sqlite3_commit_hook _h_sqlite3_commit_hook =
      _wasm.cwrap('sqlite3_commit_hook', 'number', ['number', 'number', 'number']);

  late final _def_sqlite3_rollback_hook _h_sqlite3_rollback_hook =
      _wasm.cwrap('sqlite3_rollback_hook', 'number', ['number', 'number', 'number']);

  late final _def_sqlite3_update_hook _h_sqlite3_update_hook =
      _wasm.cwrap('sqlite3_update_hook', 'number', ['number', 'number', 'number']);

  PtrVoid? commit_hook(PtrSqlite3 arg1, PtrDefxSize ptrDefxSize, PtrVoid arg2) {
    var result = _h_sqlite3_commit_hook(arg1.address, ptrDefxSize.address, arg2.address);
    return result == 0 ? null : Pointer.fromAddress(result);
  }

  PtrVoid? rollback_hook(PtrSqlite3 arg1, PtrDefxFree ptrDefxFree, PtrVoid arg2) {
    var result = _h_sqlite3_rollback_hook(arg1.address, ptrDefxFree.address, arg2.address);
    return result == 0 ? null : Pointer.fromAddress(result);
  }

  PtrVoid? update_hook(PtrSqlite3 arg1, PtrDefDefTypeGen10 ptrDefDefTypeGen10, PtrVoid arg2) {
    var result = _h_sqlite3_update_hook(arg1.address, ptrDefDefTypeGen10.address, arg2.address);
    return result == 0 ? null : Pointer.fromAddress(result);
  }
}
