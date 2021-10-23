//

import 'dart:io';

import 'package:code_builder/code_builder.dart' as cb;
import 'package:test/test.dart';

import 'common.dart';
import 'parser.dart';
import 'segment.dart';

void main() {
  hitSegmentTest();
  hitTypeTest();
  hitConstantTest();
  hitTypeDefTest();
  hitStructTest();
  hitAPITest();
}

// test code and result
class AB {
  final String code;
  final String? result;
  final dynamic before;
  final dynamic after;

  const AB(this.code, this.result, {this.before, this.after});
}

const segmentCodes = <AB>[
  AB(
    '#define SQLITE_CREATE_INDEX          1   /* Index Name      Table Name      */',
    'define SQLITE_CREATE_INDEX 1',
  ),
  AB(
    '#define SQLITE_ERROR_MISSING_COLLSEQ (SQLITE_ERROR | (1<<8))',
    'define SQLITE_ERROR_MISSING_COLLSEQ (SQLITE_ERROR | (1<<8))',
  ),
  AB(
    '# define SQLITE_TEXT 3',
    'define SQLITE_TEXT 3',
  ),
  AB(
    'int sqlite3_bind_blob(sqlite3_stmt*, int, const void*, int n, void(*)(void*));',
    'int sqlite3_bind_blob ( sqlite3_stmt * , int , const void * , int n , void ( * ) ( void * ) ) ;',
  ),
  AB(
    '::: Test :::',
    '::: Test :::',
  ),
  AB(
    '''::: Utility :::
int sqlite3_auto_extension(void(*xEntryPoint)(void));''',
    '''::: Utility ::: int sqlite3_auto_extension ( void ( * xEntryPoint ) ( void ) ) ;''',
  ),
  AB(
    '''#ifdef SQLITE_TEXT
# undef SQLITE_TEXT
#else
# define SQLITE_TEXT     3
#endif
#define SQLITE3_TEXT     3''',
    '''define SQLITE_TEXT 3 define SQLITE3_TEXT 3''',
  ),
];

void hitSegmentTest() {
  test('Segment Test', () async {
    for (var segment in segmentCodes) {
      var buffer = StringBuffer();
      final cs = CodeSegments(segment.code);
      final item = cs.iterator;
      while (item.moveNext()) {
        buffer.write(' ');
        buffer.write(item.current.raw);
      }
      expect(buffer.toString().substring(1), segment.result);
    }
  });
}

