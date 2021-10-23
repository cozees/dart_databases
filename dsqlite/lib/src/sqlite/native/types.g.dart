// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

// ****************************************** sqlite3 ******************************************

/// Each open SQLite database is represented by a pointer to an instance of the opaque structure named
/// "sqlite3".
///
/// It is useful to think of an sqlite3 pointer as an object. The [sqlite3_open()](https://www.sqlite.org/capi3ref.html#sqlite3_open),
/// [sqlite3_open16()](https://www.sqlite.org/capi3ref.html#sqlite3_open), and [sqlite3\_open\_v2()](https://www.sqlite.org/capi3ref.html#sqlite3_open)
/// interfaces are its constructors, and [sqlite3_close()](https://www.sqlite.org/capi3ref.html#sqlite3_close)
/// and [sqlite3\_close\_v2()](https://www.sqlite.org/capi3ref.html#sqlite3_close) are its destructors.
/// There are many other interfaces (such as [sqlite3\_prepare\_v2()](https://www.sqlite.org/capi3ref.html#sqlite3_prepare),
/// [sqlite3\_create\_function()](https://www.sqlite.org/capi3ref.html#sqlite3_create_function), and
/// [sqlite3\_busy\_timeout()](https://www.sqlite.org/capi3ref.html#sqlite3_busy_timeout) to name but
/// three) that are methods on an sqlite3 object.
class sqlite3 extends ffi.Opaque {}

// *********************************** sqlite3_api_routines ***********************************

/// A pointer to the opaque sqlite3\_api\_routines structure is passed as the third parameter to entry
/// points of [loadable extensions](https://www.sqlite.org/capi3ref.htmlloadext.html).
///
/// This structure must be typedefed in order to work around compiler warnings on some platforms.
class sqlite3_api_routines extends ffi.Opaque {}

// ************************************** sqlite3_backup **************************************

/// The sqlite3\_backup object records state information about an ongoing online backup operation.
///
/// The sqlite3\_backup object is created by a call to [sqlite3\_backup\_init()](https://www.sqlite.org/capi3ref.html#sqlite3backupinit)
/// and is destroyed by a call to [sqlite3\_backup\_finish()](https://www.sqlite.org/capi3ref.html#sqlite3backupfinish). See
/// Also: [Using the SQLite Online Backup API](https://www.sqlite.org/capi3ref.htmlbackup.html)
class sqlite3_backup extends ffi.Opaque {}

// *************************************** sqlite3_blob ***************************************

/// An instance of this object represents an open BLOB on which [incremental BLOB I/O](https://www.sqlite.org/capi3ref.html#sqlite3_blob_open)
/// can be performed.
///
/// Objects of this type are created by [sqlite3\_blob\_open()](https://www.sqlite.org/capi3ref.html#sqlite3_blob_open)
/// and destroyed by [sqlite3\_blob\_close()](https://www.sqlite.org/capi3ref.html#sqlite3_blob_close).
/// The [sqlite3\_blob\_read()](https://www.sqlite.org/capi3ref.html#sqlite3_blob_read) and [sqlite3\_blob\_write()](https://www.sqlite.org/capi3ref.html#sqlite3_blob_write)
/// interfaces can be used to read or write small subsections of the BLOB. The [sqlite3\_blob\_bytes()](https://www.sqlite.org/capi3ref.html#sqlite3_blob_bytes)
/// interface returns the size of the BLOB in bytes. 1 Constructor: [sqlite3\_blob\_open()](https://www.sqlite.org/capi3ref.html#sqlite3_blob_open) 1
/// Destructor: [sqlite3\_blob\_close()](https://www.sqlite.org/capi3ref.html#sqlite3_blob_close)
class sqlite3_blob extends ffi.Opaque {}

// ************************************** sqlite3_context **************************************

/// The context in which an SQL function executes is stored in an sqlite3\_context object.
///
/// A pointer to an sqlite3\_context object is always first parameter to [application-defined SQL functions](https://www.sqlite.org/capi3ref.htmlappfunc.html).
/// The application-defined SQL function implementation will pass this pointer through into calls to
/// [sqlite3_result()](https://www.sqlite.org/capi3ref.html#sqlite3_result_blob), [sqlite3\_aggregate\_context()](https://www.sqlite.org/capi3ref.html#sqlite3_aggregate_context),
/// [sqlite3\_user\_data()](https://www.sqlite.org/capi3ref.html#sqlite3_user_data), [sqlite3\_context\_db_handle()](https://www.sqlite.org/capi3ref.html#sqlite3_context_db_handle),
/// [sqlite3\_get\_auxdata()](https://www.sqlite.org/capi3ref.html#sqlite3_get_auxdata), and/or [sqlite3\_set\_auxdata()](https://www.sqlite.org/capi3ref.html#sqlite3_get_auxdata).
class sqlite3_context extends ffi.Opaque {}

// *************************************** sqlite3_file ***************************************

/// An [sqlite3_file](https://www.sqlite.org/capi3ref.html#sqlite3_file) object represents an open file
/// in the [OS interface layer](https://www.sqlite.org/capi3ref.html#sqlite3_vfs).
///
/// Individual OS interface implementations will want to subclass this object by appending additional
/// fields for their own use. The pMethods entry is a pointer to an [sqlite3\_io\_methods](https://www.sqlite.org/capi3ref.html#sqlite3_io_methods)
/// object that defines methods for performing I/O operations on the open file.
class sqlite3_file extends ffi.Struct {
  external PtrIoMethods pMethods;
}

// ************************************ sqlite3_index_info ************************************

class sqlite3_index_constraint extends ffi.Struct {
  @ffi.Int32()
  external int iColumn;

  @ffi.Uint8()
  external int op;

  @ffi.Uint8()
  external int usable;

  @ffi.Int32()
  external int iTermOffset;
}

class sqlite3_index_orderby extends ffi.Struct {
  @ffi.Int32()
  external int iColumn;

  @ffi.Uint8()
  external int desc;
}

class sqlite3_index_constraint_usage extends ffi.Struct {
  @ffi.Int32()
  external int argvIndex;

  @ffi.Uint8()
  external int omit;
}

