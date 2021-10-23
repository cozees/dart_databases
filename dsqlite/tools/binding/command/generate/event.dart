part of 'generate.dart';

const darttyped = 'dart:typed_data';

const header = ''
        '// ***************************************************************\n'
        '// **************** GENERATED CODE DOT NOT MODIFY ****************\n'
        '// ***************************************************************\n\n',
    apiClassName = 'SQLiteLibrary',
    baseClass = cb.Reference('_$apiClassName');

const dartasync = 'dart:async';
const dartconv = 'dart:convert';
const crossImport = 'native/library.g.dart?'
    'web=web/library.g.dart&'
    'io=native/library.g.dart';

const constPkg = 'package:dsqlite/src/sqlite/constants.g.dart';

const _knownImportAlias = <String, String>{
  dartasync: '_async',
  dartffi: 'ffi',
  pkgffi: 'pkgffi',
  darttyped: 'typed',
  dartconv: 'conv',
  'dart:io': 'io',
  dartjs: 'js',
  dartjsUtil: 'jsutil',
  'package:database_sql/database_sql.dart': 'dbsql',
  'package:js/js.dart': 'pkgjs',
  crossImport: 'cpf',
};

final libNumber = cb.refer('_libVersionNumber'),
    srcId = cb.refer('_sourceId'),
    libVersion = cb.refer('_libVersion');

final voidString = cb.refer('_DefVoidStringFunc'),
    versionCDef = cb.refer('_DefLibVersion'),
    versionDartDef = cb.refer('_DefLibVersionDart');

final formatter = DartFormatter(pageWidth: 100, fixes: StyleFix.all);
final emitter = GenCodeEmitter(
  allocator: PrefixedAllocator(true, _knownImportAlias),
  useNullSafetySyntax: true,
);

//
class TypeTransformProcedure {
  const TypeTransformProcedure({
    required this.alias,
    required this.webType,
    required this.dartType,
    required this.cType,
    this.canCastNatively = false,
    this.needEncode = false,
  });

  final cb.TypeReference alias;
  final cb.TypeReference webType;
  final cb.TypeReference dartType;
  final cb.TypeReference cType;
  final bool needEncode;
  final bool canCastNatively;

  cb.TypeReference dartTypeOrAlias([bool includeEncode = false]) =>
      canCastNatively || (needEncode && includeEncode) ? dartType :   alias;

  cb.TypeReference dartTypeOrAliasWeb([bool includeEncode = false]) =>
      canCastNatively || (needEncode && includeEncode)
          ? (cType.isInt64Bit ? dartDynamic : dartType)
          : alias;
}

// extended defined type
final dartUint8List = createType('Uint8List', darttyped),
    cPtrVoidAlias = createType('PtrVoid'),
    cPtrStringAlias = createType('PtrString'),
    cPtrString16Alias = createType('PtrString16');

final _arrayTypesMapping = {
  createTypeArray(ffiCType[0]!): createType('Int32List', darttyped),
  createTypeArray(ffiCType[1]!): createType('Int8List', darttyped),
  createTypeArray(ffiCType[2]!): dartUint8List,
  createTypeArray(ffiCType[3]!): createType('Int16List', darttyped),
  createTypeArray(ffiCType[4]!): createType('Uint16List', darttyped),
  createTypeArray(ffiCType[5]!): createType('Uint32List', darttyped),
  createTypeArray(ffiCType[6]!): createType('Int64List', darttyped),
  createTypeArray(ffiCType[7]!): createType('Uint64List', darttyped),
  createTypeArray(ffiCType[8]!): createType('Float32List', darttyped),
  createTypeArray(ffiCType[9]!): createType('Float64List', darttyped),
  createTypeArray(ffiCType[10]!): createType('Int8List', darttyped),
};

