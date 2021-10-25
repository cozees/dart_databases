// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

@pkgjs.JS()
library sqlite3;

import 'dart:async' as _async;
import 'dart:typed_data' as typed;

import 'package:database_sql/database_sql.dart' as dbsql;
import 'package:js/js.dart' as pkgjs;
import 'package:js/js_util.dart' as jsutil;

part 'binder.g.dart';
part 'context.g.dart';
part 'database.g.dart';
part 'extra.dart';
part 'function.g.dart';
part 'hook.g.dart';
part 'native_type.dart';
part 'pointer.dart';
part 'reader.g.dart';
part 'resultfunction.g.dart';
part 'statement.g.dart';
part 'types.g.dart';

typedef NVoid = Void;
typedef PtrString = Pointer<Utf8>;
typedef PtrString16 = Pointer<Utf16>;
typedef Nint32 = Int32;
typedef Nint8 = Int8;
typedef Nuint8 = Uint8;
typedef Nint16 = Int16;
typedef Nuint16 = Uint16;
typedef Nuint32 = Uint32;
typedef Nint64 = Int64;
typedef Nuint64 = Uint64;
typedef Nfloat = Float;
typedef Ndouble = Double;
typedef PtrVoid = Pointer<Void>;
typedef PtrInt32 = Pointer<Int32>;
typedef PtrPtrVoid = Pointer<Pointer<Void>>;
typedef PtrDefxFree = Pointer<NativeFunction<DefxFree>>;
typedef PtrDefxSize = Pointer<NativeFunction<DefxSize>>;
typedef PtrSqlite3 = Pointer<sqlite3>;
typedef PtrPtrUtf8 = Pointer<Pointer<Utf8>>;
typedef PtrPtrValue = Pointer<Pointer<sqlite3_value>>;
typedef PtrContext = Pointer<sqlite3_context>;
typedef PtrStmt = Pointer<sqlite3_stmt>;
typedef PtrValue = Pointer<sqlite3_value>;
typedef PtrDefxCompare = Pointer<NativeFunction<DefxCompare>>;
typedef PtrDefpxFunc = Pointer<NativeFunction<DefpxFunc>>;
typedef PtrDefxFinal = Pointer<NativeFunction<DefxFinal>>;
typedef PtrDefcallback = Pointer<NativeFunction<Defcallback>>;
typedef PtrPtrSqlite3 = Pointer<Pointer<sqlite3>>;
typedef PtrPtrStmt = Pointer<Pointer<sqlite3_stmt>>;
typedef PtrDefDefTypeGen10 = Pointer<NativeFunction<DefDefTypeGen10>>;

// Wrapper function for DartDefxFree
Function _wrapper1(Function f) => (int arg0) {
      final PtrVoid ptrArg0 = Pointer.fromAddress(arg0);
      return Function.apply(f, [ptrArg0]);
    };

// Wrapper function for DartDefxSize
Function _wrapper2(Function f) => (int arg0) {
      final PtrVoid ptrArg0 = Pointer.fromAddress(arg0);
      return Function.apply(f, [ptrArg0]);
    };

// Wrapper function for DartDefxCompare
Function _wrapper3(Function f) => (int arg0, int arg1, int arg2, int arg3, int arg4) {
      final PtrVoid ptrArg0 = Pointer.fromAddress(arg0);
      final PtrVoid ptrArg2 = Pointer.fromAddress(arg2);
      final PtrVoid ptrArg4 = Pointer.fromAddress(arg4);
      return Function.apply(f, [ptrArg0, arg1, ptrArg2, arg3, ptrArg4]);
    };

// Wrapper function for DartDefpxFunc
Function _wrapper4(Function f) => (int arg0, int arg1, int arg2) {
      final PtrContext ptrArg0 = Pointer.fromAddress(arg0);
      final PtrPtrValue ptrArg2 = Pointer.fromAddress(arg2);
      return Function.apply(f, [ptrArg0, arg1, ptrArg2]);
    };

