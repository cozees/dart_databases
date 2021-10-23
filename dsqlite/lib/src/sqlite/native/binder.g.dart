// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

typedef _c_sqlite3_bind_blob = Nint32 Function(PtrStmt, Nint32, PtrVoid, Nint32, PtrDefxFree);
typedef _d_sqlite3_bind_blob = int Function(PtrStmt, int, PtrVoid, int, PtrDefxFree);
typedef _c_sqlite3_bind_blob64 = Nint32 Function(PtrStmt, Nint32, PtrVoid, Nuint64, PtrDefxFree);
typedef _d_sqlite3_bind_blob64 = int Function(PtrStmt, int, PtrVoid, int, PtrDefxFree);
typedef _c_sqlite3_bind_double = Nint32 Function(PtrStmt, Nint32, Ndouble);
typedef _d_sqlite3_bind_double = int Function(PtrStmt, int, double);
typedef _c_sqlite3_bind_int = Nint32 Function(PtrStmt, Nint32, Nint32);
typedef _d_sqlite3_bind_int = int Function(PtrStmt, int, int);
typedef _c_sqlite3_bind_int64 = Nint32 Function(PtrStmt, Nint32, Nint64);
typedef _d_sqlite3_bind_int64 = int Function(PtrStmt, int, int);
typedef _c_sqlite3_bind_null = Nint32 Function(PtrStmt, Nint32);
typedef _d_sqlite3_bind_null = int Function(PtrStmt, int);
typedef _c_sqlite3_bind_text = Nint32 Function(PtrStmt, Nint32, PtrString, Nint32, PtrDefxFree);
typedef _d_sqlite3_bind_text = int Function(PtrStmt, int, PtrString, int, PtrDefxFree);
typedef _c_sqlite3_bind_text16 = Nint32 Function(PtrStmt, Nint32, PtrString16, Nint32, PtrDefxFree);
typedef _d_sqlite3_bind_text16 = int Function(PtrStmt, int, PtrString16, int, PtrDefxFree);
typedef _c_sqlite3_bind_text64 = Nint32 Function(
    PtrStmt, Nint32, ffi.Pointer<ffi.Uint8>, Nuint64, PtrDefxFree, Nuint8);
typedef _d_sqlite3_bind_text64 = int Function(
    PtrStmt, int, ffi.Pointer<ffi.Uint8>, int, PtrDefxFree, int);
typedef _c_sqlite3_bind_zeroblob = Nint32 Function(PtrStmt, Nint32, Nint32);
typedef _d_sqlite3_bind_zeroblob = int Function(PtrStmt, int, int);
typedef _c_sqlite3_bind_zeroblob64 = Nint32 Function(PtrStmt, Nint32, Nuint64);
typedef _d_sqlite3_bind_zeroblob64 = int Function(PtrStmt, int, int);

