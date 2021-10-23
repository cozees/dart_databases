part of 'parser.dart';

mixin ParseAPI on _$Parser {
  bool readAPI() {
    late final List<cb.Parameter> args;
    final mb = cb.MethodBuilder();
    final returnTypeBuilder = readDataType(segments);
    final name = segments.identifier();
    // method
    walkListener.onAPI(name);
    if (segments.peek?.raw != '(') return false;
    segments.next();
    args = readArgument();
    (segments..next()).expected([';']);
    mb.name = name;
    mb.returns = walkListener.onType(returnTypeBuilder.build());
    mb.requiredParameters.addAll(args);
    walkListener.onMethod(mb, name, true);
    return true;
  }
}
