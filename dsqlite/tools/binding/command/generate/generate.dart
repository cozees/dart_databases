import 'dart:convert';
import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:args/command_runner.dart';
import 'package:code_builder/code_builder.dart' as cb;
import 'package:dart_style/dart_style.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;
import 'package:html2md/html2md.dart' as md;
import 'package:http/http.dart' as http;

import 'code/allocator.dart';
import 'code/emitter.dart';
import 'meta.dart';
import 'parser/parser.dart';
import 'code/custom.dart';

part 'event.dart';

part 'utility.dart';

part 'generate_api.dart';

part 'generate_constant.dart';

part 'generate_object.dart';

part 'native.dart';

part 'web.dart';

const sQLiteFullDoc = 'https://www.sqlite.org/capi3ref.html';

class GenerateBinding extends Command {
  @override
  String get description => 'Generate SQLite binding for native and web.';

  @override
  String get name => 'generate';

  static const output = 'out';
  static const force = 'force';

  GenerateBinding() {
    argParser.addOption(
      output,
      help: 'Base location where code generate is store.',
    );
    argParser.addFlag(
      force,
      defaultsTo: false,
      help: 'Force command to ignore cache and reconstruct the code and document from from '
          'https://www.sqlite.org/capi3ref.html',
    );
  }

  Future<Document> loadDocument() async {
    // load sqlite full document
    print('Loading sqlite document ...');
    final response = await http.get(Uri.parse(sQLiteFullDoc));
    if (response.statusCode != 200) {
      print('SQLite full document $sQLiteFullDoc failed with result code ${response.statusCode}.');
      exit(1);
    }
    print('Parsing HTML Dom ...');
    return html.parse(response.body);
  }

  @override
  Future<String> run() async {
    final outDir = argResults![output] as String;
    final file = File('build/sqlite_c_definition.txt');
    final constants = <String>[];
    final constantsDoc = <String, List<String>>{};
    final objects = <String>[];
    final objectsDoc = <String, List<String>>{};
    final apis = <String>[];
    final apisDoc = <String, List<String>>{};
    late final String code;
    if (!argResults![force] && file.existsSync()) {
      code = file.readAsStringSync();
      final a = json.decode(File('build/constants.json').readAsStringSync());
      final b = json.decode(File('build/constants_doc.json').readAsStringSync());
      constants.addAll(List.from(a));
      constantsDoc.addAll(Map.from(b).map((key, value) => MapEntry(key, List.from(value))));
      final c = json.decode(File('build/objects.json').readAsStringSync());
      final d = json.decode(File('build/objects_doc.json').readAsStringSync());
      objects.addAll(List.from(c));
      objectsDoc.addAll(Map.from(d).map((key, value) => MapEntry(key, List.from(value))));
      final e = json.decode(File('build/apis.json').readAsStringSync());
      final f = json.decode(File('build/apis_doc.json').readAsStringSync());
      apis.addAll(List.from(e));
      apisDoc.addAll(Map.from(f).map((key, value) => MapEntry(key, List.from(value))));
    } else {
      final doc = await loadDocument();
      final divs = doc.querySelectorAll('div.columns');
      if (divs.length < 3) {
        print('SQLite Document structure failed, expected at least 3 elements got ${divs.length}.');
        exit(2);
      }
      // construct document and merge constant code
      final buffer = StringBuffer();
      await _loadConstant(buffer, doc, divs[1], constants, constantsDoc);
      // construct document and merge type code
      await _loadObjects(buffer, doc, divs[0], objects, objectsDoc);
      // construct document and merge api code
      await _loadApis(buffer, doc, divs[2], apis, apisDoc);
      // write cache
      code = buffer.toString();
      file.writeAsStringSync(code);
      File('build/constants.json').writeAsStringSync(json.encode(constants));
      File('build/constants_doc.json').writeAsStringSync(json.encode(constantsDoc));
      File('build/objects.json').writeAsStringSync(json.encode(objects));
      File('build/objects_doc.json').writeAsStringSync(json.encode(objectsDoc));
      File('build/apis.json').writeAsStringSync(json.encode(apis));
      File('build/apis_doc.json').writeAsStringSync(json.encode(apisDoc));
    }
    Parser(
      code,
      ParserEvent(
        outDir,
        apis: apis,
        apisDoc: apisDoc,
        constants: constants,
        constantsDoc: constantsDoc,
        objects: objects,
        objectsDoc: objectsDoc,
      ),
    ).parse();
    return '';
  }
}

const maxChar = 100;

String _txtSegment(String txt, int start, i, [bool addSpace = false]) {
  final segment = txt.substring(start, i).trim();
  return segment.endsWith('.') || addSpace ? '$segment ' : segment;
}

