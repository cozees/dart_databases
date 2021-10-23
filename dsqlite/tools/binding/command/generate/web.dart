part of 'generate.dart';

const _jsAnnotation = cb.Reference('JS', 'package:js/js.dart');
const dartjs = 'dart:js';
const dartjsUtil = 'dart:js_util';

final pkgJSFunc = cb.Reference('allowInterop', dartjs);

final webPointerFrom = cb.refer('Pointer').property('fromAddress');
final wasm = cb.Reference('_wasm'),
    _cWrap = wasm.property('cwrap'),
    _free = wasm.property('_free'),
    _addFunc = wasm.property('addFunction'),
    webNullPtr = cb.Reference('nullptr');

final webBigInt = createType('JsBigInt');

final _jsTypeLookup = {
  ffiCType[0]: 'number',
  ffiCType[1]: 'number',
  ffiCType[2]: 'number',
  ffiCType[3]: 'number',
  ffiCType[4]: 'number',
  ffiCType[5]: 'number',
  ffiCType[6]: 'number',
  ffiCType[7]: 'number',
  ffiCType[8]: 'number',
  ffiCType[9]: 'number',
  ffiCType[10]: 'number',
};

class FunctionMeta {
  FunctionMeta(this.meta, this.wrapper);

  final cb.Expression meta;
  final cb.MethodBuilder? wrapper;
}

final _wasmFuncMeta = <cb.Expression, FunctionMeta>{};

class TypedefMeta {
  TypedefMeta(this.name, this.ftb);

  bool declared = false;
  cb.FunctionTypeBuilder? ftb;
  final String name;
}

class WebGenerateEvent {
  WebGenerateEvent(String out) : out = [out, 'web'].joinPath() {
    libraries = <int, cb.LibraryBuilder>{
      /* *** Types **** */ 1: cb.LibraryBuilder(),
    };
    mixinBuilders = {};
    final mixins = <cb.Reference>[];
    for (var api in _generateMeta.crossPlatformApis) {
      var mod = apisNameSectionModule[api];
      if (mod == null) {
        print('::: > $api is not in the group.');
        continue;
      }
      if (libraries[mod.hashCode] == null) {
        mixins.add(cb.refer('_Mixin$mod'));
        libraries[mod.hashCode] = cb.LibraryBuilder();
        mixinBuilders[mod.hashCode] = cb.MixinBuilder()
          ..docs.add('\n\n// Mixin for $mod')
          ..name = '_Mixin$mod'
          ..on = baseClass;
        parts.add(cb.Directive.part('${mod.toLowerCase()}.g.dart'));
      }
    }
    mixins.add(cb.refer('_MixinExtra'));
    _library = initWebLibrary(mixins);
  }

  late final cb.LibraryBuilder _library;

  int _currentSection = -1;
  String _section = '';
  String? _apiName;

  final Map<cb.TypeReference, TypedefMeta> ignores = {};

  final parts = <cb.Directive>[];
  final partOf = cb.Directive.partOf('library.g.dart');

  late final Map<int, cb.LibraryBuilder> libraries;
  late final Map<int, cb.MixinBuilder> mixinBuilders;

  set section(String val) {
    _section = val;
    _currentSection = val.hashCode;
  }

  set apiName(String val) => _apiName = val;

  final String out;

  final emitter = GenCodeEmitter(
    allocator: PrefixedAllocator(true, _knownImportAlias),
    useNullSafetySyntax: true,
  );

  void _writeContent(String name, cb.LibraryBuilder builder) {
    final content = formatter.format(builder.build().accept(emitter).toString());
    (File([out, '$name.g.dart'].joinPath())..createSync(recursive: true))
        .writeAsStringSync('$header$content');
  }

