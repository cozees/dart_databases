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

Future<void> _sync(bool populate) async {
  final completion = _async.Completer();
  _wasm.FS.syncfs(populate, pkgjs.allowInterop((err) {
    if (err != null) {
      completion.completeError(err, StackTrace.current);
    } else {
      completion.complete();
    }
  }));
  await completion.future;
}

/// a reference to webassembly Module method.
@pkgjs.JS('Module')
external module(WasmModule mod);

/// module reference to wasm runtime.
final WasmModule _wasm = WasmModule();

/// indicate whether Webassembly is built with BigInt
late final bool isBigInt;

/// Javascript webassembly module
@pkgjs.JS('Object')
class WasmModule {
  external factory WasmModule();

  /// a reference to webassembly heapu8.
  external List<int> HEAPU8;

  /// a reference to webassembly hasOwnProperty method.
  external bool hasOwnProperty(String name);

  /// a reference to webassembly cwrap method.
  external cwrap(String apiName, String returnType, [List<String>? parameters]);

  /// a reference to webassembly _malloc method.
  external R _malloc<R>(int length);

  /// a reference to webassembly _free method.
  external _free(num address);

  /// a reference to webassembly run method.
  external run();

  /// a reference to webassembly writeArrayToMemory method.
  external writeArrayToMemory(typed.Uint8List binary, num buffer);

  /// a reference to webassembly setValue method.
  external setValue(num ptr, dynamic value, String type, [bool? noSafe]);

  /// a reference to webassembly getValue method.
  external getValue(num ptr, String type, [bool? noSafe]);

  /// a reference to webassembly lengthBytesUTF8 method.
  external int lengthBytesUTF8(String txt);

  /// a reference to webassembly lengthBytesUTF16 method.
  external int lengthBytesUTF16(String txt);

  /// a reference to webassembly stringToUTF8 method.
  external stringToUTF8(String txt, num ptr, int maxWriteSize);

  /// a reference to webassembly UTF8ToString method.
  external String UTF8ToString(num ptr, [int? maxSizeRead]);

  /// a reference to webassembly stringToUTF16 method.
  external stringToUTF16(String txt, num ptr, int maxWriteSize);

  /// a reference to webassembly UTF16ToString method.
  external String UTF16ToString(num ptr, [int? maxSizeRead]);

  /// a reference to webassembly addFunction method.
  external int addFunction(Function func, String meta);

  /// a reference to webassembly removeFunction method.
  external removeFunction(num ptr);

  external FileSystem FS;

  external final IDBFS;
}

@pkgjs.JS()
class FileSystem {
  external mount(dynamic a, dynamic callback, String dir);

  external syncfs(bool populate, dynamic callback);

  external mkdir(String name);
}

mixin _MixinExtra on _SQLiteLibrary {}