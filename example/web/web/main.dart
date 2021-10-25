import 'dart:html';

import 'package:database_sql/database_sql.dart' as sqldb;
import 'package:dsqlite/dsqlite.dart' as dsqlite;
import 'package:dsqlite/sqlite.dart' as sqlite;

class Sample {
  Sample(this.name, [this.age]);

  Sample.db(sqldb.RowReader reader) : name = reader.stringValueBy('name')! {
    id = reader.intValueBy('id');
    age = reader.intValueBy('age');
    createdAt = reader.valueBy('created_at');
    updatedAt = reader.valueBy('updated_at');
  }

  static Sample creator(sqldb.RowReader reader) => Sample.db(reader);

  int? id;
  String name;
  int? age;
  DateTime? createdAt;
  DateTime? updatedAt;

  @override
  String toString() =>
      'id: $id, name: $name, age: $age, create at: $createdAt, update at: $updatedAt';
}

Future<void> execute(Element output, Future Function() callback) async {
  try {
    await callback();
  } catch (e, s) {
    output.text = e.toString() + '\n' + s.toString();
  }
}

Future<void> readResult(Element output, dsqlite.Database db, sqldb.Statement stmt) async {
  try {
    final binder = dsqlite.Driver.binder;
    final dstmt = stmt as dsqlite.Statement;
    int resultCode = 0;
    final buffer = StringBuffer();
    final mi = dstmt.columnsIndexes;
    while (true) {
      resultCode = binder.step(dstmt.native);
      if (resultCode != sqlite.ROW && resultCode != sqlite.OK) {
        break;
      }
      if (binder.data_count(dstmt.native) > 0) {
        for (var name in mi.keys) {
          buffer.write(name);
          buffer.write(': ');
          buffer.write(binder.column_text(dstmt.native, mi[name]!));
          buffer.write(', ');
        }
        buffer.writeln();
      }
    }
    if (resultCode != sqlite.OK && resultCode != sqlite.DONE) {
      throw dsqlite.SQLiteException(cdb: db.native, returnCode: resultCode);
    }
    if (buffer.isNotEmpty) {
      output.text = buffer.toString();
    } else {
      final affected = binder.changes(db.native);
      final lastId = binder.last_insert_rowid(db.native);
      output.text = 'change affected: $affected\nlast id: $lastId';
    }
  } catch (e, s) {
    output.text = e.toString() + '\n' + s.toString();
  } finally {
    stmt.close();
  }
}

void main() async {
  var historyIndex = 0;
  final histories = <String>[];

  sqldb.registerDriver('sqlite3', await dsqlite.Driver.initialize(webMountPath: '/data'));
  dsqlite.Database? db =
      sqldb.open('sqlite3', dsqlite.DataSource('/data/test.db')) as dsqlite.Database;
  window.onBeforeUnload.listen((event) {
    if (db?.isClosed == false) (event as BeforeUnloadEvent).returnValue = 'ops';
  });

  final query = querySelector('#query') as TextAreaElement;
  final closeBtn = querySelector('#closedb') as ButtonElement;
  final reopenBtn = querySelector('#reopen') as ButtonElement;

  closeBtn.onClick.listen((event) async {
    query.disabled = true;
    closeBtn
      ..disabled = true
      ..hidden = true;
    reopenBtn
      ..disabled = false
      ..hidden = false;
    print('closing database connection.');
    await db?.close();
    db = null;
  });

  reopenBtn.onClick.listen((event) async {
    query.disabled = false;
    reopenBtn
      ..disabled = true
      ..hidden = true;
    closeBtn
      ..disabled = false
      ..hidden = false;
    db = sqldb.open('sqlite3', dsqlite.DataSource('/data/test.db')) as dsqlite.Database;
  });

  final output = querySelector('#output');
  query.onKeyDown.listen((event) {
    if (event.keyCode == KeyCode.TAB || event.which == KeyCode.TAB) {
      event.preventDefault();
      final val = query.value ?? '';
      final start = query.selectionStart ?? 0;
      final end = query.selectionEnd ?? 0;
      query.value = val.substring(0, start) + "  " + val.substring(end);
      query.selectionStart = query.selectionEnd = start + 1;
    }
  });

  query.onKeyUp.listen((event) async {
    if (event.altKey) {
      if (event.keyCode == KeyCode.ENTER) {
        final sql = query.value;
        query.value = '';
        print('Execute: $sql');
        await execute(output!, () async => await readResult(output, db!, await db!.prepare(sql!)));
        histories.add(sql!);
      } else if (event.keyCode == KeyCode.UP && histories.isNotEmpty) {
        historyIndex = historyIndex > 0 ? historyIndex - 1 : histories.length - 1;
        query.value = histories[historyIndex];
      } else if (event.keyCode == KeyCode.DOWN && histories.isNotEmpty) {
        final lastIndex = histories.length - 1;
        historyIndex = historyIndex < lastIndex ? historyIndex + 1 : 0;
        query.value = histories[historyIndex];
      }
    } else {
      historyIndex = -1;
    }
  });
}
