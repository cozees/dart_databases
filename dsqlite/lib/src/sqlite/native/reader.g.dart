// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

typedef _c_sqlite3_column_blob = PtrVoid Function(PtrStmt, Nint32);
typedef _d_sqlite3_column_blob = PtrVoid Function(PtrStmt, int);
typedef _c_sqlite3_column_double = Ndouble Function(PtrStmt, Nint32);
typedef _d_sqlite3_column_double = double Function(PtrStmt, int);
typedef _c_sqlite3_column_int = Nint32 Function(PtrStmt, Nint32);
typedef _d_sqlite3_column_int = int Function(PtrStmt, int);
typedef _c_sqlite3_column_int64 = Nint64 Function(PtrStmt, Nint32);
typedef _d_sqlite3_column_int64 = int Function(PtrStmt, int);
typedef _c_sqlite3_column_text = PtrString Function(PtrStmt, Nint32);
typedef _d_sqlite3_column_text = PtrString Function(PtrStmt, int);
typedef _c_sqlite3_column_text16 = PtrString16 Function(PtrStmt, Nint32);
typedef _d_sqlite3_column_text16 = PtrString16 Function(PtrStmt, int);
typedef _c_sqlite3_column_bytes = Nint32 Function(PtrStmt, Nint32);
typedef _d_sqlite3_column_bytes = int Function(PtrStmt, int);
typedef _c_sqlite3_column_bytes16 = Nint32 Function(PtrStmt, Nint32);
typedef _d_sqlite3_column_bytes16 = int Function(PtrStmt, int);
typedef _c_sqlite3_column_type = Nint32 Function(PtrStmt, Nint32);
typedef _d_sqlite3_column_type = int Function(PtrStmt, int);
typedef _c_sqlite3_column_count = Nint32 Function(PtrStmt);
typedef _d_sqlite3_column_count = int Function(PtrStmt);
typedef _c_sqlite3_column_database_name = PtrString Function(PtrStmt, Nint32);
typedef _d_sqlite3_column_database_name = PtrString Function(PtrStmt, int);
typedef _c_sqlite3_column_database_name16 = PtrString16 Function(PtrStmt, Nint32);
typedef _d_sqlite3_column_database_name16 = PtrString16 Function(PtrStmt, int);
typedef _c_sqlite3_column_table_name = PtrString Function(PtrStmt, Nint32);
typedef _d_sqlite3_column_table_name = PtrString Function(PtrStmt, int);
typedef _c_sqlite3_column_table_name16 = PtrString16 Function(PtrStmt, Nint32);
typedef _d_sqlite3_column_table_name16 = PtrString16 Function(PtrStmt, int);
typedef _c_sqlite3_column_origin_name = PtrString Function(PtrStmt, Nint32);
typedef _d_sqlite3_column_origin_name = PtrString Function(PtrStmt, int);
typedef _c_sqlite3_column_origin_name16 = PtrString16 Function(PtrStmt, Nint32);
typedef _d_sqlite3_column_origin_name16 = PtrString16 Function(PtrStmt, int);
typedef _c_sqlite3_column_decltype = PtrString Function(PtrStmt, Nint32);
typedef _d_sqlite3_column_decltype = PtrString Function(PtrStmt, int);
typedef _c_sqlite3_column_decltype16 = PtrString16 Function(PtrStmt, Nint32);
typedef _d_sqlite3_column_decltype16 = PtrString16 Function(PtrStmt, int);
typedef _c_sqlite3_column_name = PtrString Function(PtrStmt, Nint32);
typedef _d_sqlite3_column_name = PtrString Function(PtrStmt, int);
typedef _c_sqlite3_column_name16 = PtrString16 Function(PtrStmt, Nint32);
typedef _d_sqlite3_column_name16 = PtrString16 Function(PtrStmt, int);
typedef _c_sqlite3_value_blob = PtrVoid Function(PtrValue);
typedef _d_sqlite3_value_blob = PtrVoid Function(PtrValue);
typedef _c_sqlite3_value_double = Ndouble Function(PtrValue);
typedef _d_sqlite3_value_double = double Function(PtrValue);
typedef _c_sqlite3_value_int = Nint32 Function(PtrValue);
typedef _d_sqlite3_value_int = int Function(PtrValue);
typedef _c_sqlite3_value_int64 = Nint64 Function(PtrValue);
typedef _d_sqlite3_value_int64 = int Function(PtrValue);
typedef _c_sqlite3_value_text = PtrString Function(PtrValue);
typedef _d_sqlite3_value_text = PtrString Function(PtrValue);
typedef _c_sqlite3_value_text16 = PtrString16 Function(PtrValue);
typedef _d_sqlite3_value_text16 = PtrString16 Function(PtrValue);
typedef _c_sqlite3_value_text16le = PtrVoid Function(PtrValue);
typedef _d_sqlite3_value_text16le = PtrVoid Function(PtrValue);
typedef _c_sqlite3_value_text16be = PtrVoid Function(PtrValue);
typedef _d_sqlite3_value_text16be = PtrVoid Function(PtrValue);
typedef _c_sqlite3_value_bytes = Nint32 Function(PtrValue);
typedef _d_sqlite3_value_bytes = int Function(PtrValue);
typedef _c_sqlite3_value_bytes16 = Nint32 Function(PtrValue);
typedef _d_sqlite3_value_bytes16 = int Function(PtrValue);
typedef _c_sqlite3_value_type = Nint32 Function(PtrValue);
typedef _d_sqlite3_value_type = int Function(PtrValue);
typedef _c_sqlite3_value_numeric_type = Nint32 Function(PtrValue);
typedef _d_sqlite3_value_numeric_type = int Function(PtrValue);
typedef _c_sqlite3_value_nochange = Nint32 Function(PtrValue);
typedef _d_sqlite3_value_nochange = int Function(PtrValue);
typedef _c_sqlite3_value_frombind = Nint32 Function(PtrValue);
typedef _d_sqlite3_value_frombind = int Function(PtrValue);
typedef _c_sqlite3_value_dup = PtrValue Function(PtrValue);
typedef _d_sqlite3_value_dup = PtrValue Function(PtrValue);
typedef _c_sqlite3_value_free = NVoid Function(PtrValue);
typedef _d_sqlite3_value_free = void Function(PtrValue);
typedef _c_sqlite3_value_subtype = Nuint32 Function(PtrValue);
typedef _d_sqlite3_value_subtype = int Function(PtrValue);

