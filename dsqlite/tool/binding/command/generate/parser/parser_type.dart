part of 'parser.dart';

const dartffi = 'dart:ffi';
const pkgffi = 'package:ffi/ffi.dart';

///
enum Affinity {
  int,
  int8,
  uint8,
  short,
  ushort,
  uint32,
  int64,
  uint64,
  float,
  double,
  char,
  string, // index 11
  object,
  any, // replace void
  function,
  array,
}

extension AffinityExt on Affinity {
  cb.TypeReference? cType() => ffiCType[index];
}

cb.TypeReference createType(String symbol, [String? url, Iterable<cb.Reference>? types]) {
  return cb.TypeReference((trb) => trb
    ..symbol = symbol
    ..url = url
    ..types.addAll([...?types]));
}

cb.TypeReference createNullableType(String symbol, [String? url, Iterable<cb.Reference>? types]) {
  return cb.TypeReference((trb) => trb
    ..symbol = symbol
    ..url = url
    ..isNullable = true
    ..types.addAll([...?types]));
}

cb.TypeReference createTypePointer(Iterable<cb.Reference> types) =>
    createType('Pointer', dartffi, types);

cb.TypeReference createTypeArray(cb.TypeReference type) => createType('Array', dartffi, [type]);

// know type of c representation in dart
final cInt8 = createType('Int8', dartffi),
    cUint8 = createType('Uint8', dartffi),
    cInt16 = createType('Int16', dartffi),
    cUint16 = createType('Uint16', dartffi),
    cInt32 = createType('Int32', dartffi),
    cUint32 = createType('Uint32', dartffi),
    cInt64 = createType('Int64', dartffi),
    cUint64 = createType('Uint64', dartffi),
    cFloat = createType('Float', dartffi),
    cDouble = createType('Double', dartffi),
    cVoid = createType('Void', dartffi),
    cArray = createType('Array', dartffi),
    cString = createType('Utf8', pkgffi),
    cString16 = createType('Utf16', pkgffi),
    cNullPtr = createType('nullptr', dartffi);

final ffiCType = [
  cInt32,
  cInt8,
  cUint8,
  cInt16,
  cUint16,
  cUint32,
  cInt64, // index 6
  cUint64,
  cFloat, // index 8
  cDouble, // index 9
  cInt8, // char type
  cString, // index 11
  null,
  cVoid,
  null,
  cArray,
];

final dartInt = createType('int'),
    dartDouble = createType('double'),
    dartString = createType('String'),
    dartNum = createType('num'),
    dartBool = createType('bool'),
    dartVoid = createType('void'),
    dartDynamic = createType('dynamic');

final dartType = [
  dartInt,
  dartInt,
  dartInt,
  dartInt,
  dartInt,
  dartInt,
  dartInt,
  dartInt,
  dartDouble,
  dartDouble,
  dartInt,
  dartString, // index 11
  null,
  dartVoid,
  null,
  null,
];

cb.Expression readArrayType(CodeSegmentIterator segments, cb.TypeReferenceBuilder type) {
  final dimensions = <int>[];
  int? dimension;
  while (true) {
    switch (segments.current.raw) {
      case '[':
        dimension = null;
        dimensions.add(-1);
        segments.next();
        break;
      case ']':
        dimensions.last = dimension!;
        segments.next();
        break;
      case ';':
      case ',':
      case ')':
        var cc = cb.TypeReferenceBuilder();
        for (var i = 0; i < dimensions.length; i++) {
          if (i == 0) {
            cc.types.add(type.build());
          } else {
            final a = cb.TypeReferenceBuilder();
            a.types.add(cc.build());
            cc = a;
          }
          cc.symbol = 'Array';
          cc.url = dartffi;
        }
        type.url = cc.url;
        type.symbol = cc.symbol;
        type.types.clear();
        type.types.addAll(cc.types.build());
        cc.types.clear();
        return cc.build().call(dimensions.map((e) => cb.literalNum(e)));
      default:
        // valid number only
        if ((dimension = int.tryParse(segments.current.raw)) != null &&
            dimensions.isNotEmpty &&
            dimensions.last == -1) {
          segments.next();
          continue;
        }
        throw segments.syntaxError();
    }
  }
}

