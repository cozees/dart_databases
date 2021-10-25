part of 'library.g.dart';

/// mirror dart:ffi malloc
const malloc = Allocator._();

class Allocator {
  const Allocator._();

  Pointer<T> allocate<T extends NativeType>(int byteCount, {int? alignment}) =>
      Pointer.fromAddress(_wasm._malloc(byteCount));

  void free(Pointer pointer) => free(pointer);
}

/// Mirror dart:ffi Allocator
extension AllocatorAlloc on Allocator {
  Pointer<T> call<T extends NativeType>([int count = 1]) {
    if (T == Int8 || T == Uint8 || T == Utf8) return Pointer.fromAddress(_wasm._malloc(1 * count));
    if (T == Int16 || T == Uint16 || T == Utf16)
      return Pointer.fromAddress(_wasm._malloc(2 * count));
    if (T == Int32 || T == Uint32) return Pointer.fromAddress(_wasm._malloc(4 * count));
    if (T == Int64 || T == Uint64) return Pointer.fromAddress(_wasm._malloc(8 * count));
    if (T == Float) return Pointer.fromAddress(_wasm._malloc(4 * count));
    if (T == Double) return Pointer.fromAddress(_wasm._malloc(8 * count));
    // browser 32bit pointer
    // hacked we can't check type generic T is Pointer is not work as T has generic type.
    // T = Pointer<?> is not possible
    final at = T.toString();
    assert(at.startsWith('Pointer<') && at.endsWith('>'),
        'Malloc allocation only support allocate scalar type or pointer only.');
    return Pointer<T>.fromAddress(_wasm._malloc(4));
  }
}

/// free native allocated memory
free(Pointer ptr) => _wasm._free(ptr.address);

const Pointer<Never> nullptr = Pointer.fromAddress(0);

/// replicate dart:ffi Pointer
class Pointer<T extends NativeType> extends NativeType {
  const Pointer.fromAddress(this.address);

  /// Mirror dart:ffi `Pointer.fromAddress` the object [exceptionalReturn] is only compatible with
  /// dart:ffi signature however We does not use it.
  static Pointer<NativeFunction<T>> fromFunction<T extends Function>(Function f,
      [Object? exceptionalReturn]) {
    final funcMeta = _funcWasmMeta[f.runtimeType]!;
    if (funcMeta.wrapper != null) f = funcMeta.wrapper!(f);
    return Pointer.fromAddress(_wasm.addFunction(pkgjs.allowInterop(f), funcMeta.meta).toInt());
  }

  final int address;

  bool get isNull => address == 0;

  Pointer<R> cast<R extends NativeType>() => Pointer<R>.fromAddress(address);

  @override
  int get hashCode => address.hashCode;

  @override
  bool operator ==(covariant Pointer other) => address == other.address;
}

/// utility to read Pointer of a Pointer
extension PointerPointer<T extends NativeType> on Pointer<Pointer<T>> {
  Pointer<T> get value => Pointer.fromAddress(_wasm.getValue(address, 'i32').toInt());

  set value(Pointer<T> value) => _wasm.setValue(address, value.address, 'i32');

  Pointer<T> operator [](int index) {
    return Pointer.fromAddress(_wasm.getValue(address + (4 * index), 'i32').toInt());
  }
}

extension Int8Pointer on Pointer<Int8> {
  int get value => _wasm.getValue(address, 'i8');

  set value(int i) => _wasm.setValue(address, i, 'i8');
}

extension Int16Pointer on Pointer<Int16> {
  int get value => _wasm.getValue(address, 'i16');

  set value(int i) => _wasm.setValue(address, i, 'i16');
}

extension Int32Pointer on Pointer<Int32> {
  int get value => _wasm.getValue(address, 'i32');

  set value(int i) => _wasm.setValue(address, i, 'i32');
}

extension Int64Pointer on Pointer<Int64> {
  int get value => _wasm.getValue(address, 'i64');

  set value(int i) => _wasm.setValue(address, i, 'i64');
}

extension Uint8Pointer on Pointer<Uint8> {
  int get value => _wasm.getValue(address, 'i8');

  set value(int i) => _wasm.setValue(address, i, 'i8');
}

extension Uint16Pointer on Pointer<Uint16> {
  int get value => _wasm.getValue(address, 'i16');

  set value(int i) => _wasm.setValue(address, i, 'i16');
}

extension Uint32Pointer on Pointer<Uint32> {
  int get value => _wasm.getValue(address, 'i32');