const typeCodes = <AB>[
  // char & int8 & string & uint8
  AB('char sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Int8'),
  AB('signed char sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Int8'),
  AB('unsigned char sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Uint8'),
  AB('char *sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i2.Utf8>'),
  AB('char **sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i1.Pointer<_i2.Utf8>>'),
  AB('signed char *sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i2.Utf8>'),
  AB('signed char **sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i1.Pointer<_i2.Utf8>>'),
  AB('unsigned char *sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i2.Utf8>'),
  AB('unsigned char **sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i1.Pointer<_i2.Utf8>>'),
  AB('const char sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Int8'),
  AB('const unsigned char sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Uint8'),
  AB('const char *sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i2.Utf8>'),
  AB('const char **sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i1.Pointer<_i2.Utf8>>'),
  AB('const unsigned char *sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i2.Utf8>'),
  AB('const unsigned char **sqlite3_sql(sqlite3_stmt *pStmt);',
      '_i1.Pointer<_i1.Pointer<_i2.Utf8>>'),
  AB('const signed char *sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i2.Utf8>'),
  AB('const signed char **sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i1.Pointer<_i2.Utf8>>'),
  // short & int16 & uint16
  AB('short sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Int16'),
  AB('short *sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i1.Int16>'),
  AB('short **sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i1.Pointer<_i1.Int16>>'),
  AB('short int sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Int16'),
  AB('short int *sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i1.Int16>'),
  AB('short int **sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i1.Pointer<_i1.Int16>>'),
  AB('signed short sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Int16'),
  AB('signed short *sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i1.Int16>'),
  AB('signed short int sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Int16'),
  AB('signed short int *sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i1.Int16>'),
  AB('unsigned short sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Uint16'),
  AB('unsigned short *sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i1.Uint16>'),
  AB('unsigned short int sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Uint16'),
  AB('unsigned short int *sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i1.Uint16>'),
  // in contrast to https://en.wikipedia.org/wiki/C_data_types
  // we consider int as 32 bit and long as 64 bit
  AB('int sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Int32'), // wiki: minimum 16bit
  AB('int *sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i1.Int32>'), // wiki: minimum 16bit
  AB('int **sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i1.Pointer<_i1.Int32>>'),
  AB('signed sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Int32'), // wiki: minimum 16bit
  AB('signed int sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Int32'), // wiki: minimum 16bit
  AB('unsigned sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Uint32'), // wiki: minimum 16bit
  AB('unsigned int sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Uint32'), // wiki: minimum 16bit
  AB('long sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Int64'), // wiki: minimum 32bit
  AB('long int sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Int64'), // wiki: minimum 32bit
  AB('signed long sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Int64'), // wiki: minimum 32bit
  AB('signed long int sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Int64'), // wiki: minimum 32bit
  AB('unsigned long sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Uint64'), // wiki: minimum 32bit
  AB('unsigned long int sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Uint64'), // wiki: minimum 32bit
  AB('long long sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Int64'), // wiki: minimum 32bit
  AB('long long int sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Int64'), // wiki: minimum 32bit
  AB('signed long long sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Int64'), // wiki: minimum 32bit
  AB('signed long long int sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Int64'), // wiki: minimum 32bit
  AB('unsigned long long sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Uint64'), // wiki: minimum 32bit
  AB('unsigned long long int sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Uint64'),
  // float && double
  AB('float sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Float'),
  AB('double sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Double'),
  AB('long double sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Double'),
  AB('long double **sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i1.Pointer<_i1.Double>>'),
  // custom or not scalar
  AB('sqlite3_int64 sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Int64'),
  AB('sqlite_int64 sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Int64'),
  AB('sqlite3_uint64 sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Uint64'),
  AB('sqlite_uint64 sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Uint64'),
  AB('void sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Void'),
  AB('const void *sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i1.Void>'),
  AB('const void **sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<_i1.Pointer<_i1.Void>>'),
  AB('sqlite3 *sqlite3_sql(sqlite3_stmt *pStmt);', '_i1.Pointer<sqlite3>'),
  // argument test
  AB('sqlite3_stmt *pStmt);', '_i1.Pointer<sqlite3_stmt>'),
  AB('sqlite3_stmt*);', '_i1.Pointer<sqlite3_stmt>'),
  AB('sqlite3_stmt *);', '_i1.Pointer<sqlite3_stmt>'),
  AB('int *a, sqlite3*);', '_i1.Pointer<_i1.Int32>'),
  AB('int*, sqlite3*);', '_i1.Pointer<_i1.Int32>'),
  AB('int *, sqlite3*);', '_i1.Pointer<_i1.Int32>'),
  AB('void *pAux, sqlite3*);', '_i1.Pointer<_i1.Void>'),
  // special case for array
  AB('int pStmt[2]);', '_i1.Array<_i1.Int32>'),
  AB('int pStmt[5][2]);', '_i1.Array<_i1.Array<_i1.Int32>>'),
  AB('int *pStmt[23]);', '_i1.Array<_i1.Pointer<_i1.Int32>>'),
  AB('int *pStmt[4][4]);', '_i1.Array<_i1.Array<_i1.Pointer<_i1.Int32>>>'),
  AB('const char *const*argv', '_i1.Pointer<_i1.Pointer<_i2.Utf8>>'),
  AB('char*', '_i1.Pointer<_i2.Utf8>'),
  AB('char**', '_i1.Pointer<_i1.Pointer<_i2.Utf8>>'),
  AB('int **pStmt[8][3]);', '_i1.Array<_i1.Array<_i1.Pointer<_i1.Pointer<_i1.Int32>>>>'),
  AB('sqlite3 *pStmt[2]);', '_i1.Array<_i1.Pointer<sqlite3>>'),
  // struct case
  AB('const struct sqlite3_io_methods *pMethods;', '_i1.Pointer<sqlite3_io_methods>')
];

void hitTypeTest() {
  test('Type Test', () async {
    final emitter = MyEmitter(
      allocator: PrefixedAllocator(true),
      useNullSafetySyntax: true,
    );
    for (var ab in typeCodes) {
      final cs = CodeSegments(ab.code).iterator..next();
      var typeBuilder = readDataType(cs);
      if (isIdentifier.hasMatch(cs.current.raw) && cs.peek?.raw == '[') {
        cs.moveNext();
        readArrayType(cs, typeBuilder);
      }
      final result = typeBuilder.build().accept(emitter).toString();
      expect(result, ab.result,
          reason: 'Expect result ${ab.result} from ${ab.code} but got $result');
    }
  });
}