final _transformTypes = {
  ffiCType[13]: TypeTransformProcedure(
    alias: createType('NVoid'),
    dartType: dartType[13]!,
    webType: createType('Void'),
    cType: ffiCType[13]!,
    canCastNatively: true,
  ), // 13 :: void
  // special case for string
  cPtrString: TypeTransformProcedure(
    alias: createType('PtrString'),
    dartType: dartString,
    webType: createType('Pointer', null, [createType('Utf8')]),
    cType: cPtrString,
    canCastNatively: false,
    needEncode: true,
  ),
  cPtrString16: TypeTransformProcedure(
    alias: createType('PtrString16'),
    dartType: dartString,
    webType: createType('Pointer', null, [createType('Utf16')]),
    cType: cPtrString,
    canCastNatively: false,
    needEncode: true,
  ),
  for (var i = 0; i < 11; i++)
    ffiCType[i]: TypeTransformProcedure(
      alias: createType('N${ffiCType[i]!.symbol.toLowerCase()}'),
      dartType: dartType[i]!,
      cType: ffiCType[i]!,
      webType: createType(ffiCType[i]!.symbol),
      canCastNatively: true,
    ),
  // any transform type index greater than 13 is required type alias web type is always num
};

TypeTransformProcedure? findTransform(cb.TypeReference type) {
  if (type.symbol.startsWith('Ptr') || type.symbol.startsWith('N')) {
    // a type alias required loop
    // let it crash if not found. This type alias that have absolutely defined
    return _transformTypes.entries.firstWhere((e) => e.value.alias.type == type).value;
  } else if (type.isNullable == true) {
    return _transformTypes[type.rebuild((b) => b.isNullable = null)];
  } else {
    return _transformTypes[type];
  }
}

// dynamic define as parsing go so we need to check whether closure function definition is the same
// despite the argument name or method name is the same
final _usedTypedefName = <String, bool>{};

final _declaration = <cb.FunctionType, cb.TypeReference>{};

final _generateMeta = loadApiMeta();

class ParserEvent extends ComponentEvent {
  // track the number of variable count
  static int _typeCount = 1;

  static String typeName([String? name]) =>
      name == null ? 'DefTypeGen${_typeCount++}' : 'Def$name${_typeCount++}';

  ParserEvent(
    this.out, {
    required this.apis,
    required this.constants,
    required this.objects,
    required this.apisDoc,
    required this.constantsDoc,
    required this.objectsDoc,
  })  : native = NativeGenerateEvent(out),
        web = WebGenerateEvent(out),
        apiInterface = initCrossPlatformAPI();

  final String out;

  final List<String> apis;
  final List<String> constants;
  final List<String> objects;

  final Map<String, List<String>> apisDoc;
  final Map<String, List<String>> constantsDoc;
  final Map<String, List<String>> objectsDoc;

  final NativeGenerateEvent native;
  final WebGenerateEvent web;

  final cb.LibraryBuilder constantsBuilder = cb.LibraryBuilder();
  final cb.ClassBuilder apiInterface;

  @override
  void finalize() {
    // validate that everything generated
    if (constants.isNotEmpty) {
      throw Exception('There ${constants.length} constant(s) remains.\n\t ${constants.join(', ')}');
    }
    // start write code to the file.
    web.finalize();
    native.finalize();
    // generate constant value
    var content = formatter.format(constantsBuilder
        .build()
        .accept(GenCodeEmitter(
          allocator: PrefixedAllocator(false),
          useNullSafetySyntax: true,
        ))
        .toString());
    File([out, 'constants.g.dart'].joinPath())
      ..createSync(recursive: true)
      ..writeAsStringSync('$header$content');
    // generate api interface
    final apiLib = cb.LibraryBuilder()
      ..directives.addAll([
        cb.Directive.export(crossImport, show: [
          'isNative',
          'nullptr',
          'Pointer',
          'Utf8',
          'Utf16',
          'Int8',
          'Int32',
          'Int64',
          'Void',
          'PtrVoid',
          'Utf8Pointer',
          'Utf16Pointer',
          'Int32Pointer',
          'Int64Pointer',
          'PointerPointer',
          'PtrPtrUtf8',
          'malloc',
          'free',
          'AllocatorAlloc',
          'PtrSqlite3',
          'PtrPtrSqlite3',
          'PtrStmt',
          'PtrPtrStmt',
          'PtrValue',
          'PtrPtrValue',
          'PtrContext',
          'DefpxFunc',
          'DartDefpxFunc',
          'DefxFinal',
          'DartDefxFinal',
          'DefxFree',
          'DartDefxFree',
          'DefxSize',
          'DartDefxSize',
          'DefDefTypeGen10',
          'DartDefDefTypeGen10',
          'DefxCompare',
          'DartDefxCompare',
          'Defcallback',
          'DartDefcallback',
        ]),
        cb.Directive.part('apis_ext.dart'),
      ])
      ..body.add(apiInterface.build());
    content = formatter.format(apiLib
        .build()
        .accept(GenCodeEmitter(
          allocator: PrefixedAllocator(true, _knownImportAlias),
          useNullSafetySyntax: true,
        ))
        .toString());
    File([out, 'apis.g.dart'].joinPath())
      ..createSync(recursive: true)
      ..writeAsStringSync('$header$content');
  }