cb.TypeReferenceBuilder readDataType(CodeSegmentIterator segments) {
  var objName = segments.current.raw;
  String? name;
  Affinity? affinity;
  List<String>? validTypes;
  var unsigned = false;
  typeLookup:
  while (true) {
    switch (segments.current.raw) {
      case 'short':
        affinity = unsigned ? Affinity.ushort : Affinity.short;
        name = segments.current.raw;
        segments.skip(['int']);
        validTypes = null;
        break;
      case 'long':
        affinity = unsigned ? Affinity.uint64 : Affinity.int64;
        name = segments.current.raw;
        segments.skip(['long', 'int']);
        validTypes = null;
        break;
      case 'int':
        affinity = unsigned ? Affinity.uint32 : Affinity.int;
        name = segments.current.raw;
        validTypes = null;
        break typeLookup;
      case 'char':
        affinity = unsigned ? Affinity.uint8 : Affinity.int8;
        name = segments.current.raw;
        validTypes = null;
        break typeLookup;
      case 'float':
        affinity = Affinity.float;
        name = segments.current.raw;
        break typeLookup;
      case 'double':
        affinity = Affinity.double;
        name = segments.current.raw;
        break typeLookup;
      case 'unsigned':
        unsigned = true;
        affinity = Affinity.uint32;
        validTypes = ['long', 'int', 'short', 'char'];
        segments.next();
        break;
      case 'signed':
        affinity = Affinity.int;
        segments.next();
        validTypes = ['long', 'int', 'short', 'char'];
        break;
      case 'const':
        segments.next();
        if (segments.current.raw == 'struct') segments.next();
        objName = segments.current.raw;
        continue typeLookup;
      default:
        if (validTypes != null &&
            !isIdentifier.hasMatch(segments.current.raw) &&
            segments.current.raw != ',' &&
            segments.current.raw != '*' &&
            segments.current.raw != ')') segments.syntaxError();
        break typeLookup;
    }
  }

  var pointer = 0;

  if (name == null) {
    name = objName;
    switch (name) {
      case 'sqlite3_int64':
      case 'sqlite_int64':
        affinity = Affinity.int64;
        break;
      case 'sqlite3_uint64':
      case 'sqlite_uint64':
        affinity = Affinity.uint64;
        break;
      case 'void':
        affinity = Affinity.any;
        break;
      default:
        affinity ??= Affinity.object;
    }
  }

  if (segments.current.raw != ',' && segments.current.raw != ')') {
    if (segments.current.raw == '*') pointer++;
    segments.occurred('*', () => pointer++);
    if (pointer > 0 && name == 'char') affinity = Affinity.char;
  }

  if (pointer > 0) {
    if (affinity == Affinity.char) affinity = Affinity.string;
    late cb.TypeReference ct;
    if (ffiCType[affinity!.index] != null) {
      ct = ffiCType[affinity.index]!;
    } else {
      ct = createType(name);
    }
    return buildPointer(pointer, ct);
  } else {
    return (ffiCType[affinity!.index] ?? createType(name)).toBuilder();
  }
}

cb.TypeReferenceBuilder buildPointer(int pointer, cb.TypeReference type, [bool addUrl = true]) {
  if (pointer <= 0) return type.toBuilder();
  var cc = cb.TypeReferenceBuilder();
  for (var i = 0; i < pointer; i++) {
    if (i == 0) {
      cc.types.add(type);
    } else {
      final a = cb.TypeReferenceBuilder();
      a.types.add(cc.build());
      cc = a;
    }
    cc.symbol = 'Pointer';
    if (addUrl) cc.url = dartffi;
  }
  return cc;
}