class TestVisitor implements ComponentEvent {
  final cb.LibraryBuilder builder;
  final typedata = <String, cb.TypeReferenceBuilder>{};

  TestVisitor(this.builder);

  @override
  void onClass(cb.ClassBuilder cbe, [bool subClass = false]) {
    builder.body.add(cbe.build());
  }

  @override
  void onConstant(cb.Expression expr, String name) => builder.body.add(expr.statement);

  @override
  void onField(cb.FieldBuilder fb, String name) {}

  @override
  void onMethod(cb.MethodBuilder mb, String name, [bool isFunction = false]) {
    onTypeDef(
        cb.FunctionTypeBuilder()
          ..returnType = mb.returns
          ..requiredParameters.addAll(mb.requiredParameters.build().map((e) => e.type!)),
        0);
  }

  @override
  void onParameter(cb.ParameterBuilder pb, String name) {
    pb.name = name;
    if (pb.type!.url == null && (pb.type as cb.TypeReference).types.isEmpty) {
      final actualType = typedata[pb.type!.symbol!];
      if (actualType != null) {
        pb.type = actualType.build();
      }
    }
  }

  @override
  cb.TypeReference onType(cb.TypeReference tr) {
    if (tr.type.url == null && tr.types.isEmpty) {
      final actualType = typedata[tr.type.symbol];
      if (actualType != null) {
        return actualType.build();
      }
    }
    return tr;
  }

  var _typedefCount = 1;

  @override
  cb.TypeReferenceBuilder onTypeDef(
    cb.FunctionTypeBuilder ftb,
    int pointer, {
    String? name,
    String? root,
    bool explicitName = false,
  }) {
    final tname = name ?? 'typedefGen${_typedefCount++}';
    builder.body.add(ftb.build().toTypeDef(tname));
    final tbuilder = buildPointer(
      pointer,
      cb.TypeReference((b) => b
        ..symbol = 'NativeFunction'
        ..url = dartffi
        ..types.add(cb.TypeReference((b) => b.symbol = tname))),
    );
    typedata[tname] = tbuilder;
    return tbuilder;
  }

  @override
  void finalize() {}

  @override
  void onSection(String name) {}

  @override
  void onAPI(String name) {}
}

const constantCodes = [
  AB('#define SQLITE_OK 0 /* Successful result */', 'const OK = 0;'),
  AB(
    '#define SQLITE_ERROR_MISSING_COLLSEQ (SQLITE_ERROR | (1<<8))',
    'const ERROR_MISSING_COLLSEQ = (ERROR | (1<<8));',
  ),
  AB('# define SQLITE_TEXT 3', 'const TEXT = 3;'),
];

void hitConstantTest() {
  test('Constant Test', () async {
    final emitter = MyEmitter(
      allocator: PrefixedAllocator(true),
      useNullSafetySyntax: true,
    );
    for (var ab in constantCodes) {
      final builder = cb.LibraryBuilder();
      final parser = Parser(ab.code, TestVisitor(builder));
      parser.parse();
      final result = builder.build().accept(emitter).toString();
      expect(result, ab.result,
          reason: 'Expect result ${ab.result} from ${ab.code} but got $result');
    }
  });
}

const ipFFI = "import 'dart:ffi' as _i1;";
const ipPkgFFI = "import 'package:ffi/ffi.dart' as _i2;";
const ipSqlFFI = "import 'package:database_sql/database_sql.dart' as _i3;";

const typedefCodes = [
  AB('typedef struct sqlite3 sqlite3;', '$ipFFI\n\nclass sqlite3 extends _i1.Opaque {}\n'),
  AB(
    'typedef struct sqlite3_stmt sqlite3_stmt;',
    '$ipFFI\n\nclass sqlite3_stmt extends _i1.Opaque {}\n',
  ),
];

void hitTypeDefTest() {
  test('typedef test', () async {
    final emitter = MyEmitter(
      allocator: PrefixedAllocator(true),
      useNullSafetySyntax: true,
    );
    for (var ab in typedefCodes) {
      final builder = cb.LibraryBuilder();
      final parser = Parser(ab.code, TestVisitor(builder));
      parser.parse();
      final result = formatter.format(builder.build().accept(emitter).toString());
      expect(result, ab.result,
          reason: 'Expect result ${ab.result} from ${ab.code} but got $result');
    }
  });
}

