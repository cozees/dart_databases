part of 'parser.dart';

const keywords = [
  'null',
  'int',
  'double',
  'String',
  'num',
  'dynamic',
  'enum',
  'Function',
  // pre-defined type
  'true',
  'null',
  'false',
  'void',
  //
  'library',
  //
  'export',
  'import',
  'show',
  'hide',
  //
  'mixin',
  'extension',
  'class',
  'abstract',
  'extends',
  'factory',
  'super',
  'new',
  'on',
  'typedef',
  'with',
  'implements',
  // top defined
  'external',
  'late',
  'static',
  'async',
  'await',
  'sync',
  'operator',
  'get',
  'yield',
  'set' //
      'final',
  'const',
  'var',
  //
  'throw',
  'catch',
  'try',
  'finally',
  'rethrow',
  //
  'return',
  //
  'this',
  //
  'deferred',
  //
  'as',
  //
  'assert',
  //
  'part',
  //
  'required',
  'covariant',
  //
  'in',
  'is',
  'else',
  'do',
  'if',
  'switch',
  'case',
  'break',
  'continue',
  'for',
  'default',
  'while',
  //
];

// make sure it won't generate with variable which conflict with dart keyword.
String escapeKeyword(String txt) => keywords.contains(txt) ? '$txt\$' : txt;

mixin ParseConstant on _$Parser {
  bool readConstant() {
    // if not a #define or # define return null
    if (segments.current.raw != 'define') return false;
    // eligible macro constant
    var name = (segments..next()).current.raw;
    var expr = (segments..next()).current.raw;
    // Note: Currently SQLite C document provide only constant literal value or arithmetic expression
    // If in the future there other constant type such as string then we need to update this section.
    if (expr == '(') {
      for (var count = 1; count > 0;) {
        if ((segments..next()).current.raw == ')') {
          count--;
        } else if (segments.current.raw == '(') {
          count++;
        }
        expr += segments.current.raw;
      }
    }
    final i = expr.indexOf('SQLITE_');
    if (i != -1) {
      final ns = expr.indexOf(' ', i);
      final rp = expr.substring(i + 7, ns);
      expr = '${expr.substring(0, i)}$rp${expr.substring(ns)}';
    }
    final shortName = name.replaceFirst('SQLITE_', '');
    walkListener.onConstant(cb.refer(expr).assignConst(escapeKeyword(shortName)), name);
    return true;
  }
}
