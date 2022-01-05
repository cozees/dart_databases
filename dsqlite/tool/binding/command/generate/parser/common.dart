import 'package:code_builder/code_builder.dart' as cb;
import 'package:dart_style/dart_style.dart';

final formatter = DartFormatter(pageWidth: 100, fixes: StyleFix.all);

class MyEmitter extends cb.DartEmitter {
  MyEmitter({
    cb.Allocator allocator = cb.Allocator.none,
    bool useNullSafetySyntax = false,
  }) : super(
          allocator: allocator,
          orderDirectives: true,
          useNullSafetySyntax: useNullSafetySyntax,
        );

  @override
  StringSink visitLibrary(cb.Library spec, [StringSink? output]) {
    (allocator as PrefixedAllocator).emitImport = true;
    for (var i = 0; i < spec.directives.length; i++) {
      if (spec.directives[i].type == cb.DirectiveType.partOf) {
        if (spec.directives.length > 1) {
          final d = spec.directives[i];
          spec = spec.rebuild((builder) => builder.directives
            ..clear()
            ..add(d));
        }
        (allocator as PrefixedAllocator).emitImport = false;
        break;
      }
    }
    return super.visitLibrary(spec, output);
  }

  @override
  StringSink visitField(cb.Field spec, [StringSink? output]) {
    output ??= StringBuffer();
    spec.docs.forEach(output.writeln);
    for (var a in spec.annotations) {
      visitAnnotation(a, output);
    }
    var name = spec.name;
    if (spec.name.startsWith('external:')) {
      output.write('external ');
      name = spec.name.substring(9);
    }
    if (spec.static) {
      output.write('static ');
    }
    if (spec.late) {
      output.write('late ');
    }
    switch (spec.modifier) {
      case cb.FieldModifier.var$:
        if (spec.type == null) {
          output.write('var ');
        }
        break;
      case cb.FieldModifier.final$:
        output.write('final ');
        break;
      case cb.FieldModifier.constant:
        output.write('const ');
        break;
    }
    if (spec.type != null) {
      spec.type!.type.accept(this, output);
      output.write(' ');
    }
    output.write(name);
    if (spec.assignment != null) {
      output.write(' = ');
      startConstCode(spec.modifier == cb.FieldModifier.constant, () {
        spec.assignment!.accept(this, output);
      });
    }
    output.writeln(';');
    return output;
  }
}

class PrefixedAllocator implements cb.Allocator {
  static const _doNotPrefix = ['dart:core'];

  bool emitImport;

  final Map<String, String> _knownImport;
  final _imports = <String, String>{};
  var _keys = 1;

  PrefixedAllocator(this.emitImport, [this._knownImport = const {}]);

  @override
  String allocate(cb.Reference reference) {
    final symbol = reference.symbol;
    final url = reference.url;
    if (url == null || _doNotPrefix.contains(url)) {
      return symbol!;
    }
    if (_knownImport[url] != null) {
      return '${_imports.putIfAbsent(url, () => _knownImport[url]!)}.$symbol';
    }
    return '${_imports.putIfAbsent(url, _nextKey)}.$symbol';
  }

  String _nextKey() => '_i${_keys++}';

  @override
  Iterable<cb.Directive> get imports =>
      emitImport ? _imports.keys.map((u) => cb.Directive.import(u, as: _imports[u])) : [];
}