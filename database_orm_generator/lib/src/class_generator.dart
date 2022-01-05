import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart' as code;
import 'package:dart_style/dart_style.dart';
import 'package:database_sql/orm.dart';
import 'package:source_gen/source_gen.dart';

part 'annotation_helper.dart';

part 'column.dart';

part 'common.dart';

part 'constructor.dart';

part 'table.dart';

/// Value mapping for build config
class ConfigData {
  /// use for testing purpose
  static ConfigData defaultConfig() => ConfigData({
        'read_only_primary_key': true,
        'table_prefix': null,
        'column_prefix': null,
        // TODO: we might need to remove
        'allow_incomplete_column_selection': true,
      });

  ConfigData(Map<String, dynamic> config)
      : readOnlyPrimaryKey = config['read_only_primary_key'] == true,
        tablePrefix = config['table_prefix'],
        columnPrefix = config['column_prefix'],
        allowIncompleteColumnSelection = config['allow_incomplete_column_selection'] == true;

  /// should primary is not allow to change.
  final bool readOnlyPrimaryKey;

  /// If provided the table name will add this prefix before the defined name in the annotation.
  final String? tablePrefix;

  /// If provided the column name will add this prefix before the defined name in the annotation.
  final String? columnPrefix;

  /// Allow SELECT query to be able to filter the column from table.
  ///
  /// If true each field in the generate code that correspond to each column will defined with
  /// nullable type and enforce runtime check for column that is defined with **NOT NULL**.
  final bool allowIncompleteColumnSelection;
}

/// Class generator generate class file for annotation table.
class ClassGenerator extends Generator {
  /// create class generator
  ClassGenerator(this.options) : config = ConfigData(options.config);

  /// builder option configuration
  final BuilderOptions options;

  /// user's configuration
  final ConfigData config;

  TypeChecker get columnChecker => TypeChecker.fromRuntime(Column);

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    // read import
    final imports = (library.element.imports.toList()
          ..removeWhere((e) => e.uri != null && e.uri!.startsWith('dart:core')))
        .map((e) => code.Directive.import(
              e.uri.toString(),
              as: e.prefix?.name,
            ));
    final importCodes =
        imports.map((e) => "import '${e.url}' ${e.as != null ? 'as ${e.as}' : ''};");

    final libGen = code.LibraryBuilder();
    for (var element in library.allElements) {
      if (element is! ClassElement) continue;
      final tb = await TableAnnotationPresentation.parseTableAnnotation(element, importCodes);
      if (tb == null) continue;

      // additional method
      final insert = createInsertMethod(tb);
      final update = createUpdateMethod(tb);
      final delete = createDeleteMethod(tb);

      final clazzName = element.name.substring(0, element.nameLength - 5);
      final tbName = tb.name;
      libGen.body.add(code.Class((b) => b
        ..docs.add('/// A class represent table $tbName')
        ..name = clazzName
        ..annotations.addAll(tb.annotations?.map((e) => code.CodeExpression(e)) ?? [])
        ..mixins.add(code.refer(element.name))
        ..constructors.addAll([
          constructorNewObject(clazzName, tb.columns),
          constructorFromDatabase(clazzName, tb.columns),
        ])
        ..fields.addAll([
          ...generateConstantTableColumn(tbName, tb.columns),
        ])
        ..methods.addAll([
          createTableMethod(tb, tb.columns),
          code.Method((m) => m
            ..docs.add('/// static function creator use to provide to [Database.query]'
                ', [Statement.query] and [Transaction.query].')
            ..lambda = true
            ..name = 'creator'
            ..requiredParameters.add(rowReaderParam)
            ..returns = code.refer(clazzName)
            ..body = code.refer(clazzName).property('db').call([rowReaderParam.toExpr()]).code
            ..static = true),
          ...generateGetterTableColumn(tb.columns),
          ...generateSetterTableColumn(tb.columns),
          insert,
          if (update != null) update,
          if (delete != null) delete,
        ])));
    }
    return DartFormatter(pageWidth: 100).format('${libGen.build().accept(code.DartEmitter(
          allocator: SelfAllocator(imports, true),
          useNullSafetySyntax: true,
        ))}');
  }
}
