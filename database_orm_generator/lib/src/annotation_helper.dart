part of 'class_generator.dart';

DartEval? _eval;

DartEval get eval => _eval ??= DartEval();

/// Dart representation object where will produce code differently depend on kind of the given object.
///
/// **Important** We need this class as helper on top of source_gen and analyzer as both could not
/// provide advance or complex annotation definition.
class DartRepresentation {
  DartRepresentation(
    this.source, {
    this.isFunc = false,
    this.isClass = false,
    this.dartType,
    this.instantiatedObject = false,
    this.method,
  });

  /// if true the source is the code expression present object creation via constructor
  final bool isClass;

  /// if true the source is the name of a function
  final bool isFunc;

  /// either name of function or expression of a new object via constructor
  final String source;

  /// method name
  final String? method;

  /// True if the value provide to annotation is object instantiate from a constructor
  /// and not a function or constant value.
  final bool instantiatedObject;

  /// true if this constant value either scalar or object has the same type as dart field
  ///
  /// If the default is not scalar or a function then it must be an object thus it this field
  /// represent it type. If the default value is a function this type is null.
  final code.Reference? dartType;

  /// return a source as string which represent a scalar type value if it was a scalar type value
  /// otherwise null.
  String? get scalarText => !isClass && !isFunc ? source : null;
}

/// Table annotation class helper.
///
/// **Important** We need this class as helper on top of source_gen and analyzer as both could not
/// provide advance or complex annotation definition.
class TableAnnotationPresentation {
  // remove mixin word from table name
  static String omitMixin(String name) {
    if (name.startsWith('mixin_')) name = name.substring(6);
    if (name.endsWith('_mixin')) name = name.substring(0, name.length - 6);
    return name;
  }

  static TypeChecker get columnChecker => TypeChecker.fromRuntime(Column);

  static TypeChecker get tableChecker => TypeChecker.fromRuntime(Table);

  static Future<TableAnnotationPresentation?> parseTableAnnotation(
    ClassElement element,
    Iterable<String> importCodes,
  ) async {
    ElementAnnotation? tbAnnotation;
    late ConstantReader annotation;
    for (var meta in element.metadata) {
      final dto = meta.computeConstantValue();
      if (dto != null && !dto.isNull) {
        if (tableChecker.isAssignableFromType(dto.type!)) {
          if (!element.isMixin) {
            throw Exception('Annotation can only be use with a mixin.');
          }
          tbAnnotation = meta;
          annotation = ConstantReader(dto);
          break;
        }
      }
    }
    // no annotation found return null
    if (tbAnnotation == null) return null;

    // runtime result required.
    final src = tbAnnotation.toSource().substring(1);
    final buffer = StringBuffer();
    buffer.writeln('final a = $src;');
    buffer.writeln('print(a.nameConversion(\'${element.name}\'));');
    final result = await eval._exec(buffer.toString(), importCodes);

    final name = annotation.peek('name')?.stringValue ?? omitMixin(result);
    final constantClass = annotation.read('constantClass').boolValue;

    var index = 0;
    final uniques = <String, List<ColumnAnnotationPresentation>>{};
    final primariesKey = <ColumnAnnotationPresentation>[];
    ElementAnnotation? columnAnnotation;
    late ConstantReader columnReader;
    DartObject? columnDto;
    List<ColumnAnnotationPresentation> columns = [];
    for (var cEle in element.fields) {
      for (var meta in cEle.metadata) {
        columnDto = meta.computeConstantValue();
        if (columnDto != null && !columnDto.isNull) {
          if (columnChecker.isAssignableFromType(columnDto.type!)) {
            if (cEle.type.nullabilitySuffix != NullabilitySuffix.question) {
              throw Exception('Each field in mixin must declare with nullable type. It required '
                  'when querying data from database with incomplete column selection.');
            }
            columnAnnotation = meta;
            columnReader = ConstantReader(columnDto);
          }
        }
      }
      if (columnAnnotation == null) continue;

      columns.add(await ColumnAnnotationPresentation.parseColumnAnnotation(
        cEle,
        columnAnnotation,
        columnReader,
        columnDto!,
        importCodes,
        index,
        constantClass,
      ));
      index++;
      // add unique column into group
      if (columns.last.uniqueGroup != null) {
        uniques[columns.last.uniqueGroup!] ??= [];
        uniques[columns.last.uniqueGroup]!.add(columns.last);
      }
      if (columns.last.primaryKey) primariesKey.add(columns.last);
    }

    final source = tbAnnotation.toSource().substring(1);
    final stmt = parseString(content: 'var a = $source;')
        .unit
        .declarations
        .first
        .childEntities
        .first as VariableDeclarationList;
    final mi = stmt.variables.first.initializer as MethodInvocation;

    String? additional;
    List<code.Code>? clazzAnnotation;
    for (var expr in mi.argumentList.arguments) {
      if (expr is NamedExpression) {
        final vNamed = expr.name.label.toSource();
        if (vNamed == 'additional') {
          final code = 'print(${expr.expression.toSource()}.definition());';
          additional = await eval._exec(code, importCodes);
        } else if (vNamed == 'annotations') {
          for (var cexpr in (expr.expression as ListLiteral).elements) {
            clazzAnnotation ??= [];
            clazzAnnotation.add(code.Code(cexpr.toSource()));
          }
        }
      }
    }
    eval.finalize();
    return TableAnnotationPresentation(
      name,
      columns,
      uniques: uniques,
      primariesKey: primariesKey,
      additional: additional,
      annotations: clazzAnnotation,
      constantClass: constantClass,
    );
  }

