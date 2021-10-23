// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

typedef _c_sqlite3_result_blob = NVoid Function(PtrContext, PtrVoid, Nint32, PtrDefxFree);
typedef _d_sqlite3_result_blob = void Function(PtrContext, PtrVoid, int, PtrDefxFree);
typedef _c_sqlite3_result_blob64 = NVoid Function(PtrContext, PtrVoid, Nuint64, PtrDefxFree);
typedef _d_sqlite3_result_blob64 = void Function(PtrContext, PtrVoid, int, PtrDefxFree);
typedef _c_sqlite3_result_double = NVoid Function(PtrContext, Ndouble);
typedef _d_sqlite3_result_double = void Function(PtrContext, double);
typedef _c_sqlite3_result_error = NVoid Function(PtrContext, PtrString, Nint32);
typedef _d_sqlite3_result_error = void Function(PtrContext, PtrString, int);
typedef _c_sqlite3_result_error16 = NVoid Function(PtrContext, PtrString16, Nint32);
typedef _d_sqlite3_result_error16 = void Function(PtrContext, PtrString16, int);
typedef _c_sqlite3_result_error_toobig = NVoid Function(PtrContext);
typedef _d_sqlite3_result_error_toobig = void Function(PtrContext);
typedef _c_sqlite3_result_error_nomem = NVoid Function(PtrContext);
typedef _d_sqlite3_result_error_nomem = void Function(PtrContext);
typedef _c_sqlite3_result_error_code = NVoid Function(PtrContext, Nint32);
typedef _d_sqlite3_result_error_code = void Function(PtrContext, int);
typedef _c_sqlite3_result_int = NVoid Function(PtrContext, Nint32);
typedef _d_sqlite3_result_int = void Function(PtrContext, int);
typedef _c_sqlite3_result_int64 = NVoid Function(PtrContext, Nint64);
typedef _d_sqlite3_result_int64 = void Function(PtrContext, int);
typedef _c_sqlite3_result_null = NVoid Function(PtrContext);
typedef _d_sqlite3_result_null = void Function(PtrContext);
typedef _c_sqlite3_result_text = NVoid Function(PtrContext, PtrString, Nint32, PtrDefxFree);
typedef _d_sqlite3_result_text = void Function(PtrContext, PtrString, int, PtrDefxFree);
typedef _c_sqlite3_result_text64 = NVoid Function(
    PtrContext, ffi.Pointer<ffi.Uint8>, Nuint64, PtrDefxFree, Nuint8);
typedef _d_sqlite3_result_text64 = void Function(
    PtrContext, ffi.Pointer<ffi.Uint8>, int, PtrDefxFree, int);
typedef _c_sqlite3_result_text16 = NVoid Function(PtrContext, PtrString16, Nint32, PtrDefxFree);
typedef _d_sqlite3_result_text16 = void Function(PtrContext, PtrString16, int, PtrDefxFree);
typedef _c_sqlite3_result_text16le = NVoid Function(PtrContext, PtrVoid, Nint32, PtrDefxFree);
typedef _d_sqlite3_result_text16le = void Function(PtrContext, PtrVoid, int, PtrDefxFree);
typedef _c_sqlite3_result_text16be = NVoid Function(PtrContext, PtrVoid, Nint32, PtrDefxFree);
typedef _d_sqlite3_result_text16be = void Function(PtrContext, PtrVoid, int, PtrDefxFree);
typedef _c_sqlite3_result_zeroblob = NVoid Function(PtrContext, Nint32);
typedef _d_sqlite3_result_zeroblob = void Function(PtrContext, int);
typedef _c_sqlite3_result_zeroblob64 = Nint32 Function(PtrContext, Nuint64);
typedef _d_sqlite3_result_zeroblob64 = int Function(PtrContext, int);
typedef _c_sqlite3_result_subtype = NVoid Function(PtrContext, Nuint32);
typedef _d_sqlite3_result_subtype = void Function(PtrContext, int);