/// The sqlite3\_index\_info structure and its substructures is used as part of the [virtual table](https://www.sqlite.org/capi3ref.htmlvtab.html)
/// interface to pass information into and receive the reply from the [xBestIndex](https://www.sqlite.org/capi3ref.htmlvtab.html#xbestindex)
/// method of a [virtual table module](https://www.sqlite.org/capi3ref.html#sqlite3_module).
///
/// The fields under \*\*Inputs\*\* are the inputs to xBestIndex and are read-only. xBestIndex inserts
/// its results into the \*\*Outputs\*\* fields. The aConstraint\[\] array records WHERE clause constraints
/// of the form:
class sqlite3_index_info extends ffi.Struct {
  @ffi.Int32()
  external int nConstraint;

  external PtrIndexConstraint aConstraint;

  @ffi.Int32()
  external int nOrderBy;

  external PtrIndexOrderby aOrderBy;

  external PtrIndexConstraintUsage aConstraintUsage;

  @ffi.Int32()
  external int idxNum;

  external PtrString idxStr;

  @ffi.Int32()
  external int needToFreeIdxStr;

  @ffi.Int32()
  external int orderByConsumed;

  @ffi.Double()
  external double estimatedCost;

  @ffi.Int64()
  external int estimatedRows;

  @ffi.Int32()
  external int idxFlags;

  @ffi.Uint64()
  external int colUsed;
}

// ************************************ sqlite3_io_methods ************************************

typedef DefxClose = ffi.Int32 Function(PtrFile);
typedef DartDefxClose = int Function(PtrFile);
typedef DefxRead = ffi.Int32 Function(PtrFile, PtrVoid, ffi.Int32, ffi.Int64);
typedef DartDefxRead = int Function(PtrFile, PtrVoid, int, int);
typedef DefxTruncate = ffi.Int32 Function(PtrFile, ffi.Int64);
typedef DartDefxTruncate = int Function(PtrFile, int);
typedef DefxSync = ffi.Int32 Function(PtrFile, ffi.Int32);
typedef DartDefxSync = int Function(PtrFile, int);
typedef DefxFileSize = ffi.Int32 Function(PtrFile, PtrInt64);
typedef DartDefxFileSize = int Function(PtrFile, PtrInt64);
typedef DefxCheckReservedLock = ffi.Int32 Function(PtrFile, PtrInt32);
typedef DartDefxCheckReservedLock = int Function(PtrFile, PtrInt32);
typedef DefxFileControl = ffi.Int32 Function(PtrFile, ffi.Int32, PtrVoid);
typedef DartDefxFileControl = int Function(PtrFile, int, PtrVoid);
typedef DefxShmMap = ffi.Int32 Function(PtrFile, ffi.Int32, ffi.Int32, ffi.Int32, PtrPtrVoid);
typedef DartDefxShmMap = int Function(PtrFile, int, int, int, PtrPtrVoid);
typedef DefxShmLock = ffi.Int32 Function(PtrFile, ffi.Int32, ffi.Int32, ffi.Int32);
typedef DartDefxShmLock = int Function(PtrFile, int, int, int);
typedef DefxShmBarrier = ffi.Void Function(PtrFile);
typedef DartDefxShmBarrier = void Function(PtrFile);
typedef DefxFetch = ffi.Int32 Function(PtrFile, ffi.Int64, ffi.Int32, PtrPtrVoid);
typedef DartDefxFetch = int Function(PtrFile, int, int, PtrPtrVoid);
typedef DefxUnfetch = ffi.Int32 Function(PtrFile, ffi.Int64, PtrVoid);
typedef DartDefxUnfetch = int Function(PtrFile, int, PtrVoid);

/// Every file opened by the [sqlite3_vfs.xOpen](https://www.sqlite.org/capi3ref.html#sqlite3vfsxopen)
/// method populates an [sqlite3_file](https://www.sqlite.org/capi3ref.html#sqlite3_file) object (or,
/// more commonly, a subclass of the [sqlite3_file](https://www.sqlite.org/capi3ref.html#sqlite3_file)
/// object) with a pointer to an instance of this object.
///
/// This object defines the methods used to perform various operations against the open file represented
/// by the [sqlite3_file](https://www.sqlite.org/capi3ref.html#sqlite3_file) object. If the [sqlite3_vfs.xOpen](https://www.sqlite.org/capi3ref.html#sqlite3vfsxopen)
/// method sets the sqlite3\_file.pMethods element to a non-NULL pointer, then the sqlite3\_io_methods.xClose
/// method may be invoked even if the [sqlite3_vfs.xOpen](https://www.sqlite.org/capi3ref.html#sqlite3vfsxopen)
/// reported that it failed. The only way to prevent a call to xClose following a failed [sqlite3_vfs.xOpen](https://www.sqlite.org/capi3ref.html#sqlite3vfsxopen)
/// is for the [sqlite3_vfs.xOpen](https://www.sqlite.org/capi3ref.html#sqlite3vfsxopen) to set the sqlite3_file.pMethods
/// element to NULL. The flags argument to xSync may be one of [SQLITE\_SYNC\_NORMAL](https://www.sqlite.org/capi3ref.html#SQLITE_SYNC_DATAONLY)
/// or [SQLITE\_SYNC\_FULL](https://www.sqlite.org/capi3ref.html#SQLITE_SYNC_DATAONLY). The first choice
/// is the normal fsync(). The second choice is a Mac OS X style fullsync. The [SQLITE\_SYNC\_DATAONLY](https://www.sqlite.org/capi3ref.html#SQLITE_SYNC_DATAONLY)
/// flag may be ORed in to indicate that only the data of the file and not its inode needs to be synced. The
/// integer values to xLock() and xUnlock() are one of
class sqlite3_io_methods extends ffi.Struct {
  @ffi.Int32()
  external int iVersion;

  external PtrDefxClose xClose;

  external PtrDefxRead xRead;

  external PtrDefxRead xWrite;

  external PtrDefxTruncate xTruncate;

  external PtrDefxSync xSync;

  external PtrDefxFileSize xFileSize;

  external PtrDefxSync xLock;

  external PtrDefxSync xUnlock;

  external PtrDefxCheckReservedLock xCheckReservedLock;

  external PtrDefxFileControl xFileControl;

  external PtrDefxClose xSectorSize;

  external PtrDefxClose xDeviceCharacteristics;

  external PtrDefxShmMap xShmMap;

  external PtrDefxShmLock xShmLock;

