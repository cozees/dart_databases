//
import 'package:args/command_runner.dart';

import 'command/generate/generate.dart';

void main(List<String> args) {
  var runner = CommandRunner('ffigen', 'Tool load SQLite C API document and generate dart code.')
    ..addCommand(GenerateBinding())
    ..run(args);
}