  set value(int i) => _wasm.setValue(address, i, 'i32');
}

extension Uint64Pointer on Pointer<Uint64> {
  int get value => _wasm.getValue(address, 'i64');

  set value(int i) => _wasm.setValue(address, i, 'i64');
}

extension FloatPointer on Pointer<Float> {
  double get value => _wasm.getValue(address, 'float');

  set value(double i) => _wasm.setValue(address, i, 'float');
}

extension DoublePointer on Pointer<Double> {
  double get value => _wasm.getValue(address, 'double');

  set value(double i) => _wasm.setValue(address, i, 'double');
}

int _length(Pointer<Uint8> codeUnits) {
  var length = 0;
  while (_wasm.HEAPU8[codeUnits.address + length] != 0) {
    length++;
  }
  return length;
}

void _ensureNotNullptr(Pointer ptr, String operation) {
  if (ptr == nullptr) {
    throw UnsupportedError("Operation '$operation' not allowed on a 'nullptr'.");
  }
}

extension Utf8Pointer on Pointer<Utf8> {
  int get length {
    _ensureNotNullptr(this, 'length');
    final codeUnits = cast<Uint8>();
    return _length(codeUnits);
  }

  String toDartString({int? length}) =>
      length == null ? _wasm.UTF8ToString(address) : _wasm.UTF8ToString(address, length);
}

extension Utf16Pointer on Pointer<Utf16> {
  int get length {
    _ensureNotNullptr(this, 'length');
    final codeUnits = cast<Uint8>();
    return _length(codeUnits);
  }

  String toDartString({int? length}) =>
      length == null ? _wasm.UTF16ToString(address) : _wasm.UTF16ToString(address, length);
}

// use internally to provide length of binary to c api
class _PtrMeta<T extends NativeType> {
  _PtrMeta(this.length, this.ptr);

  final int length;
  final Pointer<T> ptr;
}

extension StringUtf8Pointer on String {
  Pointer<Utf8> toNativeUtf8() => _toNativeUtf8(false);

  T _toNativeUtf8<T>(bool meta) {
    var length = _wasm.lengthBytesUTF8(this) + 1;
    final result = malloc<Utf8>(length);
    _wasm.stringToUTF8(this, result.address, length);
    return (meta ? _PtrMeta(length - 1, result) : result) as T;
  }

  _PtrMeta<Utf8> _metaNativeUtf8() => _toNativeUtf8(true);
}

extension StringUtf16Pointer on String {
  Pointer<Utf16> toNativeUtf16() => _toNativeUtf16(false);

  T _toNativeUtf16<T>(bool meta) {
    var length = _wasm.lengthBytesUTF16(this) + 2;
    final result = malloc<Utf16>(length);
    _wasm.stringToUTF16(this, result.address, length);
    return (meta ? _PtrMeta(length - 2, result) : result) as T;
  }

  _PtrMeta<Utf16> _metaNativeUtf16() => _toNativeUtf16(true);
}

extension BlobPointer on typed.Uint8List {
  Pointer<Uint8> toNative([bool zeroTerminate = false]) => _toNative(false, zeroTerminate);

  T _toNative<T>(bool meta, [bool zeroTerminate = false]) {
    final size = zeroTerminate ? length + 1 : length;
    final result = malloc<Uint8>(size);
    _wasm.writeArrayToMemory(this, result.address);
    if (zeroTerminate) _wasm.setValue(result.address + size, 0, 'i8');
    return (meta ? _PtrMeta(length, result) : result) as T;
  }

  _PtrMeta<Uint8> _metaNativeUint8([bool zeroTerminate = false]) => _toNative(true, zeroTerminate);
}

extension PointerBlobPointer on Pointer<Uint8> {
  /// The number of byte that is zero-terminated.
  int get length {
    _ensureNotNullptr('length');
    return _length(this);
  }

  typed.Uint8List toUint8List({int? length}) {
    length ??= this.length;
    final result = typed.Uint8List(length);
    for (var i = 0; i < length; i++) {
      result[i] = _wasm.HEAPU8[address + i];
    }
    return result;
  }

  static int _length(Pointer<Uint8> ptr) {
    var length = 0;
    while (_wasm.HEAPU8[ptr.address + length] != 0) {
      length++;
    }
    return length;
  }

  void _ensureNotNullptr(String operation) {
    if (this == nullptr) {
      throw UnsupportedError('Operation $operation not allowed on a \'nullptr\'.');
    }
  }
}