  void finalize() {
    // write part file
    for (var mod in apisGroups.keys) {
      if (libraries[mod.hashCode] != null) {
        _writeContent(
          mod.toLowerCase(),
          libraries[mod.hashCode]!
            ..directives.add(partOf)
            ..body.add(mixinBuilders[mod.hashCode]!.build()),
        );
      }
    }
    // write types
    _writeContent('types', libraries[1]!..directives.add(partOf));
    // write main library file
    // pointer.dart is a manually constructed code
    var allStatement = <cb.Spec>[];
    for (var cType in _transformTypes.keys) {
      var m = _transformTypes[cType];
      if (m != null) {
        // api or type does not include in web export api or explicitly skipped
        if ((ignores[m.alias] != null && !ignores[m.alias]!.declared)) continue;
        allStatement.add(
            cb.CodeExpression(cb.Code('typedef ${_transformTypes[cType]!.alias.symbol}'))
                .assign(m.webType)
                .statement);
      }
    }
    // add webassembly meta
    final mm = <cb.Expression, cb.Expression>{};
    var wrapperCount = 1;
    for (var key in _wasmFuncMeta.keys) {
      var fm = _wasmFuncMeta[key]!;
      var wrapperArgs = <cb.Expression>[fm.meta];
      if (fm.wrapper != null) {
        final name = '_wrapper${wrapperCount++}';
        allStatement.addAll([
          cb.Code('\n\n// Wrapper function for ${(key as cb.Reference).symbol}\n'),
          cb.Method((mb) => mb
            ..name = name
            ..returns = createType('Function')
            ..lambda = true
            ..requiredParameters.add(cb.Parameter((pb) => pb
              ..name = 'f'
              ..type = createType('Function')))
            ..body = fm.wrapper!.build().closure.code),
        ]);
        wrapperArgs.add(cb.refer(name));
      }
      mm[key] = cb.refer('FunctionMeta').call(wrapperArgs);
    }
    allStatement.addAll([
      cb.Code('\n\n'),
      cb
          .literalMap(mm, createType('Type'), createType('FunctionMeta'))
          .assignConst('_funcWasmMeta')
          .statement,
      cb.Code('\n\n'),
    ]);
    _library
      ..directives.addAll([
        // manually code
        cb.Directive.part('pointer.dart'),
        cb.Directive.part('native_type.dart'),
        cb.Directive.part('extra.dart'),
        // genrated code
        cb.Directive.part('types.g.dart')
      ])
      ..directives.addAll(parts)
      ..body.insertAll(0, allStatement);
    _writeContent('library', _library);
  }

