part of 'class_generator.dart';

code.Method createTableMethod(
  TableAnnotationPresentation tb,
  List<ColumnAnnotationPresentation> fields,
) {
  final sqlFields = fields.map((e) {
    final buffer = StringBuffer();
    buffer.write('`');
    buffer.write(e.name);
    buffer.write('`');
    buffer.write(' ');
    buffer.write(e.type);
    // add specific column constraint
    final defVal = e.defaultValue?.scalarText;
    if (e.primaryKey && tb.primariesKey.length <= 1) {
      buffer.write(' PRIMARY KEY');
      if (e.autoIncrement) {
        buffer.write(' AUTOINCREMENT');
      }
    } else if (defVal != null) {
      var quote = '';
      if (e.dartTypeAffinity == 'String') quote = '"';
      buffer.write(' DEFAULT $quote$defVal$quote');
    } else {
      if (e.notNull) buffer.write(' NOT NULL');
      if (e.unique) buffer.write(' UNIQUE');
    }
    return buffer.toString();
  });
  final sql = StringBuffer();
  sql.writeln('\'CREATE TABLE IF NOT EXISTS `${tb.name}` (\'');
  sql.writeln('\'${sqlFields.join(',\'\n\'')}${tb.hasExtraDef ? ',' : ''}\'');
  if (tb.primariesKey.length > 1) {
    final comma = tb.uniques.values.any((c) => c.length > 1) ? ',' : '';
    sql.writeln('\'PRIMARY KEY (`${tb.primariesKey.map((e) => e.name).join('`, `')}`)$comma\'');
  }
  if (tb.uniques.isNotEmpty) {
    final ss = <String>[];
    for (var uqs in tb.uniques.values) {
      if (uqs.length > 1) ss.add('UNIQUE (`${uqs.map((e) => e.name).join('`, `')}`)');
    }
    if (ss.isNotEmpty) sql.writeln('\'${ss.join(',\'\n\'')}\'');
  }
  sql.write(tb.additional != null ? '\') ${tb.additional};\'' : '\');\'');
  return code.Method((m) {
    m.docs.add('/// Create table ${tb.name} schema.');
    m.static = true;
    m.name = 'createSQLTable';
    m.modifier = code.MethodModifier.async;
    m.requiredParameters.add(databaseParam);
    m.returns = code.refer('Future<void>', 'dart:async');
    m.body = code.Block((b) {
      b.addExpression(databaseParam.property('exec').call([
        code.CodeExpression(code.Code(sql.toString())),
      ]));
    });
  });
}

code.Method createInsertMethod(TableAnnotationPresentation tb) {
  final cc = 'final sql = \'INSERT INTO `${tb.name}` (\''
      '\'${tb.columns.map((e) => '`${e.name}`').join(',\'\n\'')}\'\n'
      '\') VALUES(${'?'.padRight(tb.columns.length - 1, ',?')})\';';
  final param = tb.columns.map((e) => e.dartName.symbol).join(',');
  return code.Method((mb) => mb
    ..docs.add('/// Insert a row record into table ${tb.name}')
    ..name = 'insert'
    ..returns = futureChange
    ..requiredParameters.add(databaseParam)
    ..body = code.Block(
      (b) => b.statements.addAll([
        code.Code(cc),
        code.Code('return '),
        databaseParam.property('exec').call(
          [code.CodeExpression(code.Code('sql'))],
          {'parameters': code.CodeExpression(code.Code('[$param]'))},
        ).statement,
      ]),
    ));
}

code.Method? createUpdateMethod(TableAnnotationPresentation tb) {
  if (tb.primariesKey.isEmpty && tb.uniques.isEmpty) return null;
  final whereClause = _whereClause(tb);
  final statements = [
    'final params = [];',
    'final fieldSet = [];',
    for (var field in tb.columns)
      'if (${fieldState.symbol} & ${field.stateField} == ${field.stateField}) {'
          'params.add(${field.dartName.symbol});'
          'fieldSet.add(\'`${field.name}`=?\');'
          '}',
    'final sql = \'UPDATE `${tb.name}` SET \${fieldSet.join(\',\')} WHERE ${whereClause[0]}\';',
    'params.addAll(${whereClause[1]});',
  ].map((e) => code.Code(e));
  return code.Method((mb) => mb
    ..docs.add('/// Update any change on into table ${tb.name}')
    ..returns = futureChangeOpt
    ..requiredParameters.add(databaseParam)
    ..name = 'update'
    ..body = code.Block((b) => b.statements.addAll([
          ...statements,
          code.Code('return '),
          databaseParam.property('exec').call(
            [code.CodeExpression(code.Code('sql'))],
            {'parameters': code.CodeExpression(code.Code('params'))},
          ).statement,
        ])));
}

code.Method? createDeleteMethod(
  TableAnnotationPresentation tb,
) {
  if (tb.primariesKey.isEmpty && tb.uniques.isEmpty) return null;
  final whereClause = _whereClause(tb);
  return code.Method((mb) => mb
    ..docs.add('/// Delete a row record from table ${tb.name}')
    ..name = 'delete'
    ..returns = futureChange
    ..requiredParameters.add(databaseParam)
    ..lambda = true
    ..body = databaseParam.property('exec').call(
      [code.literalString('DELETE FROM `${tb.name}` WHERE ${whereClause.first}')],
      {'parameters': code.CodeExpression(code.Code(whereClause.last))},
    ).code);
}

List<String> _whereClause(TableAnnotationPresentation tb) {
  final List<ColumnAnnotationPresentation> columns;
  if (tb.primariesKey.isNotEmpty) {
    columns = tb.primariesKey;
  } else if (tb.uniques.isNotEmpty) {
    columns = tb.uniques.values.first;
  } else {
    throw StateError('Never reach');
  }
  final where = StringBuffer();
  final whereParam = StringBuffer('[');
  for (var c in columns) {
    if (where.isNotEmpty) {
      where.write(' AND ');
      whereParam.write(', ');
    }
    where.write('`${c.name}`=?');
    whereParam.write(c.dartName.symbol);
  }
  whereParam.write(']');
  return [where.toString(), whereParam.toString()];
}
