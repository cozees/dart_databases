import 'dart:io';

import 'package:code_builder/code_builder.dart' as cb;
import 'package:yaml/yaml.dart' as yaml;

import 'parser/parser.dart';

abstract class Meta {
  bool get pointer;

  bool get nullable;

  static void typeYamlEncode(cb.Reference type, bool nullable, StringBuffer buffer, int indent) {
    final txtIndent = ''.padLeft(indent, ' ');
    buffer.writeln('symbol: ${type.symbol}');
    if (type.url != null) {
      buffer.write(txtIndent);
      buffer.writeln('url: ${type.url}');
    }
    if (type is cb.TypeReference) {
      buffer.write(txtIndent);
      buffer.writeln('nullable: ${(type.isNullable ?? false) || nullable}');
      buffer.write(txtIndent);
      buffer.writeln('pointer: ${type.symbol == 'Pointer' && type.url == dartffi}');
      if (type.types.isNotEmpty) {
        buffer.write(txtIndent);
        buffer.writeln('types:');
        for (var t in type.types) {
          buffer.write(txtIndent);
          buffer.write('  - ');
          typeYamlEncode(t, false, buffer, indent + 4);
        }
      }
    } else {
      buffer.write(txtIndent);
      buffer.writeln('nullable: $nullable');
    }
  }
}

class MetaType extends Meta {
  late final cb.TypeReference type;
  late final bool mustOverride;
  late final bool isBlob;
  late final bool free;
  late final String? freeBy;

  static cb.TypeReference typeReference(yaml.YamlMap obj) {
    return cb.TypeReference((b) => b
      ..symbol = obj['symbol']
      ..url = obj['url']
      ..types.addAll([
        for (var t in (obj['types'] as yaml.YamlList?) ?? []) typeReference(t),
      ]));
  }

  static cb.TypeReference rootType(yaml.YamlMap obj) {
    final nullable = obj['nullable'] == true;
    var types = obj['types'] as yaml.YamlList?;
    var trb = cb.TypeReferenceBuilder();
    trb.symbol = obj['symbol'];
    trb.url = obj['url'];
    trb.isNullable = nullable;
    if (types != null) {
      for (var t in types) {
        trb.types.add(MetaType.typeReference(t));
      }
    }
    return trb.build();
  }

  MetaType(yaml.YamlMap obj)
      : type = rootType(obj),
        isBlob = obj['blob'] == true,
        free = obj['free'] != false,
        freeBy = obj['free'] is String ? obj['free'] : null,
        mustOverride = obj['override'] == true;

  @override
  bool get nullable => type.isNullable ?? false;

  @override
  bool get pointer => type.symbol == 'Pointer' && type.url == dartffi && type.types.isNotEmpty;
}

class MetaParam extends Meta {
  late final cb.Parameter param;
  late final bool destroyer;
  late final bool mustOverride;
  late final bool isBlob;
  late final bool transform;
  late final String? sizeOf;
  late final bool textKind;

  MetaParam(yaml.YamlMap obj) {
    param = cb.Parameter((p) => p
      ..name = obj['name']
      ..type = MetaType.rootType(obj));
    sizeOf = obj['sizeOf'];
    isBlob = obj['blob'] == true;
    textKind = obj['text'] == true;
    transform = obj['transform'] != false; // default to true
    destroyer = obj['destroyer'] == true;
    mustOverride = obj['override'] == true;
  }

  @override
  bool get nullable =>
      param.type is cb.TypeReference && ((param.type as cb.TypeReference).isNullable ?? false);

  @override
  bool get pointer =>
      param.type is cb.TypeReference &&
      param.type!.symbol == 'Pointer' &&
      param.type!.url == dartffi &&
      (param.type as cb.TypeReference).types.isNotEmpty;
}

class ApiMeta {
  final MetaType returns;
  final Iterable<MetaParam> params;
  late final bool hasDestroyer;

  late final bool builtDependent;
  late final Change? change;

  ApiMeta(this.returns, this.params, this.builtDependent, [this.change]) {
    hasDestroyer = params.any((element) => element.destroyer);
  }

  void makeCorrection(cb.MethodBuilder builder) {
    if (returns.mustOverride) {
      builder.returns = returns.type;
    }
    for (var i = 0; i < params.length; i++) {
      var param = params.elementAt(i);
      if (param.mustOverride) {
        builder.requiredParameters[i] = builder.requiredParameters[i].rebuild((b) {
          final ct = param.param.type as cb.TypeReference;
          final tb = cb.TypeReferenceBuilder();
          tb.symbol = ct.symbol;
          tb.url = ct.url;
          tb.types.addAll(ct.types);
          tb.bound = ct.bound;
          // ignore the nullable
          b.type = tb.build();
        });
      }
    }
  }

  void toYaml(StringBuffer buffer, int indent) {
    final txtIndent = ''.padLeft(indent, ' ');
    buffer.write(txtIndent);
    buffer.writeln('returns:');
    buffer.write(txtIndent);
    buffer.write('  ');
    Meta.typeYamlEncode(returns.type, returns.nullable, buffer, indent + 2);
    buffer.write(txtIndent);
    buffer.writeln('arguments:');
    for (var arg in params) {
      buffer.write(txtIndent);
      buffer.writeln('  - name: ${arg.param.name}');
      buffer.write(txtIndent);
      buffer.write('    ');
      Meta.typeYamlEncode(arg.param.type!, arg.nullable, buffer, indent + 4);
    }
  }
}

enum ChangeKind {
  add,
  remove,
  deprecate,
}

class Version {
  Version(this.version, this.versionNumber, this.releaseDate);

  final String version;
  final int versionNumber;
  final String releaseDate;
}

class Change {
  Change(this.version, this.kind);

  final Version version;
  final ChangeKind kind;
}

class GenerateMeta {
  GenerateMeta(this.types, this.crossPlatformApis, this.apisMeta, this.versions);

  final List<String> types;
  final List<String> crossPlatformApis;
  final Map<String, ApiMeta> apisMeta;
  final List<Version> versions;
}

GenerateMeta loadApiMeta() {
  final meta = File('sqlite_api_meta.yaml');
  final ldoc = yaml.loadYaml(meta.readAsStringSync()) as yaml.YamlMap;
  // api list that is use for generate compatible api for both web and native
  final list = ldoc['meta'] as yaml.YamlList;
  final crossPlatformApis = (ldoc['apis'] as yaml.YamlList).cast<String>().toList();
  final listType = (ldoc['types'] as yaml.YamlList).cast<String>().toList();
  // load version
  final versions = <Version>[];
  final changes = <String, Change>{};
  final releases = ldoc['releases'] as yaml.YamlList;
  for (var r in releases) {
    versions.add(Version(
      r['version'],
      r['versionNumber'] as int,
      r['releaseDate'],
    ));
    if (r['changes'] != null) {
      for (var c in r['changes'] as yaml.YamlList) {
        changes[c['name']] = Change(versions.last, ChangeKind.values[c['kind'] as int]);
      }
    }
  }
  // load api metadata
  final apisMeta = <String, ApiMeta>{};
  for (var item in list) {
    final obj = item as yaml.YamlMap;
    final name = obj['name'] as String;
    final args = (obj['arguments'] as yaml.YamlList?) ?? [];
    apisMeta[name] = ApiMeta(
      MetaType(obj['returns']),
      args.map((e) => MetaParam(e)),
      obj['built'] == true,
      changes[name],
    );
  }
  return GenerateMeta(listType, crossPlatformApis, apisMeta, versions);
}