  void onMethod(cb.MethodBuilder mb, String name, [bool isFunction = false]) {
    // the method is not listed for generate for web.
    if (libraries[_currentSection] == null || !_generateMeta.crossPlatformApis.contains(name)) {
      return;
    }
    // rebuild method and create type def for c api.
    final ft = cb.FunctionTypeBuilder(); // c typedef api
    final nmb = mb.build().toBuilder()..name = mb.name!.substring(8);
    final args = <cb.Expression>[];
    // code place before calling api
    final before = <cb.Code>[];
    // code place after calling api
    final after = <cb.Code>[];
    // code place inside finally block
    final finally$ = <cb.Code>[];
    // if return type can be native type then dft return is defined with dart native type.
    // c typedef use alias if possible
    final meta = _generateMeta.apisMeta[name]!;
    final m = findTransform(mb.returns as cb.TypeReference);
    ft.returnType = meta.returns.pointer ? dartInt : m?.dartTypeOrAliasWeb() ?? mb.returns!;
    nmb.returns = m?.dartTypeOrAlias(true) ?? mb.returns!;
    nmb.requiredParameters.clear();
    // Transform parameters
    var cwrapArgs = <cb.Expression>[];
    MetaParam? ppMeta;
    cb.Parameter? pParam;
    for (var i = 0; i < mb.requiredParameters.length; i++) {
      var p = mb.requiredParameters[i];
      var m = findTransform(p.type! as cb.TypeReference);
      var pMeta = meta.params.elementAt(i);
      var nullable = pMeta.nullable;
      // c definition meta
      cwrapArgs.add(cb.literalString(_jsTypeLookup[p.type] ?? 'number'));
      ft.requiredParameters.add(pMeta.pointer ? dartInt : m?.dartTypeOrAliasWeb() ?? p.type!);
      // check if it is size of previous argument
      if (ppMeta != null && pMeta.sizeOf == ppMeta.param.name) {
        // exclude argument as it's size of string or blob
        late cb.Expression l;
        if (ppMeta.nullable) {
          l = cb
              .refer('${pParam!.name}Meta')
              .nullSafeProperty('length')
              .ifNullThen(cb.literalNum(0));
        } else {
          l = cb.refer('${pParam!.name}Meta').property('length');
        }
        args.add(p.type!.isInt64Bit
            ? cb.refer('isBigInt').conditional(cb.refer('JsBigIntCreator').call([l]), l)
            : l);
        ppMeta = pMeta;
        pParam = p;
        continue;
      }
      // destroyer argument is omitted for simplicity
      if (!pMeta.destroyer) {
        final type = pMeta.isBlob && pMeta.transform
            ? dartUint8List
            : pMeta.textKind
                ? dartString
                : (m?.dartTypeOrAlias(true) ?? p.type! as cb.TypeReference);
        nullable = nullable && !type.symbol.startsWith('Ptr');
        nmb.requiredParameters.add(cb.Parameter((pb) => pb
          ..name = p.name
          ..type = nullable ? type.nullable() : type));
      } else {
        args.add(cb.refer('_ptrDestructor'));
        continue;
      }
      // special for string & blob
      cb.Expression arg = cb.refer(p.name);
      if (p.type?.isInt64Bit == true) {
        // need conversion to bigint
        arg = cb.refer('JsBigIntCreator').call([arg]);
      } else if (m?.dartType == dartString || pMeta.textKind || pMeta.isBlob) {
        final mName = pMeta.isBlob
            ? '_metaNativeUint8'
            : (m!.alias.symbol.endsWith('16'))
                ? '_metaNativeUtf16'
                : '_metaNativeUtf8';
        final metaArg = cb.refer('${p.name}Meta');
        final ptrArg = cb.refer('ptr${p.name}');
        if (name.endsWith('_text64')) {
          arg = args.last.equalTo(cb.refer('UTF8', constPkg)).conditional(
              nullable
                  ? arg.nullSafeProperty('_metaNativeUtf8').call([])
                  : arg.property('_metaNativeUtf8').call([]),
              nullable
                  ? arg.nullSafeProperty('_metaNativeUtf16').call([])
                  : arg.property('_metaNativeUtf16').call([]));
        } else {
          arg = nullable ? arg.nullSafeProperty(mName).call([]) : arg.property(mName).call([]);
        }
        before.add(arg.assignFinal(metaArg.symbol!).statement);
        arg = nullable ? metaArg.nullSafeProperty('ptr') : metaArg.property('ptr');
        arg = arg.property('address');
        if (nullable) arg = arg.ifNullThen(cb.literalNum(0));
        before.add(arg.assignFinal(ptrArg.symbol!).statement);
        if (!meta.hasDestroyer) finally$.add(_free.call([ptrArg]).statement);
        arg = name.endsWith('_text64') ? ptrArg.property('cast').call([]) : ptrArg;
      } else if (pMeta.pointer) {
        arg = arg.property('address');
        if (nullable) arg = arg.ifNullThen(cb.literalNum(0));
      }
      args.add(arg);
      ppMeta = pMeta;
      pParam = p;
    }
    // special for returning string & blob
    cb.Reference? result;
    cb.Expression cwrapRT = cb.literalString(_jsTypeLookup[mb.returns] ?? 'number');
    if (mb.returns!.isInt64Bit == true) {
      result = cb.refer('result');
      after.add(Return(cb.refer('jsBigInt2DartInt').call([result])));
    } else if (nmb.returns == dartString) {
      final nType = mb.name!.contains('16') ? 'Utf16' : 'Utf8';
      final ptrFrom = createType('Pointer', null, [createType(nType)]).property('fromAddress');
      result = cb.refer('result');
      if (meta.returns.free) {
        before.add(cb.literalNum(0).assignVar(result.symbol!, ft.returnType).statement);
      }
      final length = <String, cb.Expression>{};
      if (name.contains('_value_text16')) {
        length['length'] = cb.refer('_h_sqlite3_value_bytes16').call(args);
      } else if (name.contains('_value_text')) {
        length['length'] = cb.refer('_h_sqlite3_value_bytes').call(args);
      } else if (name.contains('_column_text16')) {
        length['length'] = cb.refer('_h_sqlite3_column_bytes16').call(args);
      } else if (name.contains('_column_text')) {
        length['length'] = cb.refer('_h_sqlite3_column_bytes').call(args);
      }
      // final bytes = cb.refer('_h_${name.replaceAll('_blob', '_bytes')}');
      final expr = meta.returns.nullable
          ? result.equalTo(cb.literalNum(0)).conditional(
              cb.literalNull, ptrFrom.call([result]).property('toDartString').call([], length))
          : ptrFrom.call([result]).property('toDartString').call([], length);
      after.add(Return(expr));
      if (meta.returns.free) {
        finally$.add(_free.call([result]).statement);
      } else if (meta.returns.freeBy != null) {
        finally$.add(cb.refer(meta.returns.freeBy!.substring(8)).call([result]).statement);
      }
    } else if (meta.returns.isBlob) {
      nmb.returns = dartUint8List;
      result = cb.refer('result');
      cb.Expression expr = webPointerFrom.call([result]);
      final bytes = cb.refer('_h_${name.replaceAll('_blob', '_bytes')}');
      expr = expr
          .property('cast')
          .call([], {}, [createType('Uint8')])
          .property('toUint8List')
          .call([], {'length': bytes.call(args)});
      expr = meta.returns.nullable
          ? result.equalTo(cb.literalNum(0)).conditional(cb.literalNull, expr)
          : expr;
      after.add(Return(expr));
    } else if (meta.returns.nullable && nmb.returns != dartString) {
      result = cb.refer('result');
      if (meta.returns.pointer) {
        after.add(Return(result.equalTo(cb.literalNum(0)).conditional(
              cb.literalNull,
              webPointerFrom.call([result]),
            )));
      } else {
        throw Exception('Native C APIs of scalar type cannot be null.');
      }
    } else if (meta.returns.pointer) {
      result = cb.refer('result');
      after.add(Return(webPointerFrom.call([result])));
    }
    // if result can be null
    if (meta.returns.nullable) nmb.returns = (nmb.returns as cb.TypeReference).nullable();
    // add typedef
    final handlerName = '_h_${mb.name}';
    cb.Expression handler = cb.refer(handlerName);
    String def = '_def_${mb.name}';
    libraries[_currentSection]!.body.add(ft.build().toTypeDef(def));
    // check version and built dependent
    var fieldType = createType(def);
    var expr = _cWrap.call([cb.literalString(mb.name!), cwrapRT, cb.literalList(cwrapArgs)]);
    if (meta.builtDependent) {
      fieldType = fieldType.nullable();
      before.add(If(
        handler.equalTo(cb.literalNull),
        Throw(dbException.call([
          cb.literalString('API $name is not available, You need to enable it '
              'during library build.')
        ])),
      ));
      handler = handler.nullChecked;
    } else if (meta.change != null && meta.change!.kind != ChangeKind.deprecate) {
      fieldType = fieldType.nullable();
      final version = cb.literalNum(meta.change!.version.versionNumber);
      final libVersion = cb.refer('libVersionNumber');
      if (meta.change!.kind == ChangeKind.add) {
        before.insert(
            0,
            If(
              handler.equalTo(cb.literalNull),
              Throw(dbException.call([
                cb.literalString(
                    'API $name is not available before ${meta.change!.version.version}')
              ])),
            ));
        expr = libVersion.lessThan(version).conditional(cb.literalNull, expr);
        handler = handler.nullChecked;
      } else {
        before.insert(
            0,
            If(
              handler.equalTo(cb.literalNull),
              Throw(dbException.call([
                cb.literalString('API $name is not available after ${meta.change!.version.version}')
              ])),
            ));
        expr = libVersion.greaterThan(version).conditional(cb.literalNull, expr);
        handler = handler.nullChecked;
      }
    }
    // special case for prepare statement
    if (name.startsWith('sqlite3_prepare')) {
      final tail = cb.refer(nmb.requiredParameters.last.name);
      result = cb.refer('result');
      after.addAll([
        If(tail.property('value').property('address').operatorSubstract(args[1]).equalTo(args[2]),
            tail.property('value').assign(webNullPtr).statement),
        Return(result),
      ]);
    }
    // create method body
    nmb.body = cb.Block((b) {
      final codes = [...before];
      if (mb.returns!.symbol == 'void' && mb.returns!.url == null) {
        after.insert(0, handler.call(args).statement);
      } else if (result != null) {
        after.insert(0, handler.call(args).assignVar(result.symbol!).statement);
      } else {
        after.insert(0, Return(handler.call(args)));
      }
      if (finally$.isNotEmpty) {
        codes.add(Try(after.toBlock()).finally$(finally$.toBlock()));
      } else {
        codes.addAll(after);
      }
      if (mb.returns!.isInt64Bit) {
        late final cb.Expression resultExpr;
        if (nmb.name!.endsWith('_int64')) {
          final colTxt = nmb.requiredParameters.build().map((e) => cb.refer(e.name));
          resultExpr = cb
              .refer('int')
              .property('parse')
              .call([cb.refer(nmb.name!.replaceFirst('_int64', '_text')).call(colTxt).nullChecked]);
        } else {
          resultExpr = handler.call(args);
        }
        b.statements.add(If(cb.refer('isBigInt'), codes.toBlock()).else$(Return(resultExpr)));
      } else if (nmb.name!.endsWith('_int64')) {
        // bind_int64 or result_int64
        final colTxt =
            nmb.requiredParameters.build().map<cb.Expression>((e) => cb.refer(e.name)).toList();
        colTxt.last = colTxt.last.property('toString').call([]);
        final resultExpr = cb.refer(nmb.name!.replaceFirst('_int64', '_text')).call(colTxt);
        b.statements.add(If(cb.refer('isBigInt'), codes.toBlock()).else$(Return(resultExpr)));
      } else {
        b.statements.addAll(codes);
      }
    });
    // add field
    mixinBuilders[_currentSection]!
      ..fields.add(cb.Field((b) => b
        ..late = true
        ..modifier = cb.FieldModifier.final$
        ..name = handlerName
        ..type = fieldType
        ..assignment = expr.code))
      ..methods.add(nmb.build());
  }