  external PtrDefxShmBarrier xShmBarrier;

  external PtrDefxSync xShmUnmap;

  external PtrDefxFetch xFetch;

  external PtrDefxUnfetch xUnfetch;
}

// ************************************ sqlite3_mem_methods ************************************

typedef DefxMalloc = PtrVoid Function(ffi.Int32);
typedef DartDefxMalloc = PtrVoid Function(int);
typedef DefxFree = ffi.Void Function(PtrVoid);
typedef DartDefxFree = void Function(PtrVoid);
typedef DefxRealloc = PtrVoid Function(PtrVoid, ffi.Int32);
typedef DartDefxRealloc = PtrVoid Function(PtrVoid, int);
typedef DefxSize = ffi.Int32 Function(PtrVoid);
typedef DartDefxSize = int Function(PtrVoid);
typedef DefxRoundup = ffi.Int32 Function(ffi.Int32);
typedef DartDefxRoundup = int Function(int);

/// An instance of this object defines the interface between SQLite and low-level memory allocation routines. This
/// object is used in only one place in the SQLite interface.
///
/// A pointer to an instance of this object is the argument to [sqlite3_config()](https://www.sqlite.org/capi3ref.html#sqlite3_config)
/// when the configuration option is [SQLITE\_CONFIG\_MALLOC](https://www.sqlite.org/capi3ref.html#sqliteconfigmalloc)
/// or [SQLITE\_CONFIG\_GETMALLOC](https://www.sqlite.org/capi3ref.html#sqliteconfiggetmalloc). By creating
/// an instance of this object and passing it to [sqlite3_config](https://www.sqlite.org/capi3ref.html#sqlite3_config)([SQLITE\_CONFIG\_MALLOC](https://www.sqlite.org/capi3ref.html#sqliteconfigmalloc))
/// during configuration, an application can specify an alternative memory allocation subsystem for SQLite
/// to use for all of its dynamic memory needs. Note that SQLite comes with several [built-in memory allocators](https://www.sqlite.org/capi3ref.htmlmalloc.html#altalloc)
/// that are perfectly adequate for the overwhelming majority of applications and that this object is
/// only useful to a tiny minority of applications with specialized memory allocation requirements. This
/// object is also used during testing of SQLite in order to specify an alternative memory allocator
/// that simulates memory out-of-memory conditions in order to verify that SQLite recovers gracefully
/// from such conditions. The xMalloc, xRealloc, and xFree methods must work like the malloc(), realloc()
/// and free() functions from the standard C library. SQLite guarantees that the second argument to xRealloc
/// is always a value returned by a prior call to xRoundup. xSize should return the allocated size of
/// a memory allocation previously obtained from xMalloc or xRealloc. The allocated size is always at
/// least as big as the requested size but may be larger. The xRoundup method returns what would be the
/// allocated size of a memory allocation given a particular requested size. Most memory allocators round
/// up memory allocations at least to the next multiple of 8. Some allocators round up to a larger multiple
/// or to a power of 2. Every memory allocation request coming in through [sqlite3_malloc()](https://www.sqlite.org/capi3ref.html#sqlite3_free)
/// or [sqlite3_realloc()](https://www.sqlite.org/capi3ref.html#sqlite3_free) first calls xRoundup. If
/// xRoundup returns 0, that causes the corresponding memory allocation to fail. The xInit method initializes
/// the memory allocator. For example, it might allocate any required mutexes or initialize internal
/// data structures. The xShutdown method is invoked (indirectly) by [sqlite3_shutdown()](https://www.sqlite.org/capi3ref.html#sqlite3_initialize)
/// and should deallocate any resources acquired by xInit. The pAppData pointer is used as the only parameter
/// to xInit and xShutdown. SQLite holds the [SQLITE\_MUTEX\_STATIC_MAIN](https://www.sqlite.org/capi3ref.html#SQLITE_MUTEX_FAST)
/// mutex when it invokes the xInit method, so the xInit method need not be threadsafe. The xShutdown
/// method is only called from [sqlite3_shutdown()](https://www.sqlite.org/capi3ref.html#sqlite3_initialize)
/// so it does not need to be threadsafe either. For all other methods, SQLite holds the [SQLITE\_MUTEX\_STATIC_MEM](https://www.sqlite.org/capi3ref.html#SQLITE_MUTEX_FAST)
/// mutex as long as the [SQLITE\_CONFIG\_MEMSTATUS](https://www.sqlite.org/capi3ref.html#sqliteconfigmemstatus)
/// configuration option is turned on (which it is by default) and so the methods are automatically serialized.
/// However, if [SQLITE\_CONFIG\_MEMSTATUS](https://www.sqlite.org/capi3ref.html#sqliteconfigmemstatus)
/// is disabled, then the other methods must be threadsafe or else make their own arrangements for serialization. SQLite
/// will never invoke xInit() more than once without an intervening call to xShutdown().
class sqlite3_mem_methods extends ffi.Struct {
  external PtrDefxMalloc xMalloc;

  external PtrDefxFree xFree;

  external PtrDefxRealloc xRealloc;

  external PtrDefxSize xSize;

  external PtrDefxRoundup xRoundup;

  external PtrDefxSize xInit;

  external PtrDefxFree xShutdown;

  external PtrVoid pAppData;
}

// ************************************** sqlite3_module **************************************

typedef DefxCreate = ffi.Int32 Function(
    PtrSqlite3, PtrVoid, ffi.Int32, PtrPtrUtf8, PtrPtrVtab, PtrPtrUtf8);
typedef DartDefxCreate = int Function(PtrSqlite3, PtrVoid, int, PtrPtrUtf8, PtrPtrVtab, PtrPtrUtf8);
typedef DefxBestIndex = ffi.Int32 Function(PtrVtab, PtrIndexInfo);
typedef DartDefxBestIndex = int Function(PtrVtab, PtrIndexInfo);
typedef DefxDisconnect = ffi.Int32 Function(PtrVtab);
typedef DartDefxDisconnect = int Function(PtrVtab);
typedef DefxOpen = ffi.Int32 Function(PtrVtab, PtrPtrVtabCursor);
typedef DartDefxOpen = int Function(PtrVtab, PtrPtrVtabCursor);
typedef DefxClose1 = ffi.Int32 Function(PtrVtabCursor);
typedef DartDefxClose1 = int Function(PtrVtabCursor);
typedef DefxFilter = ffi.Int32 Function(
    PtrVtabCursor, ffi.Int32, PtrString, ffi.Int32, PtrPtrValue);
