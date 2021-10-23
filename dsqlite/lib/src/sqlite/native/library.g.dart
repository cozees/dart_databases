// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

import 'dart:async' as _async;
import 'dart:convert' as conv;
import 'dart:ffi' as ffi;
import 'dart:io' as io;
import 'dart:typed_data' as typed;

import 'package:database_sql/database_sql.dart' as dbsql;
import 'package:dsqlite/src/sqlite/constants.g.dart' as _i1;
import 'package:ffi/ffi.dart' as pkgffi;

export 'dart:ffi'
    show
        Pointer,
        PointerPointer,
        Int8,
        Int32,
        Int32Pointer,
        Int64,
        Int64Pointer,
        Void,
        AllocatorAlloc;
export 'package:ffi/ffi.dart' show Utf8, Utf16, Utf8Pointer, Utf16Pointer, malloc;

part 'backup.g.dart';
part 'binder.g.dart';
part 'blob.g.dart';
part 'context.g.dart';
part 'database.g.dart';
part 'extension.g.dart';
part 'extra.dart';
part 'function.g.dart';
part 'hook.g.dart';
part 'reader.g.dart';
part 'resultfunction.g.dart';
part 'snapshot.g.dart';
part 'statement.g.dart';
part 'types.g.dart';
part 'utility.g.dart';

