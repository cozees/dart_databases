part of 'library.g.dart';

/// replicate dart:ffi NativeType
abstract class NativeType {
  const NativeType();
}

/// replicate dart:ffi NativeFunction
abstract class NativeFunction<T extends Function> extends NativeType {}

/// replicate dart:ffi Void
abstract class Void extends NativeType {}

/// replicate dart:ffi Int8
abstract class Int8 extends NativeType {}

/// replicate dart:ffi Int16
abstract class Int16 extends NativeType {}

/// replicate dart:ffi Int16
abstract class Int32 extends NativeType {}

/// replicate dart:ffi Int64
abstract class Int64 extends NativeType {}

/// replicate dart:ffi Int8
abstract class Uint8 extends NativeType {}

/// replicate dart:ffi Int16
abstract class Uint16 extends NativeType {}

/// replicate dart:ffi Int16
abstract class Uint32 extends NativeType {}

/// replicate dart:ffi Int64
abstract class Uint64 extends NativeType {}

/// replicate dart:ffi Int64
abstract class Float extends NativeType {}

/// replicate dart:ffi Int64
abstract class Double extends NativeType {}

/// replicate dart:ffi Int64
abstract class Utf8 extends NativeType {}

/// replicate dart:ffi Int64
abstract class Utf16 extends NativeType {}