typedef DartDefxFilter = int Function(PtrVtabCursor, int, PtrString, int, PtrPtrValue);
typedef DefxColumn = ffi.Int32 Function(PtrVtabCursor, PtrContext, ffi.Int32);
typedef DartDefxColumn = int Function(PtrVtabCursor, PtrContext, int);
typedef DefxRowid = ffi.Int32 Function(PtrVtabCursor, PtrInt64);
typedef DartDefxRowid = int Function(PtrVtabCursor, PtrInt64);
typedef DefxUpdate = ffi.Int32 Function(PtrVtab, ffi.Int32, PtrPtrValue, PtrInt64);
typedef DartDefxUpdate = int Function(PtrVtab, int, PtrPtrValue, PtrInt64);
typedef DefpxFunc = ffi.Void Function(PtrContext, ffi.Int32, PtrPtrValue);
typedef DartDefpxFunc = void Function(PtrContext, int, PtrPtrValue);
typedef DefxFindFunction = ffi.Int32 Function(
    PtrVtab, ffi.Int32, PtrString, PtrPtrDefpxFunc, PtrPtrVoid);
typedef DartDefxFindFunction = int Function(PtrVtab, int, PtrString, PtrPtrDefpxFunc, PtrPtrVoid);
typedef DefxRename = ffi.Int32 Function(PtrVtab, PtrString);
typedef DartDefxRename = int Function(PtrVtab, PtrString);
typedef DefxSavepoint = ffi.Int32 Function(PtrVtab, ffi.Int32);
typedef DartDefxSavepoint = int Function(PtrVtab, int);
typedef DefxShadowName = ffi.Int32 Function(PtrString);
typedef DartDefxShadowName = int Function(PtrString);

/// This structure, sometimes called a "virtual table module", defines the implementation of a [virtual
/// table](https://www.sqlite.org/capi3ref.htmlvtab.html).
///
/// This structure consists mostly of methods for the module. A virtual table module is created by filling
/// in a persistent instance of this structure and passing a pointer to that instance to [sqlite3\_create\_module()](https://www.sqlite.org/capi3ref.html#sqlite3_create_module)
/// or [sqlite3\_create\_module_v2()](https://www.sqlite.org/capi3ref.html#sqlite3_create_module). The
/// registration remains valid until it is replaced by a different module or until the [database connection](https://www.sqlite.org/capi3ref.html#sqlite3)
/// closes. The content of this structure must not change while it is registered with any database connection.
class sqlite3_module extends ffi.Struct {
  @ffi.Int32()
  external int iVersion;

  external PtrDefxCreate xCreate;

  external PtrDefxCreate xConnect;

  external PtrDefxBestIndex xBestIndex;

  external PtrDefxDisconnect xDisconnect;

  external PtrDefxDisconnect xDestroy;

  external PtrDefxOpen xOpen;

  external PtrDefxClose1 xClose;

  external PtrDefxFilter xFilter;

  external PtrDefxClose1 xNext;

  external PtrDefxClose1 xEof;

  external PtrDefxColumn xColumn;

  external PtrDefxRowid xRowid;

  external PtrDefxUpdate xUpdate;

  external PtrDefxDisconnect xBegin;

  external PtrDefxDisconnect xSync;

  external PtrDefxDisconnect xCommit;

  external PtrDefxDisconnect xRollback;

  external PtrDefxFindFunction xFindFunction;

  external PtrDefxRename xRename;

  external PtrDefxSavepoint xSavepoint;

  external PtrDefxSavepoint xRelease;

  external PtrDefxSavepoint xRollbackTo;

  external PtrDefxShadowName xShadowName;
}

// *************************************** sqlite3_mutex ***************************************

/// The mutex module within SQLite defines [sqlite3_mutex](https://www.sqlite.org/capi3ref.html#sqlite3_mutex)
/// to be an abstract type for a mutex object.
///
/// The SQLite core never looks at the internal representation of an [sqlite3_mutex](https://www.sqlite.org/capi3ref.html#sqlite3_mutex).
/// It only deals with pointers to the [sqlite3_mutex](https://www.sqlite.org/capi3ref.html#sqlite3_mutex)
/// object. Mutexes are created using [sqlite3\_mutex\_alloc()](https://www.sqlite.org/capi3ref.html#sqlite3_mutex_alloc).
class sqlite3_mutex extends ffi.Opaque {}

// *********************************** sqlite3_mutex_methods ***********************************

typedef DefxMutexInit = ffi.Int32 Function();
typedef DartDefxMutexInit = int Function();
typedef DefxMutexAlloc = PtrMutex Function(ffi.Int32);
typedef DartDefxMutexAlloc = PtrMutex Function(int);
typedef DefxMutexFree = ffi.Void Function(PtrMutex);
typedef DartDefxMutexFree = void Function(PtrMutex);
typedef DefxMutexTry = ffi.Int32 Function(PtrMutex);
typedef DartDefxMutexTry = int Function(PtrMutex);

/// An instance of this structure defines the low-level routines used to allocate and use mutexes. Usually,
/// the default mutex implementations provided by SQLite are sufficient, however the application has
/// the option of substituting a custom implementation for specialized deployments or systems for which
/// SQLite does not provide a suitable implementation.
///
/// In this case, the application creates and populates an instance of this structure to pass to sqlite3_config()
/// along with the [SQLITE\_CONFIG\_MUTEX](https://www.sqlite.org/capi3ref.html#sqliteconfigmutex) option.
/// Additionally, an instance of this structure can be used as an output variable when querying the system
/// for the current mutex implementation, using the [SQLITE\_CONFIG\_GETMUTEX](https://www.sqlite.org/capi3ref.html#sqliteconfiggetmutex)
/// option. The xMutexInit method defined by this structure is invoked as part of system initialization
/// by the sqlite3_initialize() function. The xMutexInit routine is called by SQLite exactly once for
/// each effective call to [sqlite3_initialize()](https://www.sqlite.org/capi3ref.html#sqlite3_initialize). The
/// xMutexEnd method defined by this structure is invoked as part of system shutdown by the sqlite3_shutdown()
/// function. The implementation of this method is expected to release all outstanding resources obtained
/// by the mutex methods implementation, especially those obtained by the xMutexInit method. The xMutexEnd()
/// interface is invoked exactly once for each call to [sqlite3_shutdown()](https://www.sqlite.org/capi3ref.html#sqlite3_initialize). The
/// remaining seven methods defined by this structure (xMutexAlloc, xMutexFree, xMutexEnter, xMutexTry,
/// xMutexLeave, xMutexHeld and xMutexNotheld) implement the following interfaces (respectively):
class sqlite3_mutex_methods extends ffi.Struct {
  external PtrDefxMutexInit xMutexInit;

