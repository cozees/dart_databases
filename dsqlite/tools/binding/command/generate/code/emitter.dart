import 'package:code_builder/code_builder.dart' as cb;

import 'allocator.dart';
import 'custom.dart';

class GenCodeEmitter extends cb.DartEmitter with IfElseEmitter {
  GenCodeEmitter({
    cb.Allocator allocator = cb.Allocator.none,
    bool useNullSafetySyntax = false,
  }) : super(
          allocator: allocator,
          orderDirectives: true,
          useNullSafetySyntax: useNullSafetySyntax,
        );

  @override
  StringSink visitDirective(cb.Directive spec, [StringSink? output]) {
    if (spec.type == cb.DirectiveType.import || spec.type == cb.DirectiveType.export) {
      final uri = Uri.parse(spec.url);
      if (uri.queryParameters['io'] != null && uri.queryParameters['web'] != null) {
        output ??= StringBuffer();
        output.write(spec.type == cb.DirectiveType.import ? 'import ' : 'export ');
        output.writeln("'${uri.scheme}${uri.path}'");
        // web
        var pkg = uri.queryParameters['web']!;
        output.write('if (dart.library.js)');
        output.writeln("'$pkg'");
        output.write('if (dart.library.html)');
        output.writeln("'$pkg'");
        // io
        pkg = uri.queryParameters['io']!;
        output.write('if (dart.library.io)');
        output.writeln("'$pkg'");
        // add alias
        if (spec.as != null) {
          if (spec.deferred) {
            output.write(' deferred ');
          }
          output.write(' as ${spec.as}');
        }
        if (spec.show.isNotEmpty) {
          output
            ..write(' show ')
            ..writeAll(spec.show, ', ');
        } else if (spec.hide.isNotEmpty) {
          output
            ..write(' hide ')
            ..writeAll(spec.hide, ', ');
        }
        output.write(';');
        return output;
      }
    }
    return super.visitDirective(spec, output);
  }

  @override
  StringSink visitScopedCode(cb.ScopedCode code, [StringSink? output]) {
    output ??= StringBuffer();
    (allocator as PrefixedAllocator).emitTypeReference = true;
    output.write(code.code(allocator.allocate));
    (allocator as PrefixedAllocator).emitTypeReference = false;
    return output;
  }

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