// Mixin for Binder
mixin _MixinBinder on _SQLiteLibrary {
  late final _d_sqlite3_bind_blob _h_sqlite3_bind_blob =
      library.lookupFunction<_c_sqlite3_bind_blob, _d_sqlite3_bind_blob>('sqlite3_bind_blob');

  late final _d_sqlite3_bind_blob64? _h_sqlite3_bind_blob64 = libVersionNumber < 3008007
      ? null
      : library
          .lookupFunction<_c_sqlite3_bind_blob64, _d_sqlite3_bind_blob64>('sqlite3_bind_blob64');

  late final _d_sqlite3_bind_double _h_sqlite3_bind_double =
      library.lookupFunction<_c_sqlite3_bind_double, _d_sqlite3_bind_double>('sqlite3_bind_double');

  late final _d_sqlite3_bind_int _h_sqlite3_bind_int =
      library.lookupFunction<_c_sqlite3_bind_int, _d_sqlite3_bind_int>('sqlite3_bind_int');

  late final _d_sqlite3_bind_int64 _h_sqlite3_bind_int64 =
      library.lookupFunction<_c_sqlite3_bind_int64, _d_sqlite3_bind_int64>('sqlite3_bind_int64');

  late final _d_sqlite3_bind_null _h_sqlite3_bind_null =
      library.lookupFunction<_c_sqlite3_bind_null, _d_sqlite3_bind_null>('sqlite3_bind_null');

  late final _d_sqlite3_bind_text _h_sqlite3_bind_text =
      library.lookupFunction<_c_sqlite3_bind_text, _d_sqlite3_bind_text>('sqlite3_bind_text');

  late final _d_sqlite3_bind_text16 _h_sqlite3_bind_text16 =
      library.lookupFunction<_c_sqlite3_bind_text16, _d_sqlite3_bind_text16>('sqlite3_bind_text16');

  late final _d_sqlite3_bind_text64? _h_sqlite3_bind_text64 = libVersionNumber < 3008007
      ? null
      : library
          .lookupFunction<_c_sqlite3_bind_text64, _d_sqlite3_bind_text64>('sqlite3_bind_text64');

  late final _d_sqlite3_bind_zeroblob? _h_sqlite3_bind_zeroblob = libVersionNumber < 3004000
      ? null
      : library.lookupFunction<_c_sqlite3_bind_zeroblob, _d_sqlite3_bind_zeroblob>(
          'sqlite3_bind_zeroblob');

  late final _d_sqlite3_bind_zeroblob64? _h_sqlite3_bind_zeroblob64 = libVersionNumber < 3008011
      ? null
      : library.lookupFunction<_c_sqlite3_bind_zeroblob64, _d_sqlite3_bind_zeroblob64>(
          'sqlite3_bind_zeroblob64');

  int bind_blob(PtrStmt arg1, int arg2, typed.Uint8List? arg3) {
    final arg3Meta = arg3?._metaNativeUint8();
    final ptrArg3 = arg3Meta?.ptr ?? ffi.nullptr;
    return _h_sqlite3_bind_blob(arg1, arg2, ptrArg3, arg3Meta?.length ?? 0, _ptrDestructor);
  }

  int bind_blob64(PtrStmt arg1, int arg2, typed.Uint8List? arg3) {
    if (libVersionNumber < 3008007) {
      throw dbsql.DatabaseException('API sqlite3_bind_blob64 is not available before 3.8.7');
    }
    final arg3Meta = arg3?._metaNativeUint8();
    final ptrArg3 = arg3Meta?.ptr ?? ffi.nullptr;
    return _h_sqlite3_bind_blob64!(arg1, arg2, ptrArg3, arg3Meta?.length ?? 0, _ptrDestructor);
  }

  int bind_double(PtrStmt arg1, int arg2, double arg3) {
    return _h_sqlite3_bind_double(arg1, arg2, arg3);
  }

  int bind_int(PtrStmt arg1, int arg2, int arg3) {
    return _h_sqlite3_bind_int(arg1, arg2, arg3);
  }

  int bind_int64(PtrStmt arg1, int arg2, int arg3) {
    return _h_sqlite3_bind_int64(arg1, arg2, arg3);
  }

  int bind_null(PtrStmt arg1, int arg2) {
    return _h_sqlite3_bind_null(arg1, arg2);
  }

  int bind_text(PtrStmt arg1, int arg2, String? arg3) {
    final arg3Meta = arg3?._metaNativeUtf8();
    final ptrArg3 = arg3Meta?.ptr ?? ffi.nullptr;
    return _h_sqlite3_bind_text(arg1, arg2, ptrArg3, arg3Meta?.length ?? 0, _ptrDestructor);
  }

  int bind_text16(PtrStmt arg1, int arg2, String? arg3) {
    final arg3Meta = arg3?._metaNativeUtf16();
    final ptrArg3 = arg3Meta?.ptr ?? ffi.nullptr;
    return _h_sqlite3_bind_text16(arg1, arg2, ptrArg3, arg3Meta?.length ?? 0, _ptrDestructor);
  }

  int bind_text64(PtrStmt arg1, int arg2, String? arg3, int encoding) {
    if (libVersionNumber < 3008007) {
      throw dbsql.DatabaseException('API sqlite3_bind_text64 is not available before 3.8.7');
    }
    final arg3Meta = encoding == _i1.UTF8 ? arg3?._metaNativeUtf8() : arg3?._metaNativeUtf16();
    final ptrArg3 = arg3Meta?.ptr ?? ffi.nullptr;
    return _h_sqlite3_bind_text64!(
        arg1, arg2, ptrArg3.cast(), arg3Meta?.length ?? 0, _ptrDestructor, encoding);
  }

  int bind_zeroblob(PtrStmt arg1, int arg2, int n) {
    if (libVersionNumber < 3004000) {
      throw dbsql.DatabaseException('API sqlite3_bind_zeroblob is not available before 3.4.0');
    }
    return _h_sqlite3_bind_zeroblob!(arg1, arg2, n);
  }

  int bind_zeroblob64(PtrStmt arg1, int arg2, int arg3) {
    if (libVersionNumber < 3008011) {
      throw dbsql.DatabaseException('API sqlite3_bind_zeroblob64 is not available before 3.8.11');
    }
    return _h_sqlite3_bind_zeroblob64!(arg1, arg2, arg3);
  }
}
