part of 'class_generator.dart';

code.Constructor constructorFromDatabase(
  String clazzName,
  List<ColumnAnnotationPresentation> fields,
) {
  return code.Constructor((b) {
    b.docs.add('/// A constructor use to create from row result set from SELECT query.');
    b.name = 'db';
    b.requiredParameters.add(rowReaderParam);
    b.body = code.Block((b) {
      b.statements.addAll([
        for (var field in fields)
          field.dartName
              .assign(applyReaderConversion(
                  field,
                  rowReaderParam
                      .property(propertyByField(field))
                      .call([code.literalString(field.name)]).withNullCheck(field.notNull)))
              .statement
      ]);
    });
  });
}

code.Constructor constructorNewObject(
  String clazzName,
  List<ColumnAnnotationPresentation> fields,
) {
  var state = 0;
  final optionalParam = <code.Parameter>[];
  final statements = <code.Code>[];
  for (var field in fields) {
    final dfv = field.defaultValue;
    // TODO: check with database engine
    // ignore column or field that required set by database for example CURRENT_TIMESTAMP.
    // if (dfv != null && field.dartType ! ) continue;

    // calculate bit state change for each field, readonly field is ignored and primary key field
    // required runtime calculation.
    if (!field.primaryKey) {
      if (field.notNull) {
        state = state | field.stateField;
      } else {
        statements.add(code.Code(
            'if (${field.dartName.symbol} != null) ${fieldState.symbol} = ${fieldState.symbol} | ${field.stateField};'));
      }
    }
    // body statement
    if (dfv == null ||
        (field.dartType.compatible(dfv.dartType?.symbol) &&
            dfv.dartType?.url == field.dartType.url)) {
      // default value is compatible with dart field type thus assign value in constructor parameter
      if (!field.readonly) {
        final argName = field.dartName.publicName;
        final varName = field.dartName.symbol;
        if (field.primaryKey) {
          if (field.idGenerator != null) {
            state = state | field.stateField;
            final ifMethod = field.idGenerator!.isFunc ? '' : '.generate';
            final refer = field.idGenerator!.instantiatedObject
                ? staticGenId.symbol
                : field.idGenerator!.source;
            statements.add(code.Code('$varName = $refer$ifMethod();'));
            continue;
          } else {
            statements.addAll([
              code.Code('if ($argName != null) { $varName = $argName;'),
              code.Code('${fieldState.symbol} = ${fieldState.symbol} | ${field.stateField};'),
              code.Code('}')
            ]);
          }
        } else {
          statements.add(code.Code('$varName = $argName;'));
        }
      } else {
        statements.add(field.dartName.assign(field.dartName).statement);
      }
    } else {
      // default function assign should skip parameter
      final val = code.refer(dfv.source, dfv.dartType?.url);
      statements.add(field.dartName.assign(dfv.isFunc ? val.call([]) : val).statement);
      continue;
    }
    optionalParam.add(code.Parameter((p) {
      p.name = field.dartName.publicName;
      p.required = field.notNull && dfv == null && !field.primaryKey;
      p.named = true;
      if (field.readonly) {
        // if read one then field will be a final publicly accessible
        p.toThis = true;
      } else {
        // non-readonly field will be define with late thus no this reference
        p.type = field.primaryKey
            ? field.dartType.nullable(false)
            : field.dartType.nullable(field.notNull);
      } // if default is a function then assign at value in body instead
      if (dfv != null) {
        p.defaultTo = code.refer(dfv.source, dfv.dartType?.url).code;
      }
    }));
  }
  if (state > 0) statements.insert(0, fieldState.assign(code.literalNum(state)).statement);
  return code.Constructor((b) {
    b.docs.add('/// A constructor to create a new object of [$clazzName], '
        'no data existed in database yet until save is call.');
    b.optionalParameters.addAll(optionalParam);
    b.body = code.Block((b) => b.statements.addAll(statements));
  });
}
