part of 'generate.dart';

final ignoresConstant = [
  'SQLITE_VERSION',
  'SQLITE_VERSION_NUMBER',
  'SQLITE_SOURCE_ID',
  'SQLITE_STATIC',
  'SQLITE_TRANSIENT',
  'SQLITE_TRACE'
];

final constantSections = [
  'SQLITE_ABORT',
  'SQLITE_ABORT_ROLLBACK',
  'SQLITE_ACCESS_EXISTS',
  'SQLITE_ALTER_TABLE',
  'SQLITE_ANY',
  'SQLITE_BLOB',
  'SQLITE_CHECKPOINT_FULL',
  'SQLITE_CONFIG_COVERING_INDEX_SCAN',
  'SQLITE_DBCONFIG_DEFENSIVE',
  'SQLITE_DENY',
  'SQLITE_DESERIALIZE_FREEONCLOSE',
  'SQLITE_DETERMINISTIC',
  'SQLITE_FAIL',
  'SQLITE_FCNTL_BEGIN_ATOMIC_WRITE',
  'SQLITE_INDEX_CONSTRAINT_EQ',
  'SQLITE_IOCAP_ATOMIC',
  'SQLITE_LOCK_EXCLUSIVE',
  'SQLITE_SHM_NLOCK',
  'SQLITE_SERIALIZE_NOCOPY',
  'SQLITE_INDEX_SCAN_UNIQUE',
  'SQLITE_MUTEX_FAST',
  'SQLITE_OPEN_AUTOPROXY',
  'SQLITE_PREPARE_NORMALIZE',
  'SQLITE_SCANSTAT_EST',
  'SQLITE_SHM_EXCLUSIVE',
  'SQLITE_STATUS_MALLOC_COUNT',
  'SQLITE_SYNC_DATAONLY',
  'SQLITE_TESTCTRL_ALWAYS',
  'SQLITE_TRACE',
  'SQLITE_TXN_NONE',
  'SQLITE_VTAB_CONSTRAINT_SUPPORT',
  'SQLITE_WIN32_DATA_DIRECTORY_TYPE',
  'SQLITE_LIMIT_ATTACHED',
  'SQLITE_DBSTATUS options',
  'SQLITE_STMTSTATUS counter',
];

const resultCodeDefinition = 'https://www.sqlite.org/rescode.html';

Future<void> _loadConstant(
  StringBuffer buffer,
  Document document,
  Element element,
  List<String> constants,
  Map<String, List<String>> dartDoc,
) async {
  print('(C): Start parsing Constant ...');
  final allConstant = element.querySelectorAll('a');
  final refs = <String, List<String>>{};
  // Constant by group
  for (final c in allConstant) {
    var id = c.attributes['href'];
    if (id == null) throw Exception('SQLite constant element format failed, expected link.');
    final txt = c.text;
    if (ignoresConstant.contains(txt)) continue;
    constants.add(txt);
    id = id.substring(1);
    if (txt.replaceAll('_', '').toLowerCase() == id) {
      if (txt.startsWith('SQLITE_CONFIG')) id = 'SQLITE_CONFIG_COVERING_INDEX_SCAN';
      if (txt.startsWith('SQLITE_DBCONFIG')) id = 'SQLITE_DBCONFIG_DEFENSIVE';
      if (txt.startsWith('SQLITE_FCNTL')) id = 'SQLITE_FCNTL_BEGIN_ATOMIC_WRITE';
      if (txt.startsWith('SQLITE_SCANSTAT')) id = 'SQLITE_SCANSTAT_EST';
    }
    refs[id] ??= [];
    refs[id]!.add(txt);
  }
  // Special case when linking application with both SQLite 2 and 3. This might only problem with
  // C application, as for Dart this might not be any problem. Also this lib is purposely use for
  // SQLite 3 only.
  // See: https://www.sqlite.org/capi3ref.html#SQLITE_BLOB
  refs['SQLITE_BLOB']!.add('SQLITE3_TEXT');
  constants.add('SQLITE3_TEXT');
  // merge code
  Map<String, List<String>>? specialDefinition;
  for (final key in constantSections) {
    final a = document.querySelector('a[name="$key"]');
    final h = a?.nextElementSibling;
    if (h == null) continue;
    final bq = h.nextElementSibling;
    if (bq == null) continue;
    // read text comment
    // special case for document
    if (key == 'SQLITE_ABORT' || key == 'SQLITE_ABORT_ROLLBACK') {
      if (specialDefinition == null) {
        final response = await http.get(Uri.parse(resultCodeDefinition));
        if (response.statusCode != 200) {
          throw Exception('Loading Result code $resultCodeDefinition failed');
        }
        final document = html.parse(response.body);
        specialDefinition = _readResultCodeMeaning(document);
        dartDoc.addAll(specialDefinition);
      }
    }
    final doc = readCommentDoc(bq, dartDoc: dartDoc);
    if (refs[key] != null && refs[key]!.isNotEmpty) {
      final ct = refs[key]!;
      if (ct.length == 1) {
        // single definition
        dartDoc[ct.first] = doc;
      } else {
        // multiple definition in a single txt describe reference link instead
        for (var apiName in ct) {
          dartDoc[apiName] = [
            'See [SQLite Documentation]($sQLiteFullDoc#$key) for meaning and the use of it.'
          ];
        }
      }
    }
    final name = h.text;
    print('(C):   Start parsing constant section $name ...');
    buffer.writeln(bq.text);
  }
}
