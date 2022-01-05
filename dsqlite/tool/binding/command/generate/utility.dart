part of 'generate.dart';

extension PathList on List<String> {
  String joinPath() => join(Platform.pathSeparator);
}

extension StringUtility on String {
  String firstUpperCase() => '${this[0].toUpperCase()}${substring(1)}';
  String firstLowerCase() => '${this[0].toLowerCase()}${substring(1)}';

  cb.Expression toLiteral() => cb.literalString(this);
}

extension ListCode on List<cb.Code> {
  cb.Block toBlock() => cb.Block((b) => b.statements.addAll(this));
}

extension ExpressionUtility on cb.Expression {
  cb.Expression find(String name, cb.Reference cDef, [cb.Reference? dartDef]) =>
      call([name.toLiteral()], {}, [cDef, dartDef ?? cDef]);

  cb.Expression divisionInt(cb.Expression right) => DivInt(this, right);
}

extension TypeReferenceUtility on cb.TypeReference {
  cb.TypeReference nullable() => rebuild((b) => b.isNullable = true);

  bool get isInt64Bit => this == cInt64 || this == cUint64;
}

extension ReferenceUtility on cb.Reference {
  cb.Expression get increment => cb.CodeExpression(cb.Code.scope((a) => '${a(this)}++'));

  cb.Expression get decrement => cb.CodeExpression(cb.Code.scope((a) => '${a(this)}--'));

  bool get isInt64Bit => this == cInt64 || this == cUint64;
}

cb.Field lateFinalField(String name, cb.Code val, [cb.Reference? type]) {
  return cb.Field((b) => b
    ..name = name
    ..modifier = cb.FieldModifier.final$
    ..late = true
    ..type = type
    ..assignment = val);
}