List<String>? _wrapByCount(String? txt, bool isDartDocument) {
  if (txt == null) return null;
  final result = <String>[];
  var count = 0, smallest = maxChar - 5, start = 0, firstDot = false, remain = '';

  for (var i = 0; i < txt.length; i++) {
    if (txt[i] == ' ' && (count > smallest)) {
      result.add('$remain${_txtSegment(txt, start, i)}');
      count = 0;
      remain = '';
      start = i + 1;
      continue;
    } else if (txt[i] == '\r' || txt[i] == '\n') {
      if (start < i) remain += _txtSegment(txt, start, i, true);
      start = i + 1;
      continue;
    } else if (isDartDocument && txt[i] == '.' && !firstDot) {
      final ii = i + 1;
      if (ii < txt.length && txt[ii] == ' ') {
        firstDot = true;
        result.add('$remain${_txtSegment(txt, start, ii)}');
        result.add('');
        count = 0;
        remain = '';
        start = ii;
        continue;
      }
    }
    count++;
  }
  if (start < txt.length) {
    result.add('$remain${_txtSegment(txt, start, txt.length)}');
  } else if (remain.isNotEmpty) result.add(remain);
  return result;
}

final _mdRules = <md.Rule>[
  md.Rule('link-custom', filterFn: (node) {
    return node.nodeName == 'a' && node.getAttribute('href') != null;
  }, replacement: (content, node) {
    var href = node.getAttribute('href')!;
    var title = node.getAttribute('title') ?? '';
    var renderedTitle = title.isEmpty ? title : ' "$title"';
    return '[' + content + '](' + sQLiteFullDoc + href + renderedTitle + ')';
  }),
];

final _ignoresClassDoc = [
  RegExp(r'\d+\s+Constructors:'),
  RegExp(r'\d+\s+Destructors:'),
  RegExp(r'\d+\s+Methods:'),
];

Map<String, List<String>> _readResultCodeMeaning(Document document) {
  final h1 = document.querySelector('h1#result_code_meanings');
  if (h1 == null) throw Exception('Not a result code page or result code page wrong format.');
  Element? h3 = h1;
  // skip any until first h3
  while ((h3 = h3?.nextElementSibling) != null && h3!.localName != 'h3') {}
  // read each meaning
  Element? p;
  final buffer = StringBuffer();
  final result = <String, List<String>>{};
  do {
    final txt = h3!.text;
    final name = txt.substring(txt.indexOf(' ') + 1);
    p = h3;
    while ((p = p!.nextElementSibling) != null && p!.localName == 'p') {
      buffer.writeln(md.convert(p.innerHtml, rules: _mdRules));
    }
    result[name] = _wrapByCount(buffer.toString(), true)!;
    buffer.clear();
  } while ((h3 = p) != null && h3!.localName == 'h3');
  return result;
}

List<String> _readAsDartClassComment(Element? p) {
  final buffer = StringBuffer();
  skip:
  while ((p = p?.nextElementSibling) != null && p!.localName == 'p') {
    var txt = p.text;
    for (var re in _ignoresClassDoc) {
      if (re.hasMatch(txt)) continue skip;
    }
    buffer.writeln(md.convert(p.innerHtml, rules: _mdRules));
  }
  return _wrapByCount(buffer.toString(), true)!;
}

Map<String, List<String>> readApiDocument(Element? e, String nameRef) {
  if (e == null) return {};
  final result = <String, List<String>>{};
  while (true) {
    // check whether this match is unique to a single api
    var n = readAandBApiDocument(e, result);
    n ??= readPlainTextDocument(e, result);
    if (n == null || n.localName == 'hr') break;
    e = n;
  }
  // always add general reference doc
  final doc = 'For more information see '
      '[SQLite document](https://www.sqlite.org/capi3ref.html#$nameRef)';
  result['*'] = _wrapByCount(doc, true)!;
  return result;
}

final apiNamesReg = RegExp(r'(sqlite3_[a-z_0-9]+)\(\)');
final plainTextApiName = RegExp(r'The\s(sqlite3_[a-z_0-9]+)\([^\)]*\)([^\.]*)\.');

Element? readPlainTextDocument(Element? e, Map<String, List<String>> dartDoc) {
  var found = false;
  while (e != null && e.localName == 'p') {
    final txt = e.text.trim();
    final matches = plainTextApiName.allMatches(txt);
    if (matches.isNotEmpty) {
      found = true;
      if (dartDoc[matches.first.group(1)!] == null) {
        dartDoc[matches.first.group(1)!] = _wrapByCount(txt, true)!;
      }
    }
    e = e.nextElementSibling;
  }
  return found ? e : null;
}

