import 'dart:convert';
import 'dart:io';

import 'config.dart';
import 'util.dart';

const emcc = 'emcc';

Future<void> buildWebAssembly(BuildConfig config, String out, String dversion) async {
  if (config.wasm?.isNotEmpty != true && config.asm?.isNotEmpty != true) {
    print(red.write('Make sure configuration include either `wasm` or `asm` or both.'));
    exit(1);
  }
  final path =
      ['build', 'sqlite', dversion, 'sqlite-amalgamation-$dversion'].join(Platform.pathSeparator);
  // build bytecode
  final cfile = [path, 'sqlite3.c'].join(Platform.pathSeparator);
  final bcfile = [path, 'sqlite3.bc'].join(Platform.pathSeparator);
  try {
    print(cyan.write('Start building bytecode $cfile ...'));
    await execute(emcc, config.cflag.toList()..addAll(['-c', cfile, '-o', bcfile]));
    // build out either wasm or asm or both
    final expFunc = File([path, 'export_function.json'].join(Platform.pathSeparator));
    final runtimeFunc = File([path, 'export_runtime_function.json'].join(Platform.pathSeparator));
    expFunc.writeAsStringSync(jsonEncode(config.exportedApis.map((e) => '_$e').toList()
      ..addAll([
        '_free',
        '_malloc',
      ])));
    runtimeFunc.writeAsStringSync(jsonEncode(config.exportRuntime));
    final exported = [
      '-s',
      'EXPORTED_FUNCTIONS=@${expFunc.absolute.path}',
      '-s',
      'EXPORTED_RUNTIME_METHODS=@${runtimeFunc.absolute.path}',
    ];
    await config.eachBuildConfig((name, configs) async {
      if (config.wasm?.isNotEmpty == true) {
        for (var bconfig in configs) {
          print(cyan.write('Start building $name ${bconfig.name} $out ...'));
          var bits = bconfig.isBigInt ? 'bigint' : 'normal';
          var jsfile = [out, name, 'sqlite3.${bconfig.name}.$bits.js'].join(Platform.pathSeparator);
          File(jsfile).createSync(recursive: true);
          await execute(emcc, [...exported, ...bconfig.flags, bcfile, '-o', jsfile], true);
        }
      }
    });
  } on ResultError catch (e) {
    print(e);
    exit(e.code);
  } on ProcessException catch (e) {
    print(red.write('Make sure emscripten compile is available in your PATH environment.'));
    print(e);
    exit(e.errorCode);
  }
}

Future<int> execute(String command, List<String> args, [bool showCommand = false]) async {
  if (showCommand) {
    print('$command ${args.join(' ')}');
  }
  final result = await Process.run(command, args);
  stdout.write(result.stdout);
  stderr.write(result.stderr);
  final code = result.exitCode;
  if (code == 0) return code;
  throw ResultError(code, 'execute failed.', command, args);
}

class ResultError implements Exception {
  ResultError(this.code, this.message, this.command, this.args);

  final int code;
  final String message;
  final String command;
  final List<String> args;

  @override
  String toString() =>
      'ResultError: ${red.write(code)}, $message\n   ${red.write(command)} ${red.write(args.join(' '))}';
}