const structCodes = [
  // case 0
  AB('''
struct sqlite3_vtab {
  const sqlite3_module *pModule;  /* The module for this virtual table */
  int nRef;                       /* Number of open cursors */
  char *zErrMsg;                  /* Error message from sqlite3_mprintf() */
  /* Virtual table implementations will typically add additional fields */
};
''', '''$ipFFI\n\n$ipPkgFFI\n
class sqlite3_vtab extends _i1.Struct {
  external _i1.Pointer<sqlite3_module> pModule;

  @_i1.Int32()
  external _i1.Int32 nRef;

  external _i1.Pointer<_i2.Utf8> zErrMsg;
}
'''),
  // case 1
  AB('''
struct sqlite3_module {
  int iVersion;
  int (*xCreate)(sqlite3*, void *pAux,
               int argc, const char *const*argv,
               sqlite3_vtab **ppVTab, char**);
  int (*xEof)(sqlite3_vtab_cursor*);
  int (*xRowid)(sqlite3_vtab_cursor*, sqlite3_int64 *pRowid);
  int (*xUpdate)(sqlite3_vtab *, int, sqlite3_value **, sqlite3_int64 *);
  int (*xFindFunction)(sqlite3_vtab *pVtab, int nArg, const char *zName,
                       void (**pxFunc)(sqlite3_context*,int,sqlite3_value**),
                       void **ppArg);
};
''', '''$ipFFI\n\n$ipPkgFFI\n
typedef xCreate = _i1.Int32 Function(
    _i1.Pointer<sqlite3>,
    _i1.Pointer<_i1.Void>,
    _i1.Int32,
    _i1.Pointer<_i1.Pointer<_i2.Utf8>>,
    _i1.Pointer<_i1.Pointer<sqlite3_vtab>>,
    _i1.Pointer<_i1.Pointer<_i2.Utf8>>);
typedef xEof = _i1.Int32 Function(_i1.Pointer<sqlite3_vtab_cursor>);
typedef xRowid = _i1.Int32 Function(_i1.Pointer<sqlite3_vtab_cursor>, _i1.Pointer<_i1.Int64>);
typedef xUpdate = _i1.Int32 Function(_i1.Pointer<sqlite3_vtab>, _i1.Int32,
    _i1.Pointer<_i1.Pointer<sqlite3_value>>, _i1.Pointer<_i1.Int64>);
typedef pxFunc = _i1.Void Function(
    _i1.Pointer<sqlite3_context>, _i1.Int32, _i1.Pointer<_i1.Pointer<sqlite3_value>>);
typedef xFindFunction = _i1.Int32 Function(
    _i1.Pointer<sqlite3_vtab>,
    _i1.Int32,
    _i1.Pointer<_i2.Utf8>,
    _i1.Pointer<_i1.Pointer<_i1.NativeFunction<pxFunc>>>,
    _i1.Pointer<_i1.Pointer<_i1.Void>>);

class sqlite3_module extends _i1.Struct {
  @_i1.Int32()
  external _i1.Int32 iVersion;

  external _i1.Pointer<_i1.NativeFunction<xCreate>> xCreate;

  external _i1.Pointer<_i1.NativeFunction<xEof>> xEof;

  external _i1.Pointer<_i1.NativeFunction<xRowid>> xRowid;

  external _i1.Pointer<_i1.NativeFunction<xUpdate>> xUpdate;

  external _i1.Pointer<_i1.NativeFunction<xFindFunction>> xFindFunction;
}
'''),
  // case 2
  AB('''
struct sqlite3_index_info {
  /* Inputs */
  int nConstraint;           /* Number of entries in aConstraint */
  struct sqlite3_index_constraint {
     int iColumn;              /* Column constrained.  -1 for ROWID */
     unsigned char op;         /* Constraint operator */
     unsigned char usable;     /* True if this constraint is usable */
     int iTermOffset;          /* Used internally - xBestIndex should ignore */
  } *aConstraint;            /* Table of WHERE clause constraints */
  int nOrderBy;              /* Number of terms in the ORDER BY clause */
  struct sqlite3_index_orderby {
     int iColumn;              /* Column number */
     unsigned char desc;       /* True for DESC.  False for ASC. */
  } *aOrderBy;               /* The ORDER BY clause */
  /* Outputs */
  struct sqlite3_index_constraint_usage {
    int argvIndex;           /* if >0, constraint is part of argv to xFilter */
    unsigned char omit;      /* Do not code a test for this constraint */
  } *aConstraintUsage;
  int idxNum;                /* Number used to identify the index */
  char *idxStr;              /* String, possibly obtained from sqlite3_malloc */
  int needToFreeIdxStr;      /* Free idxStr using sqlite3_free() if true */
  int orderByConsumed;       /* True if output is already ordered */
  double estimatedCost;           /* Estimated cost of using this index */
  /* Fields below are only available in SQLite 3.8.2 and later */
  sqlite3_int64 estimatedRows;    /* Estimated number of rows returned */
  /* Fields below are only available in SQLite 3.9.0 and later */
  int idxFlags;              /* Mask of SQLITE_INDEX_SCAN_* flags */
  /* Fields below are only available in SQLite 3.10.0 and later */
  sqlite3_uint64 colUsed;    /* Input: Mask of columns used by statement */
};
''', '''$ipFFI\n\n$ipPkgFFI\n
class sqlite3_index_constraint extends _i1.Struct {
  @_i1.Int32()
  external _i1.Int32 iColumn;

  @_i1.Uint8()
  external _i1.Uint8 op;

  @_i1.Uint8()
  external _i1.Uint8 usable;

  @_i1.Int32()
  external _i1.Int32 iTermOffset;
}

class sqlite3_index_orderby extends _i1.Struct {
  @_i1.Int32()
  external _i1.Int32 iColumn;

  @_i1.Uint8()
  external _i1.Uint8 desc;
}

class sqlite3_index_constraint_usage extends _i1.Struct {
  @_i1.Int32()
  external _i1.Int32 argvIndex;

  @_i1.Uint8()
  external _i1.Uint8 omit;
}

class sqlite3_index_info extends _i1.Struct {
  @_i1.Int32()
  external _i1.Int32 nConstraint;

  external _i1.Pointer<sqlite3_index_constraint> aConstraint;

  @_i1.Int32()
  external _i1.Int32 nOrderBy;

  external _i1.Pointer<sqlite3_index_orderby> aOrderBy;

  external _i1.Pointer<sqlite3_index_constraint_usage> aConstraintUsage;

  @_i1.Int32()
  external _i1.Int32 idxNum;

  external _i1.Pointer<_i2.Utf8> idxStr;

  @_i1.Int32()
  external _i1.Int32 needToFreeIdxStr;

  @_i1.Int32()
  external _i1.Int32 orderByConsumed;

  @_i1.Double()
  external _i1.Double estimatedCost;

  @_i1.Int64()
  external _i1.Int64 estimatedRows;

  @_i1.Int32()
  external _i1.Int32 idxFlags;

  @_i1.Uint64()
  external _i1.Uint64 colUsed;
}
'''),
  // case 3
  AB('''
typedef struct sqlite3_vfs sqlite3_vfs;
typedef void (*sqlite3_syscall_ptr)(void);
struct sqlite3_vfs {
  int iVersion;            /* Structure version number (currently 3) */
  int szOsFile;            /* Size of subclassed sqlite3_file */
  int mxPathname;          /* Maximum file pathname length */
  sqlite3_vfs *pNext;      /* Next registered VFS */
  const char *zName;       /* Name of this virtual file system */
  void *pAppData;          /* Pointer to application-specific data */
  int (*xOpen)(sqlite3_vfs*, const char *zName, sqlite3_file*,
               int flags, int *pOutFlags);
  int (*xDelete)(sqlite3_vfs*, const char *zName, int syncDir);
  int (*xAccess)(sqlite3_vfs*, const char *zName, int flags, int *pResOut);
  int (*xFullPathname)(sqlite3_vfs*, const char *zName, int nOut, char *zOut);
  void *(*xDlOpen)(sqlite3_vfs*, const char *zFilename);
  void (*xDlError)(sqlite3_vfs*, int nByte, char *zErrMsg);
  void (*(*xDlSym)(sqlite3_vfs*,void*, const char *zSymbol))(void);
  void (*xDlClose)(sqlite3_vfs*, void*);
  int (*xRandomness)(sqlite3_vfs*, int nByte, char *zOut);
  int (*xSleep)(sqlite3_vfs*, int microseconds);
  int (*xCurrentTime)(sqlite3_vfs*, double*);
  int (*xGetLastError)(sqlite3_vfs*, int, char *);
  /*
  ** The methods above are in version 1 of the sqlite_vfs object
  ** definition.  Those that follow are added in version 2 or later
  */
  int (*xCurrentTimeInt64)(sqlite3_vfs*, sqlite3_int64*);
  /*
  ** The methods above are in versions 1 and 2 of the sqlite_vfs object.
  ** Those below are for version 3 and greater.
  */
  int (*xSetSystemCall)(sqlite3_vfs*, const char *zName, sqlite3_syscall_ptr);
  sqlite3_syscall_ptr (*xGetSystemCall)(sqlite3_vfs*, const char *zName);
  const char *(*xNextSystemCall)(sqlite3_vfs*, const char *zName);
  /*
  ** The methods above are in versions 1 through 3 of the sqlite_vfs object.
  ** New fields may be appended in future versions.  The iVersion
  ** value will increment whenever this happens.
  */
};
''', '''$ipFFI\n\n$ipPkgFFI\n
class sqlite3_vfs extends _i1.Opaque {}

typedef sqlite3_syscall_ptr = _i1.Void Function();
typedef xOpen = _i1.Int32 Function(_i1.Pointer<sqlite3_vfs>, _i1.Pointer<_i2.Utf8>,
    _i1.Pointer<sqlite3_file>, _i1.Int32, _i1.Pointer<_i1.Int32>);
typedef xDelete = _i1.Int32 Function(_i1.Pointer<sqlite3_vfs>, _i1.Pointer<_i2.Utf8>, _i1.Int32);
typedef xAccess = _i1.Int32 Function(
    _i1.Pointer<sqlite3_vfs>, _i1.Pointer<_i2.Utf8>, _i1.Int32, _i1.Pointer<_i1.Int32>);
typedef xFullPathname = _i1.Int32 Function(
    _i1.Pointer<sqlite3_vfs>, _i1.Pointer<_i2.Utf8>, _i1.Int32, _i1.Pointer<_i2.Utf8>);
typedef xDlOpen = _i1.Pointer<_i1.Void> Function(_i1.Pointer<sqlite3_vfs>, _i1.Pointer<_i2.Utf8>);
typedef xDlError = _i1.Void Function(_i1.Pointer<sqlite3_vfs>, _i1.Int32, _i1.Pointer<_i2.Utf8>);
typedef xDlSym = _i1.Pointer<_i1.Void> Function();
typedef xDlSym = _i1.Pointer<_i1.NativeFunction<xDlSym>> Function(
    _i1.Pointer<sqlite3_vfs>, _i1.Pointer<_i1.Void>, _i1.Pointer<_i2.Utf8>);
typedef xDlClose = _i1.Void Function(_i1.Pointer<sqlite3_vfs>, _i1.Pointer<_i1.Void>);
typedef xRandomness = _i1.Int32 Function(
    _i1.Pointer<sqlite3_vfs>, _i1.Int32, _i1.Pointer<_i2.Utf8>);
typedef xSleep = _i1.Int32 Function(_i1.Pointer<sqlite3_vfs>, _i1.Int32);
typedef xCurrentTime = _i1.Int32 Function(_i1.Pointer<sqlite3_vfs>, _i1.Pointer<_i1.Double>);
typedef xGetLastError = _i1.Int32 Function(
    _i1.Pointer<sqlite3_vfs>, _i1.Int32, _i1.Pointer<_i2.Utf8>);
typedef xCurrentTimeInt64 = _i1.Int32 Function(_i1.Pointer<sqlite3_vfs>, _i1.Pointer<_i1.Int64>);
typedef xSetSystemCall = _i1.Int32 Function(_i1.Pointer<sqlite3_vfs>, _i1.Pointer<_i2.Utf8>,
    _i1.Pointer<_i1.NativeFunction<sqlite3_syscall_ptr>>);
typedef xGetSystemCall = _i1.Pointer<_i1.NativeFunction<sqlite3_syscall_ptr>> Function(
    _i1.Pointer<sqlite3_vfs>, _i1.Pointer<_i2.Utf8>);
typedef xNextSystemCall = _i1.Pointer<_i2.Utf8> Function(
    _i1.Pointer<sqlite3_vfs>, _i1.Pointer<_i2.Utf8>);

class sqlite3_vfs extends _i1.Struct {
  @_i1.Int32()
  external _i1.Int32 iVersion;

  @_i1.Int32()
  external _i1.Int32 szOsFile;

  @_i1.Int32()
  external _i1.Int32 mxPathname;

  external _i1.Pointer<sqlite3_vfs> pNext;

  external _i1.Pointer<_i2.Utf8> zName;

  external _i1.Pointer<_i1.Void> pAppData;

  external _i1.Pointer<_i1.NativeFunction<xOpen>> xOpen;

  external _i1.Pointer<_i1.NativeFunction<xDelete>> xDelete;

  external _i1.Pointer<_i1.NativeFunction<xAccess>> xAccess;

  external _i1.Pointer<_i1.NativeFunction<xFullPathname>> xFullPathname;

  external _i1.Pointer<_i1.NativeFunction<xDlOpen>> xDlOpen;

  external _i1.Pointer<_i1.NativeFunction<xDlError>> xDlError;

  external _i1.Pointer<_i1.NativeFunction<xDlSym>> xDlSym;

  external _i1.Pointer<_i1.NativeFunction<xDlClose>> xDlClose;

  external _i1.Pointer<_i1.NativeFunction<xRandomness>> xRandomness;

  external _i1.Pointer<_i1.NativeFunction<xSleep>> xSleep;

  external _i1.Pointer<_i1.NativeFunction<xCurrentTime>> xCurrentTime;

  external _i1.Pointer<_i1.NativeFunction<xGetLastError>> xGetLastError;

  external _i1.Pointer<_i1.NativeFunction<xCurrentTimeInt64>> xCurrentTimeInt64;

  external _i1.Pointer<_i1.NativeFunction<xSetSystemCall>> xSetSystemCall;

  external _i1.Pointer<_i1.NativeFunction<xGetSystemCall>> xGetSystemCall;

  external _i1.Pointer<_i1.NativeFunction<xNextSystemCall>> xNextSystemCall;
}
'''),
  // case 4
  AB('''
typedef struct sqlite3_snapshot {
  unsigned char hidden[48];
} sqlite3_snapshot;
''', '''$ipFFI\n
class sqlite3_snapshot extends _i1.Struct {
  @_i1.Array(48)
  external _i1.Array<_i1.Uint8> hidden;
}
'''),
];