List<String>? plainsApiNameSection(Element e, String txt) {
  var a = 0, b = 0, other = 0;
  final listApi = <String>[];
  for (final child in e.children) {
    if (child.localName == 'a' && child.attributes['name'] != null && child.text.isEmpty) {
      a++;
    } else if (child.localName == 'b') {
      final matches = apiNamesReg.allMatches(child.text.trim());
      for (final match in matches) {
        listApi.add(match.group(1)!);
      }
      b++;
    } else {
      other++;
    }
  }
  return (other > 0 || (b != 1 && a == 0)) ? null : (a > 0 ? listApi : <String>[]);
}

Element? readAandBApiDocument(Element? e, Map<String, List<String>> dartDoc) {
  // nothing to do when element is null
  if (e == null) return null;
  // check a and b style
  var found = false;
  var names = plainsApiNameSection(e, e.text.trim());
  while (names != null && names.isNotEmpty) {
    found = true;
    if (names.length == 1) {
      final name = names.first;
      final buffer = StringBuffer();
      while ((e = e!.nextElementSibling) != null) {
        names = plainsApiNameSection(e!, e.text.trim());
        if (names != null) break;
        buffer.writeln(md.convert(e.innerHtml, rules: _mdRules));
      }
      dartDoc[name] = _wrapByCount(buffer.toString(), true)!;
    } else if (names.length > 1) {
      while ((e = e!.nextElementSibling) != null) {
        final txt = e!.text.trim();
        names = plainsApiNameSection(e, txt);
        if (names != null) break;
        if (e.children.isEmpty) {
          var start = 0;
          final docByName = <String, String>{};
          for (var i = txt.indexOf('.') + 1; i > start; i = txt.indexOf('.', start) + 1) {
            final paragraph = txt.substring(start, i).trim();
            final matches = plainTextApiName.allMatches(paragraph);
            if (matches.isNotEmpty) {
              start = i;
              docByName[matches.first.group(1)!] = 'The ${matches.first.group(2)!}.';
            } else if (docByName.isNotEmpty) {
              for (final k in docByName.keys) {
                dartDoc[k] = _wrapByCount(docByName[k]! + txt.substring(start), true)!;
              }
              break;
            }
          }
        } else {
          // TODO: maybe something else change in SQLite doc at the future`.
          print('Warning: expect api element doc to have no change but it\'s not.');
        }
      }
    }
  }
  return found ? e : null;
}

List<String> readCommentDoc(
  Element? element, {
  Map<String, List<String>>? dartDoc,
  bool isDartDocument = false,
}) {
  final buffer = StringBuffer();
  for (element = element?.nextElementSibling;
      element != null && element.localName == 'p';
      element = element.nextElementSibling) {
    final conCap = constantSnakeUpperCase(element.text.trim());
    if (conCap != null) {
      dartDoc?[conCap] = _wrapByCount(md.convert(element.innerHtml, rules: _mdRules), true)!;
    } else {
      buffer.writeln(md.convert(element.innerHtml, rules: _mdRules));
    }
  }
  if (dartDoc != null && element != null) readDefinitionDocument(element, dartDoc);
  return _wrapByCount(buffer.toString(), isDartDocument)!;
}

void readDefinitionDocument(Element element, [Map<String, List<String>>? dartDoc]) {
  dartDoc ??= <String, List<String>>{};
  late final void Function(Element element) readDoc;
  late final List<Element> allDefinitions;
  if (element.localName == 'dl') {
    allDefinitions = element.querySelectorAll('dt');
    readDoc = (d) {
      final name = d.text;
      if (d.nextElementSibling != null && d.nextElementSibling!.localName == 'dd') {
        final dd = d.nextElementSibling!;
        dartDoc![name] = _wrapByCount(
          md.convert(dd.innerHtml, rules: _mdRules),
          true,
        )!;
      }
    };
  } else if (element.localName == 'ul') {
    allDefinitions = element.querySelectorAll('li');
    readDoc = (d) {
      final conCap = constantSnakeUpperCase(d.text.trim());
      if (conCap != null) {
        dartDoc![conCap] = _wrapByCount(md.convert(d.innerHtml, rules: _mdRules), true)!;
      }
    };
  } else {
    return;
  }
  if (allDefinitions.isEmpty) throw Exception('Definition is empty.');
  for (final d in allDefinitions) {
    readDoc(d);
  }
}

String? constantSnakeUpperCase(String txt) {
  if (!txt.startsWith('The ')) return null;
  final index = txt.indexOf(' ', 4);
  if (index <= 0) return null;
  txt = txt.substring(4, index);
  for (final unit in txt.codeUnits) {
    if (unit == 95 || (64 < unit && unit < 91) || (47 < unit && unit < 58)) continue;
    return null;
  }
  return txt;
}