  external PtrDefxMutexInit xMutexEnd;

  external PtrDefxMutexAlloc xMutexAlloc;

  external PtrDefxMutexFree xMutexFree;

  external PtrDefxMutexFree xMutexEnter;

  external PtrDefxMutexTry xMutexTry;

  external PtrDefxMutexFree xMutexLeave;

  external PtrDefxMutexTry xMutexHeld;

  external PtrDefxMutexTry xMutexNotheld;
}

// ************************************** sqlite3_pcache **************************************

/// The sqlite3\_pcache type is opaque.
///
/// It is implemented by the pluggable module. The SQLite core has no knowledge of its size or internal
/// structure and never deals with the sqlite3\_pcache object except by holding and passing pointers
/// to the object. See [sqlite3\_pcache\_methods2](https://www.sqlite.org/capi3ref.html#sqlite3_pcache_methods2)
/// for additional information.
class sqlite3_pcache extends ffi.Opaque {}

// ********************************** sqlite3_pcache_methods2 **********************************

typedef DefxCreate2 = PtrPcache Function(ffi.Int32, ffi.Int32, ffi.Int32);
typedef DartDefxCreate2 = PtrPcache Function(int, int, int);
typedef DefxCachesize = ffi.Void Function(PtrPcache, ffi.Int32);
typedef DartDefxCachesize = void Function(PtrPcache, int);
typedef DefxPagecount = ffi.Int32 Function(PtrPcache);
typedef DartDefxPagecount = int Function(PtrPcache);
typedef DefxFetch3 = PtrPcachePage Function(PtrPcache, ffi.Uint32, ffi.Int32);
typedef DartDefxFetch3 = PtrPcachePage Function(PtrPcache, int, int);
typedef DefxUnpin = ffi.Void Function(PtrPcache, PtrPcachePage, ffi.Int32);
typedef DartDefxUnpin = void Function(PtrPcache, PtrPcachePage, int);
typedef DefxRekey = ffi.Void Function(PtrPcache, PtrPcachePage, ffi.Uint32, ffi.Uint32);
typedef DartDefxRekey = void Function(PtrPcache, PtrPcachePage, int, int);
typedef DefxTruncate4 = ffi.Void Function(PtrPcache, ffi.Uint32);
typedef DartDefxTruncate4 = void Function(PtrPcache, int);
typedef DefxDestroy = ffi.Void Function(PtrPcache);
typedef DartDefxDestroy = void Function(PtrPcache);

/// The [sqlite3_config](https://www.sqlite.org/capi3ref.html#sqlite3_config)([SQLITE\_CONFIG\_PCACHE2](https://www.sqlite.org/capi3ref.html#sqliteconfigpcache2),
/// ...) interface can register an alternative page cache implementation by passing in an instance of
/// the sqlite3\_pcache\_methods2 structure.
///
/// In many applications, most of the heap memory allocated by SQLite is used for the page cache. By
/// implementing a custom page cache using this API, an application can better control the amount of
/// memory consumed by SQLite, the way in which that memory is allocated and released, and the policies
/// used to determine exactly which parts of a database file are cached and for how long. The alternative
/// page cache mechanism is an extreme measure that is only needed by the most demanding applications.
/// The built-in page cache is recommended for most uses. The contents of the sqlite3\_pcache\_methods2
/// structure are copied to an internal buffer by SQLite within the call to [sqlite3_config](https://www.sqlite.org/capi3ref.html#sqlite3_config).
/// Hence the application may discard the parameter after the call to [sqlite3_config()](https://www.sqlite.org/capi3ref.html#sqlite3_config)
/// returns. The xInit() method is called once for each effective call to [sqlite3_initialize()](https://www.sqlite.org/capi3ref.html#sqlite3_initialize)
/// (usually only once during the lifetime of the process). The xInit() method is passed a copy of the
/// sqlite3\_pcache\_methods2.pArg value. The intent of the xInit() method is to set up global data structures
/// required by the custom page cache implementation. If the xInit() method is NULL, then the built-in
/// default page cache is used instead of the application defined page cache. The xShutdown() method is
/// called by [sqlite3_shutdown()](https://www.sqlite.org/capi3ref.html#sqlite3_initialize). It can be
/// used to clean up any outstanding resources before process shutdown, if required. The xShutdown()
/// method may be NULL. SQLite automatically serializes calls to the xInit method, so the xInit method
/// need not be threadsafe. The xShutdown method is only called from [sqlite3_shutdown()](https://www.sqlite.org/capi3ref.html#sqlite3_initialize)
/// so it does not need to be threadsafe either. All other methods must be threadsafe in multithreaded
/// applications. SQLite will never invoke xInit() more than once without an intervening call to xShutdown(). SQLite
/// invokes the xCreate() method to construct a new cache instance. SQLite will typically create one
/// cache instance for each open database file, though this is not guaranteed. The first parameter, szPage,
/// is the size in bytes of the pages that must be allocated by the cache. szPage will always a power
/// of two. The second parameter szExtra is a number of bytes of extra storage associated with each page
/// cache entry. The szExtra parameter will a number less than 250. SQLite will use the extra szExtra
/// bytes on each page to store metadata about the underlying database page on disk. The value passed
/// into szExtra depends on the SQLite version, the target platform, and how SQLite was compiled. The
/// third argument to xCreate(), bPurgeable, is true if the cache being created will be used to cache
/// database pages of a file stored on disk, or false if it is used for an in-memory database. The cache
/// implementation does not have to do anything special based with the value of bPurgeable; it is purely
/// advisory. On a cache where bPurgeable is false, SQLite will never invoke xUnpin() except to deliberately
/// delete a page. In other words, calls to xUnpin() on a cache with bPurgeable set to false will always
/// have the "discard" flag set to true. Hence, a cache created with bPurgeable false will never contain
/// any unpinned pages. The xCachesize() method may be called at any time by SQLite to set the suggested
/// maximum cache-size (number of pages stored by) the cache instance passed as the first argument. This
/// is the value configured using the SQLite "[PRAGMA cache_size](https://www.sqlite.org/capi3ref.htmlpragma.html#pragma_cache_size)"
/// command. As with the bPurgeable parameter, the implementation is not required to do anything with
/// this value; it is advisory only. The xPagecount() method must return the number of pages currently
/// stored in the cache, both pinned and unpinned. The xFetch() method locates a page in the cache and
/// returns a pointer to an sqlite3\_pcache\_page object associated with that page, or a NULL pointer.
/// The pBuf element of the returned sqlite3\_pcache\_page object will be a pointer to a buffer of szPage
/// bytes used to store the content of a single database page. The pExtra element of sqlite3\_pcache\_page
/// will be a pointer to the szExtra bytes of extra storage that SQLite has requested for each entry
/// in the page cache. The page to be fetched is determined by the key. The minimum key value is 1. After
/// it has been retrieved using xFetch, the page is considered to be "pinned". If the requested page is
/// already in the page cache, then the page cache implementation must return a pointer to the page buffer
/// with its content intact. If the requested page is not already in the cache, then the cache implementation
/// should use the value of the createFlag parameter to help it determined what action to take:
class sqlite3_pcache_methods2 extends ffi.Struct {
  @ffi.Int32()
  external int iVersion;

