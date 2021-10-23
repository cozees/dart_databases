// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

typedef _c_sqlite3_blob_bytes = Nint32 Function(PtrBlob);
typedef _d_sqlite3_blob_bytes = int Function(PtrBlob);
typedef _c_sqlite3_blob_close = Nint32 Function(PtrBlob);
typedef _d_sqlite3_blob_close = int Function(PtrBlob);
typedef _c_sqlite3_blob_open = Nint32 Function(
    PtrSqlite3, PtrString, PtrString, PtrString, Nint64, Nint32, PtrPtrBlob);
typedef _d_sqlite3_blob_open = int Function(
    PtrSqlite3, PtrString, PtrString, PtrString, int, int, PtrPtrBlob);
typedef _c_sqlite3_blob_read = Nint32 Function(PtrBlob, PtrVoid, Nint32, Nint32);
typedef _d_sqlite3_blob_read = int Function(PtrBlob, PtrVoid, int, int);
typedef _c_sqlite3_blob_reopen = Nint32 Function(PtrBlob, Nint64);
typedef _d_sqlite3_blob_reopen = int Function(PtrBlob, int);
typedef _c_sqlite3_blob_write = Nint32 Function(PtrBlob, PtrVoid, Nint32, Nint32);
typedef _d_sqlite3_blob_write = int Function(PtrBlob, PtrVoid, int, int);

// Mixin for Blob
mixin _MixinBlob on _SQLiteLibrary {
  late final _d_sqlite3_blob_bytes _h_sqlite3_blob_bytes =
      library.lookupFunction<_c_sqlite3_blob_bytes, _d_sqlite3_blob_bytes>('sqlite3_blob_bytes');

  late final _d_sqlite3_blob_close _h_sqlite3_blob_close =
      library.lookupFunction<_c_sqlite3_blob_close, _d_sqlite3_blob_close>('sqlite3_blob_close');

  late final _d_sqlite3_blob_open? _h_sqlite3_blob_open = libVersionNumber < 3004000
      ? null
      : library.lookupFunction<_c_sqlite3_blob_open, _d_sqlite3_blob_open>('sqlite3_blob_open');

  late final _d_sqlite3_blob_read _h_sqlite3_blob_read =
      library.lookupFunction<_c_sqlite3_blob_read, _d_sqlite3_blob_read>('sqlite3_blob_read');

  late final _d_sqlite3_blob_reopen? _h_sqlite3_blob_reopen = libVersionNumber < 3007004
      ? null
      : library
          .lookupFunction<_c_sqlite3_blob_reopen, _d_sqlite3_blob_reopen>('sqlite3_blob_reopen');

  late final _d_sqlite3_blob_write _h_sqlite3_blob_write =
      library.lookupFunction<_c_sqlite3_blob_write, _d_sqlite3_blob_write>('sqlite3_blob_write');

  int blob_bytes(PtrBlob arg1) {
    return _h_sqlite3_blob_bytes(arg1);
  }

  int blob_close(PtrBlob arg1) {
    return _h_sqlite3_blob_close(arg1);
  }

  int blob_open(PtrSqlite3 arg1, String zDb, String zTable, String zColumn, int iRow, int flags,
      PtrPtrBlob ppBlob) {
    if (libVersionNumber < 3004000) {
      throw dbsql.DatabaseException('API sqlite3_blob_open is not available before 3.4.0');
    }
    final zDbMeta = zDb._metaNativeUtf8();
    final ptrZDb = zDbMeta.ptr;
    final zTableMeta = zTable._metaNativeUtf8();
    final ptrZTable = zTableMeta.ptr;
    final zColumnMeta = zColumn._metaNativeUtf8();
    final ptrZColumn = zColumnMeta.ptr;
    try {
      return _h_sqlite3_blob_open!(arg1, ptrZDb, ptrZTable, ptrZColumn, iRow, flags, ppBlob);
    } finally {
      pkgffi.malloc.free(ptrZDb);
      pkgffi.malloc.free(ptrZTable);
      pkgffi.malloc.free(ptrZColumn);
    }
  }

  int blob_read(PtrBlob arg1, PtrVoid Z, int N, int iOffset) {
    return _h_sqlite3_blob_read(arg1, Z, N, iOffset);
  }

  int blob_reopen(PtrBlob arg1, int arg2) {
    if (libVersionNumber < 3007004) {
      throw dbsql.DatabaseException('API sqlite3_blob_reopen is not available before 3.7.4');
    }
    return _h_sqlite3_blob_reopen!(arg1, arg2);
  }

  int blob_write(PtrBlob arg1, PtrVoid z, int n, int iOffset) {
    return _h_sqlite3_blob_write(arg1, z, n, iOffset);
  }
}