  @override
  void onSection(String name) => native.section = web.section = name;

  @override
  void onAPI(String name) => native.apiName = web.apiName = name;

  @override
  void onClass(cb.ClassBuilder cbe, [bool subClass = false]) {
    if (objectsDoc[cbe.name] != null) {
      cbe.docs.addAll(objectsDoc[cbe.name]!.map((e) => '/// $e'));
    }
    web.onClass(cbe);
    native.onClass(cbe);
  }

  @override
  void onConstant(cb.Expression expr, String name) {
    constantsBuilder.body.add(cb.Code('\n'));
    constantsBuilder.body.addAll(constantsDoc[name]!.map((e) => cb.Code('/// $e\n')));
    constantsBuilder.body.add(expr.statement);
    constants.remove(name);
  }

  @override
  void onField(cb.FieldBuilder fb, String name) {
    final a = _transformTypes[fb.type!];
    if (a == null) {
      fb.type = onType(fb.type as cb.TypeReference);
    }
  }

  @override
  void onMethod(cb.MethodBuilder mb, String name, [bool isFunction = false]) {
    if (!apis.contains(name)) return;
    // correct declaration before generate native or web code
    _generateMeta.apisMeta[name]?.makeCorrection(mb);
    // generate native & web code
    web.onMethod(mb, name);
    native.onMethod(mb, name);
    // handle apis cross platform interface
    if (_generateMeta.crossPlatformApis.contains(name)) {
      mb.docs.add('/// Cross platform interface api for $name');
      var m = findTransform(mb.returns as cb.TypeReference);
      // assign appropriate type if possible
      final meta = _generateMeta.apisMeta[name];
      if (m?.dartType == dartString) {
        mb.returns = dartString;
      } else if (meta?.returns.isBlob == true) {
        mb.returns = dartUint8List;
      } else if (m != null) {
        mb.returns = m.dartTypeOrAlias();
      }
      // if the type is an alias typedef then add url import
      if (mb.returns!.symbol!.startsWith('Ptr')) {
        mb.returns = (mb.returns as cb.TypeReference).rebuild((b) => b.url = crossImport);
      }
      if (meta?.returns.nullable == true) {
        mb.returns = (mb.returns as cb.TypeReference).nullable();
      }
      final args = <cb.Expression>[];
      final tobeRemoved = <int>[];
      MetaParam? ppMeta;
      for (var i = 0; i < mb.requiredParameters.length; i++) {
        var pMeta = meta?.params.elementAt(i);
        // if argument is size of previous argument then skip it
        if (pMeta?.destroyer == true ||
            (pMeta != null && ppMeta != null && pMeta.sizeOf == ppMeta.param.name)) {
          tobeRemoved.add(i);
          continue;
        }
        // cannot be skip add them to parameter list
        args.add(cb.refer(mb.requiredParameters[i].name));
        var isNullable = meta?.params.elementAt(i).nullable == true;
        m = findTransform(mb.requiredParameters[i].type as cb.TypeReference);
        cb.TypeReference? type;
        if (m?.dartType == dartString) {
          type = dartString;
        } else if (pMeta?.isBlob == true) {
          type = dartUint8List;
        } else if (mb.requiredParameters[i].type!.symbol!.startsWith('Ptr')) {
          type = (mb.requiredParameters[i].type as cb.TypeReference)
              .rebuild((b) => b.url = crossImport);
        } else if (m != null) {
          type = m.needEncode || m.canCastNatively ? m.dartType : m.alias;
        } else {
          type = mb.requiredParameters[i].type as cb.TypeReference;
        }
        mb.requiredParameters[i] = mb.requiredParameters[i].rebuild((pb) {
          pb.type = isNullable && !type!.symbol.startsWith('Ptr') ? type.nullable() : type;
        });
        ppMeta = pMeta;
      }
      for (var i in tobeRemoved.reversed) {
        mb.requiredParameters.removeAt(i);
      }
      mb.name = mb.name!.substring(8);
      mb.lambda = true;
      mb.body = cb.refer('_sqlite').property(mb.name!).call(args).code;
      apiInterface.methods.add(mb.build());
    }
  }

