import 'dart:io';

import 'package:package_config/package_config.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:yaml/yaml.dart' as yaml;

import 'util.dart';

const builtDependent = <String, List<String>>{
  '-DSQLITE_ENABLE_COLUMN_METADATA': [
    'sqlite3_column_database_name',
    'sqlite3_column_database_name16',
    'sqlite3_column_table_name',
    'sqlite3_column_table_name16',
    'sqlite3_column_origin_name',
    'sqlite3_column_origin_name16',
  ],
  '-DSQLITE_ENABLE_PREUPDATE_HOOK': [
    'sqlite3_preupdate_hook',
    'sqlite3_preupdate_old',
    'sqlite3_preupdate_count',
    'sqlite3_preupdate_depth',
    'sqlite3_preupdate_new',
    'sqlite3_preupdate_blobwrite',
  ],
  '-DSQLITE_ENABLE_STMT_SCANSTATUS': [
    'sqlite3_stmt_scanstatus',
    'sqlite3_stmt_scanstatus_reset',
  ],
  '-DSQLITE_ENABLE_UNLOCK_NOTIFY': [
    'sqlite3_unlock_notify',
  ],
  '-DSQLITE_ENABLE_SNAPSHOT': [
    'sqlite3_snapshot_cmp',
    'sqlite3_snapshot_open',
    'sqlite3_snapshot_free',
    'sqlite3_snapshot_get',
    'sqlite3_snapshot_recover',
  ]
};

class ConfigItem {
  ConfigItem(this.isBigInt, this.release, this.flags);

  String get name => release ? 'release' : 'debug';

  final bool isBigInt;
  final bool release;
  final List<String> flags;
}

extension on Directory {
  File file(String name) => File(_path([absolute.path, name]));

  String _path(List<String> segment) => segment.join(Platform.pathSeparator);
}

class BuildConfig {
  static const defaultConfigFileName = 'sqlite_webassembly_build.yaml';
  static const _metaFileName = 'sqlite_api_meta.yaml';
  static const _dsqlite = 'dsqlite';

  static Future<BuildConfig> init(String yamlFile, int version, String rawVersion) async {
    final file = Directory.current.file('pubspec.yaml');
    final configFile = Directory.current.file(yamlFile);
    if (file.existsSync()) {
      final spec = Pubspec.parse(await file.readAsString());
      if (spec.dependencies.containsKey(_dsqlite)) {
        // use by other package:
        var packageConfig = await findPackageConfig(Directory.current);
        final pkg = packageConfig!.packages.firstWhere((pkg) => pkg.name == _dsqlite);
        final preConfig = Directory(pkg.root.path).file(defaultConfigFileName);
        final metaFile = Directory(pkg.root.path).file(_metaFileName);
        return BuildConfig._(preConfig, configFile, metaFile, version, rawVersion);
      } else {
        final metaFile = Directory.current.file(_metaFileName);
        return BuildConfig._(configFile, null, metaFile, version, rawVersion);
      }
    }
    print(red.write('No meta file `$_metaFileName` found.').toString());
    exit(1);
  }