void hitStructTest() {
  late MyEmitter emitter;
  group('Struct Test', () {
    var i = 0;
    for (var ab in structCodes) {
      test('Test struct ${i++}', () async {
        emitter = MyEmitter(
          allocator: PrefixedAllocator(true),
          useNullSafetySyntax: true,
        );
        final builder = cb.LibraryBuilder();
        final parser = Parser(ab.code, TestVisitor(builder));
        parser.parse();
        final result = formatter.format(builder.build().accept(emitter).toString());
        expect(result, ab.result,
            reason: 'Expect result ${ab.result} from ${ab.code} but got $result');
      });
    }
  });
}

const apiCodes = [
  AB('''
sqlite3 *sqlite3_db_handle(sqlite3_stmt*);
sqlite3_mutex *sqlite3_db_mutex(sqlite3*);
int sqlite3_bind_blob(sqlite3_stmt*, int, const void*, int n, void(*aa)(void*));
''', '''$ipFFI\n
typedef typedefGen1 = _i1.Pointer<sqlite3> Function(_i1.Pointer<sqlite3_stmt>);
typedef typedefGen2 = _i1.Pointer<sqlite3_mutex> Function(_i1.Pointer<sqlite3>);
typedef aa = _i1.Void Function(_i1.Pointer<_i1.Void>);
typedef typedefGen3 = _i1.Int32 Function(_i1.Pointer<sqlite3_stmt>, _i1.Int32,
    _i1.Pointer<_i1.Void>, _i1.Int32, _i1.Pointer<_i1.NativeFunction<aa>>);
'''),
];

void hitAPITest() {
  test('APIs function test', () async {
    final emitter = MyEmitter(
      allocator: PrefixedAllocator(true),
      useNullSafetySyntax: true,
    );
    for (var ab in apiCodes) {
      final builder = cb.LibraryBuilder();
      Parser(ab.code, TestVisitor(builder)).parse();
      final result = formatter.format(builder.build().accept(emitter).toString());
      expect(result, ab.result,
          reason: 'Expect result ${ab.result} from ${ab.code} but got $result');
    }
  });
}