  @override
  void onParameter(cb.ParameterBuilder pb, String name) {
    pb.name = name;
    final tt = _transformTypes[pb.type];
    if (tt != null && !tt.canCastNatively) {
      pb.type = tt.alias;
      web.onType(tt, false);
      native.onType(tt, false);
    } else {
      pb.type = onType(pb.type as cb.TypeReference);
    }
  }

  @override
  cb.TypeReference onType(cb.TypeReference tr) => _resolveType(tr);

  cb.TypeReference _resolveType(cb.TypeReference tr, {bool force = false}) {
    // if type is not a pointer it ignore.
    if ((tr.symbol != 'Pointer' && tr.symbol != 'Array') || tr.url != dartffi) return tr;
    // create alias for pointer
    var m = _transformTypes[tr];
    var news = m != null;
    if (!news || force) {
      var prefix = '';
      var dimension = 0;
      var original = tr.toBuilder().build();
      var refs = <String>[];
      while ((tr.symbol == 'Pointer' || tr.symbol == 'NativeFunction' || tr.symbol == 'Array') &&
          tr.url == dartffi &&
          tr.types.length == 1) {
        if (tr.symbol == 'Pointer') prefix = 'Ptr$prefix';
        if (tr.symbol == 'Array') prefix = 'Array$prefix';
        refs.add(tr.symbol);
        tr = tr.types.first as cb.TypeReference;
        dimension++;
      }
      if (tr.url != null && tr.types.isNotEmpty) throw Exception('unsupported type $tr.');
      refs.add(tr.symbol);
      cb.TypeReference? webType;
      for (var symbol in refs.reversed) {
        if (webType == null) {
          webType = createType(symbol);
        } else {
          webType = createType(symbol, null, [webType]);
        }
      }
      var tname = '$prefix${typeAliasNameConversion(tr.symbol, true)}';
      var natively = false;
      var dartType = original;
      if (dimension == 1 && _arrayTypesMapping[original] != null) {
        natively = true;
        dartType = _arrayTypesMapping[original]!;
      } // let ignored 2, 3 or more dimension we're target binary and string mostly.
      m = TypeTransformProcedure(
        alias: cb.TypeReference((b) => b.symbol = tname),
        webType: webType!,
        dartType: dartType,
        cType: original,
        needEncode: natively,
      );
      _transformTypes[original] = m;
    }
    web.onType(m!, news);
    native.onType(m, news);
    return m.alias;
  }

