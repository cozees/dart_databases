part of 'class_generator.dart';

// field state to track change in value
final fieldState = code.refer('_fieldState');
final fieldStateType = code.refer('int');

final staticGenId = code.refer('_idGenerator');

List<code.Field> generateConstantTableColumn(
  String tbName,
  List<ColumnAnnotationPresentation> fields,
) {
  final codeFields = <code.Field>[
    code.Field((b) => b
      ..docs.add('// state to keep track change of non-readonly field')
      ..name = fieldState.symbol
      ..assignment = code.Code('0')
      ..type = fieldStateType),
    code.Field((b) => b
      ..docs.add('/// Constant value for table name $tbName')
      ..name = 'tableName'
      ..static = true
      ..modifier = code.FieldModifier.constant
      ..assignment = code.literalString(tbName).code),
  ];
  for (var field in fields) {
    codeFields.add(code.Field((b) => b
      ..docs.add('/// Column ${field.name} for table $tbName.')
      ..name = field.columnConstValue
      ..static = true
      ..modifier = code.FieldModifier.constant
      ..assignment = code.literalString('${field.name};').code));
    // create static reference to id generate
    if (field.primaryKey && field.idGenerator != null && field.idGenerator!.instantiatedObject) {
      codeFields.add(code.Field((b) => b
        ..docs.add('// static constant instantiate for id generator')
        ..name = staticGenId.symbol
        ..modifier = code.FieldModifier.constant
        ..assignment = code.Code(field.idGenerator!.source)
        ..static = true));
    }
  }
  return codeFields;
}

List<code.Method> generateGetterTableColumn(List<ColumnAnnotationPresentation> fields) {
  return [
    code.Method((b) => b
      ..docs.add('/// Return true if any field in class has changed otherwise false.')
      ..name = 'hasAnyChange'
      ..returns = code.refer('bool')
      ..type = code.MethodType.getter
      ..lambda = true
      ..body = fieldState.notEqualTo(code.literalNum(0)).code),
    for (var field in fields)
      code.Method((b) => b
        ..docs.addAll([
          '/// Value of column ${field.name}',
          if (field.primaryKey) ...[
            '///',
            '/// Value null mean the object has not been insert into database otherwise non-null is returned.'
          ]
        ])
        ..name = field.dartName.publicName
        ..type = code.MethodType.getter
        ..returns = field.primaryKey
            ? field.dartType.nullable(false)
            : field.dartType.nullable(field.notNull)
        ..lambda = true
        ..body = field.dartName.withNullCheck(field.notNull && !field.primaryKey).code)
  ];
}

List<code.Method> generateSetterTableColumn(List<ColumnAnnotationPresentation> fields) {
  final setArg = code.refer('val');
  return [
    for (var field in fields)
      if (!field.readonly)
        code.Method((b) => b
          ..docs.addAll([
            '/// Set value for column ${field.name}',
            if (field.primaryKey) ...[
              '/// ',
              '/// Note: primary key auto increment type declaration should be nullable as when create',
              '/// a new object, the ID cannot be known before insert into database. Dart compile required',
              '/// setter and getter to have identical declaration thus we throw exception instead when',
              '/// setting primary key value with null.'
            ]
          ])
          ..name = field.dartName.publicName
          ..type = code.MethodType.setter
          ..requiredParameters.add(code.Parameter((pb) => pb
            ..type = field.dartType.nullable(field.notNull && !field.primaryKey)
            ..name = setArg.symbol!))
          ..body = code.Block((bb) => bb.statements.addAll([
                if (field.primaryKey)
                  code.Code(
                      'if (val == null) { throw DatabaseException(\'primary key value cannot be null.\'); }'),
                code.Code('if ('),
                field.dartName.notEqualTo(setArg).code,
                code.Code(') {'),
                fieldState
                    .assign(code.CodeExpression(
                      code.Code('${fieldState.symbol} | ${field.stateField}'),
                    ))
                    .statement,
                field.dartName.assign(setArg).statement,
                code.Code('}'),
              ])))
  ];
}
