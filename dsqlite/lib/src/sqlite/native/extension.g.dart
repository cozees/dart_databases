// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

/// Extension method for converting a [Uint8List] to a `Pointer<Void>`.
extension BinaryBlobPointer on typed.Uint8List {
  /// Creates a byte array from this Uint8List.
  ///
  /// If [zeroTerminate] is true then the method will return a C pointer to a byte array that include single NUL at the end.
  ffi.Pointer<ffi.Void> toNative(
          {ffi.Allocator allocator = pkgffi.malloc, bool zeroTerminate = false}) =>
      _toNative(false, allocator, zeroTerminate);
// Use internally.
  _PtrMeta<ffi.Void> _metaNativeUint8({ffi.Allocator allocator = pkgffi.malloc}) =>
      _toNative(true, allocator, true);
// convert dart Uint8List to c pointer Uint8 internally.
  T _toNative<T>(bool meta, ffi.Allocator allocator, bool zeroTerminate) {
    final size = zeroTerminate ? length + 1 : length;
    final result = allocator<ffi.Uint8>(size);
    final typed.Uint8List native = result.asTypedList(size);
    native.setAll(0, this);
    if (zeroTerminate) {
      native[length] = 0;
    }
    return meta ? (_PtrMeta(length, result.cast<ffi.Void>()) as T) : (result.cast<ffi.Void>() as T);
  }
}

/// Extension method for converting a`Pointer<Void>` to a [Uint8List].
extension BlobPointer on ffi.Pointer<ffi.Uint8> {
  /// The number of byte that is zero-terminated.
  int get length {
    _ensureNotNullptr('length');
    return _length(this);
  }

  typed.Uint8List toUint8List({int? length}) {
    _ensureNotNullptr('toUint8List');
    if (length != null) {
      RangeError.checkNotNegative(length, 'length');
    } else {
      length = _length(this);
    }
    return asTypedList(length);
  }

  static int _length(ffi.Pointer<ffi.Uint8> units) {
    var length = 0;
    while (units[length] != 0) {
      length++;
    }
    return length;
  }

  void _ensureNotNullptr(String operation) {
    if (this == ffi.nullptr) {
      throw UnsupportedError('Operation $operation not allowed on a \'nullptr\'.');
    }
  }
}

extension _StringMetaUtf8Pointer on String {
  _PtrMeta<pkgffi.Utf8> _metaNativeUtf8() {
    final units = conv.utf8.encode(this);
    final result = pkgffi.malloc<ffi.Uint8>(units.length + 1);
    final nativeString = result.asTypedList(units.length + 1);
    nativeString.setAll(0, units);
    nativeString[units.length] = 0;
    return _PtrMeta(length, result.cast());
  }
}

extension _StringMetaUtf16Pointer on String {
  _PtrMeta<pkgffi.Utf16> _metaNativeUtf16() {
    final units = codeUnits;
    final result = pkgffi.malloc<ffi.Uint16>(units.length + 1);
    final nativeString = result.asTypedList(units.length + 1);
    nativeString.setRange(0, units.length, units);
    nativeString[units.length] = 0;
    return _PtrMeta(units.length * 2, result.cast());
  }
}