  @override
  cb.TypeReferenceBuilder onTypeDef(
    cb.FunctionTypeBuilder ftb,
    int pointer, {
    String? name,
    String? root,
    bool explicitName = false,
  }) {
    // already existed
    final ft = ftb.build();
    var type = _declaration[ft];
    if (type != null) {
      type = buildPointer(pointer, type).build();
      type = _resolveType(type, force: false);
      return type.toBuilder();
    }
    // generate a name if not exist or conflict
    name ??= typeName();
    var gname = explicitName ? name : 'Def$name';
    if (_usedTypedefName[gname] == true) {
      // add `Def` prefix to avoid parameter name conflict with the type
      gname = root != null ? 'Def$root$name' : 'Def$name${_typeCount++}';
    }
    // generate typedef alias to current closure
    web.onTypeDef(ftb, gname);
    native.onTypeDef(ftb, gname);
    // let create type alias which different depend on platform
    if (pointer > 0) {
      var trb = cb.TypeReferenceBuilder()
        ..types.add(cb.TypeReference((b) => b..symbol = gname))
        ..symbol = 'NativeFunction'
        ..url = dartffi;
      var based = trb.build();
      var type = buildPointer(pointer, based).build();
      type = _resolveType(type, force: true);
      _declaration[ft] = based;
      _usedTypedefName[gname] = true;
      return type.toBuilder();
    }
    throw Exception('Unsupported typedef function $name without pointer.');
  }
}

String typeAliasNameConversion(String txt, [bool firstCap = false]) {
  if (txt == 'sqlite3') return '${txt[0].toUpperCase()}${txt.substring(1)}';
  if (txt.contains('sqlite3_')) txt = txt.replaceFirst('sqlite3_', '');
  final buffer = StringBuffer();
  for (var i = 0; i < txt.length; i++) {
    var n = i + 1;
    if (txt[i] == '_') {
      if (buffer.isEmpty) continue;
      if (n < txt.length) {
        i = n;
        buffer.write(txt[n].toUpperCase());
      }
    } else {
      buffer.write(buffer.isEmpty && firstCap ? txt[i].toUpperCase() : txt[i]);
    }
  }
  return buffer.toString();
}

cb.ClassBuilder initCrossPlatformAPI() {
  final field = cb.refer('_sqlite');
  final builder = cb.ClassBuilder();
  builder.docs.add('/// Cross platform interface for native and web.');
  builder.name = apiClassName;
  builder.fields.add(cb.Field((fb) {
    fb.modifier = cb.FieldModifier.final$;
    fb.name = field.symbol!;
    fb.type = createType(apiClassName, crossImport);
  }));
  builder.constructors.add(cb.Constructor((b) => b
    ..name = '_'
    ..requiredParameters.add(cb.Parameter((pb) => pb
      ..name = field.symbol!
      ..toThis = true))));
  builder.methods.addAll([
    cb.Method((mb) => mb
      ..static = true
      ..modifier = cb.MethodModifier.async
      ..returns = createType('Future', dartasync, [createType(apiClassName)])
      ..optionalParameters.add(cb.Parameter((pb) => pb
        ..name = 'path'
        ..type = createNullableType('String')))
      ..body = Return(cb.refer(apiClassName).property('_').call([
        cb.refer('SQLiteLibrary', crossImport).property('instance').call([cb.refer('path')]).awaited
      ]))
      ..name = 'instance'),
    cb.Method((mb) => mb
      ..docs.add('/// Return the current version of current sqlite3 library in number')
      ..name = 'libVersionNumber'
      ..returns = dartInt
      ..type = cb.MethodType.getter
      ..lambda = true
      ..body = field.property('libVersionNumber').code),
    cb.Method((mb) => mb
      ..docs.add('/// Return the current version of current sqlite3 library in String')
      ..name = 'libVersion'
      ..returns = dartString
      ..type = cb.MethodType.getter
      ..lambda = true
      ..body = field.property('libVersion').code),
    cb.Method((mb) => mb
      ..docs.add('/// Return the hash source id of current sqlite3 library.')
      ..name = 'sourceId'
      ..returns = dartString
      ..type = cb.MethodType.getter
      ..lambda = true
      ..body = field.property('sourceId').code),
  ]);
  return builder;
}