// Mixin for Reader
mixin _MixinReader on _SQLiteLibrary {
  late final _d_sqlite3_column_blob _h_sqlite3_column_blob =
      library.lookupFunction<_c_sqlite3_column_blob, _d_sqlite3_column_blob>('sqlite3_column_blob');

  late final _d_sqlite3_column_double _h_sqlite3_column_double = library
      .lookupFunction<_c_sqlite3_column_double, _d_sqlite3_column_double>('sqlite3_column_double');

  late final _d_sqlite3_column_int _h_sqlite3_column_int =
      library.lookupFunction<_c_sqlite3_column_int, _d_sqlite3_column_int>('sqlite3_column_int');

  late final _d_sqlite3_column_int64 _h_sqlite3_column_int64 = library
      .lookupFunction<_c_sqlite3_column_int64, _d_sqlite3_column_int64>('sqlite3_column_int64');

  late final _d_sqlite3_column_text _h_sqlite3_column_text =
      library.lookupFunction<_c_sqlite3_column_text, _d_sqlite3_column_text>('sqlite3_column_text');

  late final _d_sqlite3_column_text16 _h_sqlite3_column_text16 = library
      .lookupFunction<_c_sqlite3_column_text16, _d_sqlite3_column_text16>('sqlite3_column_text16');

  late final _d_sqlite3_column_bytes _h_sqlite3_column_bytes = library
      .lookupFunction<_c_sqlite3_column_bytes, _d_sqlite3_column_bytes>('sqlite3_column_bytes');

  late final _d_sqlite3_column_bytes16 _h_sqlite3_column_bytes16 =
      library.lookupFunction<_c_sqlite3_column_bytes16, _d_sqlite3_column_bytes16>(
          'sqlite3_column_bytes16');

  late final _d_sqlite3_column_type _h_sqlite3_column_type =
      library.lookupFunction<_c_sqlite3_column_type, _d_sqlite3_column_type>('sqlite3_column_type');

  late final _d_sqlite3_column_count _h_sqlite3_column_count = library
      .lookupFunction<_c_sqlite3_column_count, _d_sqlite3_column_count>('sqlite3_column_count');

  late final _d_sqlite3_column_database_name? _h_sqlite3_column_database_name = _nullable(() =>
      library.lookupFunction<_c_sqlite3_column_database_name, _d_sqlite3_column_database_name>(
          'sqlite3_column_database_name'));

  late final _d_sqlite3_column_database_name16? _h_sqlite3_column_database_name16 = _nullable(() =>
      library.lookupFunction<_c_sqlite3_column_database_name16, _d_sqlite3_column_database_name16>(
          'sqlite3_column_database_name16'));

  late final _d_sqlite3_column_table_name? _h_sqlite3_column_table_name = _nullable(() =>
      library.lookupFunction<_c_sqlite3_column_table_name, _d_sqlite3_column_table_name>(
          'sqlite3_column_table_name'));

  late final _d_sqlite3_column_table_name16? _h_sqlite3_column_table_name16 = _nullable(() =>
      library.lookupFunction<_c_sqlite3_column_table_name16, _d_sqlite3_column_table_name16>(
          'sqlite3_column_table_name16'));

  late final _d_sqlite3_column_origin_name? _h_sqlite3_column_origin_name = _nullable(() =>
      library.lookupFunction<_c_sqlite3_column_origin_name, _d_sqlite3_column_origin_name>(
          'sqlite3_column_origin_name'));

  late final _d_sqlite3_column_origin_name16? _h_sqlite3_column_origin_name16 = _nullable(() =>
      library.lookupFunction<_c_sqlite3_column_origin_name16, _d_sqlite3_column_origin_name16>(
          'sqlite3_column_origin_name16'));

  late final _d_sqlite3_column_decltype _h_sqlite3_column_decltype =
      library.lookupFunction<_c_sqlite3_column_decltype, _d_sqlite3_column_decltype>(
          'sqlite3_column_decltype');

  late final _d_sqlite3_column_decltype16 _h_sqlite3_column_decltype16 =
      library.lookupFunction<_c_sqlite3_column_decltype16, _d_sqlite3_column_decltype16>(
          'sqlite3_column_decltype16');

  late final _d_sqlite3_column_name _h_sqlite3_column_name =
      library.lookupFunction<_c_sqlite3_column_name, _d_sqlite3_column_name>('sqlite3_column_name');

  late final _d_sqlite3_column_name16 _h_sqlite3_column_name16 = library
      .lookupFunction<_c_sqlite3_column_name16, _d_sqlite3_column_name16>('sqlite3_column_name16');

  late final _d_sqlite3_value_blob _h_sqlite3_value_blob =
      library.lookupFunction<_c_sqlite3_value_blob, _d_sqlite3_value_blob>('sqlite3_value_blob');

  late final _d_sqlite3_value_double _h_sqlite3_value_double = library
      .lookupFunction<_c_sqlite3_value_double, _d_sqlite3_value_double>('sqlite3_value_double');

  late final _d_sqlite3_value_int _h_sqlite3_value_int =
      library.lookupFunction<_c_sqlite3_value_int, _d_sqlite3_value_int>('sqlite3_value_int');

  late final _d_sqlite3_value_int64 _h_sqlite3_value_int64 =
      library.lookupFunction<_c_sqlite3_value_int64, _d_sqlite3_value_int64>('sqlite3_value_int64');

  late final _d_sqlite3_value_text _h_sqlite3_value_text =
      library.lookupFunction<_c_sqlite3_value_text, _d_sqlite3_value_text>('sqlite3_value_text');

  late final _d_sqlite3_value_text16 _h_sqlite3_value_text16 = library
      .lookupFunction<_c_sqlite3_value_text16, _d_sqlite3_value_text16>('sqlite3_value_text16');

  late final _d_sqlite3_value_text16le _h_sqlite3_value_text16le =
      library.lookupFunction<_c_sqlite3_value_text16le, _d_sqlite3_value_text16le>(
          'sqlite3_value_text16le');

  late final _d_sqlite3_value_text16be _h_sqlite3_value_text16be =
      library.lookupFunction<_c_sqlite3_value_text16be, _d_sqlite3_value_text16be>(
          'sqlite3_value_text16be');

  late final _d_sqlite3_value_bytes _h_sqlite3_value_bytes =
      library.lookupFunction<_c_sqlite3_value_bytes, _d_sqlite3_value_bytes>('sqlite3_value_bytes');

  late final _d_sqlite3_value_bytes16 _h_sqlite3_value_bytes16 = library
      .lookupFunction<_c_sqlite3_value_bytes16, _d_sqlite3_value_bytes16>('sqlite3_value_bytes16');

  late final _d_sqlite3_value_type _h_sqlite3_value_type =
      library.lookupFunction<_c_sqlite3_value_type, _d_sqlite3_value_type>('sqlite3_value_type');

  late final _d_sqlite3_value_numeric_type _h_sqlite3_value_numeric_type =
      library.lookupFunction<_c_sqlite3_value_numeric_type, _d_sqlite3_value_numeric_type>(
          'sqlite3_value_numeric_type');

  late final _d_sqlite3_value_nochange? _h_sqlite3_value_nochange = libVersionNumber < 3022000
      ? null
      : library.lookupFunction<_c_sqlite3_value_nochange, _d_sqlite3_value_nochange>(
          'sqlite3_value_nochange');

  late final _d_sqlite3_value_frombind? _h_sqlite3_value_frombind = libVersionNumber < 3028000
      ? null
      : library.lookupFunction<_c_sqlite3_value_frombind, _d_sqlite3_value_frombind>(
          'sqlite3_value_frombind');

  late final _d_sqlite3_value_dup? _h_sqlite3_value_dup = libVersionNumber < 3008011
      ? null
      : library.lookupFunction<_c_sqlite3_value_dup, _d_sqlite3_value_dup>('sqlite3_value_dup');

  late final _d_sqlite3_value_free? _h_sqlite3_value_free = libVersionNumber < 3008011
      ? null
      : library.lookupFunction<_c_sqlite3_value_free, _d_sqlite3_value_free>('sqlite3_value_free');

  late final _d_sqlite3_value_subtype? _h_sqlite3_value_subtype = libVersionNumber < 3009000
      ? null
      : library.lookupFunction<_c_sqlite3_value_subtype, _d_sqlite3_value_subtype>(
          'sqlite3_value_subtype');

  typed.Uint8List? column_blob(PtrStmt arg1, int iCol) {
    var result = _h_sqlite3_column_blob(arg1, iCol);
    return result == ffi.nullptr
        ? null
        : result.cast<ffi.Uint8>().toUint8List(length: _h_sqlite3_column_bytes(arg1, iCol));
  }

  double column_double(PtrStmt arg1, int iCol) {
    return _h_sqlite3_column_double(arg1, iCol);
  }

  int column_int(PtrStmt arg1, int iCol) {
    return _h_sqlite3_column_int(arg1, iCol);
  }

  int column_int64(PtrStmt arg1, int iCol) {
    return _h_sqlite3_column_int64(arg1, iCol);
  }

  String? column_text(PtrStmt arg1, int iCol) {
    var result = _h_sqlite3_column_text(arg1, iCol);
    return result == ffi.nullptr
        ? null
        : result.toDartString(length: _h_sqlite3_column_bytes(arg1, iCol));
  }

  String? column_text16(PtrStmt arg1, int iCol) {
    var result = _h_sqlite3_column_text16(arg1, iCol);
    return result == ffi.nullptr
        ? null
        : result.toDartString(length: _h_sqlite3_column_bytes16(arg1, iCol) ~/ 2);
  }

  int column_bytes(PtrStmt arg1, int iCol) {
    return _h_sqlite3_column_bytes(arg1, iCol);
  }

  int column_bytes16(PtrStmt arg1, int iCol) {
    return _h_sqlite3_column_bytes16(arg1, iCol);
  }

  int column_type(PtrStmt arg1, int iCol) {
    return _h_sqlite3_column_type(arg1, iCol);
  }

  int column_count(PtrStmt pStmt) {
    return _h_sqlite3_column_count(pStmt);
  }

  String? column_database_name(PtrStmt arg1, int arg2) {
    PtrString result = ffi.nullptr;
    if (_h_sqlite3_column_database_name == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_column_database_name is not available, You need to enable it during library build.');
    }
    try {
      var result = _h_sqlite3_column_database_name!(arg1, arg2);
      return result == ffi.nullptr ? null : result.toDartString();
    } finally {
      pkgffi.malloc.free(result);
    }
  }

  String? column_database_name16(PtrStmt arg1, int arg2) {
    ffi.Pointer<pkgffi.Utf16> result = ffi.nullptr;
    if (_h_sqlite3_column_database_name16 == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_column_database_name16 is not available, You need to enable it during library build.');
    }
    try {
      var result = _h_sqlite3_column_database_name16!(arg1, arg2);
      return result == ffi.nullptr ? null : result.toDartString();
    } finally {
      pkgffi.malloc.free(result);
    }
  }

  String? column_table_name(PtrStmt arg1, int arg2) {
    PtrString result = ffi.nullptr;
    if (_h_sqlite3_column_table_name == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_column_table_name is not available, You need to enable it during library build.');
    }
    try {
      var result = _h_sqlite3_column_table_name!(arg1, arg2);
      return result == ffi.nullptr ? null : result.toDartString();
    } finally {
      pkgffi.malloc.free(result);
    }
  }

  String? column_table_name16(PtrStmt arg1, int arg2) {
    ffi.Pointer<pkgffi.Utf16> result = ffi.nullptr;
    if (_h_sqlite3_column_table_name16 == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_column_table_name16 is not available, You need to enable it during library build.');
    }
    try {
      var result = _h_sqlite3_column_table_name16!(arg1, arg2);
      return result == ffi.nullptr ? null : result.toDartString();
    } finally {
      pkgffi.malloc.free(result);
    }
  }

  String? column_origin_name(PtrStmt arg1, int arg2) {
    PtrString result = ffi.nullptr;
    if (_h_sqlite3_column_origin_name == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_column_origin_name is not available, You need to enable it during library build.');
    }
    try {
      var result = _h_sqlite3_column_origin_name!(arg1, arg2);
      return result == ffi.nullptr ? null : result.toDartString();
    } finally {
      pkgffi.malloc.free(result);
    }
  }

  String? column_origin_name16(PtrStmt arg1, int arg2) {
    ffi.Pointer<pkgffi.Utf16> result = ffi.nullptr;
    if (_h_sqlite3_column_origin_name16 == null) {
      throw dbsql.DatabaseException(
          'API sqlite3_column_origin_name16 is not available, You need to enable it during library build.');
    }
    try {
      var result = _h_sqlite3_column_origin_name16!(arg1, arg2);
      return result == ffi.nullptr ? null : result.toDartString();
    } finally {
      pkgffi.malloc.free(result);
    }
  }

  String? column_decltype(PtrStmt arg1, int arg2) {
    PtrString result = ffi.nullptr;
    try {
      var result = _h_sqlite3_column_decltype(arg1, arg2);
      return result == ffi.nullptr ? null : result.toDartString();
    } finally {
      pkgffi.malloc.free(result);
    }
  }

  String? column_decltype16(PtrStmt arg1, int arg2) {
    ffi.Pointer<pkgffi.Utf16> result = ffi.nullptr;
    try {
      var result = _h_sqlite3_column_decltype16(arg1, arg2);
      return result == ffi.nullptr ? null : result.toDartString();
    } finally {
      pkgffi.malloc.free(result);
    }
  }

  String? column_name(PtrStmt arg1, int N) {
    PtrString result = ffi.nullptr;
    try {
      var result = _h_sqlite3_column_name(arg1, N);
      return result == ffi.nullptr ? null : result.toDartString();
    } finally {
      pkgffi.malloc.free(result);
    }
  }

  String? column_name16(PtrStmt arg1, int N) {
    ffi.Pointer<pkgffi.Utf16> result = ffi.nullptr;
    try {
      var result = _h_sqlite3_column_name16(arg1, N);
      return result == ffi.nullptr ? null : result.toDartString();
    } finally {
      pkgffi.malloc.free(result);
    }
  }

  typed.Uint8List? value_blob(PtrValue arg1) {
    var result = _h_sqlite3_value_blob(arg1);
    return result == ffi.nullptr
        ? null
        : result.cast<ffi.Uint8>().toUint8List(length: _h_sqlite3_value_bytes(arg1));
  }

  double value_double(PtrValue arg1) {
    return _h_sqlite3_value_double(arg1);
  }

  int value_int(PtrValue arg1) {
    return _h_sqlite3_value_int(arg1);
  }

  int value_int64(PtrValue arg1) {
    return _h_sqlite3_value_int64(arg1);
  }

  String? value_text(PtrValue arg1) {
    var result = _h_sqlite3_value_text(arg1);
    return result == ffi.nullptr ? null : result.toDartString(length: _h_sqlite3_value_bytes(arg1));
  }

  String? value_text16(PtrValue arg1) {
    var result = _h_sqlite3_value_text16(arg1);
    return result == ffi.nullptr
        ? null
        : result.toDartString(length: _h_sqlite3_value_bytes16(arg1) ~/ 2);
  }

  PtrVoid? value_text16le(PtrValue arg1) {
    var result = _h_sqlite3_value_text16le(arg1);
    return result == ffi.nullptr ? null : result;
  }

  PtrVoid? value_text16be(PtrValue arg1) {
    var result = _h_sqlite3_value_text16be(arg1);
    return result == ffi.nullptr ? null : result;
  }

  int value_bytes(PtrValue arg1) {
    return _h_sqlite3_value_bytes(arg1);
  }

  int value_bytes16(PtrValue arg1) {
    return _h_sqlite3_value_bytes16(arg1);
  }

  int value_type(PtrValue arg1) {
    return _h_sqlite3_value_type(arg1);
  }

  int value_numeric_type(PtrValue arg1) {
    return _h_sqlite3_value_numeric_type(arg1);
  }

  int value_nochange(PtrValue arg1) {
    if (libVersionNumber < 3022000) {
      throw dbsql.DatabaseException('API sqlite3_value_nochange is not available before 3.22.0');
    }
    return _h_sqlite3_value_nochange!(arg1);
  }

  int value_frombind(PtrValue arg1) {
    if (libVersionNumber < 3028000) {
      throw dbsql.DatabaseException('API sqlite3_value_frombind is not available before 3.28.0');
    }
    return _h_sqlite3_value_frombind!(arg1);
  }

  PtrValue? value_dup(PtrValue arg1) {
    if (libVersionNumber < 3008011) {
      throw dbsql.DatabaseException('API sqlite3_value_dup is not available before 3.8.11');
    }
    var result = _h_sqlite3_value_dup!(arg1);
    return result == ffi.nullptr ? null : result;
  }

  void value_free(PtrValue arg1) {
    if (libVersionNumber < 3008011) {
      throw dbsql.DatabaseException('API sqlite3_value_free is not available before 3.8.11');
    }
    return _h_sqlite3_value_free!(arg1);
  }

  int value_subtype(PtrValue arg1) {
    if (libVersionNumber < 3009000) {
      throw dbsql.DatabaseException('API sqlite3_value_subtype is not available before 3.9.0');
    }
    return _h_sqlite3_value_subtype!(arg1);
  }
}