  TableAnnotationPresentation(
    this.name,
    this.columns, {
    this.uniques = const {},
    this.primariesKey = const [],
    this.additional,
    this.annotations,
    this.constantClass = false,
  }) : hasExtraDef = primariesKey.length > 1 || uniques.values.any((e) => e.length > 1);

  /// name of the table.
  final String name;

  /// an sql definition that append to the tail of create table query.
  final String? additional;

  /// list of column defined in the mixin
  final List<ColumnAnnotationPresentation> columns;

  /// list of primary key column
  final List<ColumnAnnotationPresentation> primariesKey;

  /// list of unique column
  final Map<String, List<ColumnAnnotationPresentation>> uniques;

  /// indicate that after column definition there is other definition such as primary, unique
  final bool hasExtraDef;

  /// annotation that need to place above generated class.
  final List<code.Code>? annotations;

  /// See [Table.constantClass] for detail.
  final bool constantClass;
}

/// Column annotation class helper
///
/// **Important** We need this class as helper on top of source_gen and analyzer as both could not
/// provide advance or complex annotation definition.
class ColumnAnnotationPresentation {
  // default method check for constant reader/writer class
  static const readerMethod = ['decode', 'marshal'];
  static const writerMethod = ['encode', 'unmarshal'];

  static Iterable<FuncCheck> funcCheck(String returnType, List<String> paramTypes) => [
        FuncCheck(
            '',
            (type) =>
                type.isDynamic ||
                type.isDartCoreObject ||
                type.getDisplayString(withNullability: false) == returnType,
            paramTypes
                .map((e) => (type) =>
                    type.isDynamic ||
                    type.isDartCoreObject ||
                    type.getDisplayString(withNullability: false) == e)
                .toList(growable: false))
      ];

  static Iterable<FuncCheck> rwCheck(
          Iterable<String> methods, String returnType, List<String> paramTypes) =>
      methods.map((e) => FuncCheck(
          e,
          (type) =>
              type.isDynamic ||
              type.isDartCoreObject ||
              type.getDisplayString(withNullability: false) == returnType,
          paramTypes
              .map((e) => (type) =>
                  type.isDynamic ||
                  type.isDartCoreObject ||
                  type.getDisplayString(withNullability: false) == e)
              .toList(growable: false)));

