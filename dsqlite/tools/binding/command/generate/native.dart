part of 'generate.dart';

final cPtrVoid = createTypePointer([cVoid]),
    cPtrString = createTypePointer([cString]),
    cPtrString16 = createTypePointer([cString16]),
    library = cb.refer('library'),
    dynamicLibrary = createType('DynamicLibrary', dartffi),
    lookup = library.property('lookup'),
    funcLookup = library.property('lookupFunction'),
    malloc = cb.refer('malloc', pkgffi),
    mallocFree = malloc.property('free'),
    calloc = cb.refer('calloc', pkgffi),
    callocFree = calloc.property('free'),
    superRef = cb.refer('super'),
    nativeFuncFrom = cb.refer('Pointer', dartffi).property('fromFunction'),
    dbException = cb.refer('DatabaseException', 'package:database_sql/database_sql.dart');

class FunctionAliasMeta {
  FunctionAliasMeta(this.returnType, this.dartFuncType);

  final cb.TypeReference returnType;
  final cb.TypeReference dartFuncType;
}

class NativeGenerateEvent {
  NativeGenerateEvent(String out) : out = [out, 'native'].join(Platform.pathSeparator) {
    libraries = <int, cb.LibraryBuilder>{
      /* *** Types **** */ 1: cb.LibraryBuilder(),
    };
    mixinBuilders = {};
    for (var mod in apisGroups.keys) {
      libraries[mod.hashCode] = cb.LibraryBuilder();
      mixinBuilders[mod.hashCode] = cb.MixinBuilder()
        ..docs.add('\n\n// Mixin for $mod')
        ..name = '_Mixin$mod'
        ..on = baseClass;
    }
  }

  final partOf = cb.Directive.partOf('library.g.dart');
  final parts = apisGroups.keys.map((e) => cb.Directive.part('${e.toLowerCase()}.g.dart'));

  int _currentSection = -1;
  String _section = '';

  final Map<cb.TypeReference, FunctionAliasMeta> _funcAlias = {};

  FunctionAliasMeta? findFuncTypeAlias(cb.TypeReference type) {
    if (type.symbol.startsWith('Ptr')) {
      type = createType(type.symbol.replaceAll('Ptr', '').firstLowerCase());
    }
    return _funcAlias[type];
  }

  set section(String val) {
    _section = val;
    _currentSection = val.hashCode;
    if (libraries[_currentSection] == null) {
      if (_clazzStore.isNotEmpty) {
        libraries[1]!.body.addAll(_clazzStore.values);
        _clazzStore.clear();
      }
      int half = ((90 - val.length) / 2).ceil();
      final asterisk = ''.padLeft(half, '*');
      libraries[1]!.body.add(cb.Code('\n\n// $asterisk $val $asterisk\n\n'));
    }
  }

  // ignore, nothing to do with it right now
  set apiName(String val) {}

  final String out;

  late final Map<int, cb.LibraryBuilder> libraries;
  late final Map<int, cb.MixinBuilder> mixinBuilders;

  // prevent type conflict
  final Map<String, cb.Class> _clazzStore = {};

  void _writeContent(String name, cb.LibraryBuilder builder) {
    final content = formatter.format(builder.build().accept(emitter).toString());
    (File([out, '$name.g.dart'].joinPath())..createSync(recursive: true))
        .writeAsStringSync('$header$content');
  }

  void finalize() {
    // write part file
    for (var mod in apisGroups.keys) {
      _writeContent(
        mod.toLowerCase(),
        libraries[mod.hashCode]!
          ..directives.add(partOf)
          ..body.add(mixinBuilders[mod.hashCode]!.build()),
      );
    }
    libraries[1]!.body.addAll(_clazzStore.values);
    _writeContent('types', libraries[1]!..directives.add(partOf));
    // write extension
    _writeContent('extension', _extensionNativeHelper()..directives.add(partOf));
    // write main part file.
    final library = cb.LibraryBuilder()
      ..directives.addAll([
        ...parts,
        cb.Directive.part('types.g.dart'),
        cb.Directive.part('extension.g.dart'),
        // manual coding
        cb.Directive.part('extra.dart'),
        // forward export
        cb.Directive.export(dartffi, show: [
          'Pointer',
          'PointerPointer',
          'Int8',
          'Int32',
          'Int32Pointer',
          'Int64',
          'Int64Pointer',
          'Void',
          'AllocatorAlloc',
        ]),
        cb.Directive.export(pkgffi, show: [
          'Utf8',
          'Utf16',
          'Utf8Pointer',
          'Utf16Pointer',
          'malloc',
        ]),
      ])
      ..body.addAll([
        for (var cType in _transformTypes.keys)
          if (_transformTypes[cType] != null)
            cb.CodeExpression(cb.Code('typedef ${_transformTypes[cType]!.alias.symbol}'))
                .assign(cType!)
                .statement
      ]);
    _writeContent('library', _generateLibraryCode(library));
  }