typedef NVoid = ffi.Void;
typedef PtrString = ffi.Pointer<pkgffi.Utf8>;
typedef PtrString16 = ffi.Pointer<pkgffi.Utf16>;
typedef Nint32 = ffi.Int32;
typedef Nint8 = ffi.Int8;
typedef Nuint8 = ffi.Uint8;
typedef Nint16 = ffi.Int16;
typedef Nuint16 = ffi.Uint16;
typedef Nuint32 = ffi.Uint32;
typedef Nint64 = ffi.Int64;
typedef Nuint64 = ffi.Uint64;
typedef Nfloat = ffi.Float;
typedef Ndouble = ffi.Double;
typedef PtrIoMethods = ffi.Pointer<sqlite3_io_methods>;
typedef PtrIndexConstraint = ffi.Pointer<sqlite3_index_constraint>;
typedef PtrIndexOrderby = ffi.Pointer<sqlite3_index_orderby>;
typedef PtrIndexConstraintUsage = ffi.Pointer<sqlite3_index_constraint_usage>;
typedef PtrFile = ffi.Pointer<sqlite3_file>;
typedef PtrDefxClose = ffi.Pointer<ffi.NativeFunction<DefxClose>>;
typedef PtrVoid = ffi.Pointer<ffi.Void>;
typedef PtrDefxRead = ffi.Pointer<ffi.NativeFunction<DefxRead>>;
typedef PtrDefxTruncate = ffi.Pointer<ffi.NativeFunction<DefxTruncate>>;
typedef PtrDefxSync = ffi.Pointer<ffi.NativeFunction<DefxSync>>;
typedef PtrInt64 = ffi.Pointer<ffi.Int64>;
typedef PtrDefxFileSize = ffi.Pointer<ffi.NativeFunction<DefxFileSize>>;
typedef PtrInt32 = ffi.Pointer<ffi.Int32>;
typedef PtrDefxCheckReservedLock = ffi.Pointer<ffi.NativeFunction<DefxCheckReservedLock>>;
typedef PtrDefxFileControl = ffi.Pointer<ffi.NativeFunction<DefxFileControl>>;
typedef PtrPtrVoid = ffi.Pointer<ffi.Pointer<ffi.Void>>;
typedef PtrDefxShmMap = ffi.Pointer<ffi.NativeFunction<DefxShmMap>>;
typedef PtrDefxShmLock = ffi.Pointer<ffi.NativeFunction<DefxShmLock>>;
typedef PtrDefxShmBarrier = ffi.Pointer<ffi.NativeFunction<DefxShmBarrier>>;
typedef PtrDefxFetch = ffi.Pointer<ffi.NativeFunction<DefxFetch>>;
typedef PtrDefxUnfetch = ffi.Pointer<ffi.NativeFunction<DefxUnfetch>>;
typedef PtrDefxMalloc = ffi.Pointer<ffi.NativeFunction<DefxMalloc>>;
typedef PtrDefxFree = ffi.Pointer<ffi.NativeFunction<DefxFree>>;
typedef PtrDefxRealloc = ffi.Pointer<ffi.NativeFunction<DefxRealloc>>;
typedef PtrDefxSize = ffi.Pointer<ffi.NativeFunction<DefxSize>>;
typedef PtrDefxRoundup = ffi.Pointer<ffi.NativeFunction<DefxRoundup>>;
typedef PtrSqlite3 = ffi.Pointer<sqlite3>;
typedef PtrPtrUtf8 = ffi.Pointer<ffi.Pointer<pkgffi.Utf8>>;
typedef PtrPtrVtab = ffi.Pointer<ffi.Pointer<sqlite3_vtab>>;
typedef PtrDefxCreate = ffi.Pointer<ffi.NativeFunction<DefxCreate>>;
typedef PtrVtab = ffi.Pointer<sqlite3_vtab>;
typedef PtrIndexInfo = ffi.Pointer<sqlite3_index_info>;
typedef PtrDefxBestIndex = ffi.Pointer<ffi.NativeFunction<DefxBestIndex>>;
typedef PtrDefxDisconnect = ffi.Pointer<ffi.NativeFunction<DefxDisconnect>>;
typedef PtrPtrVtabCursor = ffi.Pointer<ffi.Pointer<sqlite3_vtab_cursor>>;
typedef PtrDefxOpen = ffi.Pointer<ffi.NativeFunction<DefxOpen>>;
typedef PtrVtabCursor = ffi.Pointer<sqlite3_vtab_cursor>;
typedef PtrDefxClose1 = ffi.Pointer<ffi.NativeFunction<DefxClose1>>;
typedef PtrPtrValue = ffi.Pointer<ffi.Pointer<sqlite3_value>>;
typedef PtrDefxFilter = ffi.Pointer<ffi.NativeFunction<DefxFilter>>;
typedef PtrContext = ffi.Pointer<sqlite3_context>;
typedef PtrDefxColumn = ffi.Pointer<ffi.NativeFunction<DefxColumn>>;
typedef PtrDefxRowid = ffi.Pointer<ffi.NativeFunction<DefxRowid>>;
typedef PtrDefxUpdate = ffi.Pointer<ffi.NativeFunction<DefxUpdate>>;
typedef PtrPtrDefpxFunc = ffi.Pointer<ffi.Pointer<ffi.NativeFunction<DefpxFunc>>>;
typedef PtrDefxFindFunction = ffi.Pointer<ffi.NativeFunction<DefxFindFunction>>;
typedef PtrDefxRename = ffi.Pointer<ffi.NativeFunction<DefxRename>>;
typedef PtrDefxSavepoint = ffi.Pointer<ffi.NativeFunction<DefxSavepoint>>;
typedef PtrDefxShadowName = ffi.Pointer<ffi.NativeFunction<DefxShadowName>>;
typedef PtrDefxMutexInit = ffi.Pointer<ffi.NativeFunction<DefxMutexInit>>;
typedef PtrMutex = ffi.Pointer<sqlite3_mutex>;
typedef PtrDefxMutexAlloc = ffi.Pointer<ffi.NativeFunction<DefxMutexAlloc>>;
typedef PtrDefxMutexFree = ffi.Pointer<ffi.NativeFunction<DefxMutexFree>>;
typedef PtrDefxMutexTry = ffi.Pointer<ffi.NativeFunction<DefxMutexTry>>;
typedef PtrPcache = ffi.Pointer<sqlite3_pcache>;
typedef PtrDefxCreate2 = ffi.Pointer<ffi.NativeFunction<DefxCreate2>>;
typedef PtrDefxCachesize = ffi.Pointer<ffi.NativeFunction<DefxCachesize>>;
typedef PtrDefxPagecount = ffi.Pointer<ffi.NativeFunction<DefxPagecount>>;
typedef PtrPcachePage = ffi.Pointer<sqlite3_pcache_page>;
typedef PtrDefxFetch3 = ffi.Pointer<ffi.NativeFunction<DefxFetch3>>;
typedef PtrDefxUnpin = ffi.Pointer<ffi.NativeFunction<DefxUnpin>>;
typedef PtrDefxRekey = ffi.Pointer<ffi.NativeFunction<DefxRekey>>;
typedef PtrDefxTruncate4 = ffi.Pointer<ffi.NativeFunction<DefxTruncate4>>;
typedef PtrDefxDestroy = ffi.Pointer<ffi.NativeFunction<DefxDestroy>>;
typedef PtrSyscallPtr = ffi.Pointer<ffi.NativeFunction<sqlite3_syscall_ptr>>;
typedef PtrVfs = ffi.Pointer<sqlite3_vfs>;
typedef PtrDefxOpen5 = ffi.Pointer<ffi.NativeFunction<DefxOpen5>>;
typedef PtrDefxDelete = ffi.Pointer<ffi.NativeFunction<DefxDelete>>;
typedef PtrDefxAccess = ffi.Pointer<ffi.NativeFunction<DefxAccess>>;
typedef PtrDefxFullPathname = ffi.Pointer<ffi.NativeFunction<DefxFullPathname>>;
typedef PtrDefxDlOpen = ffi.Pointer<ffi.NativeFunction<DefxDlOpen>>;
typedef PtrDefxDlError = ffi.Pointer<ffi.NativeFunction<DefxDlError>>;
typedef PtrDefxDlSym = ffi.Pointer<ffi.NativeFunction<DefxDlSym>>;
typedef PtrDefxDlSym6 = ffi.Pointer<ffi.NativeFunction<DefxDlSym6>>;
typedef PtrDefxDlClose = ffi.Pointer<ffi.NativeFunction<DefxDlClose>>;
typedef PtrDefxRandomness = ffi.Pointer<ffi.NativeFunction<DefxRandomness>>;
typedef PtrDefxSleep = ffi.Pointer<ffi.NativeFunction<DefxSleep>>;
typedef PtrDouble = ffi.Pointer<ffi.Double>;
typedef PtrDefxCurrentTime = ffi.Pointer<ffi.NativeFunction<DefxCurrentTime>>;
typedef PtrDefxCurrentTimeInt64 = ffi.Pointer<ffi.NativeFunction<DefxCurrentTimeInt64>>;
typedef PtrDefxSetSystemCall = ffi.Pointer<ffi.NativeFunction<DefxSetSystemCall>>;
typedef PtrDefxGetSystemCall = ffi.Pointer<ffi.NativeFunction<DefxGetSystemCall>>;
typedef PtrDefxNextSystemCall = ffi.Pointer<ffi.NativeFunction<DefxNextSystemCall>>;
typedef PtrModule = ffi.Pointer<sqlite3_module>;
typedef ArrayUint8 = ffi.Array<ffi.Uint8>;
typedef PtrBackup = ffi.Pointer<sqlite3_backup>;
typedef PtrStmt = ffi.Pointer<sqlite3_stmt>;
typedef PtrValue = ffi.Pointer<sqlite3_value>;
typedef PtrBlob = ffi.Pointer<sqlite3_blob>;
typedef PtrPtrBlob = ffi.Pointer<ffi.Pointer<sqlite3_blob>>;
typedef PtrDefDefTypeGen7 = ffi.Pointer<ffi.NativeFunction<DefDefTypeGen7>>;
typedef PtrDefDefTypeGen8 = ffi.Pointer<ffi.NativeFunction<DefDefTypeGen8>>;
typedef PtrDefDefTypeGen9 = ffi.Pointer<ffi.NativeFunction<DefDefTypeGen9>>;
typedef PtrDefxCompare = ffi.Pointer<ffi.NativeFunction<DefxCompare>>;
typedef PtrDefpxFunc = ffi.Pointer<ffi.NativeFunction<DefpxFunc>>;
typedef PtrDefxFinal = ffi.Pointer<ffi.NativeFunction<DefxFinal>>;
typedef PtrDefcallback = ffi.Pointer<ffi.NativeFunction<Defcallback>>;
typedef PtrPtrPtrUtf8 = ffi.Pointer<ffi.Pointer<ffi.Pointer<pkgffi.Utf8>>>;
typedef PtrPtrSqlite3 = ffi.Pointer<ffi.Pointer<sqlite3>>;
typedef PtrPtrStmt = ffi.Pointer<ffi.Pointer<sqlite3_stmt>>;
typedef PtrDefxPreUpdate = ffi.Pointer<ffi.NativeFunction<DefxPreUpdate>>;
typedef PtrDefxTrace = ffi.Pointer<ffi.NativeFunction<DefxTrace>>;
typedef PtrDefxProfile = ffi.Pointer<ffi.NativeFunction<DefxProfile>>;
typedef PtrDefxAuth = ffi.Pointer<ffi.NativeFunction<DefxAuth>>;
typedef PtrSnapshot = ffi.Pointer<sqlite3_snapshot>;
typedef PtrPtrSnapshot = ffi.Pointer<ffi.Pointer<sqlite3_snapshot>>;
typedef PtrDefxCallback = ffi.Pointer<ffi.NativeFunction<DefxCallback>>;
typedef PtrDefxNotify = ffi.Pointer<ffi.NativeFunction<DefxNotify>>;
typedef PtrDefDefTypeGen10 = ffi.Pointer<ffi.NativeFunction<DefDefTypeGen10>>;
typedef PtrDefDefTypeGen11 = ffi.Pointer<ffi.NativeFunction<DefDefTypeGen11>>;

