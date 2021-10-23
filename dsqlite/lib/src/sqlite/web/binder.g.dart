// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

typedef DefxFree = NVoid Function(PtrVoid);
typedef DartDefxFree = void Function(PtrVoid);
typedef _def_sqlite3_bind_blob = int Function(int, int, int, int, int);
typedef _def_sqlite3_bind_double = int Function(int, int, double);
typedef _def_sqlite3_bind_int = int Function(int, int, int);
typedef _def_sqlite3_bind_int64 = int Function(int, int, dynamic);
typedef _def_sqlite3_bind_null = int Function(int, int);
typedef _def_sqlite3_bind_text = int Function(int, int, int, int, int);
typedef _def_sqlite3_bind_text16 = int Function(int, int, int, int, int);

// Mixin for Binder
mixin _MixinBinder on _SQLiteLibrary {
  late final _def_sqlite3_bind_blob _h_sqlite3_bind_blob = _wasm
      .cwrap('sqlite3_bind_blob', 'number', ['number', 'number', 'number', 'number', 'number']);

  late final _def_sqlite3_bind_double _h_sqlite3_bind_double =
      _wasm.cwrap('sqlite3_bind_double', 'number', ['number', 'number', 'number']);

  late final _def_sqlite3_bind_int _h_sqlite3_bind_int =
      _wasm.cwrap('sqlite3_bind_int', 'number', ['number', 'number', 'number']);

  late final _def_sqlite3_bind_int64 _h_sqlite3_bind_int64 =
      _wasm.cwrap('sqlite3_bind_int64', 'number', ['number', 'number', 'number']);

  late final _def_sqlite3_bind_null _h_sqlite3_bind_null =
      _wasm.cwrap('sqlite3_bind_null', 'number', ['number', 'number']);

  late final _def_sqlite3_bind_text _h_sqlite3_bind_text = _wasm
      .cwrap('sqlite3_bind_text', 'number', ['number', 'number', 'number', 'number', 'number']);

  late final _def_sqlite3_bind_text16 _h_sqlite3_bind_text16 = _wasm
      .cwrap('sqlite3_bind_text16', 'number', ['number', 'number', 'number', 'number', 'number']);

  int bind_blob(PtrStmt arg1, int arg2, typed.Uint8List? arg3) {
    final arg3Meta = arg3?._metaNativeUint8();
    final ptrarg3 = arg3Meta?.ptr.address ?? 0;
    return _h_sqlite3_bind_blob(arg1.address, arg2, ptrarg3, arg3Meta?.length ?? 0, _ptrDestructor);
  }

  int bind_double(PtrStmt arg1, int arg2, double arg3) {
    return _h_sqlite3_bind_double(arg1.address, arg2, arg3);
  }

  int bind_int(PtrStmt arg1, int arg2, int arg3) {
    return _h_sqlite3_bind_int(arg1.address, arg2, arg3);
  }

  int bind_int64(PtrStmt arg1, int arg2, int arg3) {
    if (isBigInt) {
      return _h_sqlite3_bind_int64(arg1.address, arg2, JsBigIntCreator(arg3));
    } else {
      return bind_text(arg1, arg2, arg3.toString());
    }
  }

  int bind_null(PtrStmt arg1, int arg2) {
    return _h_sqlite3_bind_null(arg1.address, arg2);
  }

  int bind_text(PtrStmt arg1, int arg2, String? arg3) {
    final arg3Meta = arg3?._metaNativeUtf8();
    final ptrarg3 = arg3Meta?.ptr.address ?? 0;
    return _h_sqlite3_bind_text(arg1.address, arg2, ptrarg3, arg3Meta?.length ?? 0, _ptrDestructor);
  }

  int bind_text16(PtrStmt arg1, int arg2, String? arg3) {
    final arg3Meta = arg3?._metaNativeUtf16();
    final ptrarg3 = arg3Meta?.ptr.address ?? 0;
    return _h_sqlite3_bind_text16(
        arg1.address, arg2, ptrarg3, arg3Meta?.length ?? 0, _ptrDestructor);
  }
}