  void onClass(cb.ClassBuilder cbe, [bool subClass = false]) {
    if (_generateMeta.types.contains(cbe.name)) {
      libraries[1]!.body.add(cbe.build().rebuild((b) => b.extend = createType('NativeType')));
    }
  }

  void onType(TypeTransformProcedure ttd, [bool news = true]) {
    if (libraries.containsKey(_currentSection) &&
        (_apiName == null || _generateMeta.crossPlatformApis.contains(_apiName))) {
      var meta = ignores[ttd.alias];
      if (meta == null) {
        meta = TypedefMeta(ttd.alias.symbol, null);
        ignores[ttd.alias] = meta;
      }
      meta.declared = true;
      if (ttd.alias.symbol.startsWith('Ptr')) {
        meta = ignores[createType(ttd.alias.symbol.replaceAll('Ptr', ''))];
      }
      if (meta?.ftb != null) {
        _produceTypeDef(meta!.ftb!, meta.name);
        meta.ftb = null;
        meta.declared = true;
      }
    } else if (ignores[ttd.alias] == null) {
      ignores[ttd.alias] = TypedefMeta(ttd.alias.symbol, null);
    }
  }

  void onTypeDef(cb.FunctionTypeBuilder ftb, String name) {
    if (libraries[_currentSection] != null &&
        (_apiName == null || _generateMeta.crossPlatformApis.contains(_apiName))) {
      _produceTypeDef(ftb, name);
    } else {
      ignores[createType(name)] = TypedefMeta(name, ftb);
    }
  }