  BuildConfig._(File hosted, File? pkgConfig, File meta, int version, String rawVersion) {
    final hostedDoc = yaml.loadYaml(hosted.readAsStringSync()) as yaml.YamlMap;
    final doc = pkgConfig != null && pkgConfig.existsSync()
        ? yaml.loadYaml(pkgConfig.readAsStringSync()) as yaml.YamlMap
        : null;
    // use original host if the current package or project not defined.
    exportRuntime = (doc?['runtime'] as yaml.YamlList?)?.cast() ??
        (hostedDoc['runtime'] as yaml.YamlList).cast();
    cflag = (doc?['cflag'] as yaml.YamlList?)?.expand((e) => e.split(' ')) ??
        (hostedDoc['cflag'] as yaml.YamlList).expand((e) => e.split(' '));
    emitBitInt = doc?['emitBitInt'] ?? hostedDoc['emitBitInt'];
    emflag = (doc?['emflag'] as yaml.YamlList?)?.expand((e) => e.split(' ')) ??
        (hostedDoc['emflag'] as yaml.YamlList).expand((e) => e.split(' '));
    emflagRelease = (doc?['release'] as yaml.YamlList?)?.expand((e) => e.split(' ')) ??
        (hostedDoc['release'] as yaml.YamlList?)?.expand((e) => e.split(' '));
    emflagDebug = (doc?['debug'] as yaml.YamlList?)?.expand((e) => e.split(' ')) ??
        (hostedDoc['debug'] as yaml.YamlList?)?.expand((e) => e.split(' '));
    asm = doc != null
        ? (doc['asm'] as yaml.YamlList?)?.expand((e) => e.split(' '))
        : (hostedDoc['asm'] as yaml.YamlList?)?.expand((e) => e.split(' '));
    wasm = doc != null
        ? (doc['wasm'] as yaml.YamlList?)?.expand((e) => e.split(' '))
        : (hostedDoc['wasm'] as yaml.YamlList?)?.expand((e) => e.split(' '));
    // build export apis
    final metaDoc = yaml.loadYaml(meta.readAsStringSync()) as yaml.YamlMap;
    if (doc?.containsKey('exported') == true) {
      exportedApis = (doc!['exported'] as yaml.YamlList).cast<String>().toList();
    } else {
      exportedApis = (metaDoc['apis'] as yaml.YamlList).cast<String>().toList();
    }
    // required api
    exportedApis.addAll([
      'sqlite3_sourceid',
      'sqlite3_libversion',
      'sqlite3_libversion_number',
    ]);
    // check release version
    final releases = metaDoc['releases'] as yaml.YamlList;
    final removedApis = <String>[];
    final notExistedApis = <String>[];
    for (var release in releases) {
      // there is change in the release so skip it.
      var changes = release['changes'] as yaml.YamlList?;
      if (changes == null) continue;
      // there ares change(s)
      if (release['versionNumber'] <= version) {
        // ignore add or deprecate apis, only removed api is important
        for (var change in changes) {
          if (change['kind'] == 1 && exportedApis.remove(change['name'])) {
            removedApis.add(change['name']);
          }
        }
      } else {
        // newer version
        for (var change in changes) {
          if (change['kind'] == 0 && exportedApis.remove(change['name'])) {
            notExistedApis.add(change['name']);
          }
        }
      }
    }
    if (removedApis.isNotEmpty) {
      print(red
          .write('There are api(s) being excluded as it has been remove in prior to $rawVersion:')
          .toString());
      print(magenta.write(removedApis.joinWrap(indent: 3)).toString());
    }
    if (notExistedApis.isNotEmpty) {
      print(red
          .write('There are api(s) that does not existed in the current version $rawVersion')
          .toString());
      print(magenta.write(notExistedApis.joinWrap(indent: 3)).toString());
    }
    // remove api base on c flag
    removedApis.clear();
    for (var d in builtDependent.keys) {
      if (!cflag.contains(d)) {
        for (var api in builtDependent[d]!) {
          if (exportedApis.remove(api)) removedApis.add(api);
        }
      }
    }
    if (removedApis.isNotEmpty) {
      print(red.write('There are api(s) being excluded as its not enable with compile options.'));
      print(magenta.write(removedApis.joinWrap(indent: 3)).toString());
    }
  }

  late final Iterable<String> exportRuntime;
  late final List<String> exportedApis;

  late final bool emitBitInt;

  late final Iterable<String> cflag;
  late final Iterable<String> emflag;
  late final Iterable<String>? emflagDebug;
  late final Iterable<String>? emflagRelease;
  late final Iterable<String>? asm;
  late final Iterable<String>? wasm;

  bool get hasAnyBuild => asm != null || wasm != null;

  Future<void> eachBuildConfig(
    Future<void> Function(String name, Iterable<ConfigItem>) callback,
  ) async {
    if (wasm != null) await callback('wasm', wasmConfig);
    if (asm != null) await callback('asm', asmConfig);
  }

  Iterable<ConfigItem> get wasmConfig {
    final flags = [...emflag, ...wasm!, '-s', 'WASM=1'];
    return wasm != null
        ? [
            if (emflagDebug != null) ...[
              ConfigItem(false, false, [...flags, ...emflagDebug!, '-fsanitize=address']),
              if (emitBitInt)
                ConfigItem(true, false,
                    [...flags, ...emflagDebug!, '-fsanitize=address', '-s', 'WASM_BIGINT']),
            ],
            if (emflagRelease != null) ...[
              ConfigItem(false, true, [...flags, ...emflagRelease!]),
              if (emitBitInt)
                ConfigItem(true, true, [...flags, ...emflagRelease!, '-s', 'WASM_BIGINT']),
            ],
          ]
        : <ConfigItem>[];
  }

  Iterable<ConfigItem> get asmConfig {
    final flags = [...emflag, ...asm!, '-s', 'WASM=0'];
    return asm != null
        ? [
            if (emflagDebug != null) ...[
              ConfigItem(false, false, [...flags, ...emflagDebug!]),
              if (emitBitInt)
                ConfigItem(true, false, [...flags, ...emflagDebug!, '-s', 'WASM_BIGINT']),
            ],
            if (emflagRelease != null) ...[
              ConfigItem(false, true, [...flags, ...emflagRelease!]),
              if (emitBitInt)
                ConfigItem(true, true, [...flags, ...emflagRelease!, '-s', 'WASM_BIGINT']),
            ],
          ]
        : <ConfigItem>[];
  }
}
