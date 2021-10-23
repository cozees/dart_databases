import 'package:code_builder/code_builder.dart' as cb;
import 'package:code_builder/src/specs/code.dart';
import 'package:code_builder/src/visitors.dart';

// ******** If Else ********
class IfElseCond implements cb.Code {
  final List<cb.Expression> _conditions = [];
  final List<cb.Code> _codes = [];

  IfElseCond elseif(cb.Expression condition, cb.Code code) =>
      _notDone().._conditions.add(condition).._codes.add(code);

  IfElseCond else$(cb.Code code) => _notDone().._codes.add(code);

  IfElseCond _notDone() {
    if (_codes.length == _conditions.length) return this;
    throw Exception('Control flow has been close with else already.');
  }

  @override
  R accept<R>(covariant AdvanceVisitor<R> visitor, [R? context]) =>
      visitor.visitIfElse(this, context);
}

class If extends IfElseCond {
  If(cb.Expression condition, cb.Code code) {
    _conditions.add(condition);
    _codes.add(code);
  }
}

// ******** Effective Division integer ********

class DivInt extends cb.Expression {
  DivInt(this.left, this.right);

  final cb.Expression left;
  final cb.Expression right;

  @override
  R accept<R>(covariant AdvanceVisitor<R> visitor, [R? context]) =>
      visitor.visitDivInt(this, context);
}

// ******** Return ********

class Return implements cb.Code {
  Return(cb.Expression expression) : _expr = expression;

  final cb.Expression _expr;

  @override
  R accept<R>(covariant AdvanceVisitor<R> visitor, [R? context]) =>
      visitor.visitReturn(this, context);
}

// ******** Try Catch ********

const rethrow$ = cb.Code('rethrow;');

class Throw implements cb.Code {
  Throw(this.expr);

  final cb.Expression expr;

  @override
  R accept<R>(covariant AdvanceVisitor<R> visitor, [R? context]) =>
      visitor.visitThrow(this, context);
}

class _CatchClause {
  _CatchClause.on$(this.on$, this.code)
      : exception = null,
        stacktrace = null;

  _CatchClause.catch$(this.exception, this.stacktrace, this.code) : on$ = null;

  _CatchClause.onCatch$(this.on$, this.exception, this.stacktrace, this.code);

  final cb.Code code;
  final cb.Reference? on$;
  final cb.Reference? exception;
  final cb.Reference? stacktrace;
}

class TryCatch implements cb.Code {
  TryCatch._(this._try);

  final cb.Code _try;
  final List<_CatchClause> _catches = [];
  cb.Code? _finally;

  TryCatch on$(cb.Reference exception, cb.Code code) => _notCatch()
    .._notFinally()
    .._catches.add(_CatchClause.on$(exception, code));

  TryCatch on$catch(cb.Reference exception,
      cb.Code Function(cb.Reference exception, cb.Reference stack) callback) {
    _notCatch();
    _notFinally();
    final e = cb.refer('e'), s = cb.refer('s');
    return this.._catches.add(_CatchClause.onCatch$(exception, e, s, callback(e, s)));
  }

  TryCatch catch$(cb.Code Function(cb.Reference exception, cb.Reference stack) callback) {
    _notFinally();
    final e = cb.refer('e'), s = cb.refer('s');
    return this.._catches.add(_CatchClause.catch$(e, s, callback(e, s)));
  }

  TryCatch finally$(cb.Code code) => _notFinally().._finally = code;

  TryCatch _notCatch() {
    if (_catches.isNotEmpty && _catches.last.on$ == null) {
      throw Exception('Catch code is already instate, the on catch clause is never reach.');
    }
    return this;
  }

  TryCatch _notFinally() {
    if (_finally != null) {
      throw Exception('Try catch flow has been close with finally code.');
    }
    return this;
  }

  @override
  R accept<R>(covariant AdvanceVisitor<R> visitor, [R? context]) =>
      visitor.visitTryCatch(this, context);
}

class Try extends TryCatch {
  Try(cb.Code code) : super._(code);
}

// ******** While ********

class While implements cb.Code {
  While(this.condition, this.body);

  final cb.Expression condition;

  final cb.Code body;

  @override
  R accept<R>(covariant AdvanceVisitor<R> visitor, [R? context]) =>
      visitor.visitWhile(this, context);
}

// ******** For ********

class For implements cb.Code {
  For.index({
    cb.Expression? init,
    required cb.Expression if$,
    cb.Expression? step,
    required cb.Code body,
  }) : this._(init, if$, step, null, null, body);

