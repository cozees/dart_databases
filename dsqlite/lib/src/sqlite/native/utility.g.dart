// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

typedef _c_sqlite3_auto_extension = Nint32 Function(PtrSyscallPtr);
typedef _d_sqlite3_auto_extension = int Function(PtrSyscallPtr);
typedef _c_sqlite3_cancel_auto_extension = Nint32 Function(PtrSyscallPtr);
typedef _d_sqlite3_cancel_auto_extension = int Function(PtrSyscallPtr);
typedef _c_sqlite3_compileoption_used = Nint32 Function(PtrString);
typedef _d_sqlite3_compileoption_used = int Function(PtrString);
typedef _c_sqlite3_compileoption_get = PtrString Function(Nint32);
typedef _d_sqlite3_compileoption_get = PtrString Function(int);
typedef _c_sqlite3_complete = Nint32 Function(PtrString);
typedef _d_sqlite3_complete = int Function(PtrString);
typedef _c_sqlite3_complete16 = Nint32 Function(PtrVoid);
typedef _d_sqlite3_complete16 = int Function(PtrVoid);
typedef _c_sqlite3_enable_shared_cache = Nint32 Function(Nint32);
typedef _d_sqlite3_enable_shared_cache = int Function(int);
typedef _c_sqlite3_soft_heap_limit64 = Nint64 Function(Nint64);
typedef _d_sqlite3_soft_heap_limit64 = int Function(int);
typedef _c_sqlite3_hard_heap_limit64 = Nint64 Function(Nint64);
typedef _d_sqlite3_hard_heap_limit64 = int Function(int);
typedef _c_sqlite3_initialize = Nint32 Function();
typedef _d_sqlite3_initialize = int Function();
typedef _c_sqlite3_shutdown = Nint32 Function();
typedef _d_sqlite3_shutdown = int Function();
typedef _c_sqlite3_keyword_count = Nint32 Function();
typedef _d_sqlite3_keyword_count = int Function();
typedef _c_sqlite3_keyword_name = Nint32 Function(Nint32, PtrPtrUtf8, PtrInt32);
typedef _d_sqlite3_keyword_name = int Function(int, PtrPtrUtf8, PtrInt32);
typedef _c_sqlite3_keyword_check = Nint32 Function(PtrString, Nint32);
typedef _d_sqlite3_keyword_check = int Function(PtrString, int);
typedef _c_sqlite3_malloc = PtrVoid Function(Nint32);
typedef _d_sqlite3_malloc = PtrVoid Function(int);
typedef _c_sqlite3_malloc64 = PtrVoid Function(Nuint64);
typedef _d_sqlite3_malloc64 = PtrVoid Function(int);
typedef _c_sqlite3_realloc = PtrVoid Function(PtrVoid, Nint32);
typedef _d_sqlite3_realloc = PtrVoid Function(PtrVoid, int);
typedef _c_sqlite3_realloc64 = PtrVoid Function(PtrVoid, Nuint64);
typedef _d_sqlite3_realloc64 = PtrVoid Function(PtrVoid, int);
typedef _c_sqlite3_msize = Nuint64 Function(PtrVoid);
typedef _d_sqlite3_msize = int Function(PtrVoid);
typedef _c_sqlite3_memory_used = Nint64 Function();
typedef _d_sqlite3_memory_used = int Function();
typedef _c_sqlite3_memory_highwater = Nint64 Function(Nint32);
typedef _d_sqlite3_memory_highwater = int Function(int);
typedef _c_sqlite3_randomness = NVoid Function(Nint32, PtrVoid);
typedef _d_sqlite3_randomness = void Function(int, PtrVoid);
typedef _c_sqlite3_release_memory = Nint32 Function(Nint32);
typedef _d_sqlite3_release_memory = int Function(int);
typedef _c_sqlite3_reset_auto_extension = NVoid Function();
typedef _d_sqlite3_reset_auto_extension = void Function();
typedef _c_sqlite3_sleep = Nint32 Function(Nint32);
typedef _d_sqlite3_sleep = int Function(int);
typedef _c_sqlite3_status = Nint32 Function(Nint32, PtrInt32, PtrInt32, Nint32);
typedef _d_sqlite3_status = int Function(int, PtrInt32, PtrInt32, int);
typedef _c_sqlite3_status64 = Nint32 Function(Nint32, PtrInt64, PtrInt64, Nint32);
typedef _d_sqlite3_status64 = int Function(int, PtrInt64, PtrInt64, int);
typedef _c_sqlite3_strglob = Nint32 Function(PtrString, PtrString);
typedef _d_sqlite3_strglob = int Function(PtrString, PtrString);
typedef _c_sqlite3_stricmp = Nint32 Function(PtrString, PtrString);
typedef _d_sqlite3_stricmp = int Function(PtrString, PtrString);
typedef _c_sqlite3_strnicmp = Nint32 Function(PtrString, PtrString, Nint32);
typedef _d_sqlite3_strnicmp = int Function(PtrString, PtrString, int);
typedef _c_sqlite3_strlike = Nint32 Function(PtrString, PtrString, Nuint32);
typedef _d_sqlite3_strlike = int Function(PtrString, PtrString, int);
typedef _c_sqlite3_threadsafe = Nint32 Function();
typedef _d_sqlite3_threadsafe = int Function();
typedef _c_sqlite3_vfs_find = PtrVfs Function(PtrString);
typedef _d_sqlite3_vfs_find = PtrVfs Function(PtrString);
typedef _c_sqlite3_vfs_register = Nint32 Function(PtrVfs, Nint32);
typedef _d_sqlite3_vfs_register = int Function(PtrVfs, int);
typedef _c_sqlite3_vfs_unregister = Nint32 Function(PtrVfs);
typedef _d_sqlite3_vfs_unregister = int Function(PtrVfs);
typedef _c_sqlite3_win32_set_directory = Nint32 Function(Nuint64, PtrVoid);
typedef _d_sqlite3_win32_set_directory = int Function(int, PtrVoid);
typedef _c_sqlite3_win32_set_directory8 = Nint32 Function(Nuint64, PtrString);
typedef _d_sqlite3_win32_set_directory8 = int Function(int, PtrString);
typedef _c_sqlite3_win32_set_directory16 = Nint32 Function(Nuint64, PtrString16);
typedef _d_sqlite3_win32_set_directory16 = int Function(int, PtrString16);