// Mixin for ResultFunction
mixin _MixinResultFunction on _SQLiteLibrary {
  late final _d_sqlite3_result_blob _h_sqlite3_result_blob =
      library.lookupFunction<_c_sqlite3_result_blob, _d_sqlite3_result_blob>('sqlite3_result_blob');

  late final _d_sqlite3_result_blob64? _h_sqlite3_result_blob64 = libVersionNumber < 3008007
      ? null
      : library.lookupFunction<_c_sqlite3_result_blob64, _d_sqlite3_result_blob64>(
          'sqlite3_result_blob64');

  late final _d_sqlite3_result_double _h_sqlite3_result_double = library
      .lookupFunction<_c_sqlite3_result_double, _d_sqlite3_result_double>('sqlite3_result_double');

  late final _d_sqlite3_result_error _h_sqlite3_result_error = library
      .lookupFunction<_c_sqlite3_result_error, _d_sqlite3_result_error>('sqlite3_result_error');

  late final _d_sqlite3_result_error16 _h_sqlite3_result_error16 =
      library.lookupFunction<_c_sqlite3_result_error16, _d_sqlite3_result_error16>(
          'sqlite3_result_error16');

  late final _d_sqlite3_result_error_toobig _h_sqlite3_result_error_toobig =
      library.lookupFunction<_c_sqlite3_result_error_toobig, _d_sqlite3_result_error_toobig>(
          'sqlite3_result_error_toobig');

  late final _d_sqlite3_result_error_nomem _h_sqlite3_result_error_nomem =
      library.lookupFunction<_c_sqlite3_result_error_nomem, _d_sqlite3_result_error_nomem>(
          'sqlite3_result_error_nomem');

  late final _d_sqlite3_result_error_code? _h_sqlite3_result_error_code = libVersionNumber < 3005006
      ? null
      : library.lookupFunction<_c_sqlite3_result_error_code, _d_sqlite3_result_error_code>(
          'sqlite3_result_error_code');

  late final _d_sqlite3_result_int _h_sqlite3_result_int =
      library.lookupFunction<_c_sqlite3_result_int, _d_sqlite3_result_int>('sqlite3_result_int');

  late final _d_sqlite3_result_int64 _h_sqlite3_result_int64 = library
      .lookupFunction<_c_sqlite3_result_int64, _d_sqlite3_result_int64>('sqlite3_result_int64');

  late final _d_sqlite3_result_null _h_sqlite3_result_null =
      library.lookupFunction<_c_sqlite3_result_null, _d_sqlite3_result_null>('sqlite3_result_null');

  late final _d_sqlite3_result_text _h_sqlite3_result_text =
      library.lookupFunction<_c_sqlite3_result_text, _d_sqlite3_result_text>('sqlite3_result_text');

  late final _d_sqlite3_result_text64? _h_sqlite3_result_text64 = libVersionNumber < 3008007
      ? null
      : library.lookupFunction<_c_sqlite3_result_text64, _d_sqlite3_result_text64>(
          'sqlite3_result_text64');

  late final _d_sqlite3_result_text16 _h_sqlite3_result_text16 = library
      .lookupFunction<_c_sqlite3_result_text16, _d_sqlite3_result_text16>('sqlite3_result_text16');

  late final _d_sqlite3_result_text16le _h_sqlite3_result_text16le =
      library.lookupFunction<_c_sqlite3_result_text16le, _d_sqlite3_result_text16le>(
          'sqlite3_result_text16le');

  late final _d_sqlite3_result_text16be _h_sqlite3_result_text16be =
      library.lookupFunction<_c_sqlite3_result_text16be, _d_sqlite3_result_text16be>(
          'sqlite3_result_text16be');

  late final _d_sqlite3_result_zeroblob _h_sqlite3_result_zeroblob =
      library.lookupFunction<_c_sqlite3_result_zeroblob, _d_sqlite3_result_zeroblob>(
          'sqlite3_result_zeroblob');

  late final _d_sqlite3_result_zeroblob64? _h_sqlite3_result_zeroblob64 = libVersionNumber < 3008011
      ? null
      : library.lookupFunction<_c_sqlite3_result_zeroblob64, _d_sqlite3_result_zeroblob64>(
          'sqlite3_result_zeroblob64');

  late final _d_sqlite3_result_subtype? _h_sqlite3_result_subtype = libVersionNumber < 3009000
      ? null
      : library.lookupFunction<_c_sqlite3_result_subtype, _d_sqlite3_result_subtype>(
          'sqlite3_result_subtype');

  void result_blob(PtrContext arg1, typed.Uint8List arg2) {
    final arg2Meta = arg2._metaNativeUint8();
    final ptrArg2 = arg2Meta.ptr;
    return _h_sqlite3_result_blob(arg1, ptrArg2, arg2Meta.length, _ptrDestructor);
  }

  void result_blob64(PtrContext arg1, typed.Uint8List arg2) {
    if (libVersionNumber < 3008007) {
      throw dbsql.DatabaseException('API sqlite3_result_blob64 is not available before 3.8.7');
    }
    final arg2Meta = arg2._metaNativeUint8();
    final ptrArg2 = arg2Meta.ptr;
    return _h_sqlite3_result_blob64!(arg1, ptrArg2, arg2Meta.length, _ptrDestructor);
  }

  void result_double(PtrContext arg1, double arg2) {
    return _h_sqlite3_result_double(arg1, arg2);
  }

  void result_error(PtrContext arg1, String arg2) {
    final arg2Meta = arg2._metaNativeUtf8();
    final ptrArg2 = arg2Meta.ptr;
    try {
      return _h_sqlite3_result_error(arg1, ptrArg2, arg2Meta.length);
    } finally {
      pkgffi.malloc.free(ptrArg2);
    }
  }

  void result_error16(PtrContext arg1, String arg2) {
    final arg2Meta = arg2._metaNativeUtf16();
    final ptrArg2 = arg2Meta.ptr;
    try {
      return _h_sqlite3_result_error16(arg1, ptrArg2, arg2Meta.length);
    } finally {
      pkgffi.malloc.free(ptrArg2);
    }
  }

  void result_error_toobig(PtrContext arg1) {
    return _h_sqlite3_result_error_toobig(arg1);
  }

  void result_error_nomem(PtrContext arg1) {
    return _h_sqlite3_result_error_nomem(arg1);
  }

  void result_error_code(PtrContext arg1, int arg2) {
    if (libVersionNumber < 3005006) {
      throw dbsql.DatabaseException('API sqlite3_result_error_code is not available before 3.5.6');
    }
    return _h_sqlite3_result_error_code!(arg1, arg2);
  }

  void result_int(PtrContext arg1, int arg2) {
    return _h_sqlite3_result_int(arg1, arg2);
  }

  void result_int64(PtrContext arg1, int arg2) {
    return _h_sqlite3_result_int64(arg1, arg2);
  }

  void result_null(PtrContext arg1) {
    return _h_sqlite3_result_null(arg1);
  }

  void result_text(PtrContext arg1, String arg2) {
    final arg2Meta = arg2._metaNativeUtf8();
    final ptrArg2 = arg2Meta.ptr;
    return _h_sqlite3_result_text(arg1, ptrArg2, arg2Meta.length, _ptrDestructor);
  }

  void result_text64(PtrContext arg1, String arg2, int encoding) {
    if (libVersionNumber < 3008007) {
      throw dbsql.DatabaseException('API sqlite3_result_text64 is not available before 3.8.7');
    }
    final arg2Meta = encoding == _i1.UTF8 ? arg2._metaNativeUtf8() : arg2._metaNativeUtf16();
    final ptrArg2 = arg2Meta.ptr;
    return _h_sqlite3_result_text64!(
        arg1, ptrArg2.cast(), arg2Meta.length, _ptrDestructor, encoding);
  }

  void result_text16(PtrContext arg1, String arg2) {
    final arg2Meta = arg2._metaNativeUtf16();
    final ptrArg2 = arg2Meta.ptr;
    return _h_sqlite3_result_text16(arg1, ptrArg2, arg2Meta.length, _ptrDestructor);
  }

  void result_text16le(PtrContext arg1, PtrVoid arg2, int arg3, PtrDefxFree ptrDefxFree) {
    return _h_sqlite3_result_text16le(arg1, arg2, arg3, ptrDefxFree);
  }

  void result_text16be(PtrContext arg1, PtrVoid arg2, int arg3, PtrDefxFree ptrDefxFree) {
    return _h_sqlite3_result_text16be(arg1, arg2, arg3, ptrDefxFree);
  }

  void result_zeroblob(PtrContext arg1, int n) {
    return _h_sqlite3_result_zeroblob(arg1, n);
  }

  int result_zeroblob64(PtrContext arg1, int n) {
    if (libVersionNumber < 3008011) {
      throw dbsql.DatabaseException('API sqlite3_result_zeroblob64 is not available before 3.8.11');
    }
    return _h_sqlite3_result_zeroblob64!(arg1, n);
  }

  void result_subtype(PtrContext arg1, int arg2) {
    if (libVersionNumber < 3009000) {
      throw dbsql.DatabaseException('API sqlite3_result_subtype is not available before 3.9.0');
    }
    return _h_sqlite3_result_subtype!(arg1, arg2);
  }
}
