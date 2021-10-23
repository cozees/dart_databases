part of 'library.g.dart';

/// indicate that is code is currently running in vm or native-vm dart
const isNative = true;

// use internally to provide length of binary to c api
class _PtrMeta<T extends ffi.NativeType> {
  _PtrMeta(this.length, this.ptr);

  final int length;
  final ffi.Pointer<T> ptr;
}

const _version3_6_1 = 3006001;

typedef _def_db_config_1 = ffi.Int32 Function(
    PtrSqlite3, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Int32> result);
typedef _dart_def_db_config_1 = int Function(PtrSqlite3, int, int, ffi.Pointer<ffi.Int32> result);

mixin _MixinExtra on _SQLiteLibrary {
  late final _h_db_config_1 = libVersionNumber < _version3_6_1
      ? null
      : library.lookupFunction<_def_db_config_1, _dart_def_db_config_1>('sqlite3_db_config');

  int db_config(PtrSqlite3 db, int op, List<dynamic> varg) {
    switch (op) {
      case _i1.DBCONFIG_NO_CKPT_ON_CLOSE:
        checkVersion('sqlite3_db_config', '3.6.1', _version3_6_1);
        // We might not need to pass pointer however document does not mention whether we can
        // pass null pointer, see: https://www.sqlite.org/c3ref/c_dbconfig_defensive.html#sqlitedbconfiglookaside
        final change = pkgffi.malloc<ffi.Int32>();
        try {
          return _h_db_config_1!(db, op, varg.first, change);
        } finally {
          pkgffi.malloc.free(change);
        }
    }
    return _i1.ERROR;
  }

  // TODO: add sqlite3_config

  void checkVersion(String api, String version, int numVersion) {
    if (libVersionNumber < numVersion) {
      throw dbsql.DatabaseException('API $api is not available before $version');
    }
  }
}