/// provide cross platform function to free memory.
free(ffi.Pointer ptr) => pkgffi.malloc.free(ptr);

/// alias to dart:ffi nullptr
ffi.Pointer<Never> get nullptr => ffi.nullptr;

// a common function which use to free native resource when it's no longer use.
void _sqliteDestructor(ffi.Pointer<ffi.Void> ptr) => pkgffi.malloc.free(ptr);
final _ptrDestructor =
    ffi.Pointer.fromFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>(_sqliteDestructor);

// typedef to help dynamic library lookup api for current versioning of the sqlite
typedef _DefVoidStringFunc = ffi.Pointer<pkgffi.Utf8> Function();
typedef _DefLibVersion = ffi.Int32 Function();
typedef _DefLibVersionDart = int Function();
typedef _DefSqliteFree = ffi.Void Function(ffi.Pointer<ffi.Void>);
typedef _DefSqliteFreeDart = void Function(ffi.Pointer<ffi.Void>);

// basic class that hold property need to perform interaction with SQLite
abstract class _SQLiteLibrary {
  _SQLiteLibrary(this.library);

// cannot use reference method to lookup native function.
// Must call library.lookupFunction directly.
  final ffi.DynamicLibrary library;

  late final _libVersion =
      library.lookupFunction<_DefVoidStringFunc, _DefVoidStringFunc>('sqlite3_libversion');