// Wrapper function for DartDefxFinal
Function _wrapper5(Function f) => (int arg0) {
      final PtrContext ptrArg0 = Pointer.fromAddress(arg0);
      return Function.apply(f, [ptrArg0]);
    };

// Wrapper function for DartDefcallback
Function _wrapper6(Function f) => (int arg0, int arg1, int arg2, int arg3) {
      final PtrVoid ptrArg0 = Pointer.fromAddress(arg0);
      final PtrPtrUtf8 ptrArg2 = Pointer.fromAddress(arg2);
      final PtrPtrUtf8 ptrArg3 = Pointer.fromAddress(arg3);
      return Function.apply(f, [ptrArg0, arg1, ptrArg2, ptrArg3]);
    };

// Wrapper function for DartDefDefTypeGen10
Function _wrapper7(Function f) => (int arg0, int arg1, int arg2, int arg3, dynamic arg4) {
      final PtrVoid ptrArg0 = Pointer.fromAddress(arg0);
      final PtrString ptrArg2 = Pointer.fromAddress(arg2);
      final PtrString ptrArg3 = Pointer.fromAddress(arg3);
      final int iArg4 = jsBigInt2DartInt(arg4);
      return Function.apply(f, [ptrArg0, arg1, ptrArg2, ptrArg3, iArg4]);
    };

const _funcWasmMeta = <Type, FunctionMeta>{
  DartDefxFree: FunctionMeta('vi', _wrapper1),
  DartDefxSize: FunctionMeta('ii', _wrapper2),
  DartDefxCompare: FunctionMeta('iiiiii', _wrapper3),
  DartDefpxFunc: FunctionMeta('viii', _wrapper4),
  DartDefxFinal: FunctionMeta('vi', _wrapper5),
  DartDefcallback: FunctionMeta('iiiii', _wrapper6),
  DartDefDefTypeGen10: FunctionMeta('viiiij', _wrapper7)
};

// typedef to help dynamic library lookup api for current versioning of the sqlite
typedef _DefVoidStringFunc = String Function();
typedef _DefLibVersionDart = int Function();

// Destructor use to free pointer allocation
void _sqliteDestructor(num ptr) => _wasm._free(ptr);
final int _ptrDestructor = _wasm.addFunction(pkgjs.allowInterop(_sqliteDestructor), 'vi');

abstract class _SQLiteLibrary {
  late final _DefLibVersionDart _libVersionNumber =
      _wasm.cwrap('sqlite3_libversion_number', 'number');

  late final _DefVoidStringFunc _libVersion = _wasm.cwrap('sqlite3_libversion', 'string');

  late final _DefVoidStringFunc _sourceId = _wasm.cwrap('sqlite3_sourceid', 'string');

  /// return dynamic library version
  String get libVersion => _libVersion();

  /// return dynamic library source id
  String get sourceId => _sourceId();

  /// return SQLite dynamic library version as number
  int get libVersionNumber => _libVersionNumber();
}

/// Web binder provide a compatible method to access SQLite C APIs.
class SQLiteLibrary extends _SQLiteLibrary
    with
        _MixinDatabase,
        _MixinStatement,
        _MixinBinder,
        _MixinReader,
        _MixinFunction,
        _MixinContext,
        _MixinResultFunction,
        _MixinHook,
        _MixinExtra {
  SQLiteLibrary._();

  static _async.Future<SQLiteLibrary> instance({String? path, required String? mountDir}) async {
    await jsutil.promiseToFuture(module(_wasm));
    _wasm.run();
    _wasm.FS.mkdir(mountDir!);
    _wasm.FS.mount(_wasm.IDBFS, jsutil.newObject(), mountDir);
    await _sync(true);
    isBigInt = _wasm.hasOwnProperty('HEAPU64') && _wasm.hasOwnProperty('HEAP64');
    return SQLiteLibrary._();
  }
}
