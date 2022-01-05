part of 'class_generator.dart';

/// default imported package
const databaseSQLPackage = 'package:database_sql/database_sql.dart';

/// row reader parameter
final rowReaderType = code.refer('RowReader', databaseSQLPackage);
final rowReaderParam = code.Parameter((b) {
  b.name = 'reader';
  b.type = rowReaderType;
});

/// Database parameter
final databaseType = code.refer('Database', databaseSQLPackage);
final databaseParam = code.Parameter((b) {
  b.name = 'db';
  b.type = databaseType;
});

/// Future refer
final futureVoid = code.refer('Future<void>', 'dart:async');
final futureChange = code.refer('Future<Changes>', 'dart:async');
final futureChangeOpt = code.refer('Future<Changes?>', 'dart:async');

// helper for Parameter class
extension _ParamRefer on code.Parameter {
  code.Expression property(String field) => toExpr().property(field);

  code.Expression call(
    Iterable<code.Expression> positionalArguments, [
    Map<String, code.Expression> namedArguments = const {},
    List<code.Reference> typeArguments = const [],
  ]) =>
      toExpr().call(positionalArguments, namedArguments, typeArguments);

  code.Expression toExpr() => code.refer(name);
}

// helper for code.Expression class
extension _ExpressionUtil on code.Expression {
  code.Expression withNullCheck(bool notNull) => notNull ? nullChecked : this;
}

// helper for code.Reference: type
extension _ReferenceUtil on code.Reference {
  bool compatible(String? type) =>
      type == symbol ||
      (type != null &&
          symbol!.length - 1 == type.length &&
          symbol!.startsWith(type) &&
          symbol![symbol!.length - 1] == '?');

  code.Reference nullable(bool notNull) => notNull ? this : code.refer('$symbol?', url);
}

//
class ExtReference extends code.Reference {
  ExtReference(this.publicName, String symbol, [String? url]) : super(symbol, url);
  final String publicName;
}

/// avoid auto generated alias for imported package.
class SelfAllocator implements code.Allocator {
  SelfAllocator(Iterable<code.Directive> imports, [this.part = false])
      : _originSourceImport = {for (var v in imports) v.url: v};

  final Map<String, code.Directive> _originSourceImport;

  final _imports = <String, String?>{};

  final bool part;

  @override
  String allocate(code.Reference reference) {
    String? alias;
    if (reference.url != null) {
      alias = _originSourceImport[reference.url]?.as;
      final exAlias = _imports[reference.url];
      if (!_imports.containsKey(reference.url)) {
        _imports[reference.url!] = alias;
      } else if (exAlias != alias) {
        throw Exception('Import pacakge ${reference.url} is inconsistent previously with alias'
            '$exAlias however current import as an alias as $alias');
      }
    }
    return alias == null || reference.symbol!.startsWith('$alias.')
        ? reference.symbol!
        : '$alias.${reference.symbol}';
  }

  @override
  Iterable<code.Directive> get imports =>
      part ? [] : _imports.keys.map((u) => code.Directive.import(u, as: _imports[u]));
}

/// common class that have default conversion method
const preSupportClass = [
  _CommonClassRefer('DateTime', 'parse', 'toIso8601String'),
  _CommonClassRefer('Uri', 'parse', 'toString'),
];

// store class name and method
class _CommonClassRefer {
  const _CommonClassRefer(this.name, this.reader, this.writer);

  final String name;
  final String reader; // always static or factory
  final String writer; // all non-static method
}

// Comment last extension helper
extension _CommonClassUtil on List<_CommonClassRefer> {
  code.Expression? anyReader(code.Reference? type) {
    if (type != null) {
      for (var ccr in this) {
        if (type.compatible(ccr.name)) return code.refer(ccr.name).property(ccr.reader);
      }
    }
  }
}

/// Apply reader help add code generate to parse value from database into dart object
code.Expression applyReaderConversion(ColumnAnnotationPresentation field, code.Expression ref) {
  code.Expression? expr;
  final reader = field.reader;
  if (reader != null) {
    if (reader.isFunc) {
      return code.refer(reader.source).call([ref]);
    } else {
      return code.refer(reader.source).property(reader.method!).call([ref]);
    }
  } else if (field.dartType.compatible('bool')) {
    return ref.equalTo(code.refer('1'));
  } else if ((expr = preSupportClass.anyReader(field.dartType)) != null) {
    return expr!.call([ref]);
  } else if (!field.dartType.compatible(field.dartTypeAffinity)) {
    // not a scalar value therefore reader is required.
    throw Exception('column field ${field.dartName.symbol} has a type ${field.dartType.symbol} '
        'which is not compatible with sql value ${field.type} thus a reader is required.');
  }
  return ref;
}

String propertyByField(ColumnAnnotationPresentation field) {
  switch (field.dartTypeAffinity) {
    case 'int':
    case 'bool':
      return 'intValueBy';
    case 'String':
    case 'DateTime':
      return 'stringValueBy';
    case 'Uint8List':
      return 'blobValueBy';
    case 'double':
      return 'doubleValueBy';
    default:
      return 'valueBy';
  }
}