  void _produceTypeDef(cb.FunctionTypeBuilder ftb, String name) {
    cb.MethodBuilder? wrapper = cb.MethodBuilder();
    final wrapperArgs = <cb.Expression>[];
    final wrapperBody = <cb.Code>[];
    final dFunc = 'Dart$name';
    final nftb = ftb.build().toBuilder();
    final dftb = ftb.build().toBuilder();
    final mrt = findTransform(ftb.returnType as cb.TypeReference);
    var meta = '';
    if (mrt != null) {
      meta += _wasmMeta(mrt);
      nftb.returnType = mrt.alias;
      dftb.returnType = mrt.dartTypeOrAlias();
    }
    for (var i = 0; i < ftb.requiredParameters.length; i++) {
      var m = findTransform(ftb.requiredParameters[i] as cb.TypeReference);
      if (m != null) {
        meta += _wasmMeta(m);
        nftb.requiredParameters[i] = m.alias;
        dftb.requiredParameters[i] = m.dartTypeOrAlias();
        late cb.Reference type;
        if (m.cType.symbol == 'Pointer' && m.cType.url == dartffi) {
          type = dartInt;
          wrapperBody.add(cb
              .refer('Pointer')
              .property('fromAddress')
              .call([cb.refer('arg$i')])
              .assignFinal('ptrArg$i', m.alias)
              .statement);
          wrapperArgs.add(cb.refer('ptrArg$i'));
        } else if (m.cType.isInt64Bit) {
          type = dartDynamic;
          wrapperBody.add(cb
              .refer('jsBigInt2DartInt')
              .call([cb.refer('arg$i')])
              .assignFinal('iArg$i', dartInt)
              .statement);
          wrapperArgs.add(cb.refer('iArg$i'));
        } else {
          type = dftb.requiredParameters[i];
          wrapperArgs.add(cb.refer('arg$i'));
        }
        wrapper.requiredParameters.add(cb.Parameter((pb) => pb
          ..name = 'arg$i'
          ..type = type));
      }
    }
    if (mrt != null && mrt.cType.symbol == 'Pointer' && mrt.cType.url == dartffi) {
      wrapper.returns = dartInt;
      wrapperBody.addAll([
        cb
            .refer('Function')
            .property('apply')
            .call([cb.refer('f'), cb.literalList(wrapperArgs)])
            .assignFinal('result')
            .statement,
        Return(cb.refer('result').property('address')),
      ]);
    } else if (wrapperBody.isNotEmpty) {
      wrapper.returns = dftb.returnType;
      wrapperBody.add(Return(cb
          .refer('Function')
          .property('apply')
          .call([cb.refer('f'), cb.literalList(wrapperArgs)])));
      wrapper.body = wrapperBody.toBlock();
    } else {
      wrapper = null;
    }
    libraries[_currentSection]!.body.add(nftb.build().toTypeDef(name));
    libraries[_currentSection]!.body.add(dftb.build().toTypeDef(dFunc));
    // add webassembly meta
    _wasmFuncMeta[cb.refer(dFunc)] = FunctionMeta(cb.literalString(meta), wrapper);
  }

