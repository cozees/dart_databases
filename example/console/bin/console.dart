import 'dart:io';

import 'package:database_sql/database_sql.dart' as sqldb;
import 'package:dsqlite/dsqlite.dart' as dsqlite;

void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('Provide path to sqlite3 dynamic library.');
    exit(1);
  }
  sqldb.registerDriver('sqlite3', await dsqlite.Driver.initialize(path: arguments.first));
  sqldb.protect('sqlite3', dsqlite.DataSource('test.db'), block: (db) async {
    await db.exec('CREATE TABLE test (text TEXT);');
    await db.exec('INSERT INTO test VALUES(?),(?),(?);', parameters: ['jomo', 'kimilo', 'yiho']);
    await db.protectQuery<sqldb.Row>('SELECT * FROM test;', block: (rows) async {
      while (rows.moveNext()) {
        print('text: ${rows.current.stringValueBy('text')}');
      }
    });
  });
}