  external PtrVoid pArg;

  external PtrDefxSize xInit;

  external PtrDefxFree xShutdown;

  external PtrDefxCreate2 xCreate;

  external PtrDefxCachesize xCachesize;

  external PtrDefxPagecount xPagecount;

  external PtrDefxFetch3 xFetch;

  external PtrDefxUnpin xUnpin;

  external PtrDefxRekey xRekey;

  external PtrDefxTruncate4 xTruncate;

  external PtrDefxDestroy xDestroy;

  external PtrDefxDestroy xShrink;
}

// ************************************ sqlite3_pcache_page ************************************

/// The sqlite3\_pcache\_page object represents a single page in the page cache.
///
/// The page cache will allocate instances of this object. Various methods of the page cache use pointers
/// to instances of this object as parameters or as their return value. See [sqlite3\_pcache\_methods2](https://www.sqlite.org/capi3ref.html#sqlite3_pcache_methods2)
/// for additional information.
class sqlite3_pcache_page extends ffi.Struct {
  external PtrVoid pBuf;

  external PtrVoid pExtra;
}

// *************************************** sqlite3_stmt ***************************************

/// An instance of this object represents a single SQL statement that has been compiled into binary form
/// and is ready to be evaluated. Think of each SQL statement as a separate computer program.
///
/// The original SQL text is source code. A prepared statement object is the compiled object code. All
/// SQL must be converted into a prepared statement before it can be run. The life-cycle of a prepared
/// statement object usually goes like this:
class sqlite3_stmt extends ffi.Opaque {}

// *************************************** sqlite3_value ***************************************

/// SQLite uses the sqlite3\_value object to represent all values that can be stored in a database table.
///
/// SQLite uses dynamic typing for the values it stores. Values stored in sqlite3\_value objects can
/// be integers, floating point values, strings, BLOBs, or NULL. An sqlite3\_value object may be either
/// "protected" or "unprotected". Some interfaces require a protected sqlite3\_value. Other interfaces
/// will accept either a protected or an unprotected sqlite3\_value. Every interface that accepts sqlite3\_value
/// arguments specifies whether or not it requires a protected sqlite3_value. The [sqlite3\_value\_dup()](https://www.sqlite.org/capi3ref.html#sqlite3_value_dup)
/// interface can be used to construct a new protected sqlite3\_value from an unprotected sqlite3\_value. The
/// terms "protected" and "unprotected" refer to whether or not a mutex is held. An internal mutex is
/// held for a protected sqlite3\_value object but no mutex is held for an unprotected sqlite3\_value
/// object. If SQLite is compiled to be single-threaded (with [SQLITE_THREADSAFE=0](https://www.sqlite.org/capi3ref.htmlcompile.html#threadsafe)
/// and with [sqlite3_threadsafe()](https://www.sqlite.org/capi3ref.html#sqlite3_threadsafe) returning
/// 0) or if SQLite is run in one of reduced mutex modes [SQLITE\_CONFIG\_SINGLETHREAD](https://www.sqlite.org/capi3ref.html#sqliteconfigsinglethread)
/// or [SQLITE\_CONFIG\_MULTITHREAD](https://www.sqlite.org/capi3ref.html#sqliteconfigmultithread) then
/// there is no distinction between protected and unprotected sqlite3\_value objects and they can be
/// used interchangeably. However, for maximum code portability it is recommended that applications still
/// make the distinction between protected and unprotected sqlite3\_value objects even when not strictly
/// required. The sqlite3_value objects that are passed as parameters into the implementation of [application-defined
/// SQL functions](https://www.sqlite.org/capi3ref.htmlappfunc.html) are protected. The sqlite3_value
/// object returned by [sqlite3\_column\_value()](https://www.sqlite.org/capi3ref.html#sqlite3_column_blob)
/// is unprotected. Unprotected sqlite3_value objects may only be used as arguments to [sqlite3\_result\_value()](https://www.sqlite.org/capi3ref.html#sqlite3_result_blob),
/// [sqlite3\_bind\_value()](https://www.sqlite.org/capi3ref.html#sqlite3_bind_blob), and [sqlite3\_value\_dup()](https://www.sqlite.org/capi3ref.html#sqlite3_value_dup).
/// The [sqlite3\_value\_type()](https://www.sqlite.org/capi3ref.html#sqlite3_value_blob) family of interfaces
/// require protected sqlite3_value objects.
class sqlite3_value extends ffi.Opaque {}

// **************************************** sqlite3_vfs ****************************************