  static DartRepresentation? readDartRepresentationValue(
      DartObject dto, Expression expr, bool needMethod,
      [String? Function(ExecutableElement? func, ClassElement?, String type)? throwingTest]) {
    final func = dto.toFunctionValue();
    // check if it was eligible
    String? methodName;
    if (throwingTest != null) {
      methodName = throwingTest(func, dto.type!.element as ClassElement?, dto.type!.toString());
    }

    var source = expr.toSource();
    late final String dtName;
    late final String? pkg;
    if (dto.type?.element != null) {
      dtName = dto.type!.element!.name!;
      pkg = dto.type!.element?.library?.identifier;
    } else {
      pkg = null;
      dtName = 'Function';
    }

    return DartRepresentation(
      source,
      isFunc: func != null,
      isClass: dto.type?.element is ClassElement,
      dartType: code.refer(dtName, pkg),
      // only function, value and class constructor call is allow for constant field.
      instantiatedObject: expr is MethodInvocation,
      method: methodName,
    );
  }

  static Future<ColumnAnnotationPresentation> parseColumnAnnotation(
    FieldElement field,
    ElementAnnotation elementAnnotation,
    ConstantReader constantReader,
    DartObject dto,
    Iterable<String> imports,
    int index,
    bool forceReadOnly,
  ) async {
    // runtime result required.
    final src = elementAnnotation.toSource().substring(1);
    final buffer = StringBuffer();
    buffer.writeln('final a = $src;');
    buffer.writeln('print(a.nameConversion(\'${field.name}\'));');
    buffer.writeln('print(a.type.dartTypeAffinity.toString());');
    buffer.writeln('print(a.type.dartType?.toString());');
    buffer.writeln('print(a.type.sqlDataType());');
    final result = (await eval._exec(buffer.toString(), imports))
        .split('\n')
        .map((e) => e == 'null' ? null : e)
        .toList();

    final name = constantReader.peek('name')?.stringValue ?? result[0]!;
    final dartName = field.isPrivate ? field.name.substring(1) : field.name;
    final readonly = constantReader.read('readonly').boolValue || field.isFinal || forceReadOnly;
    final primaryKey = constantReader.read('primaryKey').boolValue;
    final autoIncrement = constantReader.read('autoIncrement').boolValue;
    final notNull = constantReader.read('notNull').boolValue;
    final type = result[3]!;
    final dtVal = dto.getField('dartType')?.toTypeValue();
    String? dartTypePkg;
    late String dartType;
    if (dtVal != null) {
      dartType = dtVal.getDisplayString(withNullability: false);
      dartTypePkg = dtVal.element?.library?.identifier;
    } else {
      dartType = result[2] ?? result[1]!;
    }

    final source = elementAnnotation.toSource().substring(1);
    final stmt = parseString(content: 'var a = $source;')
        .unit
        .declarations
        .first
        .childEntities
        .first as VariableDeclarationList;
    final mi = stmt.variables.first.initializer as MethodInvocation;

    DartRepresentation? defaultValue;
    DartRepresentation? idGenerator;
    DartRepresentation? reader;
    DartRepresentation? writer;
    for (var expr in mi.argumentList.arguments) {
      if (expr is NamedExpression) {
        final vNamed = expr.name.label.toSource();
        switch (vNamed) {
          case 'idGenerator':
            if (!primaryKey) throw Exception('idGenerator must be a primary key in $src.');
            if (autoIncrement) {
              throw Exception('You can only use either idGenerator or autoIncrement, both of them'
                  ' cannot given at the same time.');
            }
            idGenerator = readDartRepresentationValue(
              dto.getField(vNamed)!,
              expr.expression,
              false,
              (ExecutableElement? func, ClassElement? e, String _) {
                if (func != null && func.matchOf(funcCheck(dartType, []))) return null;
                if (e != null &&
                    (e.extendsOf('IdGenerator', [dartType]) ||
                        e.implementOf('IdGenerator', [dartType]))) {
                  return 'generate';
                }
                throw Exception('Invalid IdGenerator value define in @$src.');
              },
            );
            break;
          case 'defaultValue':
            if (primaryKey) throw Exception('Primary key cannot have default value.');
            defaultValue = readDartRepresentationValue(
              dto.getField(vNamed)!,
              expr.expression,
              false,
              (ExecutableElement? func, ClassElement? e, String type) {
                if ((func == null || !func.matchOf(funcCheck(dartType, []))) &&
                    (e == null ||
                        (!e.extendsOf('SQLDefaultValueValue') &&
                            !e.implementOf('SQLDefaultValueValue') &&
                            type != dartType))) {
                  throw Exception('Default value define in @$src, is not a valid default value.');
                }
              },
            );
            break;
          case 'reader':
            reader = readDartRepresentationValue(dto.getField(vNamed)!, expr.expression, true,
                (ExecutableElement? func, ClassElement? e, String _) {
              if (func != null && func.matchOf(funcCheck(dartType, [result[1]!]))) return null;
              if (e != null) {
                final name = e.hasAnyMethodOf(rwCheck(readerMethod, dartType, [result[1]!]));
                if (name != null) return name;
              }
              throw Exception('Invalid reader value define in @$src.');
            });
            break;
          case 'writer':
            writer = readDartRepresentationValue(dto.getField(vNamed)!, expr.expression, true,
                (ExecutableElement? func, ClassElement? e, String _) {
              if (func != null && func.matchOf(funcCheck(result[1]!, [dartType]))) return null;
              if (e != null) {
                final name = e.hasAnyMethodOf(rwCheck(writerMethod, result[1]!, [dartType]));
                if (name != null) return name;
              }
              throw Exception('Invalid writer value define in @$src.');
            });
            break;
        }
      }
    }

    return ColumnAnnotationPresentation(
      name: name,
      stateField: math.pow(2, index) as int,
      dartName: ExtReference(dartName, '_$dartName'),
      columnConstValue: 'column${dartName[0].toUpperCase()}${dartName.substring(1)}',
      primaryKey: primaryKey,
      autoIncrement: autoIncrement,
      notNull: notNull,
      unique: constantReader.peek('unique')?.boolValue ?? false,
      uniqueGroup: constantReader.peek('uniqueGroup')?.stringValue,
      readonly: readonly,
      dartType: code.refer(dartType, dartTypePkg),
      type: type,
      dartTypeAffinity: result[1]!,
      defaultValue: defaultValue,
      idGenerator: idGenerator,
      reader: reader,
      writer: writer,
    );
  }

