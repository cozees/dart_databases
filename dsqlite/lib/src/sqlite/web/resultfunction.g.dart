// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

typedef _def_sqlite3_result_blob = void Function(int, int, int, int);
typedef _def_sqlite3_result_double = void Function(int, double);
typedef _def_sqlite3_result_error = void Function(int, int, int);
typedef _def_sqlite3_result_error16 = void Function(int, int, int);
typedef _def_sqlite3_result_error_toobig = void Function(int);
typedef _def_sqlite3_result_error_nomem = void Function(int);
typedef _def_sqlite3_result_error_code = void Function(int, int);
typedef _def_sqlite3_result_int = void Function(int, int);
typedef _def_sqlite3_result_int64 = void Function(int, dynamic);
typedef _def_sqlite3_result_null = void Function(int);
typedef _def_sqlite3_result_text = void Function(int, int, int, int);
typedef _def_sqlite3_result_text16 = void Function(int, int, int, int);

// Mixin for ResultFunction
mixin _MixinResultFunction on _SQLiteLibrary {
  late final _def_sqlite3_result_blob _h_sqlite3_result_blob =
      _wasm.cwrap('sqlite3_result_blob', 'number', ['number', 'number', 'number', 'number']);

  late final _def_sqlite3_result_double _h_sqlite3_result_double =
      _wasm.cwrap('sqlite3_result_double', 'number', ['number', 'number']);

  late final _def_sqlite3_result_error _h_sqlite3_result_error =
      _wasm.cwrap('sqlite3_result_error', 'number', ['number', 'number', 'number']);

  late final _def_sqlite3_result_error16 _h_sqlite3_result_error16 =
      _wasm.cwrap('sqlite3_result_error16', 'number', ['number', 'number', 'number']);

  late final _def_sqlite3_result_error_toobig _h_sqlite3_result_error_toobig =
      _wasm.cwrap('sqlite3_result_error_toobig', 'number', ['number']);

  late final _def_sqlite3_result_error_nomem _h_sqlite3_result_error_nomem =
      _wasm.cwrap('sqlite3_result_error_nomem', 'number', ['number']);

  late final _def_sqlite3_result_error_code? _h_sqlite3_result_error_code =
      libVersionNumber < 3005006
          ? null
          : _wasm.cwrap('sqlite3_result_error_code', 'number', ['number', 'number']);

  late final _def_sqlite3_result_int _h_sqlite3_result_int =
      _wasm.cwrap('sqlite3_result_int', 'number', ['number', 'number']);

  late final _def_sqlite3_result_int64 _h_sqlite3_result_int64 =
      _wasm.cwrap('sqlite3_result_int64', 'number', ['number', 'number']);

  late final _def_sqlite3_result_null _h_sqlite3_result_null =
      _wasm.cwrap('sqlite3_result_null', 'number', ['number']);

  late final _def_sqlite3_result_text _h_sqlite3_result_text =
      _wasm.cwrap('sqlite3_result_text', 'number', ['number', 'number', 'number', 'number']);

  late final _def_sqlite3_result_text16 _h_sqlite3_result_text16 =
      _wasm.cwrap('sqlite3_result_text16', 'number', ['number', 'number', 'number', 'number']);

  void result_blob(PtrContext arg1, typed.Uint8List arg2) {
    final arg2Meta = arg2._metaNativeUint8();
    final ptrarg2 = arg2Meta.ptr.address;
    return _h_sqlite3_result_blob(arg1.address, ptrarg2, arg2Meta.length, _ptrDestructor);
  }

  void result_double(PtrContext arg1, double arg2) {
    return _h_sqlite3_result_double(arg1.address, arg2);
  }

  void result_error(PtrContext arg1, String arg2) {
    final arg2Meta = arg2._metaNativeUtf8();
    final ptrarg2 = arg2Meta.ptr.address;
    try {
      return _h_sqlite3_result_error(arg1.address, ptrarg2, arg2Meta.length);
    } finally {
      _wasm._free(ptrarg2);
    }
  }

  void result_error16(PtrContext arg1, String arg2) {
    final arg2Meta = arg2._metaNativeUtf16();
    final ptrarg2 = arg2Meta.ptr.address;
    try {
      return _h_sqlite3_result_error16(arg1.address, ptrarg2, arg2Meta.length);
    } finally {
      _wasm._free(ptrarg2);
    }
  }

  void result_error_toobig(PtrContext arg1) {
    return _h_sqlite3_result_error_toobig(arg1.address);
  }

  void result_error_nomem(PtrContext arg1) {
    return _h_sqlite3_result_error_nomem(arg1.address);
  }

  void result_error_code(PtrContext arg1, int arg2) {
    if (_h_sqlite3_result_error_code == null) {
      throw dbsql.DatabaseException('API sqlite3_result_error_code is not available before 3.5.6');
    }
    return _h_sqlite3_result_error_code!(arg1.address, arg2);
  }

  void result_int(PtrContext arg1, int arg2) {
    return _h_sqlite3_result_int(arg1.address, arg2);
  }

  void result_int64(PtrContext arg1, int arg2) {
    if (isBigInt) {
      return _h_sqlite3_result_int64(arg1.address, JsBigIntCreator(arg2));
    } else {
      return result_text(arg1, arg2.toString());
    }
  }

  void result_null(PtrContext arg1) {
    return _h_sqlite3_result_null(arg1.address);
  }

  void result_text(PtrContext arg1, String arg2) {
    final arg2Meta = arg2._metaNativeUtf8();
    final ptrarg2 = arg2Meta.ptr.address;
    return _h_sqlite3_result_text(arg1.address, ptrarg2, arg2Meta.length, _ptrDestructor);
  }

  void result_text16(PtrContext arg1, String arg2) {
    final arg2Meta = arg2._metaNativeUtf16();
    final ptrarg2 = arg2Meta.ptr.address;
    return _h_sqlite3_result_text16(arg1.address, ptrarg2, arg2Meta.length, _ptrDestructor);
  }
}