typedef sqlite3_syscall_ptr = ffi.Void Function();
typedef Dartsqlite3_syscall_ptr = void Function();
typedef DefxOpen5 = ffi.Int32 Function(PtrVfs, PtrString, PtrFile, ffi.Int32, PtrInt32);
typedef DartDefxOpen5 = int Function(PtrVfs, PtrString, PtrFile, int, PtrInt32);
typedef DefxDelete = ffi.Int32 Function(PtrVfs, PtrString, ffi.Int32);
typedef DartDefxDelete = int Function(PtrVfs, PtrString, int);
typedef DefxAccess = ffi.Int32 Function(PtrVfs, PtrString, ffi.Int32, PtrInt32);
typedef DartDefxAccess = int Function(PtrVfs, PtrString, int, PtrInt32);
typedef DefxFullPathname = ffi.Int32 Function(PtrVfs, PtrString, ffi.Int32, PtrString);
typedef DartDefxFullPathname = int Function(PtrVfs, PtrString, int, PtrString);
typedef DefxDlOpen = PtrVoid Function(PtrVfs, PtrString);
typedef DartDefxDlOpen = PtrVoid Function(PtrVfs, PtrString);
typedef DefxDlError = ffi.Void Function(PtrVfs, ffi.Int32, PtrString);
typedef DartDefxDlError = void Function(PtrVfs, int, PtrString);
typedef DefxDlSym = ffi.Pointer<ffi.Void> Function();
typedef DartDefxDlSym = PtrVoid Function();
typedef DefxDlSym6 = PtrDefxDlSym Function(PtrVfs, PtrVoid, PtrString);
typedef DartDefxDlSym6 = PtrDefxDlSym Function(PtrVfs, PtrVoid, PtrString);
typedef DefxDlClose = ffi.Void Function(PtrVfs, PtrVoid);
typedef DartDefxDlClose = void Function(PtrVfs, PtrVoid);
typedef DefxRandomness = ffi.Int32 Function(PtrVfs, ffi.Int32, PtrString);
typedef DartDefxRandomness = int Function(PtrVfs, int, PtrString);
typedef DefxSleep = ffi.Int32 Function(PtrVfs, ffi.Int32);
typedef DartDefxSleep = int Function(PtrVfs, int);
typedef DefxCurrentTime = ffi.Int32 Function(PtrVfs, PtrDouble);
typedef DartDefxCurrentTime = int Function(PtrVfs, PtrDouble);
typedef DefxCurrentTimeInt64 = ffi.Int32 Function(PtrVfs, PtrInt64);
typedef DartDefxCurrentTimeInt64 = int Function(PtrVfs, PtrInt64);
typedef DefxSetSystemCall = ffi.Int32 Function(PtrVfs, PtrString, sqlite3_syscall_ptr);
typedef DartDefxSetSystemCall = int Function(PtrVfs, PtrString, sqlite3_syscall_ptr);
typedef DefxGetSystemCall = sqlite3_syscall_ptr Function(PtrVfs, PtrString);
typedef DartDefxGetSystemCall = sqlite3_syscall_ptr Function(PtrVfs, PtrString);
typedef DefxNextSystemCall = PtrString Function(PtrVfs, PtrString);
typedef DartDefxNextSystemCall = PtrString Function(PtrVfs, PtrString);

/// An instance of the sqlite3_vfs object defines the interface between the SQLite core and the underlying
/// operating system.
///
/// The "vfs" in the name of the object stands for "virtual file system". See the [VFS documentation](https://www.sqlite.org/capi3ref.htmlvfs.html)
/// for further information. The VFS interface is sometimes extended by adding new methods onto the end.
/// Each time such an extension occurs, the iVersion field is incremented. The iVersion value started
/// out as 1 in SQLite [version 3.5.0](https://www.sqlite.org/capi3ref.htmlreleaselog/3_5_0.html) on
/// 2007-09-04, then increased to 2 with SQLite [version 3.7.0](https://www.sqlite.org/capi3ref.htmlreleaselog/3_7_0.html)
/// on 2010-07-21, and then increased to 3 with SQLite [version 3.7.6](https://www.sqlite.org/capi3ref.htmlreleaselog/3_7_6.html)
/// on 2011-04-12. Additional fields may be appended to the sqlite3\_vfs object and the iVersion value
/// may increase again in future versions of SQLite. Note that due to an oversight, the structure of
/// the sqlite3\_vfs object changed in the transition from SQLite [version 3.5.9](https://www.sqlite.org/capi3ref.htmlreleaselog/3_5_9.html)
/// to [version 3.6.0](https://www.sqlite.org/capi3ref.htmlreleaselog/3_6_0.html) on 2008-07-16 and yet
/// the iVersion field was not increased. The szOsFile field is the size of the subclassed [sqlite3_file](https://www.sqlite.org/capi3ref.html#sqlite3_file)
/// structure used by this VFS. mxPathname is the maximum length of a pathname in this VFS. Registered
/// sqlite3_vfs objects are kept on a linked list formed by the pNext pointer. The [sqlite3\_vfs\_register()](https://www.sqlite.org/capi3ref.html#sqlite3_vfs_find)
/// and [sqlite3\_vfs\_unregister()](https://www.sqlite.org/capi3ref.html#sqlite3_vfs_find) interfaces
/// manage this list in a thread-safe way. The [sqlite3\_vfs\_find()](https://www.sqlite.org/capi3ref.html#sqlite3_vfs_find)
/// interface searches the list. Neither the application code nor the VFS implementation should use the
/// pNext pointer. The pNext field is the only field in the sqlite3\_vfs structure that SQLite will ever
/// modify. SQLite will only access or modify this field while holding a particular static mutex. The
/// application should never modify anything within the sqlite3\_vfs object once the object has been
/// registered. The zName field holds the name of the VFS module. The name must be unique across all VFS
/// modules. SQLite guarantees that the zFilename parameter to xOpen is either a NULL pointer or string
/// obtained from xFullPathname() with an optional suffix added. If a suffix is added to the zFilename
/// parameter, it will consist of a single "-" character followed by no more than 11 alphanumeric and/or
/// "-" characters. SQLite further guarantees that the string will be valid and unchanged until xClose()
/// is called. Because of the previous sentence, the [sqlite3_file](https://www.sqlite.org/capi3ref.html#sqlite3_file)
/// can safely store a pointer to the filename if it needs to remember the filename for some reason.
/// If the zFilename parameter to xOpen is a NULL pointer then xOpen must invent its own temporary name
/// for the file. Whenever the xFilename parameter is NULL it will also be the case that the flags parameter
/// will include [SQLITE\_OPEN\_DELETEONCLOSE](https://www.sqlite.org/capi3ref.html#SQLITE_OPEN_AUTOPROXY). The
/// flags argument to xOpen() includes all bits set in the flags argument to [sqlite3\_open\_v2()](https://www.sqlite.org/capi3ref.html#sqlite3_open).
/// Or if [sqlite3_open()](https://www.sqlite.org/capi3ref.html#sqlite3_open) or [sqlite3_open16()](https://www.sqlite.org/capi3ref.html#sqlite3_open)
/// is used, then flags includes at least [SQLITE\_OPEN\_READWRITE](https://www.sqlite.org/capi3ref.html#SQLITE_OPEN_AUTOPROXY)
/// | [SQLITE\_OPEN\_CREATE](https://www.sqlite.org/capi3ref.html#SQLITE_OPEN_AUTOPROXY). If xOpen()
/// opens a file read-only then it sets *pOutFlags to include [SQLITE\_OPEN\_READONLY](https://www.sqlite.org/capi3ref.html#SQLITE_OPEN_AUTOPROXY).
/// Other bits in *pOutFlags may be set. SQLite will also add one of the following flags to the xOpen()
/// call, depending on the object being opened:
class sqlite3_vfs extends ffi.Struct {
  @ffi.Int32()
  external int iVersion;

