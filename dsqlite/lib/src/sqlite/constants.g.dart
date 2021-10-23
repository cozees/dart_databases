// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const OK = 0;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const ERROR = 1;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const INTERNAL = 2;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const PERM = 3;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const ABORT = 4;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const BUSY = 5;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const LOCKED = 6;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const NOMEM = 7;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const READONLY = 8;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const INTERRUPT = 9;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const IOERR = 10;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const CORRUPT = 11;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const NOTFOUND = 12;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const FULL = 13;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const CANTOPEN = 14;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const PROTOCOL = 15;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const EMPTY = 16;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const SCHEMA = 17;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const TOOBIG = 18;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const CONSTRAINT = 19;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const MISMATCH = 20;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const MISUSE = 21;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const NOLFS = 22;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const AUTH = 23;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const FORMAT = 24;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const RANGE = 25;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const NOTADB = 26;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const NOTICE = 27;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const WARNING = 28;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const ROW = 100;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT) for meaning and the use of it.
const DONE = 101;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const ERROR_MISSING_COLLSEQ = (ERROR | (1 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const ERROR_RETRY = (ERROR | (2 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const ERROR_SNAPSHOT = (ERROR | (3 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_READ = (IOERR | (1 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_SHORT_READ = (IOERR | (2 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_WRITE = (IOERR | (3 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_FSYNC = (IOERR | (4 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_DIR_FSYNC = (IOERR | (5 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_TRUNCATE = (IOERR | (6 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_FSTAT = (IOERR | (7 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_UNLOCK = (IOERR | (8 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_RDLOCK = (IOERR | (9 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_DELETE = (IOERR | (10 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_BLOCKED = (IOERR | (11 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_NOMEM = (IOERR | (12 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_ACCESS = (IOERR | (13 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_CHECKRESERVEDLOCK = (IOERR | (14 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_LOCK = (IOERR | (15 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_CLOSE = (IOERR | (16 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_DIR_CLOSE = (IOERR | (17 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_SHMOPEN = (IOERR | (18 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_SHMSIZE = (IOERR | (19 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_SHMLOCK = (IOERR | (20 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_SHMMAP = (IOERR | (21 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_SEEK = (IOERR | (22 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_DELETE_NOENT = (IOERR | (23 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_MMAP = (IOERR | (24 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_GETTEMPPATH = (IOERR | (25 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_CONVPATH = (IOERR | (26 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_VNODE = (IOERR | (27 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_AUTH = (IOERR | (28 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_BEGIN_ATOMIC = (IOERR | (29 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_COMMIT_ATOMIC = (IOERR | (30 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_ROLLBACK_ATOMIC = (IOERR | (31 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_DATA = (IOERR | (32 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const IOERR_CORRUPTFS = (IOERR | (33 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const LOCKED_SHAREDCACHE = (LOCKED | (1 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const LOCKED_VTAB = (LOCKED | (2 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const BUSY_RECOVERY = (BUSY | (1 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const BUSY_SNAPSHOT = (BUSY | (2 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const BUSY_TIMEOUT = (BUSY | (3 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const CANTOPEN_NOTEMPDIR = (CANTOPEN | (1 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const CANTOPEN_ISDIR = (CANTOPEN | (2 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const CANTOPEN_FULLPATH = (CANTOPEN | (3 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const CANTOPEN_CONVPATH = (CANTOPEN | (4 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const CANTOPEN_DIRTYWAL = (CANTOPEN | (5 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const CANTOPEN_SYMLINK = (CANTOPEN | (6 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const CORRUPT_VTAB = (CORRUPT | (1 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const CORRUPT_SEQUENCE = (CORRUPT | (2 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const CORRUPT_INDEX = (CORRUPT | (3 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const READONLY_RECOVERY = (READONLY | (1 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const READONLY_CANTLOCK = (READONLY | (2 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const READONLY_ROLLBACK = (READONLY | (3 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const READONLY_DBMOVED = (READONLY | (4 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const READONLY_CANTINIT = (READONLY | (5 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const READONLY_DIRECTORY = (READONLY | (6 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const ABORT_ROLLBACK = (ABORT | (2 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const CONSTRAINT_CHECK = (CONSTRAINT | (1 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const CONSTRAINT_COMMITHOOK = (CONSTRAINT | (2 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const CONSTRAINT_FOREIGNKEY = (CONSTRAINT | (3 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const CONSTRAINT_FUNCTION = (CONSTRAINT | (4 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const CONSTRAINT_NOTNULL = (CONSTRAINT | (5 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const CONSTRAINT_PRIMARYKEY = (CONSTRAINT | (6 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const CONSTRAINT_TRIGGER = (CONSTRAINT | (7 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const CONSTRAINT_UNIQUE = (CONSTRAINT | (8 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const CONSTRAINT_VTAB = (CONSTRAINT | (9 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const CONSTRAINT_ROWID = (CONSTRAINT | (10 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const CONSTRAINT_PINNED = (CONSTRAINT | (11 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const NOTICE_RECOVER_WAL = (NOTICE | (1 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const NOTICE_RECOVER_ROLLBACK = (NOTICE | (2 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const WARNING_AUTOINDEX = (WARNING | (1 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const AUTH_USER = (AUTH | (1 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const OK_LOAD_PERMANENTLY = (OK | (1 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT_ROLLBACK) for meaning and the use of it.
const OK_SYMLINK = (OK | (2 << 8));

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ACCESS_EXISTS) for meaning and the use of it.
const ACCESS_EXISTS = 0;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ACCESS_EXISTS) for meaning and the use of it.
const ACCESS_READWRITE = 1;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ACCESS_EXISTS) for meaning and the use of it.
const ACCESS_READ = 2;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const CREATE_INDEX = 1;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const CREATE_TABLE = 2;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const CREATE_TEMP_INDEX = 3;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const CREATE_TEMP_TABLE = 4;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const CREATE_TEMP_TRIGGER = 5;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const CREATE_TEMP_VIEW = 6;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const CREATE_TRIGGER = 7;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const CREATE_VIEW = 8;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const DELETE = 9;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const DROP_INDEX = 10;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const DROP_TABLE = 11;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const DROP_TEMP_INDEX = 12;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const DROP_TEMP_TABLE = 13;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const DROP_TEMP_TRIGGER = 14;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const DROP_TEMP_VIEW = 15;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const DROP_TRIGGER = 16;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const DROP_VIEW = 17;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const INSERT = 18;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const PRAGMA = 19;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const READ = 20;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const SELECT = 21;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const TRANSACTION = 22;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const UPDATE = 23;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const ATTACH = 24;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const DETACH = 25;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const ALTER_TABLE = 26;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const REINDEX = 27;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const ANALYZE = 28;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const CREATE_VTABLE = 29;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const DROP_VTABLE = 30;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const FUNCTION = 31;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const SAVEPOINT = 32;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const COPY = 0;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ALTER_TABLE) for meaning and the use of it.
const RECURSIVE = 33;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ANY) for meaning and the use of it.
const UTF8 = 1;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ANY) for meaning and the use of it.
const UTF16LE = 2;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ANY) for meaning and the use of it.
const UTF16BE = 3;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ANY) for meaning and the use of it.
const UTF16 = 4;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ANY) for meaning and the use of it.
const ANY = 5;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_ANY) for meaning and the use of it.
const UTF16_ALIGNED = 8;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_BLOB) for meaning and the use of it.
const INTEGER = 1;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_BLOB) for meaning and the use of it.
const FLOAT = 2;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_BLOB) for meaning and the use of it.
const BLOB = 4;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_BLOB) for meaning and the use of it.
const NULL = 5;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_BLOB) for meaning and the use of it.
const TEXT = 3;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_BLOB) for meaning and the use of it.
const SQLITE3_TEXT = 3;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CHECKPOINT_FULL) for meaning and the use of it.
const CHECKPOINT_PASSIVE = 0;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CHECKPOINT_FULL) for meaning and the use of it.
const CHECKPOINT_FULL = 1;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CHECKPOINT_FULL) for meaning and the use of it.
const CHECKPOINT_RESTART = 2;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CHECKPOINT_FULL) for meaning and the use of it.
const CHECKPOINT_TRUNCATE = 3;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_SINGLETHREAD = 1;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_MULTITHREAD = 2;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_SERIALIZED = 3;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_MALLOC = 4;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_GETMALLOC = 5;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_SCRATCH = 6;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_PAGECACHE = 7;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_HEAP = 8;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_MEMSTATUS = 9;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_MUTEX = 10;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_GETMUTEX = 11;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_LOOKASIDE = 13;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_PCACHE = 14;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_GETPCACHE = 15;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_LOG = 16;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_URI = 17;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_PCACHE2 = 18;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_GETPCACHE2 = 19;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_COVERING_INDEX_SCAN = 20;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_SQLLOG = 21;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_MMAP_SIZE = 22;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_WIN32_HEAPSIZE = 23;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_PCACHE_HDRSZ = 24;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_PMASZ = 25;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_STMTJRNL_SPILL = 26;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_SMALL_MALLOC = 27;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_SORTERREF_SIZE = 28;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_CONFIG_COVERING_INDEX_SCAN) for meaning and the use of it.
const CONFIG_MEMDB_MAXSIZE = 29;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DBCONFIG_DEFENSIVE) for meaning and the use of it.
const DBCONFIG_MAINDBNAME = 1000;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DBCONFIG_DEFENSIVE) for meaning and the use of it.
const DBCONFIG_LOOKASIDE = 1001;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DBCONFIG_DEFENSIVE) for meaning and the use of it.
const DBCONFIG_ENABLE_FKEY = 1002;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DBCONFIG_DEFENSIVE) for meaning and the use of it.
const DBCONFIG_ENABLE_TRIGGER = 1003;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DBCONFIG_DEFENSIVE) for meaning and the use of it.
const DBCONFIG_ENABLE_FTS3_TOKENIZER = 1004;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DBCONFIG_DEFENSIVE) for meaning and the use of it.
const DBCONFIG_ENABLE_LOAD_EXTENSION = 1005;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DBCONFIG_DEFENSIVE) for meaning and the use of it.
const DBCONFIG_NO_CKPT_ON_CLOSE = 1006;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DBCONFIG_DEFENSIVE) for meaning and the use of it.
const DBCONFIG_ENABLE_QPSG = 1007;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DBCONFIG_DEFENSIVE) for meaning and the use of it.
const DBCONFIG_TRIGGER_EQP = 1008;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DBCONFIG_DEFENSIVE) for meaning and the use of it.
const DBCONFIG_RESET_DATABASE = 1009;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DBCONFIG_DEFENSIVE) for meaning and the use of it.
const DBCONFIG_DEFENSIVE = 1010;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DBCONFIG_DEFENSIVE) for meaning and the use of it.
const DBCONFIG_WRITABLE_SCHEMA = 1011;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DBCONFIG_DEFENSIVE) for meaning and the use of it.
const DBCONFIG_LEGACY_ALTER_TABLE = 1012;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DBCONFIG_DEFENSIVE) for meaning and the use of it.
const DBCONFIG_DQS_DML = 1013;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DBCONFIG_DEFENSIVE) for meaning and the use of it.
const DBCONFIG_DQS_DDL = 1014;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DBCONFIG_DEFENSIVE) for meaning and the use of it.
const DBCONFIG_ENABLE_VIEW = 1015;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DBCONFIG_DEFENSIVE) for meaning and the use of it.
const DBCONFIG_LEGACY_FILE_FORMAT = 1016;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DBCONFIG_DEFENSIVE) for meaning and the use of it.
const DBCONFIG_TRUSTED_SCHEMA = 1017;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DBCONFIG_DEFENSIVE) for meaning and the use of it.
const DBCONFIG_MAX = 1017;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DENY) for meaning and the use of it.
const DENY = 1;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DENY) for meaning and the use of it.
const IGNORE = 2;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DESERIALIZE_FREEONCLOSE) for meaning and the use of it.
const DESERIALIZE_FREEONCLOSE = 1;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DESERIALIZE_FREEONCLOSE) for meaning and the use of it.
const DESERIALIZE_RESIZEABLE = 2;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_DESERIALIZE_FREEONCLOSE) for meaning and the use of it.
const DESERIALIZE_READONLY = 4;

/// The SQLITE_DETERMINISTIC flag means that the new function always gives the same output when the input
/// parameters are the same.
///
/// The [abs() function](https://www.sqlite.org/capi3ref.htmllang_corefunc.html#abs) is deterministic,
/// for example, but [randomblob()](https://www.sqlite.org/capi3ref.htmllang_corefunc.html#randomblob)
/// is not. Functions must be deterministic in order to be used in certain contexts such as with the
/// WHERE clause of [partial indexes](https://www.sqlite.org/capi3ref.htmlpartialindex.html) or in [generated
/// columns](https://www.sqlite.org/capi3ref.htmlgencol.html). SQLite might also optimize deterministic
/// functions by factoring them out of inner loops.
const DETERMINISTIC = 0x000000800;

/// The SQLITE_DIRECTONLY flag means that the function may only be invoked from top-level SQL, and cannot
/// be used in VIEWs or TRIGGERs nor in schema structures such as [CHECK constraints](https://www.sqlite.org/capi3ref.htmllang_createtable.html#ckconst),
/// [DEFAULT clauses](https://www.sqlite.org/capi3ref.htmllang_createtable.html#dfltval), [expression
/// indexes](https://www.sqlite.org/capi3ref.htmlexpridx.html), [partial indexes](https://www.sqlite.org/capi3ref.htmlpartialindex.html),
/// or [generated columns](https://www.sqlite.org/capi3ref.htmlgencol.html).
///
/// The SQLITE_DIRECTONLY flags is a security feature which is recommended for all [application-defined
/// SQL functions](https://www.sqlite.org/capi3ref.htmlappfunc.html), and especially for functions that
/// have side-effects or that could potentially leak sensitive information.
const DIRECTONLY = 0x000080000;

/// The SQLITE_SUBTYPE flag indicates to SQLite that a function may call [sqlite3\_value\_subtype()](https://www.sqlite.org/capi3ref.html#sqlite3_value_subtype)
/// to inspect the sub-types of its arguments.
///
/// Specifying this flag makes no difference for scalar or aggregate user functions. However, if it
/// is not specified for a user-defined window function, then any sub-types belonging to arguments passed
/// to the window function may be discarded before the window function is called (i.e. sqlite3\_value\_subtype()
/// will always return 0).
const SUBTYPE = 0x000100000;

/// The SQLITE_INNOCUOUS flag means that the function is unlikely to cause problems even if misused.
///
/// An innocuous function should have no side effects and should not depend on any values other than
/// its input parameters. The [abs() function](https://www.sqlite.org/capi3ref.htmllang_corefunc.html#abs)
/// is an example of an innocuous function. The [load_extension() SQL function](https://www.sqlite.org/capi3ref.htmllang_corefunc.html#load_extension)
/// is not innocuous because of its side effects. SQLITE\_INNOCUOUS is similar to SQLITE\_DETERMINISTIC,
/// but is not exactly the same. The [random() function](https://www.sqlite.org/capi3ref.htmllang_corefunc.html#random)
/// is an example of a function that is innocuous but not deterministic. Some heightened security settings
/// ([SQLITE\_DBCONFIG\_TRUSTED_SCHEMA](https://www.sqlite.org/capi3ref.html#sqlitedbconfigtrustedschema)
/// and [PRAGMA trusted_schema=OFF](https://www.sqlite.org/capi3ref.htmlpragma.html#pragma_trusted_schema))
/// disable the use of SQL functions inside views and triggers and in schema structures such as [CHECK
/// constraints](https://www.sqlite.org/capi3ref.htmllang_createtable.html#ckconst), [DEFAULT clauses](https://www.sqlite.org/capi3ref.htmllang_createtable.html#dfltval),
/// [expression indexes](https://www.sqlite.org/capi3ref.htmlexpridx.html), [partial indexes](https://www.sqlite.org/capi3ref.htmlpartialindex.html),
/// and [generated columns](https://www.sqlite.org/capi3ref.htmlgencol.html) unless the function is tagged
/// with SQLITE\_INNOCUOUS. Most built-in functions are innocuous. Developers are advised to avoid using
/// the SQLITE\_INNOCUOUS flag for application-defined functions unless the function has been carefully
/// audited and found to be free of potentially security-adverse side-effects and information-leaks.
const INNOCUOUS = 0x000200000;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FAIL) for meaning and the use of it.
const ROLLBACK = 1;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FAIL) for meaning and the use of it.
const FAIL = 3;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FAIL) for meaning and the use of it.
const REPLACE = 5;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_LOCKSTATE = 1;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_GET_LOCKPROXYFILE = 2;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_SET_LOCKPROXYFILE = 3;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_LAST_ERRNO = 4;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_SIZE_HINT = 5;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_CHUNK_SIZE = 6;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_FILE_POINTER = 7;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_SYNC_OMITTED = 8;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_WIN32_AV_RETRY = 9;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_PERSIST_WAL = 10;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_OVERWRITE = 11;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_VFSNAME = 12;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_POWERSAFE_OVERWRITE = 13;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_PRAGMA = 14;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_BUSYHANDLER = 15;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_TEMPFILENAME = 16;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_MMAP_SIZE = 18;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_TRACE = 19;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_HAS_MOVED = 20;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_SYNC = 21;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_COMMIT_PHASETWO = 22;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_WIN32_SET_HANDLE = 23;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_WAL_BLOCK = 24;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_ZIPVFS = 25;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_RBU = 26;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_VFS_POINTER = 27;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_JOURNAL_POINTER = 28;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_WIN32_GET_HANDLE = 29;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_PDB = 30;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_BEGIN_ATOMIC_WRITE = 31;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_COMMIT_ATOMIC_WRITE = 32;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_ROLLBACK_ATOMIC_WRITE = 33;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_LOCK_TIMEOUT = 34;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_DATA_VERSION = 35;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_SIZE_LIMIT = 36;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_CKPT_DONE = 37;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_RESERVE_BYTES = 38;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_CKPT_START = 39;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_EXTERNAL_READER = 40;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_FCNTL_BEGIN_ATOMIC_WRITE) for meaning and the use of it.
const FCNTL_CKSM_FILE = 41;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_INDEX_CONSTRAINT_EQ) for meaning and the use of it.
const INDEX_CONSTRAINT_EQ = 2;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_INDEX_CONSTRAINT_EQ) for meaning and the use of it.
const INDEX_CONSTRAINT_GT = 4;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_INDEX_CONSTRAINT_EQ) for meaning and the use of it.
const INDEX_CONSTRAINT_LE = 8;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_INDEX_CONSTRAINT_EQ) for meaning and the use of it.
const INDEX_CONSTRAINT_LT = 16;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_INDEX_CONSTRAINT_EQ) for meaning and the use of it.
const INDEX_CONSTRAINT_GE = 32;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_INDEX_CONSTRAINT_EQ) for meaning and the use of it.
const INDEX_CONSTRAINT_MATCH = 64;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_INDEX_CONSTRAINT_EQ) for meaning and the use of it.
const INDEX_CONSTRAINT_LIKE = 65;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_INDEX_CONSTRAINT_EQ) for meaning and the use of it.
const INDEX_CONSTRAINT_GLOB = 66;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_INDEX_CONSTRAINT_EQ) for meaning and the use of it.
const INDEX_CONSTRAINT_REGEXP = 67;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_INDEX_CONSTRAINT_EQ) for meaning and the use of it.
const INDEX_CONSTRAINT_NE = 68;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_INDEX_CONSTRAINT_EQ) for meaning and the use of it.
const INDEX_CONSTRAINT_ISNOT = 69;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_INDEX_CONSTRAINT_EQ) for meaning and the use of it.
const INDEX_CONSTRAINT_ISNOTNULL = 70;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_INDEX_CONSTRAINT_EQ) for meaning and the use of it.
const INDEX_CONSTRAINT_ISNULL = 71;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_INDEX_CONSTRAINT_EQ) for meaning and the use of it.
const INDEX_CONSTRAINT_IS = 72;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_INDEX_CONSTRAINT_EQ) for meaning and the use of it.
const INDEX_CONSTRAINT_FUNCTION = 150;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_IOCAP_ATOMIC) for meaning and the use of it.
const IOCAP_ATOMIC = 0x00000001;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_IOCAP_ATOMIC) for meaning and the use of it.
const IOCAP_ATOMIC512 = 0x00000002;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_IOCAP_ATOMIC) for meaning and the use of it.
const IOCAP_ATOMIC1K = 0x00000004;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_IOCAP_ATOMIC) for meaning and the use of it.
const IOCAP_ATOMIC2K = 0x00000008;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_IOCAP_ATOMIC) for meaning and the use of it.
const IOCAP_ATOMIC4K = 0x00000010;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_IOCAP_ATOMIC) for meaning and the use of it.
const IOCAP_ATOMIC8K = 0x00000020;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_IOCAP_ATOMIC) for meaning and the use of it.
const IOCAP_ATOMIC16K = 0x00000040;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_IOCAP_ATOMIC) for meaning and the use of it.
const IOCAP_ATOMIC32K = 0x00000080;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_IOCAP_ATOMIC) for meaning and the use of it.
const IOCAP_ATOMIC64K = 0x00000100;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_IOCAP_ATOMIC) for meaning and the use of it.
const IOCAP_SAFE_APPEND = 0x00000200;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_IOCAP_ATOMIC) for meaning and the use of it.
const IOCAP_SEQUENTIAL = 0x00000400;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_IOCAP_ATOMIC) for meaning and the use of it.
const IOCAP_UNDELETABLE_WHEN_OPEN = 0x00000800;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_IOCAP_ATOMIC) for meaning and the use of it.
const IOCAP_POWERSAFE_OVERWRITE = 0x00001000;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_IOCAP_ATOMIC) for meaning and the use of it.
const IOCAP_IMMUTABLE = 0x00002000;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_IOCAP_ATOMIC) for meaning and the use of it.
const IOCAP_BATCH_ATOMIC = 0x00004000;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_LOCK_EXCLUSIVE) for meaning and the use of it.
const LOCK_NONE = 0;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_LOCK_EXCLUSIVE) for meaning and the use of it.
const LOCK_SHARED = 1;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_LOCK_EXCLUSIVE) for meaning and the use of it.
const LOCK_RESERVED = 2;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_LOCK_EXCLUSIVE) for meaning and the use of it.
const LOCK_PENDING = 3;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_LOCK_EXCLUSIVE) for meaning and the use of it.
const LOCK_EXCLUSIVE = 4;

/// The xShmLock method on [sqlite3\_io\_methods](https://www.sqlite.org/capi3ref.html#sqlite3_io_methods)
/// may use values between 0 and this upper bound as its "offset" argument. The SQLite core will never
/// attempt to acquire or release a lock outside of this range
const SHM_NLOCK = 8;

/// Zero or more of the following constants can be OR-ed together for the F argument to [sqlite3_serialize(D,S,P,F)](https://www.sqlite.org/capi3ref.html#sqlite3_serialize). SQLITE\_SERIALIZE\_NOCOPY
/// means that [sqlite3_serialize()](https://www.sqlite.org/capi3ref.html#sqlite3_serialize) will return
/// a pointer to contiguous in-memory database that it is currently using, without making a copy of the
/// database. If SQLite is not currently using a contiguous in-memory database, then this option causes
/// [sqlite3_serialize()](https://www.sqlite.org/capi3ref.html#sqlite3_serialize) to return a NULL pointer.
/// SQLite will only be using a contiguous in-memory database if it has been initialized by a prior call
/// to [sqlite3_deserialize()](https://www.sqlite.org/capi3ref.html#sqlite3_deserialize).
const SERIALIZE_NOCOPY = 0x001;

/// Virtual table implementations are allowed to set the [sqlite3\_index\_info](https://www.sqlite.org/capi3ref.html#sqlite3_index_info).idxFlags
/// field to some combination of these bits.
const INDEX_SCAN_UNIQUE = 1;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_MUTEX_FAST) for meaning and the use of it.
const MUTEX_FAST = 0;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_MUTEX_FAST) for meaning and the use of it.
const MUTEX_RECURSIVE = 1;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_MUTEX_FAST) for meaning and the use of it.
const MUTEX_STATIC_MAIN = 2;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_MUTEX_FAST) for meaning and the use of it.
const MUTEX_STATIC_MEM = 3;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_MUTEX_FAST) for meaning and the use of it.
const MUTEX_STATIC_MEM2 = 4;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_MUTEX_FAST) for meaning and the use of it.
const MUTEX_STATIC_OPEN = 4;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_MUTEX_FAST) for meaning and the use of it.
const MUTEX_STATIC_PRNG = 5;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_MUTEX_FAST) for meaning and the use of it.
const MUTEX_STATIC_LRU = 6;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_MUTEX_FAST) for meaning and the use of it.
const MUTEX_STATIC_LRU2 = 7;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_MUTEX_FAST) for meaning and the use of it.
const MUTEX_STATIC_PMEM = 7;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_MUTEX_FAST) for meaning and the use of it.
const MUTEX_STATIC_APP1 = 8;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_MUTEX_FAST) for meaning and the use of it.
const MUTEX_STATIC_APP2 = 9;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_MUTEX_FAST) for meaning and the use of it.
const MUTEX_STATIC_APP3 = 10;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_MUTEX_FAST) for meaning and the use of it.
const MUTEX_STATIC_VFS1 = 11;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_MUTEX_FAST) for meaning and the use of it.
const MUTEX_STATIC_VFS2 = 12;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_MUTEX_FAST) for meaning and the use of it.
const MUTEX_STATIC_VFS3 = 13;

/// The database is opened in read-only mode.
///
/// If the database does not already exist, an error is returned.
const OPEN_READONLY = 0x00000001;

/// The database is opened for reading and writing if possible, or reading only if the file is write
/// protected by the operating system.
///
/// In either case the database must already exist, otherwise an error is returned.
const OPEN_READWRITE = 0x00000002;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_OPEN_AUTOPROXY) for meaning and the use of it.
const OPEN_CREATE = 0x00000004;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_OPEN_AUTOPROXY) for meaning and the use of it.
const OPEN_DELETEONCLOSE = 0x00000008;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_OPEN_AUTOPROXY) for meaning and the use of it.
const OPEN_EXCLUSIVE = 0x00000010;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_OPEN_AUTOPROXY) for meaning and the use of it.
const OPEN_AUTOPROXY = 0x00000020;

/// The filename can be interpreted as a URI if this flag is set.
const OPEN_URI = 0x00000040;

/// The database will be opened as an in-memory database.
///
/// The database is named by the "filename" argument for the purposes of cache-sharing, if shared cache
/// mode is enabled, but the "filename" is otherwise ignored.
const OPEN_MEMORY = 0x00000080;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_OPEN_AUTOPROXY) for meaning and the use of it.
const OPEN_MAIN_DB = 0x00000100;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_OPEN_AUTOPROXY) for meaning and the use of it.
const OPEN_TEMP_DB = 0x00000200;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_OPEN_AUTOPROXY) for meaning and the use of it.
const OPEN_TRANSIENT_DB = 0x00000400;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_OPEN_AUTOPROXY) for meaning and the use of it.
const OPEN_MAIN_JOURNAL = 0x00000800;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_OPEN_AUTOPROXY) for meaning and the use of it.
const OPEN_TEMP_JOURNAL = 0x00001000;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_OPEN_AUTOPROXY) for meaning and the use of it.
const OPEN_SUBJOURNAL = 0x00002000;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_OPEN_AUTOPROXY) for meaning and the use of it.
const OPEN_SUPER_JOURNAL = 0x00004000;

/// The new database connection will use the "multi-thread" [threading mode](https://www.sqlite.org/capi3ref.htmlthreadsafe.html).
///
/// This means that separate threads are allowed to use SQLite at the same time, as long as each thread
/// is using a different [database connection](https://www.sqlite.org/capi3ref.html#sqlite3).
const OPEN_NOMUTEX = 0x00008000;

/// The new database connection will use the "serialized" [threading mode](https://www.sqlite.org/capi3ref.htmlthreadsafe.html).
///
/// This means the multiple threads can safely attempt to use the same database connection at the same
/// time. (Mutexes will block any actual concurrency, but in this mode there is no harm in trying.)
const OPEN_FULLMUTEX = 0x00010000;

/// The database is opened [shared cache](https://www.sqlite.org/capi3ref.htmlsharedcache.html) enabled,
/// overriding the default shared cache setting provided by [sqlite3\_enable\_shared_cache()](https://www.sqlite.org/capi3ref.html#sqlite3_enable_shared_cache).
const OPEN_SHAREDCACHE = 0x00020000;

/// The database is opened [shared cache](https://www.sqlite.org/capi3ref.htmlsharedcache.html) disabled,
/// overriding the default shared cache setting provided by [sqlite3\_enable\_shared_cache()](https://www.sqlite.org/capi3ref.html#sqlite3_enable_shared_cache).
const OPEN_PRIVATECACHE = 0x00040000;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_OPEN_AUTOPROXY) for meaning and the use of it.
const OPEN_WAL = 0x00080000;

/// The database filename is not allowed to be a symbolic link
const OPEN_NOFOLLOW = 0x01000000;

/// The SQLITE\_PREPARE\_PERSISTENT flag is a hint to the query planner that the prepared statement will
/// be retained for a long time and probably reused many times.
///
/// Without this flag, [sqlite3\_prepare\_v3()](https://www.sqlite.org/capi3ref.html#sqlite3_prepare)
/// and [sqlite3\_prepare16\_v3()](https://www.sqlite.org/capi3ref.html#sqlite3_prepare) assume that
/// the prepared statement will be used just once or at most a few times and then destroyed using [sqlite3_finalize()](https://www.sqlite.org/capi3ref.html#sqlite3_finalize)
/// relatively soon. The current implementation acts on this hint by avoiding the use of [lookaside memory](https://www.sqlite.org/capi3ref.htmlmalloc.html#lookaside)
/// so as not to deplete the limited store of lookaside memory. Future versions of SQLite may act on
/// this hint differently.
const PREPARE_PERSISTENT = 0x01;

/// The SQLITE\_PREPARE\_NORMALIZE flag is a no-op.
///
/// This flag used to be required for any prepared statement that wanted to use the [sqlite3\_normalized\_sql()](https://www.sqlite.org/capi3ref.html#sqlite3_expanded_sql)
/// interface. However, the [sqlite3\_normalized\_sql()](https://www.sqlite.org/capi3ref.html#sqlite3_expanded_sql)
/// interface is now available to all prepared statements, regardless of whether or not they use this
/// flag.
const PREPARE_NORMALIZE = 0x02;

/// The SQLITE\_PREPARE\_NO\_VTAB flag causes the SQL compiler to return an error (error code SQLITE\_ERROR)
/// if the statement uses any virtual tables.
const PREPARE_NO_VTAB = 0x04;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_SCANSTAT_EST) for meaning and the use of it.
const SCANSTAT_NLOOP = 0;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_SCANSTAT_EST) for meaning and the use of it.
const SCANSTAT_NVISIT = 1;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_SCANSTAT_EST) for meaning and the use of it.
const SCANSTAT_EST = 2;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_SCANSTAT_EST) for meaning and the use of it.
const SCANSTAT_NAME = 3;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_SCANSTAT_EST) for meaning and the use of it.
const SCANSTAT_EXPLAIN = 4;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_SCANSTAT_EST) for meaning and the use of it.
const SCANSTAT_SELECTID = 5;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_SHM_EXCLUSIVE) for meaning and the use of it.
const SHM_UNLOCK = 1;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_SHM_EXCLUSIVE) for meaning and the use of it.
const SHM_LOCK = 2;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_SHM_EXCLUSIVE) for meaning and the use of it.
const SHM_SHARED = 4;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_SHM_EXCLUSIVE) for meaning and the use of it.
const SHM_EXCLUSIVE = 8;

/// This parameter is the current amount of memory checked out using [sqlite3_malloc()](https://www.sqlite.org/capi3ref.html#sqlite3_free),
/// either directly or indirectly.
///
/// The figure includes calls made to [sqlite3_malloc()](https://www.sqlite.org/capi3ref.html#sqlite3_free)
/// by the application and internal memory usage by the SQLite library. Auxiliary page-cache memory controlled
/// by [SQLITE\_CONFIG\_PAGECACHE](https://www.sqlite.org/capi3ref.html#sqliteconfigpagecache) is not
/// included in this parameter. The amount returned is the sum of the allocation sizes as reported by
/// the xSize method in [sqlite3\_mem\_methods](https://www.sqlite.org/capi3ref.html#sqlite3_mem_methods).
const STATUS_MEMORY_USED = 0;

/// This parameter returns the number of pages used out of the [pagecache memory allocator](https://www.sqlite.org/capi3ref.htmlmalloc.html#pagecache)
/// that was configured using [SQLITE\_CONFIG\_PAGECACHE](https://www.sqlite.org/capi3ref.html#sqliteconfigpagecache).
///
/// The value returned is in pages, not in bytes.
const STATUS_PAGECACHE_USED = 1;

/// This parameter returns the number of bytes of page cache allocation which could not be satisfied
/// by the [SQLITE\_CONFIG\_PAGECACHE](https://www.sqlite.org/capi3ref.html#sqliteconfigpagecache) buffer
/// and where forced to overflow to [sqlite3_malloc()](https://www.sqlite.org/capi3ref.html#sqlite3_free).
///
/// The returned value includes allocations that overflowed because they where too large (they were
/// larger than the "sz" parameter to [SQLITE\_CONFIG\_PAGECACHE](https://www.sqlite.org/capi3ref.html#sqliteconfigpagecache))
/// and allocations that overflowed because no space was left in the page cache.
const STATUS_PAGECACHE_OVERFLOW = 2;

/// No longer used.
const STATUS_SCRATCH_USED = 3;

/// No longer used.
const STATUS_SCRATCH_OVERFLOW = 4;

/// This parameter records the largest memory allocation request handed to [sqlite3_malloc()](https://www.sqlite.org/capi3ref.html#sqlite3_free)
/// or [sqlite3_realloc()](https://www.sqlite.org/capi3ref.html#sqlite3_free) (or their internal equivalents).
///
/// Only the value returned in the *pHighwater parameter to [sqlite3_status()](https://www.sqlite.org/capi3ref.html#sqlite3_status)
/// is of interest. The value written into the *pCurrent parameter is undefined.
const STATUS_MALLOC_SIZE = 5;

/// The \*pHighwater parameter records the deepest parser stack.
///
/// The \*pCurrent value is undefined. The *pHighwater value is only meaningful if SQLite is compiled
/// with [YYTRACKMAXSTACKDEPTH](https://www.sqlite.org/capi3ref.htmlcompile.html#yytrackmaxstackdepth).
const STATUS_PARSER_STACK = 6;

/// This parameter records the largest memory allocation request handed to the [pagecache memory allocator](https://www.sqlite.org/capi3ref.htmlmalloc.html#pagecache).
///
/// Only the value returned in the *pHighwater parameter to [sqlite3_status()](https://www.sqlite.org/capi3ref.html#sqlite3_status)
/// is of interest. The value written into the *pCurrent parameter is undefined.
const STATUS_PAGECACHE_SIZE = 7;

/// No longer used.
const STATUS_SCRATCH_SIZE = 8;

/// This parameter records the number of separate memory allocations currently checked out.
const STATUS_MALLOC_COUNT = 9;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_SYNC_DATAONLY) for meaning and the use of it.
const SYNC_NORMAL = 0x00002;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_SYNC_DATAONLY) for meaning and the use of it.
const SYNC_FULL = 0x00003;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_SYNC_DATAONLY) for meaning and the use of it.
const SYNC_DATAONLY = 0x00010;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_FIRST = 5;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_PRNG_SAVE = 5;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_PRNG_RESTORE = 6;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_PRNG_RESET = 7;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_BITVEC_TEST = 8;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_FAULT_INSTALL = 9;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_BENIGN_MALLOC_HOOKS = 10;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_PENDING_BYTE = 11;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_ASSERT = 12;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_ALWAYS = 13;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_RESERVE = 14;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_OPTIMIZATIONS = 15;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_ISKEYWORD = 16;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_SCRATCHMALLOC = 17;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_INTERNAL_FUNCTIONS = 17;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_LOCALTIME_FAULT = 18;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_EXPLAIN_STMT = 19;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_ONCE_RESET_THRESHOLD = 19;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_NEVER_CORRUPT = 20;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_VDBE_COVERAGE = 21;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_BYTEORDER = 22;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_ISINIT = 23;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_SORTER_MMAP = 24;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_IMPOSTER = 25;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_PARSER_COVERAGE = 26;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_RESULT_INTREAL = 27;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_PRNG_SEED = 28;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_EXTRA_SCHEMA_CHECKS = 29;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_SEEK_COUNT = 30;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_TRACEFLAGS = 31;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_TUNE = 32;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_TESTCTRL_ALWAYS) for meaning and the use of it.
const TESTCTRL_LAST = 32;

/// An SQLITE\_TRACE\_STMT callback is invoked when a prepared statement first begins running and possibly
/// at other times during the execution of the prepared statement, such as at the start of each trigger
/// subprogram.
///
/// The P argument is a pointer to the [prepared statement](https://www.sqlite.org/capi3ref.html#sqlite3_stmt).
/// The X argument is a pointer to a string which is the unexpanded SQL text of the prepared statement
/// or an SQL comment that indicates the invocation of a trigger. The callback can compute the same text
/// that would have been returned by the legacy [sqlite3_trace()](https://www.sqlite.org/capi3ref.html#sqlite3_profile)
/// interface by using the X argument when X begins with "--" and invoking [sqlite3\_expanded\_sql(P)](https://www.sqlite.org/capi3ref.html#sqlite3_expanded_sql)
/// otherwise.
const TRACE_STMT = 0x01;

/// An SQLITE\_TRACE\_PROFILE callback provides approximately the same information as is provided by
/// the [sqlite3_profile()](https://www.sqlite.org/capi3ref.html#sqlite3_profile) callback.
///
/// The P argument is a pointer to the [prepared statement](https://www.sqlite.org/capi3ref.html#sqlite3_stmt)
/// and the X argument points to a 64-bit integer which is the estimated of the number of nanosecond
/// that the prepared statement took to run. The SQLITE\_TRACE\_PROFILE callback is invoked when the
/// statement finishes.
const TRACE_PROFILE = 0x02;

/// An SQLITE\_TRACE\_ROW callback is invoked whenever a prepared statement generates a single row of
/// result.
///
/// The P argument is a pointer to the [prepared statement](https://www.sqlite.org/capi3ref.html#sqlite3_stmt)
/// and the X argument is unused.
const TRACE_ROW = 0x04;

/// An SQLITE\_TRACE\_CLOSE callback is invoked when a database connection closes.
///
/// The P argument is a pointer to the [database connection](https://www.sqlite.org/capi3ref.html#sqlite3)
/// object and the X argument is unused.
const TRACE_CLOSE = 0x08;

/// The SQLITE\_TXN\_NONE state means that no transaction is currently pending.
const TXN_NONE = 0;

/// The SQLITE\_TXN\_READ state means that the database is currently in a read transaction.
///
/// Content has been read from the database file but nothing in the database file has changed. The transaction
/// state will advanced to SQLITE\_TXN\_WRITE if any changes occur and there are no other conflicting
/// concurrent write transactions. The transaction state will revert to SQLITE\_TXN\_NONE following a
/// [ROLLBACK](https://www.sqlite.org/capi3ref.htmllang_transaction.html) or [COMMIT](https://www.sqlite.org/capi3ref.htmllang_transaction.html).
const TXN_READ = 1;

/// The SQLITE\_TXN\_WRITE state means that the database is currently in a write transaction.
///
/// Content has been written to the database file but has not yet committed. The transaction state will
/// change to to SQLITE\_TXN\_NONE at the next [ROLLBACK](https://www.sqlite.org/capi3ref.htmllang_transaction.html)
/// or [COMMIT](https://www.sqlite.org/capi3ref.htmllang_transaction.html).
const TXN_WRITE = 2;

/// Calls of the form [sqlite3\_vtab\_config](https://www.sqlite.org/capi3ref.html#sqlite3_vtab_config)(db,SQLITE\_VTAB\_CONSTRAINT_SUPPORT,X)
/// are supported, where X is an integer.
///
/// If X is zero, then the [virtual table](https://www.sqlite.org/capi3ref.htmlvtab.html) whose [xCreate](https://www.sqlite.org/capi3ref.htmlvtab.html#xcreate)
/// or [xConnect](https://www.sqlite.org/capi3ref.htmlvtab.html#xconnect) method invoked [sqlite3\_vtab\_config()](https://www.sqlite.org/capi3ref.html#sqlite3_vtab_config)
/// does not support constraints. In this configuration (which is the default) if a call to the [xUpdate](https://www.sqlite.org/capi3ref.htmlvtab.html#xupdate)
/// method returns [SQLITE_CONSTRAINT](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT), then the entire
/// statement is rolled back as if [OR ABORT](https://www.sqlite.org/capi3ref.htmllang_conflict.html)
/// had been specified as part of the users SQL statement, regardless of the actual ON CONFLICT mode
/// specified. If X is non-zero, then the virtual table implementation guarantees that if [xUpdate](https://www.sqlite.org/capi3ref.htmlvtab.html#xupdate)
/// returns [SQLITE_CONSTRAINT](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT), it will do so before
/// any modifications to internal or persistent data structures have been made. If the [ON CONFLICT](https://www.sqlite.org/capi3ref.htmllang_conflict.html)
/// mode is ABORT, FAIL, IGNORE or ROLLBACK, SQLite is able to roll back a statement or database transaction,
/// and abandon or continue processing the current SQL statement as appropriate. If the ON CONFLICT mode
/// is REPLACE and the [xUpdate](https://www.sqlite.org/capi3ref.htmlvtab.html#xupdate) method returns
/// [SQLITE_CONSTRAINT](https://www.sqlite.org/capi3ref.html#SQLITE_ABORT), SQLite handles this as if
/// the ON CONFLICT mode had been ABORT. Virtual table implementations that are required to handle OR
/// REPLACE must do so within the [xUpdate](https://www.sqlite.org/capi3ref.htmlvtab.html#xupdate) method.
/// If a call to the [sqlite3\_vtab\_on_conflict()](https://www.sqlite.org/capi3ref.html#sqlite3_vtab_on_conflict)
/// function indicates that the current ON CONFLICT policy is REPLACE, the virtual table implementation
/// should silently replace the appropriate rows within the xUpdate callback and return SQLITE\_OK. Or,
/// if this is not possible, it may return SQLITE\_CONSTRAINT, in which case SQLite falls back to OR
/// ABORT constraint handling.
const VTAB_CONSTRAINT_SUPPORT = 1;

/// Calls of the form [sqlite3\_vtab\_config](https://www.sqlite.org/capi3ref.html#sqlite3_vtab_config)(db,SQLITE\_VTAB\_INNOCUOUS)
/// from within the the [xConnect](https://www.sqlite.org/capi3ref.htmlvtab.html#xconnect) or [xCreate](https://www.sqlite.org/capi3ref.htmlvtab.html#xcreate)
/// methods of a [virtual table](https://www.sqlite.org/capi3ref.htmlvtab.html) implmentation identify
/// that virtual table as being safe to use from within triggers and views.
///
/// Conceptually, the SQLITE\_VTAB\_INNOCUOUS tag means that the virtual table can do no serious harm
/// even if it is controlled by a malicious hacker. Developers should avoid setting the SQLITE\_VTAB\_INNOCUOUS
/// flag unless absolutely necessary.
const VTAB_INNOCUOUS = 2;

/// Calls of the form [sqlite3\_vtab\_config](https://www.sqlite.org/capi3ref.html#sqlite3_vtab_config)(db,SQLITE\_VTAB\_DIRECTONLY)
/// from within the the [xConnect](https://www.sqlite.org/capi3ref.htmlvtab.html#xconnect) or [xCreate](https://www.sqlite.org/capi3ref.htmlvtab.html#xcreate)
/// methods of a [virtual table](https://www.sqlite.org/capi3ref.htmlvtab.html) implmentation prohibits
/// that virtual table from being used from within triggers and views.
const VTAB_DIRECTONLY = 3;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_WIN32_DATA_DIRECTORY_TYPE) for meaning and the use of it.
const WIN32_DATA_DIRECTORY_TYPE = 1;

/// See [SQLite Documentation](https://www.sqlite.org/capi3ref.html#SQLITE_WIN32_DATA_DIRECTORY_TYPE) for meaning and the use of it.
const WIN32_TEMP_DIRECTORY_TYPE = 2;

/// The maximum size of any string or BLOB or table row, in bytes.
const LIMIT_LENGTH = 0;

/// The maximum length of an SQL statement, in bytes.
const LIMIT_SQL_LENGTH = 1;

/// The maximum number of columns in a table definition or in the result set of a [SELECT](https://www.sqlite.org/capi3ref.htmllang_select.html)
/// or the maximum number of columns in an index or in an ORDER BY or GROUP BY clause.
const LIMIT_COLUMN = 2;

/// The maximum depth of the parse tree on any expression.
const LIMIT_EXPR_DEPTH = 3;

/// The maximum number of terms in a compound SELECT statement.
const LIMIT_COMPOUND_SELECT = 4;

/// The maximum number of instructions in a virtual machine program used to implement an SQL statement.
///
/// If [sqlite3\_prepare\_v2()](https://www.sqlite.org/capi3ref.html#sqlite3_prepare) or the equivalent
/// tries to allocate space for more than this many opcodes in a single prepared statement, an SQLITE_NOMEM
/// error is returned.
const LIMIT_VDBE_OP = 5;

/// The maximum number of arguments on a function.
const LIMIT_FUNCTION_ARG = 6;

/// The maximum number of [attached databases](https://www.sqlite.org/capi3ref.htmllang_attach.html).
const LIMIT_ATTACHED = 7;

/// The maximum length of the pattern argument to the [LIKE](https://www.sqlite.org/capi3ref.htmllang_expr.html#like)
/// or [GLOB](https://www.sqlite.org/capi3ref.htmllang_expr.html#glob) operators.
const LIMIT_LIKE_PATTERN_LENGTH = 8;

/// The maximum index number of any [parameter](https://www.sqlite.org/capi3ref.htmllang_expr.html#varparam)
/// in an SQL statement.
const LIMIT_VARIABLE_NUMBER = 9;

/// The maximum depth of recursion for triggers.
const LIMIT_TRIGGER_DEPTH = 10;

/// The maximum number of auxiliary worker threads that a single [prepared statement](https://www.sqlite.org/capi3ref.html#sqlite3_stmt)
/// may start.
const LIMIT_WORKER_THREADS = 11;

/// This parameter returns the number of lookaside memory slots currently checked out.
const DBSTATUS_LOOKASIDE_USED = 0;

/// This parameter returns the approximate number of bytes of heap memory used by all pager caches associated
/// with the database connection.
///
/// The highwater mark associated with SQLITE\_DBSTATUS\_CACHE_USED is always 0.
const DBSTATUS_CACHE_USED = 1;

/// This parameter returns the approximate number of bytes of heap memory used to store the schema for
/// all databases associated with the connection - main, temp, and any [ATTACH](https://www.sqlite.org/capi3ref.htmllang_attach.html)-ed
/// databases.
///
/// The full amount of memory used by the schemas is reported, even if the schema memory is shared with
/// other database connections due to [shared cache mode](https://www.sqlite.org/capi3ref.htmlsharedcache.html)
/// being enabled. The highwater mark associated with SQLITE\_DBSTATUS\_SCHEMA_USED is always 0.
const DBSTATUS_SCHEMA_USED = 2;

/// This parameter returns the approximate number of bytes of heap and lookaside memory used by all prepared
/// statements associated with the database connection.
///
/// The highwater mark associated with SQLITE\_DBSTATUS\_STMT_USED is always 0.
const DBSTATUS_STMT_USED = 3;

/// This parameter returns the number of malloc attempts that were satisfied using lookaside memory.
///
/// Only the high-water value is meaningful; the current value is always zero.
const DBSTATUS_LOOKASIDE_HIT = 4;

/// This parameter returns the number malloc attempts that might have been satisfied using lookaside
/// memory but failed due to the amount of memory requested being larger than the lookaside slot size.
///
/// Only the high-water value is meaningful; the current value is always zero.
const DBSTATUS_LOOKASIDE_MISS_SIZE = 5;

/// This parameter returns the number malloc attempts that might have been satisfied using lookaside
/// memory but failed due to all lookaside memory already being in use.
///
/// Only the high-water value is meaningful; the current value is always zero.
const DBSTATUS_LOOKASIDE_MISS_FULL = 6;

/// This parameter returns the number of pager cache hits that have occurred.
///
/// The highwater mark associated with SQLITE\_DBSTATUS\_CACHE_HIT is always 0.
const DBSTATUS_CACHE_HIT = 7;

/// This parameter returns the number of pager cache misses that have occurred.
///
/// The highwater mark associated with SQLITE\_DBSTATUS\_CACHE_MISS is always 0.
const DBSTATUS_CACHE_MISS = 8;

/// This parameter returns the number of dirty cache entries that have been written to disk.
///
/// Specifically, the number of pages written to the wal file in wal mode databases, or the number of
/// pages written to the database file in rollback mode databases. Any pages written as part of transaction
/// rollback or database recovery operations are not included. If an IO or other error occurs while writing
/// a page to disk, the effect on subsequent SQLITE\_DBSTATUS\_CACHE\_WRITE requests is undefined. The
/// highwater mark associated with SQLITE\_DBSTATUS\_CACHE\_WRITE is always 0.
const DBSTATUS_CACHE_WRITE = 9;

/// This parameter returns zero for the current value if and only if all foreign key constraints (deferred
/// or immediate) have been resolved.
///
/// The highwater mark is always 0.
const DBSTATUS_DEFERRED_FKS = 10;

/// This parameter is similar to DBSTATUS\_CACHE\_USED, except that if a pager cache is shared between
/// two or more connections the bytes of heap memory used by that pager cache is divided evenly between
/// the attached connections.
///
/// In other words, if none of the pager caches associated with the database connection are shared,
/// this request returns the same value as DBSTATUS\_CACHE\_USED. Or, if one or more or the pager caches
/// are shared, the value returned by this call will be smaller than that returned by DBSTATUS\_CACHE\_USED.
/// The highwater mark associated with SQLITE\_DBSTATUS\_CACHE\_USED\_SHARED is always 0.
const DBSTATUS_CACHE_USED_SHARED = 11;

/// This parameter returns the number of dirty cache entries that have been written to disk in the middle
/// of a transaction due to the page cache overflowing.
///
/// Transactions are more efficient if they are written to disk all at once. When pages spill mid-transaction,
/// that introduces additional overhead. This parameter can be used help identify inefficiencies that
/// can be resolved by increasing the cache size.
const DBSTATUS_CACHE_SPILL = 12;

/// These constants are the available integer "verbs" that can be passed as the second argument to the
/// [sqlite3\_db\_status()](https://www.sqlite.org/capi3ref.html#sqlite3_db_status) interface. New verbs
/// may be added in future releases of SQLite. Existing verbs might be discontinued. Applications should
/// check the return code from [sqlite3\_db\_status()](https://www.sqlite.org/capi3ref.html#sqlite3_db_status)
/// to make sure that the call worked. The [sqlite3\_db\_status()](https://www.sqlite.org/capi3ref.html#sqlite3_db_status)
/// interface will return a non-zero error code if a discontinued or unsupported verb is invoked.
const DBSTATUS_MAX = 12;

/// This is the number of times that SQLite has stepped forward in a table as part of a full table scan.
///
/// Large numbers for this counter may indicate opportunities for performance improvement through careful
/// use of indices.
const STMTSTATUS_FULLSCAN_STEP = 1;

/// This is the number of sort operations that have occurred.
///
/// A non-zero value in this counter may indicate an opportunity to improvement performance through
/// careful use of indices.
const STMTSTATUS_SORT = 2;

/// This is the number of rows inserted into transient indices that were created automatically in order
/// to help joins run faster.
///
/// A non-zero value in this counter may indicate an opportunity to improvement performance by adding
/// permanent indices that do not need to be reinitialized each time the statement is run.
const STMTSTATUS_AUTOINDEX = 3;

/// This is the number of virtual machine operations executed by the prepared statement if that number
/// is less than or equal to 2147483647.
///
/// The number of virtual machine operations can be used as a proxy for the total work done by the prepared
/// statement. If the number of virtual machine operations exceeds 2147483647 then the value returned
/// by this statement status code is undefined.
const STMTSTATUS_VM_STEP = 4;

/// This is the number of times that the prepare statement has been automatically regenerated due to
/// schema changes or changes to [bound parameters](https://www.sqlite.org/capi3ref.htmllang_expr.html#varparam)
/// that might affect the query plan.
const STMTSTATUS_REPREPARE = 5;

/// This is the number of times that the prepared statement has been run.
///
/// A single "run" for the purposes of this counter is one or more calls to [sqlite3_step()](https://www.sqlite.org/capi3ref.html#sqlite3_step)
/// followed by a call to [sqlite3_reset()](https://www.sqlite.org/capi3ref.html#sqlite3_reset). The
/// counter is incremented on the first [sqlite3_step()](https://www.sqlite.org/capi3ref.html#sqlite3_step)
/// call of each cycle.
const STMTSTATUS_RUN = 6;

/// This is the approximate number of bytes of heap memory used to store the prepared statement.
///
/// This value is not actually a counter, and so the resetFlg parameter to sqlite3\_stmt\_status() is
/// ignored when the opcode is SQLITE\_STMTSTATUS\_MEMUSED.
const STMTSTATUS_MEMUSED = 99;
