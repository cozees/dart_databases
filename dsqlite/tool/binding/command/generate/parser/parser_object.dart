part of 'parser.dart';

/// known type for class inherit for C struct object
const cOpaque = cb.Reference('Opaque', dartffi), cStruct = cb.Reference('Struct', dartffi);

mixin ParseObject on _$Parser {
  bool readTypeDef() {
    if (segments.current.raw != 'typedef' || segments.peek == null) return false;
    segments.next();
    if (segments.current.raw == 'struct') {
      segments.next();
      final name = segments.identifier();
      segments.next();
      if (segments.current.raw == '{') {
        // struct declaration
        return readStruct(false, true) != null;
      } else {
        segments.identifier();
        (segments..next()).expected([';']);
        final clazzBuilder = cb.ClassBuilder()
          ..name = name
          ..extend = cOpaque;
        walkListener.onClass(clazzBuilder);
        return true;
      }
    } else {
      // support typedef function only
      final typeBuilder = readDataType(segments);
      var pointer = 0;
      segments.expected(['(']);
      segments.occurred('*', () => pointer++);
      final tname = segments.identifier();
      (segments..next()).expected([')']);
      (segments..next()).expected(['(']);
      final args = readArgumentType();
      (segments..next()).expected([';']);
      walkListener.onTypeDef(
        cb.FunctionTypeBuilder()
          ..requiredParameters.addAll(args)
          ..returnType = typeBuilder.build(),
        pointer,
        name: tname,
        explicitName: true,
      );
      return true;
    }
  }

  cb.ClassBuilder? readStruct([bool sub = false, bool typedef = false]) {
    final clazzBuilder = cb.ClassBuilder();
    if (!typedef) {
      if (segments.current.raw != 'struct') return null;
      clazzBuilder.name = segments.identifier(next: true);
      (segments..next()).expected(['{']);
    }
    clazzBuilder.extend = cStruct;
    while (segments.moveNext() && segments.current.raw != '}') {
      if (segments.current.raw == 'struct') {
        final subClazz = readStruct(true);
        var pointer = 0;
        segments.occurred('*', () => pointer++);
        final vName = segments.identifier();
        (segments..next()).expected([';']);
        // build typeBuilder
        clazzBuilder.fields.add(cb.Field((b) {
          b.name = 'external:$vName';
          b.type = buildPointer(pointer, createType(subClazz!.name!)).build();
          walkListener.onField(b, vName);
        }));
        continue;
      }
      final fieldBuilder = cb.FieldBuilder();
      var typeBuilder = readDataType(segments);
      if (segments.current.raw == '(') {
        // function
        clazzBuilder.fields.add(readMethodExternal(typeBuilder, clazzBuilder.name!));
      } else {
        // make fieldBuilder external
        // TODO: submit pullrequest on git hub to add external fieldBuilder https://github.com/dart-lang/code_builder
        final fname = segments.identifier();
        fieldBuilder.name = 'external:$fname';
        if (segments.peek?.raw == '[') {
          segments.next();
          final expr = readArrayType(segments, typeBuilder);
          fieldBuilder.annotations.add(expr);
        } else {
          segments.next();
        }
        segments.expected([';']);
        fieldBuilder.type = typeBuilder.build();
        final i = ffiCType.indexOf(fieldBuilder.type as cb.TypeReference);
        // add annotation
        if (i != -1 && i < Affinity.string.index) {
          fieldBuilder.annotations.add(fieldBuilder.type!.call([]));
        }
        walkListener.onField(fieldBuilder, fname);
        clazzBuilder.fields.add(fieldBuilder.build());
      }
    }
    if (typedef) {
      // normal syntax can has asterisk * as pointer however SQLite do not introduce it so we skip it.
      clazzBuilder.name = segments.identifier(next: true);
      (segments..next()).expected([';']);
    } else if (segments.peek?.raw == ';') {
      segments.moveNext();
    }
    walkListener.onClass(clazzBuilder, sub);
    return clazzBuilder;
  }

  cb.Field readMethodExternal(cb.TypeReferenceBuilder returnType, String rootName) {
    final fieldBuilder = cb.FieldBuilder();
    var pointer = 0, subFuncRTypePointer = 0;
    segments.occurred('*', () => pointer++);
    late final String name;
    cb.FunctionTypeBuilder? subFtb;
    if (segments.current.raw == '(') {
      // function to function
      subFuncRTypePointer = pointer;
      pointer = 0;
      segments.occurred('*', () => pointer++);
      name = segments.identifier();
      subFtb = cb.FunctionTypeBuilder();
    } else {
      name = segments.identifier();
    }
    fieldBuilder.name = 'external:$name';
    (segments..next()).expected([')']);
    (segments..next()).expected(['(']);
    final ftb = cb.FunctionTypeBuilder()..requiredParameters.addAll(readArgumentType(rootName));
    if (subFtb != null) {
      (segments..next()).expected([')']);
      (segments..next()).expected(['(']);
      final subArgTypes = readArgumentType(rootName)
        ..removeWhere((e) => e.symbol == 'Void' && e.url == dartffi);
      subFtb.requiredParameters.addAll(subArgTypes);
      subFtb.returnType = buildPointer(subFuncRTypePointer, returnType.build()).build();
      ftb.returnType = walkListener.onTypeDef(subFtb, pointer, name: name).build();
    } else {
      ftb.returnType = walkListener.onType(returnType.build());
    }
    (segments..next()).expected([';']);
    fieldBuilder.type = walkListener.onTypeDef(ftb, pointer, name: name).build();
    walkListener.onField(fieldBuilder, name);
    return fieldBuilder.build();
  }
}