  static String _wasmMeta(TypeTransformProcedure m) {
    if (m.cType == cVoid) return 'v';
    if (m.cType == cFloat) return 'f';
    if (m.cType == cDouble) return 'd';
    final i = ffiCType.indexOf(m.cType);
    if (i == 10 || i < 6) return 'i';
    if (i > 5 && i < 8) return 'j';
    if (m.cType.symbol == 'Pointer' && m.cType.url == dartffi) return 'i';
    throw Exception('Unsupported type ${m.cType}, cannot translate to webassembly param type.');
  }
}

cb.LibraryBuilder initWebLibrary(List<cb.Reference> mixins) {
  final builder = cb.LibraryBuilder();
  builder.name = 'sqlite3';
  builder.annotations.add(_jsAnnotation.call([]));
  builder.body.addAll([
    _jsReference('module', jsName: 'Module', requiredParam: [
      _paramater('mod', createType('WasmModule')),
    ]),
    cb.Field((fb) => fb
      ..docs.add('/// module reference to wasm runtime.')
      ..name = '_wasm'
      ..modifier = cb.FieldModifier.final$
      ..type = createType('WasmModule')
      ..assignment = cb.refer('WasmModule').call([]).code),
    cb.Field((fb) => fb
      ..docs.add('/// indicate whether Webassembly is built with BigInt')
      ..name = 'isBigInt'
      ..late = true
      ..modifier = cb.FieldModifier.final$
      ..type = dartBool),
    cb.Class((b) => b
      ..docs.add('/// Javascript webassembly module')
      ..annotations.add(_jsAnnotation.call([cb.literalString('Object')]))
      ..name = 'WasmModule'
      ..constructors.add(cb.Constructor((b) => b
        ..factory = true
        ..external = true))
      ..fields.addAll([
        cb.Field((fb) => fb
          ..docs.add('/// a reference to webassembly heapu8.')
          ..name = 'external:HEAPU8'
          ..type = createType('List', null, [dartInt]))
      ])
      ..methods.addAll([
        _jsReference('hasOwnProperty', returns: dartBool, requiredParam: [
          _paramater('name', dartString),
        ]),
        _jsReference(
          'cwrap',
          requiredParam: [
            _paramater('apiName', dartString),
            _paramater('returnType', dartString),
          ],
          optionalParam: [
            _paramater('parameters', createType('List', null, [dartString]).nullable())
          ],
        ),
        _jsReference('_malloc', returns: createType('R'), types: true, requiredParam: [
          _paramater('length', dartInt),
        ]),
        _jsReference('_free', requiredParam: [_paramater('address', dartNum)]),
        _jsReference('run'),
        _jsReference('writeArrayToMemory', requiredParam: [
          _paramater('binary', dartUint8List),
          _paramater('buffer', dartNum),
        ]),
        _jsReference(
          'setValue',
          requiredParam: [
            _paramater('ptr', dartNum),
            _paramater('value', dartDynamic),
            _paramater('type', dartString)
          ],
          optionalParam: [_paramater('noSafe', dartBool.nullable())],
        ),
        _jsReference(
          'getValue',
          requiredParam: [_paramater('ptr', dartNum), _paramater('type', dartString)],
          optionalParam: [_paramater('noSafe', dartBool.nullable())],
        ),
        _jsReference('lengthBytesUTF8', returns: dartInt, requiredParam: [
          _paramater('txt', dartString),
        ]),
        _jsReference('lengthBytesUTF16', returns: dartInt, requiredParam: [
          _paramater('txt', dartString),
        ]),
        _jsReference('stringToUTF8', requiredParam: [
          _paramater('txt', dartString),
          _paramater('ptr', dartNum),
          _paramater('maxWriteSize', dartInt),
        ]),
        _jsReference(
          'UTF8ToString',
          returns: dartString,
          requiredParam: [_paramater('ptr', dartNum)],
          optionalParam: [_paramater('maxSizeRead', dartInt.nullable())],
        ),
        _jsReference('stringToUTF16', requiredParam: [
          _paramater('txt', dartString),
          _paramater('ptr', dartNum),
          _paramater('maxWriteSize', dartInt),
        ]),
        _jsReference(
          'UTF16ToString',
          returns: dartString,
          requiredParam: [_paramater('ptr', dartNum)],
          optionalParam: [_paramater('maxSizeRead', dartInt.nullable())],
        ),
        _jsReference('addFunction', returns: dartInt, requiredParam: [
          _paramater('func', createType('Function')),
          _paramater('meta', dartString),
        ]),
        _jsReference('removeFunction', requiredParam: [_paramater('ptr', dartNum)]),
      ])),
    cb.Code(
        '\n\n// typedef to help dynamic library lookup api for current versioning of the sqlite\n'),
    cb.FunctionType((b) => b..returnType = dartString).toTypeDef(voidString.symbol!),
    cb.FunctionType((b) => b..returnType = dartInt).toTypeDef(versionDartDef.symbol!),
    cb.Method((b) => b
      ..docs.add('\n\n// Destructor use to free pointer allocation')
      ..returns = dartVoid
      ..name = '_sqliteDestructor'
      ..requiredParameters.add(cb.Parameter((pb) => pb
        ..name = 'ptr'
        ..type = dartNum))
      ..body = _free.call([cb.refer('ptr')]).code
      ..lambda = true),
    _addFunc
        .call([
          pkgJSFunc.call([cb.refer('_sqliteDestructor')]),
          cb.literalString('vi'),
        ])
        .assignFinal('_ptrDestructor', dartInt)
        .statement,
    cb.Class((b) {
      b.name = baseClass.symbol;
      b.abstract = true;
      b.fields.addAll([
        lateFinalField(
          libNumber.symbol!,
          _cWrap.call(
              [cb.literalString('sqlite3_libversion_number'), cb.literalString('number')]).code,
          versionDartDef,
        ),
        lateFinalField(
          libVersion.symbol!,
          _cWrap.call([cb.literalString('sqlite3_libversion'), cb.literalString('string')]).code,
          voidString,
        ),
        lateFinalField(
          srcId.symbol!,
          _cWrap.call([cb.literalString('sqlite3_sourceid'), cb.literalString('string')]).code,
          voidString,
        ),
      ]);
      b.methods.addAll([
        cb.Method((mb) => mb
          ..docs.add('/// return dynamic library version')
          ..name = libVersion.symbol!.substring(1)
          ..lambda = true
          ..type = cb.MethodType.getter
          ..body = libVersion.call([]).code
          ..returns = dartString),
        cb.Method((mb) => mb
          ..docs.add('/// return dynamic library source id')
          ..name = srcId.symbol!.substring(1)
          ..lambda = true
          ..type = cb.MethodType.getter
          ..body = srcId.call([]).code
          ..returns = dartString),
        cb.Method((mb) => mb
          ..docs.add('/// return SQLite dynamic library version as number')
          ..name = libNumber.symbol!.substring(1)
          ..returns = dartInt
          ..lambda = true
          ..type = cb.MethodType.getter
          ..body = libNumber.call([]).code),
      ]);
    }),
    cb.Class((b) => b
      ..docs.add('/// Web binder provide a compatible method to access SQLite C APIs.')
      ..name = apiClassName
      ..extend = baseClass
      ..mixins.addAll(mixins)
      ..methods.addAll([
        cb.Method((b) => b
          ..static = true
          ..name = 'instance'
          ..modifier = cb.MethodModifier.async
          ..optionalParameters.add(cb.Parameter((pb) => pb
            ..name = 'path'
            ..type = createNullableType('String')))
          ..returns = createType('Future', dartasync, [createType(apiClassName)])
          ..body = <cb.Code>[
            cb
                .refer('promiseToFuture', dartjsUtil)
                .call([
                  cb.refer('module').call([cb.refer('_wasm')])
                ])
                .awaited
                .statement,
            wasm.property('run').call([]).statement,
            cb
                .refer('isBigInt')
                .assign(wasm.property('hasOwnProperty').call([cb.literalString('HEAPU64')]).and(
                    wasm.property('hasOwnProperty').call([cb.literalString('HEAP64')])))
                .statement,
            Return(cb.refer(apiClassName).property('_').call([])),
          ].toBlock())
      ])
      ..constructors.add(cb.Constructor((b) => b.name = '_'))),
  ]);
  return builder;
}

cb.Method _jsReference(
  String name, {
  String? jsName,
  cb.TypeReference? returns,
  Iterable<cb.Parameter>? requiredParam,
  Iterable<cb.Parameter>? optionalParam,
  bool types = false,
}) {
  if (types && returns == null) throw Exception('Generic required the given return type');
  return cb.Method((mb) => mb
    ..docs.add('/// a reference to webassembly ${jsName ?? name} method.')
    ..annotations.addAll(jsName == null
        ? []
        : [
            _jsAnnotation.call([cb.literalString(jsName)])
          ])
    ..name = name
    ..external = true
    ..returns = returns
    ..types.addAll(types ? [returns!] : [])
    ..requiredParameters.addAll(requiredParam ?? [])
    ..optionalParameters.addAll(optionalParam ?? []));
}

cb.Parameter _paramater(
  String name,
  cb.TypeReference type, {
  bool named = false,
  cb.Code? default$,
}) =>
    cb.Parameter((pb) => pb
      ..name = name
      ..named = named
      ..defaultTo = default$
      ..type = type);