  ColumnAnnotationPresentation({
    required this.name,
    required this.dartName,
    required this.dartType,
    required this.dartTypeAffinity,
    required this.type,
    required this.stateField,
    required this.columnConstValue,
    this.primaryKey = false,
    this.autoIncrement = false,
    this.unique = false,
    this.uniqueGroup,
    this.notNull = true,
    this.idGenerator,
    this.defaultValue,
    this.readonly = false,
    this.reader,
    this.writer,
  });

  /// a number use to identified change of a field
  final int stateField;

  /// name of column in database table
  final String name;

  /// type of column in database table
  final String type;

  /// name of dart variable that represent this column
  final ExtReference dartName;

  /// a static dart field name that store table column name
  final String columnConstValue;

  /// dart type represent the variable
  final code.Reference dartType;

  /// to determine what method use to read data from sql reset set
  final String dartTypeAffinity;

  /// indicate whether this column represent primary key
  final bool primaryKey;

  /// indicate whether this column should be auto incremented
  final bool autoIncrement;

  /// indicate whether this column should be unique in the table
  final bool unique;

  /// indicate whether this column should be unique a long side other column in the table
  final String? uniqueGroup;

  /// indicate that the column should not null
  final bool notNull;

  /// indicate that the value of current column should be read only
  final bool readonly;

  /// The code that allow generate a unique id if the auto generated id is not supported by SQL engine.
  ///
  /// For example if we attempt to define a string as an id then generator is better suit for provide
  /// such as custom value for the id when a new object is created from the constructor.
  /// 1. If id generator is a function then the id will be initialize in constructor body with the value
  ///    return from the generator function.
  /// 2. If id generator is an object then it must implement a method name `generate` with empty argument
  ///    and return appropriate value that match the id type.
  /// 3. If any option above is not match then generator will throw exception.
  final DartRepresentation? idGenerator;

  /// default value for column and field
  ///
  /// If reader is available, the value will be given reader before assigned to the column field.
  /// otherwise the generator will attempt the below step:
  /// 1. if default value is object and match dart type then the value will be use to initial dart
  ///    field in the constructor and field will be include in constructor method.
  /// 2. if default value is a function, generator will exclude field from constructor parameter
  ///    and it value will be initial in constructor body instead.
  /// 3. if default value is a pre-define sql literal value such as CURRENT_TIMESTAMP, CURRENT_DATE
  ///    or CURRENT_TIME, then generator will look for database engine registration for a helper
  ///    function that can generate the value for the dart field.
  /// 4. Generator will attempt to use the default value as the value of the field if they both has
  ///    the same type or compatible type such as type alias.
  /// 5. if any option above is not available the generator will throw exception instead.
  final DartRepresentation? defaultValue;

