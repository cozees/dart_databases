part of 'generate.dart';

const ignoresObject = [
  'sqlite3_int64',
  'sqlite3_str',
  // remove sqlite3_data_directory and sqlite3_temp_directory, add them to api instead.
  'sqlite3_data_directory',
  'sqlite3_temp_directory',
];

const additionalObject = <Map<String, String>>[
  {'sqlite3_snapshot': 'sqlite3_snapshot'},
];

Future<void> _loadObjects(
    StringBuffer buffer,
  Document document,
  Element element,
  List<String> objects,
  Map<String, List<String>> dartDoc,
) async {
  print('(O): Start parsing Type Object ...');
  final allObject = element.querySelectorAll('a');
  // Constant by group
  final ids = <String, String>{};
  for (final o in allObject) {
    final id = o.attributes['href'];
    if (id == null) throw Exception('SQLite constant element format failed, expected link.');
    final nameRef = id.substring(1);
    if (ignoresObject.contains(nameRef)) continue;
    final objName = o.text;
    objects.add(objName);
    ids[nameRef] = objName;
  }
  // add additional object type which is not list in object list
  for (final ao in additionalObject) {
    ids.addAll(ao);
    objects.addAll(ao.keys);
  }
  // parse each object doc
  for (final refIdName in ids.keys) {
    final infoName = ids[refIdName]!;
    final a = document.querySelector('a[name="$refIdName"]');
    if (a == null) throw Exception('Document of $refIdName not existed.');
    final h = a.nextElementSibling;
    if (h == null || h.localName != 'h2') {
      throw Exception('Doc header not found or not wrong format ($refIdName).');
    }
    final bq = h.nextElementSibling;
    if (bq == null || bq.localName != 'blockquote') {
      throw Exception('Doc blockquote not found or not wrong format ($refIdName).');
    }
    print('(O):   Parsing document and code for $infoName ...');
    buffer.writeln('::: $refIdName :::\n');
    buffer.writeln(bq.text);
    final doc = _readAsDartClassComment(bq);
    dartDoc[refIdName] = doc;
  }
}
