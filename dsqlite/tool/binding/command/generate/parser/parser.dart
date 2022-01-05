//
//

import 'package:code_builder/code_builder.dart' as cb;

import 'segment.dart';

part 'parser_api.dart';

part 'parser_constant.dart';

part 'parser_object.dart';

part 'parser_type.dart';

class PairResult<A, B> {
  PairResult(this.a, this.b);

  final A? a;
  final B? b;
}

abstract class ComponentEvent {
  void finalize();

  cb.TypeReferenceBuilder onTypeDef(cb.FunctionTypeBuilder ftb, int pointer,
      {String? name, String? root, bool explicitName = false});

  cb.TypeReference onType(cb.TypeReference tr);

  void onParameter(cb.ParameterBuilder pb, String name);

  void onField(cb.FieldBuilder fb, String name);

  /// use by api parser.
  void onMethod(cb.MethodBuilder mb, String name, [bool isFunction = false]);

  void onClass(cb.ClassBuilder cbe, [bool subClass = false]);

  void onConstant(cb.Expression expr, String name);

  void onSection(String name);

  void onAPI(String name);
}

class _$Parser {
  final CodeSegmentIterator segments;
  final ComponentEvent walkListener;

  _$Parser(this.segments, this.walkListener);

  PairResult<String, cb.TypeReferenceBuilder> readArgumentFunction(
    cb.TypeReferenceBuilder returnType, [
    String? rootName,
  ]) {
    var pointer = 0;
    segments.occurred('*', () => pointer++);
    String? name;
    if (segments.current.raw != ')') {
      name = segments.identifier();
      (segments..next()).expected([')']);
    }
    (segments..next()).expected(['(']);
    final ftb = cb.FunctionTypeBuilder()
      ..returnType = returnType.build()
      ..requiredParameters.addAll(readArgumentType(rootName));
    return PairResult(name, walkListener.onTypeDef(ftb, pointer, name: name, root: rootName));
  }

  List<cb.TypeReference> readArgumentType([String? rootName]) {
    final result = <cb.TypeReference>[];
    String? name;
    late cb.TypeReferenceBuilder typeBuilder;
    loop:
    while (segments.moveNext()) {
      if (name == null) {
        typeBuilder = readDataType(segments);
      }
      switch (segments.current.raw) {
        case '(':
          // function argument we need to create typedef for this.
          final pair = readArgumentFunction(typeBuilder, rootName);
          typeBuilder = pair.b!;
          name = typeBuilder.symbol!;
          name = pair.a ?? '${name[0].toLowerCase()}${name.substring(1)}';
          continue;
        case ',':
          result.add(walkListener.onType(typeBuilder.build()));
          name = null;
          continue;
        case ')':
          result.add(walkListener.onType(typeBuilder.build()));
          break loop;
        default:
          name = segments.identifier();
          if (segments.peek?.raw == '[') readArrayType(segments, typeBuilder);
      }
    }
    return (result.length == 1 && result.first == ffiCType[Affinity.any.index]) ? [] : result;
  }

  List<cb.Parameter> readArgument() {
    final result = <cb.Parameter>[];
    var nameIndex = 1;
    String? name;
    late cb.ParameterBuilder pb;
    late cb.TypeReferenceBuilder typeBuilder;
    loop:
    while (segments.moveNext()) {
      if (name == null) {
        pb = cb.ParameterBuilder();
        typeBuilder = readDataType(segments);
      }
      switch (segments.current.raw) {
        // NOTE: potentially there is array type in the future so check `[`
        case '(':
          // function argument we need to create typedef for this.
          final pair = readArgumentFunction(typeBuilder);
          typeBuilder = pair.b!;
          name = typeBuilder.symbol!;
          name = pair.a ?? '${name[0].toLowerCase()}${name.substring(1)}';
          continue;
        case ',':
          walkListener.onParameter(pb..type = typeBuilder.build(), name ?? 'arg${nameIndex++}');
          result.add(pb.build());
          name = null;
          continue;
        case ')':
          walkListener.onParameter(pb..type = typeBuilder.build(), name ?? 'arg${nameIndex++}');
          result.add(pb.build());
          break loop;
        default:
          name = segments.identifier();
          if (segments.peek?.raw == '[') readArrayType(segments, typeBuilder);
      }
    }
    return (result.length == 1 && result.first.type == ffiCType[Affinity.any.index]) ? [] : result;
  }
}

class Parser extends _$Parser with ParseConstant, ParseObject, ParseAPI {
  Parser(String code, ComponentEvent walkListener)
      : this._what(CodeSegments(code, debug: true), walkListener);

  Parser._what(this.aa, ComponentEvent walkListener) : super(aa.iterator, walkListener);

  final CodeSegments aa;

  ComponentEvent parse() {
    while (segments.moveNext()) {
      if (segments.current.raw.startsWith(':::')) {
        walkListener.onSection(segments.current.raw.replaceAll(':::', '').trim());
        continue;
      }
      if (readConstant()) continue;
      if (readTypeDef()) continue;
      if (readStruct() != null) continue;
      if (readAPI()) continue;
    }
    walkListener.finalize();
    return walkListener;
  }
}