  void onClass(cb.ClassBuilder cbe, [bool subClass = false]) {
    final prevClazz = _clazzStore[cbe.name];
    if (prevClazz == null || prevClazz.extend == cOpaque) {
      final original = cbe.fields;
      cbe.fields = ListBuilder<cb.Field>();
      cbe.fields.addAll(original.build().map((field) => field.rebuild((fb) {
            final m = _transformTypes[fb.type];
            if (m != null) {
              fb.type = m.canCastNatively ? m.dartType : m.alias;
            }
          })));
      _clazzStore[cbe.name!] = cbe.build();
      cbe.fields = original;
    }
  }

  void onMethod(cb.MethodBuilder mb, String name, [bool isFunction = false]) {
    final cft = cb.FunctionTypeBuilder(); // c typedef api
    final dft = cb.FunctionTypeBuilder(); // dart typedef is any
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
    final m = findTransform(mb.returns as cb.TypeReference);
    cft.returnType = m?.alias ?? mb.returns;
    dft.returnType = m?.dartTypeOrAlias() ?? mb.returns!;
    nmb.returns = m?.dartTypeOrAlias(true) ?? mb.returns!;
    nmb.requiredParameters.clear();
    final meta = _generateMeta.apisMeta[name]!;
    // transform argument first
    if (mb.requiredParameters.length > 1 ||
        (mb.requiredParameters.isNotEmpty &&
            mb.requiredParameters.first.type != createType('NVoid'))) {
      // debug and test purpose only
      var countPtrStr = 0;
      MetaParam? ppMeta;
      cb.Parameter? pParam;
      for (var i = 0; i < mb.requiredParameters.length; i++) {
        var p = mb.requiredParameters[i];
        var m = findTransform(p.type! as cb.TypeReference);
        var pMeta = meta.params.elementAt(i);
        var nullable = pMeta.nullable;
        // c definition meta
        cft.requiredParameters.add(m?.alias ?? p.type!);
        dft.requiredParameters.add(m?.dartTypeOrAlias() ?? p.type!);
        // check if it is size of previous argument
        if (ppMeta != null && pMeta.sizeOf == ppMeta.param.name) {
          // exclude argument as it's size of string or blob
          if (ppMeta.nullable) {
            args.add(cb
                .refer('${pParam!.name}Meta')
                .nullSafeProperty('length')
                .ifNullThen(cb.literalNum(0)));
          } else {
            args.add(cb.refer('${pParam!.name}Meta').property('length'));
          }
          ppMeta = pMeta;
          pParam = p;
          continue;
        }
        // destroyer argument is omitted for simplicity
        if (!pMeta.destroyer) {
          var type = pMeta.isBlob && pMeta.transform
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
        if (m?.dartType == dartString || pMeta.textKind || (pMeta.isBlob && pMeta.transform)) {
          final metaArg = cb.refer('${p.name}Meta');
          final ptrName = cb.refer('ptr${p.name.firstUpperCase()}');
          if (name.endsWith('_text64')) {
            arg = cb
                .refer(mb.requiredParameters.last.name)
                .equalTo(cb.refer('UTF8', constPkg))
                .conditional(
                    nullable
                        ? arg.nullSafeProperty('_metaNativeUtf8').call([])
                        : arg.property('_metaNativeUtf8').call([]),
                    nullable
                        ? arg.nullSafeProperty('_metaNativeUtf16').call([])
                        : arg.property('_metaNativeUtf16').call([]));
          } else {
            final mName = pMeta.isBlob
                ? '_metaNativeUint8'
                : (m!.alias.symbol.endsWith('16'))
                    ? '_metaNativeUtf16'
                    : '_metaNativeUtf8';
            arg = nullable ? arg.nullSafeProperty(mName).call([]) : arg.property(mName).call([]);
          }
          before.add(arg.assignFinal(metaArg.symbol!).statement);
          arg = nullable
              ? metaArg.nullSafeProperty('ptr').ifNullThen(cNullPtr)
              : metaArg.property('ptr');
          before.add(arg.assignFinal(ptrName.symbol!).statement);
          if (!meta.hasDestroyer) {
            finally$.add(mallocFree.call([ptrName]).statement);
          } else {
            countPtrStr++;
          }
          args.add(name.endsWith('_text64') ? ptrName.property('cast').call([]) : ptrName);
        } else {
          args.add(nullable ? arg.ifNullThen(cNullPtr) : arg);
          // use for verifying only
          if (pMeta.isBlob) countPtrStr++;
        }
        ppMeta = pMeta;
        pParam = p;
      }
      if (countPtrStr != 1 && meta.hasDestroyer) {
        throw Exception('APIs: $name has destroyer but accept $countPtrStr native '
            ' allocation. Only allowed 1.');
      }
    }
    // special for returning string & blob
    cb.Reference? result;
    if (nmb.returns == dartString) {
      result = cb.refer('result');
      if (meta.returns.free) before.add(cNullPtr.assignVar(result.symbol!, mb.returns).statement);
      final length = <String, cb.Expression>{};
      final two = cb.literalNum(2);
      if (name.contains('_value_text16')) {
        length['length'] = cb.refer('_h_sqlite3_value_bytes16').call(args).divisionInt(two);
      } else if (name.contains('_value_text')) {
        length['length'] = cb.refer('_h_sqlite3_value_bytes').call(args);
      } else if (name.contains('_column_text16')) {
        length['length'] = cb.refer('_h_sqlite3_column_bytes16').call(args).divisionInt(two);
      } else if (name.contains('_column_text')) {
        length['length'] = cb.refer('_h_sqlite3_column_bytes').call(args);
      }
      var expr = meta.returns.nullable
          ? result
              .equalTo(cNullPtr)
              .conditional(cb.literalNull, result.property('toDartString').call([], length))
          : result.property('toDartString').call([], length);
      after.add(Return(expr));
      if (meta.returns.free) {
        if (meta.returns.freeBy != null) {
          expr = cb.refer('_h_${meta.returns.freeBy}');
          finally$.add(expr.call([result.property('cast').call([])]).statement);
        } else {
          finally$.add(mallocFree.call([result]).statement);
        }
      }
    } else if (meta.returns.isBlob) {
      nmb.returns = dartUint8List;
      cb.Expression expr = result = cb.refer('result');
      if (mb.returns == cPtrVoid || mb.returns == cPtrVoidAlias) {
        expr = result.property('cast').call([], {}, [Affinity.uint8.cType()!]);
      }
      final bytes = cb.refer('_h_${name.replaceAll('_blob', '_bytes')}');
      expr = expr.property('toUint8List').call([], {'length': bytes.call(args)});
      expr =
          meta.returns.nullable ? result.equalTo(cNullPtr).conditional(cb.literalNull, expr) : expr;
      after.add(Return(expr));
    } else if (meta.returns.nullable) {
      result = cb.refer('result');
      if (meta.returns.pointer) {
        after.add(Return(result.equalTo(cNullPtr).conditional(cb.literalNull, result)));
      } else {
        throw Exception('Native C APIs of scalar type cannot be null.');
      }
    }
    // if result can be null
    if (meta.returns.nullable) nmb.returns = (nmb.returns as cb.TypeReference).nullable();
    // add typedef
    final handlerName = '_h_${mb.name}';
    cb.Expression handler = cb.refer(handlerName);
    String cdef = '_c_${mb.name}';
    String? ddef;
    libraries[_currentSection]!.body.addAll([
      cft.build().toTypeDef(cdef),
      if (cft != dft) dft.build().toTypeDef(ddef = '_d_${mb.name}')
    ]);
    // check version and built dependent
    var fieldType = ddef == null ? createType(cdef) : createType(ddef);
    var expr = funcLookup.find(mb.name!, cb.refer(cdef), ddef == null ? null : cb.refer(ddef));
    if (meta.builtDependent) {
      fieldType = fieldType.nullable();
      expr = cb.refer('_nullable').call([
        cb.Method((mb) => mb
          ..lambda = true
          ..body = expr.code).closure
      ]);
    }
    if (meta.change != null && meta.change!.kind != ChangeKind.deprecate) {
      fieldType = fieldType.nullable();
      final version = cb.literalNum(meta.change!.version.versionNumber);
      final libVersion = cb.refer('libVersionNumber');
      if (meta.change!.kind == ChangeKind.add) {
        before.insert(
            0,
            If(
              libVersion.lessThan(version),
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
              libVersion.greaterThan(version),
              Throw(dbException.call([
                cb.literalString('API $name is not available after ${meta.change!.version.version}')
              ])),
            ));
        expr = libVersion.greaterThan(version).conditional(cb.literalNull, expr);
        handler = handler.nullChecked;
      }
    }
    if (meta.builtDependent) {
      before.add(If(
        handler.equalTo(cb.literalNull),
        Throw(dbException.call([
          cb.literalString('API $name is not available, You need to enable it '
              'during library build.')
        ])),
      ));
      if (handler is cb.Reference) handler = handler.nullChecked;
    }
    // special case for prepare statement
    if (name.startsWith('sqlite3_prepare')) {
      result = cb.refer('result');
      after.addAll([
        If(
            args.last
                .property('value')
                .property('address')
                .operatorSubstract(args[1].property('address'))
                .equalTo(args[2]),
            args.last.property('value').assign(cNullPtr).statement),
        Return(result),
      ]);
    }
    // create method body
    nmb.body = cb.Block((b) {
      b.statements.addAll(before);
      if (mb.returns!.symbol == 'void' && mb.returns!.url == null) {
        after.insert(0, handler.call(args).statement);
      } else if (result != null) {
        after.insert(0, handler.call(args).assignVar(result.symbol!).statement);
      } else {
        after.insert(0, Return(handler.call(args)));
      }
      if (finally$.isNotEmpty) {
        b.statements.add(Try(after.toBlock()).finally$(finally$.toBlock()));
      } else {
        b.statements.addAll(after);
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

  void onType(TypeTransformProcedure ttd, [bool news = true]) {
    // TODO: implement visitType
  }

  void onTypeDef(cb.FunctionTypeBuilder ftb, String name) {
    // dart function typedef
    var cf = ftb.build();
    var df = cf.rebuild((b) {
      var m = findTransform(b.returnType as cb.TypeReference);
      if (m != null) b.returnType = m.dartTypeOrAlias();
      for (var i = 0; i < b.requiredParameters.length; i++) {
        m = findTransform(b.requiredParameters[i] as cb.TypeReference);
        if (m != null) b.requiredParameters[i] = m.dartTypeOrAlias();
      }
    });
    final dFunc = 'Dart$name';
    // write to specific
    if (libraries[_currentSection] != null) {
      libraries[_currentSection]!.body.add(cf.toTypeDef(name));
      libraries[_currentSection]!.body.add(df.toTypeDef(dFunc));
    } else {
      libraries[1]!.body.add(cf.toTypeDef(name));
      libraries[1]!.body.add(df.toTypeDef(dFunc));
    }
    _funcAlias[createType(name)] =
        FunctionAliasMeta(df.returnType as cb.TypeReference, createType(dFunc));
  }
}

cb.LibraryBuilder _generateLibraryCode(cb.LibraryBuilder builder) {
  final mixins = apisGroups.keys.map((e) => cb.Reference('_Mixin$e'));
  // expose free and malloc
  builder.body.addAll([
    cb.Method((mb) => mb
      ..docs.add('/// provide cross platform function to free memory.')
      ..name = 'free'
      ..lambda = true
      ..requiredParameters.add(cb.Parameter((pb) => pb
        ..name = 'ptr'
        ..type = createType('Pointer', dartffi)))
      ..body = cb.refer('malloc', pkgffi).property('free').call([cb.refer('ptr')]).code),
    cb.Method((mb) => mb
      ..docs.add('/// alias to dart:ffi nullptr')
      ..name = 'nullptr'
      ..lambda = true
      ..returns = createType('Pointer', dartffi, [createType('Never')])
      ..type = cb.MethodType.getter
      ..body = cb.refer('nullptr', dartffi).code),
  ]);
  // and destructor code
  builder.body.addAll([
    cb.Code(
        '\n\n// a common function which use to free native resource when it\'s no longer use.\n'),
    cb.Method((b) => b
      ..returns = dartVoid
      ..name = '_sqliteDestructor'
      ..requiredParameters.add(cb.Parameter((pb) => pb
        ..name = 'ptr'
        ..type = cPtrVoid))
      ..body = mallocFree.call([cb.refer('ptr')]).code
      ..lambda = true),
    nativeFuncFrom
        .call([
          cb.refer('_sqliteDestructor')
        ], {}, [
          cb.FunctionType((fb) => fb
            ..returnType = Affinity.any.cType()
            ..requiredParameters.add(cPtrVoid))
        ])
        .assignFinal('_ptrDestructor')
        .statement,
    cb.Code('\n\n'),
  ]);
  // add type for lib version api.
  final sqliteCFree = cb.refer('_DefSqliteFree');
  final sqliteDFree = cb.refer('_DefSqliteFreeDart');
  builder.body.addAll([
    cb.Code('// typedef to help dynamic library lookup api for current versioning of the sqlite\n'),
    cb.FunctionType((b) => b..returnType = cPtrString).toTypeDef(voidString.symbol!),
    cb.FunctionType((b) => b..returnType = Affinity.int.cType()).toTypeDef(versionCDef.symbol!),
    cb.FunctionType((b) => b..returnType = dartInt).toTypeDef(versionDartDef.symbol!),
    cb.FunctionType((b) => b
      ..returnType = cVoid
      ..requiredParameters.add(cPtrVoid)).toTypeDef(sqliteCFree.symbol!),
    cb.FunctionType((b) => b
      ..returnType = dartVoid
      ..requiredParameters.add(cPtrVoid)).toTypeDef(sqliteDFree.symbol!),
  ]);
  // add abstract basic class
  builder.body.add(cb.Class((b) {
    b.docs.add('\n\n// basic class that hold property need to perform interaction with SQLite');
    b.name = '_$apiClassName';
    b.abstract = true;
    b.fields.addAll([
      cb.Field((fb) => fb
        ..docs.addAll([
          '// cannot use reference method to lookup native function.',
          '// Must call library.lookupFunction directly.'
        ])
        ..name = library.symbol
        ..modifier = cb.FieldModifier.final$
        ..type = dynamicLibrary),
      lateFinalField(libVersion.symbol!, funcLookup.find('sqlite3_libversion', voidString).code),
      lateFinalField(srcId.symbol!, funcLookup.find('sqlite3_sourceid', voidString).code),
      lateFinalField(
        libNumber.symbol!,
        funcLookup.find('sqlite3_libversion_number', versionCDef, versionDartDef).code,
      ),
      lateFinalField(
        '_h_sqlite3_free',
        funcLookup.find('sqlite3_free', sqliteCFree, sqliteDFree).code,
      )
    ]);
    b.constructors.add(cb.Constructor((b) => b
      ..requiredParameters.add(cb.Parameter((pb) => pb
        ..name = library.symbol!
        ..toThis = true))));
    b.methods.addAll([
      cb.Method((mb) => mb
        ..docs.add('/// return dynamic library version')
        ..name = libVersion.symbol!.substring(1)
        ..lambda = true
        ..type = cb.MethodType.getter
        ..body = libVersion.call([]).property('toDartString').call([]).code
        ..returns = dartString),
      cb.Method((mb) => mb
        ..docs.add('/// return dynamic library source id')
        ..name = srcId.symbol!.substring(1)
        ..lambda = true
        ..type = cb.MethodType.getter
        ..body = srcId.call([]).property('toDartString').call([]).code
        ..returns = dartString),
      cb.Method((mb) => mb
        ..docs.add('/// return SQLite dynamic library version as number')
        ..name = libNumber.symbol!.substring(1)
        ..returns = dartInt
        ..lambda = true
        ..type = cb.MethodType.getter
        ..body = libNumber.call([]).code),
      cb.Method((mb) => mb
        ..docs.add('/// free resource allocated by SQLite malloc.')
        ..name = 'free'
        ..returns = dartVoid
        ..requiredParameters.add(cb.Parameter((pb) => pb
          ..name = 'arg'
          ..type = cPtrVoid))
        ..lambda = true
        ..body = cb.refer('_h_sqlite3_free').call([cb.refer('arg')]).code),
    ]);
  }));
  // add implemented class
  final apiConstructor = cb.refer(apiClassName).property('_');
  builder.body.add(cb.Class((b) => b
    ..docs.add('/// Native binder provide a compatible method to access SQLite C APIs.')
    ..name = apiClassName
    ..extend = baseClass
    ..mixins.addAll([...mixins, cb.Reference('_MixinExtra')])
    ..methods.addAll([
      cb.Method((b) => b
        ..static = true
        ..name = 'instance'
        ..modifier = cb.MethodModifier.async
        ..returns = createType('Future', dartasync, [createType(apiClassName)])
        ..optionalParameters.add(cb.Parameter((pb) => pb
          ..name = 'path'
          ..type = createNullableType('String')))
        ..body = If(
          cb.refer('Platform', 'dart:io').property('isIOS'),
          Return(apiConstructor.call([dynamicLibrary.property('process').call([])])),
        )
            .elseif(
              cb.refer('path').notEqualTo(cb.literalNull),
              Return(apiConstructor.call([
                dynamicLibrary.property('open').call([cb.refer('path')])
              ])),
            )
            .else$(
              Throw(cb.refer('Exception').call([
                cb.literalString(
                    'Platform other than iOS required explicit path to create dynamic library.')
              ])),
            )),
    ])
    ..constructors.addAll([
      cb.Constructor((b) => b
        ..name = '_'
        ..requiredParameters.add(cb.Parameter((pb) => pb
          ..name = library.symbol!
          ..type = dynamicLibrary))
        ..initializers.add(superRef.call([cb.refer('library')]).code)),
    ])));
  // nullable method when look for api that depend on built
  builder.body.add(cb.Method((mb) => mb
    ..docs.addAll([
      '// helper to initialize property to null if any error occurred while executing function f',
      '// this use for the case when lookup for a C api that might be not available as the library',
      '// itself may built without support such as APIs.'
    ])
    ..name = '_nullable'
    ..returns = cb.TypeReference((b) => (b..isNullable = true).symbol = 'F')
    ..types.add(cb.refer('F'))
    ..requiredParameters.add(cb.Parameter((b) => b
      ..name = 'f'
      ..type = cb.FunctionType((fb) => fb.returnType = cb.refer('F'))))
    ..body = Try(Return(cb.refer('f').call([]))).catch$((e, s) => Return(cb.literalNull))));
  return builder;
}

cb.LibraryBuilder _extensionNativeHelper() {
  final result = cb.LibraryBuilder();
  // '/// Converts this C binary blob to a Dart [Uint8List].',
  // '/// Copy byte array from C memory to Dart Uint8List until zero-terminated if lenght is not provided.',
  // '/// If length is provided, zero-termination is ignored and the result can contain NUL characters.',
  final length = cb.refer('length');
  result.body.addAll([
    cb.Extension((b) {
      b.docs.add('/// Extension method for converting a [Uint8List] to a `Pointer<Void>`.');
      b.name = 'BinaryBlobPointer';
      b.on = dartUint8List;
      b.methods.addAll([
        cb.Method((mb) => mb
          ..docs.addAll([
            '/// Creates a byte array from this Uint8List.',
            '///',
            '/// If [zeroTerminate] is true then the method will return a C pointer to a byte array that include single NUL at the end.',
          ])
          ..returns = cPtrVoid
          ..name = 'toNative'
          ..optionalParameters.addAll([
            cb.Parameter((pb) => pb
              ..name = 'allocator'
              ..named = true
              ..defaultTo = cb.refer('malloc', pkgffi).code
              ..type = createType('Allocator', dartffi)),
            cb.Parameter((pb) => pb
              ..name = 'zeroTerminate'
              ..named = true
              ..defaultTo = cb.literalFalse.code
              ..type = dartBool),
          ])
          ..lambda = true
          ..body = cb
              .refer('_toNative')
              .call([cb.literalFalse, cb.refer('allocator'), cb.refer('zeroTerminate')]).code),
        cb.Method((mb) => mb
          ..docs.add('// Use internally.')
          ..returns = createType('_PtrMeta', null, [cVoid])
          ..name = '_metaNativeUint8'
          ..optionalParameters.add(
            cb.Parameter((pb) => pb
              ..name = 'allocator'
              ..named = true
              ..defaultTo = cb.refer('malloc', pkgffi).code
              ..type = createType('Allocator', dartffi)),
          )
          ..lambda = true
          ..body = cb
              .refer('_toNative')
              .call([cb.literalTrue, cb.refer('allocator'), cb.literalTrue]).code),
        cb.Method((mb) {
          mb.docs.add('// convert dart Uint8List to c pointer Uint8 internally.');
          mb.returns = createType('T');
          mb.name = '_toNative';
          mb.types.add(mb.returns!);
          final terminator = cb.refer('zeroTerminate');
          mb.requiredParameters.addAll([
            cb.Parameter((pb) => pb
              ..name = 'meta'
              ..type = dartBool),
            cb.Parameter((pb) => pb
              ..name = 'allocator'
              ..defaultTo = cb.refer('malloc', pkgffi).code
              ..type = createType('Allocator', dartffi)),
            cb.Parameter((pb) => pb
              ..name = terminator.symbol!
              ..defaultTo = cb.literalFalse.code
              ..type = dartBool),
          ]);
          final size = cb.refer('size');
          final alloc = cb.refer('allocator');
          final result = cb.refer('result');
          final native = cb.refer('native');
          final ptr = result.property('cast').call([], {}, [cVoid]);
          mb.body = <cb.Code>[
            terminator
                .conditional(length.operatorAdd(cb.literalNum(1)), length)
                .assignFinal(size.symbol!)
                .statement,
            alloc.call([size], {}, [Affinity.uint8.cType()!]).assignFinal(result.symbol!).statement,
            result.property('asTypedList').call([size]).assignFinal(native.symbol!, b.on).statement,
            native.property('setAll').call([cb.literalNum(0), cb.refer('this')]).statement,
            If(terminator, native.index(length).assign(cb.literalNum(0)).statement),
            Return(cb.refer('meta').conditional(
                  cb.refer('_PtrMeta').call([length, ptr]).asA(mb.returns!),
                  ptr.asA(mb.returns!),
                )),
          ].toBlock();
        })
      ]);
    }),
    cb.Extension((b) {
      b.docs.add('/// Extension method for converting a`Pointer<Void>` to a [Uint8List].');
      b.name = 'BlobPointer';
      b.on = createTypePointer([Affinity.uint8.cType()!]);
      final nullCheck = cb.refer('_ensureNotNullptr');
      final pLength = cb.refer('_length');
      b.methods.addAll([
        cb.Method((mb) {
          mb.docs.add('/// The number of byte that is zero-terminated.');
          mb.name = 'length';
          mb.type = cb.MethodType.getter;
          mb.returns = dartInt;
          mb.body = <cb.Code>[
            nullCheck.call([cb.literalString('length')]).statement,
            Return(pLength.call([cb.refer('this')])),
          ].toBlock();
        }),
        cb.Method((mb) {
          mb.docs.addAll([]);
          mb.name = 'toUint8List';
          mb.returns = dartUint8List;
          mb.optionalParameters.add(cb.Parameter((pb) => pb
            ..name = 'length'
            ..named = true
            ..type = dartInt.nullable()));
          mb.body = <cb.Code>[
            nullCheck.call([cb.literalString('toUint8List')]).statement,
            If(
              length.notEqualTo(cb.literalNull),
              cb.refer('RangeError').property('checkNotNegative').call([
                length,
                cb.literalString(length.symbol!),
              ]).statement,
            ).else$(length.assign(pLength.call([cb.refer('this')])).statement),
            Return(cb.refer('asTypedList').call([length])),
          ].toBlock();
        }),
        cb.Method((mb) {
          mb.name = pLength.symbol;
          mb.returns = dartInt;
          mb.static = true;
          mb.requiredParameters.add(cb.Parameter((pb) => pb
            ..name = 'units'
            ..type = b.on));
          mb.body = <cb.Code>[
            cb.literalNum(0).assignVar(length.symbol!).statement,
            While(
              cb.refer('units').index(length).notEqualTo(cb.literalNum(0)),
              length.increment.statement,
            ),
            Return(length),
          ].toBlock();
        }),
        cb.Method.returnsVoid((mb) {
          mb.name = nullCheck.symbol;
          mb.requiredParameters.add(cb.Parameter((pb) => pb
            ..name = 'operation'
            ..type = dartString));
          mb.body = If(
            cb.refer('this').equalTo(cNullPtr),
            Throw(cb.refer('UnsupportedError').call([
              cb.literalString("Operation \$operation not allowed on a 'nullptr'."),
            ])),
          );
        }),
      ]);
    }),
    cb.Extension((b) => b
      ..name = '_StringMetaUtf8Pointer'
      ..on = dartString
      ..methods.add(cb.Method((mb) {
        final units = cb.refer('units');
        final size = units.property('length').operatorAdd(cb.literalNum(1));
        final result = cb.refer('result');
        final nativeString = cb.refer('nativeString');
        mb.name = '_metaNativeUtf8';
        mb.returns = createType('_PtrMeta', null, [cString]);
        mb.body = <cb.Code>[
          cb
              .refer('utf8', dartconv)
              .property('encode')
              .call([cb.refer('this')])
              .assignFinal(units.symbol!)
              .statement,
          malloc.call([size], {}, [cUint8]).assignFinal(result.symbol!).statement,
          result.property('asTypedList').call([size]).assignFinal(nativeString.symbol!).statement,
          nativeString.property('setAll').call([cb.literalNum(0), units]).statement,
          nativeString.index(units.property('length')).assign(cb.literalNum(0)).statement,
          Return(cb.refer('_PtrMeta').call([length, result.property('cast').call([])]))
        ].toBlock();
      }))),
    cb.Extension((b) => b
      ..name = '_StringMetaUtf16Pointer'
      ..on = dartString
      ..methods.add(cb.Method((mb) {
        final units = cb.refer('units');
        final length = units.property('length');
        final size = length.operatorAdd(cb.literalNum(1));
        final result = cb.refer('result');
        final nativeString = cb.refer('nativeString');
        mb.name = '_metaNativeUtf16';
        mb.returns = createType('_PtrMeta', null, [cString16]);
        mb.body = <cb.Code>[
          cb.refer('codeUnits').assignFinal(units.symbol!).statement,
          malloc.call([size], {}, [cUint16]).assignFinal(result.symbol!).statement,
          result.property('asTypedList').call([size]).assignFinal(nativeString.symbol!).statement,
          nativeString.property('setRange').call([cb.literalNum(0), length, units]).statement,
          nativeString.index(length).assign(cb.literalNum(0)).statement,
          Return(cb
              .refer('_PtrMeta')
              .call([length.operatorMultiply(cb.literalNum(2)), result.property('cast').call([])]))
        ].toBlock();
      }))),
  ]);
  return result;
}

// TODO: add:
// - sqlite3_vtab_config
// - sqlite3_config
// - sqlite3_db_config
// - sqlite3_data_directory
// - sqlite3_temp_directory
//
// Correct sqlite3_auto_extension typedef where entry point is different from what is invoke
// See https://www.sqlite.org/capi3ref.html#sqlite3_auto_extension
//
// TODO: careful of using xDestroy in binding api, the length of binary or text must provided
// in order to make SQLite invoke xDestroy when it no longer use.
// https://www.sqlite.org/capi3ref.html#sqlite3_bind_blob
//
// TODO: check all return pointer api. For potential null pointer (address == 0)