  /// a function that use to convert sql data table into dart object.
  ///
  /// By default, Generate will look for
  /// 1. [reader] if available generator will use reader to convert sql value to dart value.
  /// 2. Compatible dart type such as [DateTime], [bool], [Uri] include enum is handle automatically.
  /// 3. If Dart Type is a class then generator is attempted to use method fromSQLValue if available.
  /// 4. generator will throw an exception as last option and generation will failed.
  final DartRepresentation? reader;

  /// a function that use to convert dart object into sql engine data type before saving it to database.
  ///
  /// By default, Generate will look for
  /// 1. [write] if available generator will use write to convert dart value into sql data type.
  /// 2. Compatible dart type such as [DateTime], [bool], [Uri] include enum is handle automatically.
  /// 3. If Dart Type is a class then generator is attempted to use method toSQLValue if available.
  /// 4. generator will throw an exception as last option and generation will failed.
  final DartRepresentation? writer;
}

typedef DartTypeCheck = bool Function(DartType);

/// store data to verify existing of a method or function check
class FuncCheck {
  FuncCheck(this.name, this.returnTypeCheck, [this.paramTypes = const []]);

  /// name of method
  final String name;

  /// List of parameter type required. Empty mean no parameter needed
  List<DartTypeCheck> paramTypes;

  /// The return type required
  DartTypeCheck returnTypeCheck;
}

//
extension _ExecutableElementUtil on ExecutableElement {
  bool matchOf(Iterable<FuncCheck> requirement, [bool checkName = false]) {
    for (var fc in requirement) {
      if ((!checkName || fc.name == name) && fc.returnTypeCheck(returnType)) {
        var i = 0;
        for (; i < fc.paramTypes.length; i++) {
          if (!fc.paramTypes[i](parameters[i].type)) {
            return false;
          }
        }
        if (i < parameters.length) {
          for (; i < parameters.length; i++) {
            if (!parameters[i].isOptional) {
              return false;
            }
          }
        }
        return true;
      }
    }
    return false;
  }
}

//
extension _ClassElementUtil on ClassElement {
  bool _compareGeneric(List<String> generics, List<DartType>? typeArgs) {
    if (typeArgs?.length != generics.length) return false;
    for (var i = 0; i < generics.length; i++) {
      if (generics[i] != typeArgs![i].element?.name) return false;
    }
    return true;
  }

  bool extendsOf(String name, [List<String>? genericType]) {
    if (supertype?.element.name != name) return false;
    return genericType == null ? true : _compareGeneric(genericType, supertype?.typeArguments);
  }

  bool implementOf(String name, [List<String>? genericType]) {
    for (var it in interfaces) {
      if (it.element.name == name) {
        return genericType == null ? true : _compareGeneric(genericType, it.typeArguments);
      }
    }
    return false;
  }

  String? hasAnyMethodOf(Iterable<FuncCheck> requirement) {
    for (var m in methods) {
      if (m.matchOf(requirement, true)) return m.name;
    }
  }
}

//
class DartEval {
  static final _runtimeEvalExe =
      ['build', 'database_orm_generator', '__dart_eval.dart'].join(Platform.pathSeparator);

  DartEval() {
    execFile = File(_runtimeEvalExe)..createSync(recursive: true);
  }

  late final File execFile;

  void finalize() {
    execFile.deleteSync();
    _eval = null;
  }

  Future<String> _exec(String body, Iterable<String> imports) async {
    final code = '${imports.join('\n')}\nvoid main() { $body }';
    execFile.writeAsString(code);
    var process = await Process.run('dart', ['run', _runtimeEvalExe]);
    var exitCode = process.exitCode;
    final data = process.stdout.toString().trim();
    if (exitCode != 0 || data.isEmpty) {
      finalize();
      throw Exception(process.stderr.toString());
    }
    return data;
  }
}