// Mixin for Utility
mixin _MixinUtility on _SQLiteLibrary {
  late final _d_sqlite3_auto_extension? _h_sqlite3_auto_extension = libVersionNumber < 3003008
      ? null
      : library.lookupFunction<_c_sqlite3_auto_extension, _d_sqlite3_auto_extension>(
          'sqlite3_auto_extension');

  late final _d_sqlite3_cancel_auto_extension? _h_sqlite3_cancel_auto_extension = libVersionNumber <
          3008000
      ? null
      : library.lookupFunction<_c_sqlite3_cancel_auto_extension, _d_sqlite3_cancel_auto_extension>(
          'sqlite3_cancel_auto_extension');

  late final _d_sqlite3_compileoption_used? _h_sqlite3_compileoption_used =
      libVersionNumber < 3006023
          ? null
          : library.lookupFunction<_c_sqlite3_compileoption_used, _d_sqlite3_compileoption_used>(
              'sqlite3_compileoption_used');

  late final _d_sqlite3_compileoption_get? _h_sqlite3_compileoption_get = libVersionNumber < 3006023
      ? null
      : library.lookupFunction<_c_sqlite3_compileoption_get, _d_sqlite3_compileoption_get>(
          'sqlite3_compileoption_get');

  late final _d_sqlite3_complete _h_sqlite3_complete =
      library.lookupFunction<_c_sqlite3_complete, _d_sqlite3_complete>('sqlite3_complete');

  late final _d_sqlite3_complete16 _h_sqlite3_complete16 =
      library.lookupFunction<_c_sqlite3_complete16, _d_sqlite3_complete16>('sqlite3_complete16');

  late final _d_sqlite3_enable_shared_cache _h_sqlite3_enable_shared_cache =
      library.lookupFunction<_c_sqlite3_enable_shared_cache, _d_sqlite3_enable_shared_cache>(
          'sqlite3_enable_shared_cache');

  late final _d_sqlite3_soft_heap_limit64? _h_sqlite3_soft_heap_limit64 = libVersionNumber < 3007003
      ? null
      : library.lookupFunction<_c_sqlite3_soft_heap_limit64, _d_sqlite3_soft_heap_limit64>(
          'sqlite3_soft_heap_limit64');

  late final _d_sqlite3_hard_heap_limit64? _h_sqlite3_hard_heap_limit64 = libVersionNumber < 3031000
      ? null
      : library.lookupFunction<_c_sqlite3_hard_heap_limit64, _d_sqlite3_hard_heap_limit64>(
          'sqlite3_hard_heap_limit64');

  late final _d_sqlite3_initialize? _h_sqlite3_initialize = libVersionNumber < 3006000
      ? null
      : library.lookupFunction<_c_sqlite3_initialize, _d_sqlite3_initialize>('sqlite3_initialize');

  late final _d_sqlite3_shutdown? _h_sqlite3_shutdown = libVersionNumber < 3006000
      ? null
      : library.lookupFunction<_c_sqlite3_shutdown, _d_sqlite3_shutdown>('sqlite3_shutdown');

  late final _d_sqlite3_keyword_count? _h_sqlite3_keyword_count = libVersionNumber < 3024000
      ? null
      : library.lookupFunction<_c_sqlite3_keyword_count, _d_sqlite3_keyword_count>(
          'sqlite3_keyword_count');

  late final _d_sqlite3_keyword_name? _h_sqlite3_keyword_name = libVersionNumber < 3024000
      ? null
      : library
          .lookupFunction<_c_sqlite3_keyword_name, _d_sqlite3_keyword_name>('sqlite3_keyword_name');

  late final _d_sqlite3_keyword_check? _h_sqlite3_keyword_check = libVersionNumber < 3024000
      ? null
      : library.lookupFunction<_c_sqlite3_keyword_check, _d_sqlite3_keyword_check>(
          'sqlite3_keyword_check');

  late final _d_sqlite3_malloc _h_sqlite3_malloc =
      library.lookupFunction<_c_sqlite3_malloc, _d_sqlite3_malloc>('sqlite3_malloc');

  late final _d_sqlite3_malloc64? _h_sqlite3_malloc64 = libVersionNumber < 3008007
      ? null
      : library.lookupFunction<_c_sqlite3_malloc64, _d_sqlite3_malloc64>('sqlite3_malloc64');

  late final _d_sqlite3_realloc _h_sqlite3_realloc =
      library.lookupFunction<_c_sqlite3_realloc, _d_sqlite3_realloc>('sqlite3_realloc');

  late final _d_sqlite3_realloc64? _h_sqlite3_realloc64 = libVersionNumber < 3008007
      ? null
      : library.lookupFunction<_c_sqlite3_realloc64, _d_sqlite3_realloc64>('sqlite3_realloc64');

  late final _d_sqlite3_msize? _h_sqlite3_msize = libVersionNumber < 3008007
      ? null
      : library.lookupFunction<_c_sqlite3_msize, _d_sqlite3_msize>('sqlite3_msize');

  late final _d_sqlite3_memory_used _h_sqlite3_memory_used =
      library.lookupFunction<_c_sqlite3_memory_used, _d_sqlite3_memory_used>('sqlite3_memory_used');

  late final _d_sqlite3_memory_highwater _h_sqlite3_memory_highwater =
      library.lookupFunction<_c_sqlite3_memory_highwater, _d_sqlite3_memory_highwater>(
          'sqlite3_memory_highwater');

  late final _d_sqlite3_randomness _h_sqlite3_randomness =
      library.lookupFunction<_c_sqlite3_randomness, _d_sqlite3_randomness>('sqlite3_randomness');

  late final _d_sqlite3_release_memory _h_sqlite3_release_memory =
      library.lookupFunction<_c_sqlite3_release_memory, _d_sqlite3_release_memory>(
          'sqlite3_release_memory');

  late final _d_sqlite3_reset_auto_extension _h_sqlite3_reset_auto_extension =
      library.lookupFunction<_c_sqlite3_reset_auto_extension, _d_sqlite3_reset_auto_extension>(
          'sqlite3_reset_auto_extension');

  late final _d_sqlite3_sleep _h_sqlite3_sleep =
      library.lookupFunction<_c_sqlite3_sleep, _d_sqlite3_sleep>('sqlite3_sleep');

  late final _d_sqlite3_status? _h_sqlite3_status = libVersionNumber < 3006000
      ? null
      : library.lookupFunction<_c_sqlite3_status, _d_sqlite3_status>('sqlite3_status');

  late final _d_sqlite3_status64? _h_sqlite3_status64 = libVersionNumber < 3008009
      ? null
      : library.lookupFunction<_c_sqlite3_status64, _d_sqlite3_status64>('sqlite3_status64');

  late final _d_sqlite3_strglob? _h_sqlite3_strglob = libVersionNumber < 3007017
      ? null
      : library.lookupFunction<_c_sqlite3_strglob, _d_sqlite3_strglob>('sqlite3_strglob');

  late final _d_sqlite3_stricmp? _h_sqlite3_stricmp = libVersionNumber < 3007011
      ? null
      : library.lookupFunction<_c_sqlite3_stricmp, _d_sqlite3_stricmp>('sqlite3_stricmp');

  late final _d_sqlite3_strnicmp _h_sqlite3_strnicmp =
      library.lookupFunction<_c_sqlite3_strnicmp, _d_sqlite3_strnicmp>('sqlite3_strnicmp');

  late final _d_sqlite3_strlike? _h_sqlite3_strlike = libVersionNumber < 3010000
      ? null
      : library.lookupFunction<_c_sqlite3_strlike, _d_sqlite3_strlike>('sqlite3_strlike');

  late final _d_sqlite3_threadsafe _h_sqlite3_threadsafe =
      library.lookupFunction<_c_sqlite3_threadsafe, _d_sqlite3_threadsafe>('sqlite3_threadsafe');

  late final _d_sqlite3_vfs_find _h_sqlite3_vfs_find =
      library.lookupFunction<_c_sqlite3_vfs_find, _d_sqlite3_vfs_find>('sqlite3_vfs_find');

  late final _d_sqlite3_vfs_register _h_sqlite3_vfs_register = library
      .lookupFunction<_c_sqlite3_vfs_register, _d_sqlite3_vfs_register>('sqlite3_vfs_register');

  late final _d_sqlite3_vfs_unregister _h_sqlite3_vfs_unregister =
      library.lookupFunction<_c_sqlite3_vfs_unregister, _d_sqlite3_vfs_unregister>(
          'sqlite3_vfs_unregister');

  late final _d_sqlite3_win32_set_directory _h_sqlite3_win32_set_directory =
      library.lookupFunction<_c_sqlite3_win32_set_directory, _d_sqlite3_win32_set_directory>(
          'sqlite3_win32_set_directory');

  late final _d_sqlite3_win32_set_directory8 _h_sqlite3_win32_set_directory8 =
      library.lookupFunction<_c_sqlite3_win32_set_directory8, _d_sqlite3_win32_set_directory8>(
          'sqlite3_win32_set_directory8');

  late final _d_sqlite3_win32_set_directory16 _h_sqlite3_win32_set_directory16 =
      library.lookupFunction<_c_sqlite3_win32_set_directory16, _d_sqlite3_win32_set_directory16>(
          'sqlite3_win32_set_directory16');

  int auto_extension(PtrSyscallPtr xEntryPoint) {
    if (libVersionNumber < 3003008) {
      throw dbsql.DatabaseException('API sqlite3_auto_extension is not available before 3.3.8');
    }
    return _h_sqlite3_auto_extension!(xEntryPoint);
  }

  int cancel_auto_extension(PtrSyscallPtr xEntryPoint) {
    if (libVersionNumber < 3008000) {
      throw dbsql.DatabaseException(
          'API sqlite3_cancel_auto_extension is not available before 3.8.0');
    }
    return _h_sqlite3_cancel_auto_extension!(xEntryPoint);
  }

  int compileoption_used(String zOptName) {
    if (libVersionNumber < 3006023) {
      throw dbsql.DatabaseException(
          'API sqlite3_compileoption_used is not available before 3.6.23');
    }
    final zOptNameMeta = zOptName._metaNativeUtf8();
    final ptrZOptName = zOptNameMeta.ptr;
    try {
      return _h_sqlite3_compileoption_used!(ptrZOptName);
    } finally {
      pkgffi.malloc.free(ptrZOptName);
    }
  }

  String? compileoption_get(int N) {
    if (libVersionNumber < 3006023) {
      throw dbsql.DatabaseException('API sqlite3_compileoption_get is not available before 3.6.23');
    }
    PtrString result = ffi.nullptr;
    try {
      var result = _h_sqlite3_compileoption_get!(N);
      return result == ffi.nullptr ? null : result.toDartString();
    } finally {
      pkgffi.malloc.free(result);
    }
  }

  int complete(String sql) {
    final sqlMeta = sql._metaNativeUtf8();
    final ptrSql = sqlMeta.ptr;
    try {
      return _h_sqlite3_complete(ptrSql);
    } finally {
      pkgffi.malloc.free(ptrSql);
    }
  }

  int complete16(PtrVoid sql) {
    return _h_sqlite3_complete16(sql);
  }

  int enable_shared_cache(int arg1) {
    return _h_sqlite3_enable_shared_cache(arg1);
  }

  int soft_heap_limit64(int N) {
    if (libVersionNumber < 3007003) {
      throw dbsql.DatabaseException('API sqlite3_soft_heap_limit64 is not available before 3.7.3');
    }
    return _h_sqlite3_soft_heap_limit64!(N);
  }

  int hard_heap_limit64(int N) {
    if (libVersionNumber < 3031000) {
      throw dbsql.DatabaseException('API sqlite3_hard_heap_limit64 is not available before 3.31.0');
    }
    return _h_sqlite3_hard_heap_limit64!(N);
  }

  int initialize() {
    if (libVersionNumber < 3006000) {
      throw dbsql.DatabaseException('API sqlite3_initialize is not available before 3.6.0 beta');
    }
    return _h_sqlite3_initialize!();
  }

  int shutdown() {
    if (libVersionNumber < 3006000) {
      throw dbsql.DatabaseException('API sqlite3_shutdown is not available before 3.6.0 beta');
    }
    return _h_sqlite3_shutdown!();
  }

  int keyword_count() {
    if (libVersionNumber < 3024000) {
      throw dbsql.DatabaseException('API sqlite3_keyword_count is not available before 3.24.0');
    }
    return _h_sqlite3_keyword_count!();
  }

  int keyword_name(int arg1, PtrPtrUtf8 arg2, PtrInt32 arg3) {
    if (libVersionNumber < 3024000) {
      throw dbsql.DatabaseException('API sqlite3_keyword_name is not available before 3.24.0');
    }
    return _h_sqlite3_keyword_name!(arg1, arg2, arg3);
  }

  int keyword_check(String arg1) {
    if (libVersionNumber < 3024000) {
      throw dbsql.DatabaseException('API sqlite3_keyword_check is not available before 3.24.0');
    }
    final arg1Meta = arg1._metaNativeUtf8();
    final ptrArg1 = arg1Meta.ptr;
    try {
      return _h_sqlite3_keyword_check!(ptrArg1, arg1Meta.length);
    } finally {
      pkgffi.malloc.free(ptrArg1);
    }
  }

  PtrVoid? malloc(int arg1) {
    var result = _h_sqlite3_malloc(arg1);
    return result == ffi.nullptr ? null : result;
  }

  PtrVoid? malloc64(int arg1) {
    if (libVersionNumber < 3008007) {
      throw dbsql.DatabaseException('API sqlite3_malloc64 is not available before 3.8.7');
    }
    var result = _h_sqlite3_malloc64!(arg1);
    return result == ffi.nullptr ? null : result;
  }

  PtrVoid? realloc(PtrVoid arg1, int arg2) {
    var result = _h_sqlite3_realloc(arg1, arg2);
    return result == ffi.nullptr ? null : result;
  }

  PtrVoid? realloc64(PtrVoid arg1, int arg2) {
    if (libVersionNumber < 3008007) {
      throw dbsql.DatabaseException('API sqlite3_realloc64 is not available before 3.8.7');
    }
    var result = _h_sqlite3_realloc64!(arg1, arg2);
    return result == ffi.nullptr ? null : result;
  }

  int msize(PtrVoid arg1) {
    if (libVersionNumber < 3008007) {
      throw dbsql.DatabaseException('API sqlite3_msize is not available before 3.8.7');
    }
    return _h_sqlite3_msize!(arg1);
  }

  int memory_used() {
    return _h_sqlite3_memory_used();
  }

  int memory_highwater(int resetFlag) {
    return _h_sqlite3_memory_highwater(resetFlag);
  }

  void randomness(int N, PtrVoid P) {
    return _h_sqlite3_randomness(N, P);
  }

  int release_memory(int arg1) {
    return _h_sqlite3_release_memory(arg1);
  }

  void reset_auto_extension() {
    return _h_sqlite3_reset_auto_extension();
  }

  int sleep(int arg1) {
    return _h_sqlite3_sleep(arg1);
  }

  int status(int op, PtrInt32 pCurrent, PtrInt32 pHighwater, int resetFlag) {
    if (libVersionNumber < 3006000) {
      throw dbsql.DatabaseException('API sqlite3_status is not available before 3.6.0 beta');
    }
    return _h_sqlite3_status!(op, pCurrent, pHighwater, resetFlag);
  }

  int status64(int op, PtrInt64 pCurrent, PtrInt64 pHighwater, int resetFlag) {
    if (libVersionNumber < 3008009) {
      throw dbsql.DatabaseException('API sqlite3_status64 is not available before 3.8.9');
    }
    return _h_sqlite3_status64!(op, pCurrent, pHighwater, resetFlag);
  }

  int strglob(String zGlob, String zStr) {
    if (libVersionNumber < 3007017) {
      throw dbsql.DatabaseException('API sqlite3_strglob is not available before 3.7.17');
    }
    final zGlobMeta = zGlob._metaNativeUtf8();
    final ptrZGlob = zGlobMeta.ptr;
    final zStrMeta = zStr._metaNativeUtf8();
    final ptrZStr = zStrMeta.ptr;
    try {
      return _h_sqlite3_strglob!(ptrZGlob, ptrZStr);
    } finally {
      pkgffi.malloc.free(ptrZGlob);
      pkgffi.malloc.free(ptrZStr);
    }
  }

  int stricmp(String arg1, String arg2) {
    if (libVersionNumber < 3007011) {
      throw dbsql.DatabaseException('API sqlite3_stricmp is not available before 3.7.11');
    }
    final arg1Meta = arg1._metaNativeUtf8();
    final ptrArg1 = arg1Meta.ptr;
    final arg2Meta = arg2._metaNativeUtf8();
    final ptrArg2 = arg2Meta.ptr;
    try {
      return _h_sqlite3_stricmp!(ptrArg1, ptrArg2);
    } finally {
      pkgffi.malloc.free(ptrArg1);
      pkgffi.malloc.free(ptrArg2);
    }
  }

  int strnicmp(String arg1, String arg2, int arg3) {
    final arg1Meta = arg1._metaNativeUtf8();
    final ptrArg1 = arg1Meta.ptr;
    final arg2Meta = arg2._metaNativeUtf8();
    final ptrArg2 = arg2Meta.ptr;
    try {
      return _h_sqlite3_strnicmp(ptrArg1, ptrArg2, arg3);
    } finally {
      pkgffi.malloc.free(ptrArg1);
      pkgffi.malloc.free(ptrArg2);
    }
  }

  int strlike(String zGlob, String zStr, int cEsc) {
    if (libVersionNumber < 3010000) {
      throw dbsql.DatabaseException('API sqlite3_strlike is not available before 3.10.0');
    }
    final zGlobMeta = zGlob._metaNativeUtf8();
    final ptrZGlob = zGlobMeta.ptr;
    final zStrMeta = zStr._metaNativeUtf8();
    final ptrZStr = zStrMeta.ptr;
    try {
      return _h_sqlite3_strlike!(ptrZGlob, ptrZStr, cEsc);
    } finally {
      pkgffi.malloc.free(ptrZGlob);
      pkgffi.malloc.free(ptrZStr);
    }
  }

  int threadsafe() {
    return _h_sqlite3_threadsafe();
  }

  PtrVfs? vfs_find(String? zVfsName) {
    final zVfsNameMeta = zVfsName?._metaNativeUtf8();
    final ptrZVfsName = zVfsNameMeta?.ptr ?? ffi.nullptr;
    try {
      var result = _h_sqlite3_vfs_find(ptrZVfsName);
      return result == ffi.nullptr ? null : result;
    } finally {
      pkgffi.malloc.free(ptrZVfsName);
    }
  }

  int vfs_register(PtrVfs arg1, int makeDflt) {
    return _h_sqlite3_vfs_register(arg1, makeDflt);
  }

  int vfs_unregister(PtrVfs arg1) {
    return _h_sqlite3_vfs_unregister(arg1);
  }

  int win32_set_directory(int arg1, PtrVoid zValue) {
    return _h_sqlite3_win32_set_directory(arg1, zValue);
  }

  int win32_set_directory8(int arg1, String? zValue) {
    final zValueMeta = zValue?._metaNativeUtf8();
    final ptrZValue = zValueMeta?.ptr ?? ffi.nullptr;
    try {
      return _h_sqlite3_win32_set_directory8(arg1, ptrZValue);
    } finally {
      pkgffi.malloc.free(ptrZValue);
    }
  }

  int win32_set_directory16(int arg1, String? zValue) {
    final zValueMeta = zValue?._metaNativeUtf16();
    final ptrZValue = zValueMeta?.ptr ?? ffi.nullptr;
    try {
      return _h_sqlite3_win32_set_directory16(arg1, ptrZValue);
    } finally {
      pkgffi.malloc.free(ptrZValue);
    }
  }
}
