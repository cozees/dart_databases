import 'dart:io';

import 'package:args/args.dart';

import 'build.dart';
import 'config.dart';
import 'source.dart';
import 'util.dart';

/// output directory
const String output = 'output';

/// version
const String release = 'release';

/// hash to for verify download content
const String verify = 'verify';

/// the path to yaml configure file
const String buildConfigFile = 'config';

/// flag indicate whether should build a webassembly
const String build = 'build';

/// flag indicate whether should force download sqlite source code.
const String download = 'download';

void main(List<String> args) async {
  var argParser = ArgParser()
    ..addFlag(
      build,
      abbr: 'b',
      help: 'Build webassembly if there is any cache otherwise download the source code.',
    )
    ..addFlag(download, abbr: 'd', help: 'Download sqlite source code.')
    ..addOption(
      output,
      abbr: 'o',
      help: 'Output directory of built file.',
    )
    ..addOption(
      release,
      help: 'The release of sqlite in format YEAR:VERSION.',
      mandatory: true,
    )
    ..addOption(
      buildConfigFile,
      abbr: 'c',
      help: 'Path to build config file.',
      defaultsTo: BuildConfig.defaultConfigFileName,
    )
    ..addOption(
      verify,
      help: 'Hash to verify download content, in format: algo:hex',
    );
  // parse argument
  late ArgResults result;
  try {
    result = argParser.parse(args);
  } catch (e) {
    print(argParser.usage);
    exit(1);
  }

  var drelease = (result[release] as String).split(':');
  final year = drelease[0];
  final dversion = drelease[1].downloadVersion(), nversion = drelease[1].versionNumber();
  final dverify = result[verify] as String?;

  // download file
  if (result['download']) {
    await downloadSource(year, dversion, drelease[1], dverify);
    await extractSource();
    if (!result['build']) exit(0);
  }
  // if build flag set then output is required.
  if (result['build']) {
    final out = result[output] as String?;
    if (out != null) {
      final bc = await BuildConfig.init(result[buildConfigFile], nversion, drelease[1]);
      await buildWebAssembly(bc, [out, drelease[1]].join(Platform.pathSeparator), dversion);
      exit(0);
    }
    print(red.write('Output is required when build webassembly.'));
  } else {
    print(red.write('build or download option must be provided.'));
  }
  print(argParser.usage);
}

extension on String {
  int versionNumber() {
    // omit last build if version has 4 segment, major.minor.patch.build
    // only major, minor and patch is take into consideration
    const a = [1000000, 1000, 1, 0];
    final it = a.iterator;
    return split('.')
        .map((e) => int.parse(e))
        .fold(0, (v, e) => v + (e * (it..moveNext()).current));
  }

  String downloadVersion() {
    // 3.36.0 => 3360000
    const a = [1, 2, 2, 2];
    final it = a.iterator;
    final segment = split('.');
    if (segment.length == 3) segment.add('0');
    return segment.map((e) => e.padRight((it..moveNext()).current, '0')).join();
  }
}
