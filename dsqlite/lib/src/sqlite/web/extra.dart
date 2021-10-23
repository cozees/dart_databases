part of 'library.g.dart';

/// indicate that is code is currently running in vm or native-vm dart otherwise web
const isNative = false;

/// Store information about defined function and provide wrapper to convert webassembly address
/// into Pointer type if needed.
class FunctionMeta {
  const FunctionMeta(this.meta, [this.wrapper]);

  final String meta;
  final Function Function(Function)? wrapper;
}

/// represent js:bigint primitive type.
@pkgjs.JS('BigInt')
class JsBigInt {}

/// [number] can be either a number or a valid string which contain digit only.
@pkgjs.JS('BigInt')
external JsBigInt JsBigIntCreator(number);

@pkgjs.JS('String')
external String jsString(obj);

/// convert javascript bigint int dart int
int jsBigInt2DartInt(dynamic jsBigInt) => int.parse(jsString(jsBigInt));

/// convert javascript bigint into dart bigint
BigInt jsBigIntDartBigInt(dynamic jsBigInt) => BigInt.parse(jsString(jsBigInt));

/// convert dart int into javascript bigint
JsBigInt fromInt(int i) => JsBigIntCreator(i);

/// convert dart [BigInt] into javascript bigint
JsBigInt fromBigInt(BigInt i) => JsBigIntCreator(i);

mixin _MixinExtra on _SQLiteLibrary {}