  @ffi.Int32()
  external int szOsFile;

  @ffi.Int32()
  external int mxPathname;

  external PtrVfs pNext;

  external PtrString zName;

  external PtrVoid pAppData;

  external PtrDefxOpen5 xOpen;

  external PtrDefxDelete xDelete;

  external PtrDefxAccess xAccess;

  external PtrDefxFullPathname xFullPathname;

  external PtrDefxDlOpen xDlOpen;

  external PtrDefxDlError xDlError;

  external PtrDefxDlSym6 xDlSym;

  external PtrDefxDlClose xDlClose;

  external PtrDefxRandomness xRandomness;

  external PtrDefxSleep xSleep;

  external PtrDefxCurrentTime xCurrentTime;

  external PtrDefxRandomness xGetLastError;

  external PtrDefxCurrentTimeInt64 xCurrentTimeInt64;

  external PtrDefxSetSystemCall xSetSystemCall;

  external PtrDefxGetSystemCall xGetSystemCall;

  external PtrDefxNextSystemCall xNextSystemCall;
}

// *************************************** sqlite3_vtab ***************************************

/// Every [virtual table module](https://www.sqlite.org/capi3ref.html#sqlite3_module) implementation
/// uses a subclass of this object to describe a particular instance of the [virtual table](https://www.sqlite.org/capi3ref.htmlvtab.html).
///
/// Each subclass will be tailored to the specific needs of the module implementation. The purpose of
/// this superclass is to define certain fields that are common to all module implementations. Virtual
/// tables methods can set an error message by assigning a string obtained from [sqlite3_mprintf()](https://www.sqlite.org/capi3ref.html#sqlite3_mprintf)
/// to zErrMsg. The method should take care that any prior string is freed by a call to [sqlite3_free()](https://www.sqlite.org/capi3ref.html#sqlite3_free)
/// prior to assigning a new string to zErrMsg. After the error message is delivered up to the client
/// application, the string will be automatically freed by sqlite3_free() and the zErrMsg field will
/// be zeroed.
class sqlite3_vtab extends ffi.Struct {
  external PtrModule pModule;

  @ffi.Int32()
  external int nRef;

  external PtrString zErrMsg;
}

// ************************************ sqlite3_vtab_cursor ************************************

/// Every [virtual table module](https://www.sqlite.org/capi3ref.html#sqlite3_module) implementation
/// uses a subclass of the following structure to describe cursors that point into the [virtual table](https://www.sqlite.org/capi3ref.htmlvtab.html)
/// and are used to loop through the virtual table.
///
/// Cursors are created using the [xOpen](https://www.sqlite.org/capi3ref.htmlvtab.html#xopen) method
/// of the module and are destroyed by the [xClose](https://www.sqlite.org/capi3ref.htmlvtab.html#xclose)
/// method. Cursors are used by the [xFilter](https://www.sqlite.org/capi3ref.htmlvtab.html#xfilter),
/// [xNext](https://www.sqlite.org/capi3ref.htmlvtab.html#xnext), [xEof](https://www.sqlite.org/capi3ref.htmlvtab.html#xeof),
/// [xColumn](https://www.sqlite.org/capi3ref.htmlvtab.html#xcolumn), and [xRowid](https://www.sqlite.org/capi3ref.htmlvtab.html#xrowid)
/// methods of the module. Each module implementation will define the content of a cursor structure to
/// suit its own needs. This superclass exists in order to define fields of the cursor that are common
/// to all implementations.
class sqlite3_vtab_cursor extends ffi.Struct {
  external PtrVtab pVtab;
}

// ************************************* sqlite3_snapshot *************************************

/// An instance of the snapshot object records the state of a [WAL mode](https://www.sqlite.org/capi3ref.htmlwal.html)
/// database for some specific point in history. In [WAL mode](https://www.sqlite.org/capi3ref.htmlwal.html),
/// multiple [database connections](https://www.sqlite.org/capi3ref.html#sqlite3) that are open on the
/// same database file can each be reading a different historical version of the database file.
///
/// When a [database connection](https://www.sqlite.org/capi3ref.html#sqlite3) begins a read transaction,
/// that connection sees an unchanging copy of the database as it existed for the point in time when
/// the transaction first started. Subsequent changes to the database from other connections are not
/// seen by the reader until a new read transaction is started. The sqlite3_snapshot object records state
/// information about an historical version of the database file so that it is possible to later open
/// a new read transaction that sees that historical version of the database rather than the most recent
/// version. 1 Constructor: [sqlite3\_snapshot\_get()](https://www.sqlite.org/capi3ref.html#sqlite3_snapshot_get) 1
/// Destructor: [sqlite3\_snapshot\_free()](https://www.sqlite.org/capi3ref.html#sqlite3_snapshot_free)
class sqlite3_snapshot extends ffi.Struct {
  @ffi.Array(48)
  external ArrayUint8 hidden;
}