  late final _sourceId =
      library.lookupFunction<_DefVoidStringFunc, _DefVoidStringFunc>('sqlite3_sourceid');

  late final _libVersionNumber =
      library.lookupFunction<_DefLibVersion, _DefLibVersionDart>('sqlite3_libversion_number');

  late final _h_sqlite3_free =
      library.lookupFunction<_DefSqliteFree, _DefSqliteFreeDart>('sqlite3_free');

  /// return dynamic library version
  String get libVersion => _libVersion().toDartString();

  /// return dynamic library source id
  String get sourceId => _sourceId().toDartString();

  /// return SQLite dynamic library version as number
  int get libVersionNumber => _libVersionNumber();

  /// free resource allocated by SQLite malloc.
  void free(ffi.Pointer<ffi.Void> arg) => _h_sqlite3_free(arg);
}

/// Native binder provide a compatible method to access SQLite C APIs.
class SQLiteLibrary extends _SQLiteLibrary
    with
        _MixinBackup,
        _MixinHook,
        _MixinDatabase,
        _MixinSnapshot,
        _MixinUtility,
        _MixinContext,
        _MixinBlob,
        _MixinStatement,
        _MixinBinder,
        _MixinReader,
        _MixinResultFunction,
        _MixinFunction,
        _MixinExtra {
  SQLiteLibrary._(ffi.DynamicLibrary library) : super(library);

  static _async.Future<SQLiteLibrary> instance([String? path]) async {
    if (io.Platform.isIOS) {
      return SQLiteLibrary._(ffi.DynamicLibrary.process());
    } else if (path != null) {
      return SQLiteLibrary._(ffi.DynamicLibrary.open(path));
    } else {
      throw Exception('Platform other than iOS required explicit path to create dynamic library.');
    }
  }
}

// helper to initialize property to null if any error occurred while executing function f
// this use for the case when lookup for a C api that might be not available as the library
// itself may built without support such as APIs.
F? _nullable<F>(F Function() f) {
  try {
    return f();
  } catch (e, s) {
    return null;
  }
}
