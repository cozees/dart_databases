// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

typedef _c_sqlite3_backup_init = PtrBackup Function(PtrSqlite3, PtrString, PtrSqlite3, PtrString);
typedef _d_sqlite3_backup_init = PtrBackup Function(PtrSqlite3, PtrString, PtrSqlite3, PtrString);
typedef _c_sqlite3_backup_step = Nint32 Function(PtrBackup, Nint32);
typedef _d_sqlite3_backup_step = int Function(PtrBackup, int);
typedef _c_sqlite3_backup_finish = Nint32 Function(PtrBackup);
typedef _d_sqlite3_backup_finish = int Function(PtrBackup);
typedef _c_sqlite3_backup_remaining = Nint32 Function(PtrBackup);
typedef _d_sqlite3_backup_remaining = int Function(PtrBackup);
typedef _c_sqlite3_backup_pagecount = Nint32 Function(PtrBackup);
typedef _d_sqlite3_backup_pagecount = int Function(PtrBackup);

// Mixin for Backup
mixin _MixinBackup on _SQLiteLibrary {
  late final _d_sqlite3_backup_init _h_sqlite3_backup_init =
      library.lookupFunction<_c_sqlite3_backup_init, _d_sqlite3_backup_init>('sqlite3_backup_init');

  late final _d_sqlite3_backup_step _h_sqlite3_backup_step =
      library.lookupFunction<_c_sqlite3_backup_step, _d_sqlite3_backup_step>('sqlite3_backup_step');

  late final _d_sqlite3_backup_finish _h_sqlite3_backup_finish = library
      .lookupFunction<_c_sqlite3_backup_finish, _d_sqlite3_backup_finish>('sqlite3_backup_finish');

  late final _d_sqlite3_backup_remaining _h_sqlite3_backup_remaining =
      library.lookupFunction<_c_sqlite3_backup_remaining, _d_sqlite3_backup_remaining>(
          'sqlite3_backup_remaining');

  late final _d_sqlite3_backup_pagecount _h_sqlite3_backup_pagecount =
      library.lookupFunction<_c_sqlite3_backup_pagecount, _d_sqlite3_backup_pagecount>(
          'sqlite3_backup_pagecount');

  PtrBackup? backup_init(
      PtrSqlite3 pDest, String zDestName, PtrSqlite3 pSource, String zSourceName) {
    final zDestNameMeta = zDestName._metaNativeUtf8();
    final ptrZDestName = zDestNameMeta.ptr;
    final zSourceNameMeta = zSourceName._metaNativeUtf8();
    final ptrZSourceName = zSourceNameMeta.ptr;
    try {
      var result = _h_sqlite3_backup_init(pDest, ptrZDestName, pSource, ptrZSourceName);
      return result == ffi.nullptr ? null : result;
    } finally {
      pkgffi.malloc.free(ptrZDestName);
      pkgffi.malloc.free(ptrZSourceName);
    }
  }

  int backup_step(PtrBackup p, int nPage) {
    return _h_sqlite3_backup_step(p, nPage);
  }

  int backup_finish(PtrBackup p) {
    return _h_sqlite3_backup_finish(p);
  }

  int backup_remaining(PtrBackup p) {
    return _h_sqlite3_backup_remaining(p);
  }

  int backup_pagecount(PtrBackup p) {
    return _h_sqlite3_backup_pagecount(p);
  }
}