  For.in$({required cb.Reference var$, required cb.Reference in$, required cb.Code body})
      : this._(null, null, null, var$, in$, body);

  For._(this.initial, this.condition, this.step, this.var$, this.in$, this.body);

  final cb.Expression? initial;
  final cb.Expression? condition;
  final cb.Expression? step;

  final cb.Reference? in$;
  final cb.Reference? var$;

  final cb.Code body;

  @override
  R accept<R>(covariant AdvanceVisitor<R> visitor, [R? context]) => visitor.visitFor(this, context);
}

abstract class AdvanceVisitor<T>
    implements cb.ExpressionVisitor<T>, CodeVisitor<T>, SpecVisitor<T> {
  T visitIfElse(IfElseCond code, [T? context]);

  T visitReturn(Return code, [T? context]);

  T visitTryCatch(TryCatch tc, [T? context]);

  T visitThrow(Throw t, [T? context]);

  T visitWhile(While t, [T? context]);

  T visitFor(For t, [T? context]);

  T visitDivInt(DivInt t, [T? context]);
}

abstract class IfElseEmitter implements AdvanceVisitor<StringSink> {
  @override
  StringSink visitIfElse(IfElseCond code, [StringSink? output]) {
    output ??= StringBuffer();
    output.write('if (');
    code._conditions.first.accept(this as cb.ExpressionEmitter, output);
    output.write(') {');
    code._codes.first.accept(this as CodeEmitter, output);
    output.write('}');
    var i = 1;
    for (; i < code._conditions.length; i++) {
      output.write('else if (');
      code._conditions[i].accept(this as cb.ExpressionEmitter, output);
      output.write(') {');
      code._codes[i].accept(this as CodeEmitter, output);
      output.write('}');
    }
    // remain is the last 1 which is else code
    if (i < code._codes.length) {
      output.write('else {');
      code._codes[i].accept(this as CodeEmitter, output);
      output.write('}');
    }
    return output;
  }

  @override
  StringSink visitReturn(Return code, [StringSink? output]) {
    output ??= StringBuffer();
    output.write('return ');
    code._expr.accept(this as cb.ExpressionEmitter, output);
    output.write(';');
    return output;
  }

  @override
  StringSink visitTryCatch(TryCatch tc, [StringSink? output]) {
    if (tc._finally == null && tc._catches.isEmpty) {
      throw Exception('Try must follow by a catch clause or finally clause.');
    }
    output ??= StringBuffer();
    output.write('try {');
    tc._try.accept(this as CodeVisitor, output);
    output.write('}');
    for (var c in tc._catches) {
      if (c.on$ != null) {
        output.write('on ');
        c.on$!.accept(this, output);
      }
      if (c.exception != null) {
        output.write(' catch(');
        c.exception!.accept(this, output);
        if (c.stacktrace != null) {
          output.write(', ');
          c.stacktrace!.accept(this, output);
        }
        output.write(')');
      }
      output.write(' {');
      c.code.accept(this as CodeEmitter, output);
      output.write('}');
    }
    if (tc._finally != null) {
      output.write('finally {');
      tc._finally!.accept(this as CodeEmitter, output);
      output.write('}');
    }
    return output;
  }

  @override
  StringSink visitThrow(Throw t, [StringSink? output]) {
    output ??= StringBuffer();
    output.write('throw ');
    t.expr.accept(this as cb.ExpressionEmitter, output);
    output.write(';');
    return output;
  }

  @override
  StringSink visitWhile(While t, [StringSink? output]) {
    output ??= StringBuffer();
    output.write('while (');
    t.condition.accept(this as cb.ExpressionEmitter, output);
    output.write(') {');
    t.body.accept(this, output);
    output.write('}');
    return output;
  }

  @override
  StringSink visitFor(For t, [StringSink? output]) {
    output ??= StringBuffer();
    output.write('for (');
    if (t.in$ != null) {
      output.write('var ');
      t.var$!.accept(this, output);
      output.write(' in ');
      t.in$!.accept(this, output);
    } else {
      t.initial?.accept(this as cb.ExpressionEmitter, output);
      output.write('; ');
      t.condition!.accept(this as cb.ExpressionEmitter, output);
      output.write('; ');
      t.step?.accept(this as cb.ExpressionEmitter, output);
    }
    output.write(') {');
    t.body.accept(this, output);
    output.write('}');
    return output;
  }

  @override
  StringSink visitDivInt(DivInt t, [StringSink? output]) {
    output ??= StringBuffer();
    t.left.accept(this, output);
    output.write(' ~/ ');
    t.right.accept(this, output);
    return output;
  }
}
