import 'dart:math';

import 'package:database_sql/database_sql.dart' as sqldb;
import 'package:dsqlite/dsqlite.dart' as dsqlite;
import 'package:dsqlite/sqlite.dart' as sqlite;

/// Strongly recommended to use Custom object to hold data from sqlite3 when the data is frequently
/// access, for example the data use in scroll view ..etc.
class CustomRowObject {
  /// create a object which is ready to store into database.
  CustomRowObject(this.text);

  CustomRowObject.db(sqldb.RowReader reader)
      : id = reader.intValueBy('id')!,
        text = reader.stringValueBy('text')!;

  /// null if record is not in database yet otherwise id is always available
  int? id;

  /// text column
  final String text;

  /// creator to give to query api
  static CustomRowObject creator(sqldb.RowReader reader) => CustomRowObject.db(reader);

  @override
  String toString() => 'ID: $id, text: $text';
}

void main() async {
  sqldb.registerDriver(
    'sqlite3',
    //
    await dsqlite.Driver.initialize(
      path: '/* path so sqlite library */',
      connectHook: (driver, db, ds) {
        // SELECT pow(2,3);
        // SELECT pow(2,bit) FROM aTable;
        db.registerFunction(
          'pow',
          sqldb.DatabaseFunction<sqlite.PtrContext, int>(
            argumentsNumber: 2,
            argConverter: (i, reader) => reader.intValueAt(i),
            resultHandler: dsqlite.applyIntResult,
            func: (int x, int y) => pow(x, y),
          ),
        );
        // callback invoke when commit or rollback from transaction or save point
        db.registerCommitHook(() => sqlite.OK);
        db.registerRollbackHook(() => print('Rollback occurred.'));
      },
    ),
  );

  // open database connection
  final db = sqldb.open('sqlite3', dsqlite.DataSource('test.db'));
  await db.exec('CREATE TABLE sample(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT);');
  final changes = await db.exec('INSERT INTO sample(text) VALUES(?),(@text);', parameters: [
    'dsqlite a sqlite3 driver for package database_sql',
    dsqlite.NameParameter<String>(
      'text',
      'We can use plain data or named parameter to bind parameter',
    ),
  ]);
  // print 'LAST ID: 1, affected: 1'
  print('LAST ID: ${changes.lastInsertId}, affected: ${changes.rowsAffected}');
  final rows = await db.query<sqldb.Row>('SELECT * FROM sample;');
  while (rows.moveNext()) {
    print('ID: ${rows.current.intValueBy('id')}, text: ${rows.current.stringValueBy('text')}');
  }
  // must close manually as currently garbage collection can only be done via C APIs
  rows.close();
  db.close();

  // use protected api
  await sqldb.protect('sqlite3', dsqlite.DataSource('test.db'), block: (db) async {
    await db.exec('INSERT INTO sample(text) VALUES(\$text),(?);', parameters: [
      dsqlite.IndexParameter<String>(2, 'Bind by index explicitly.'),
      dsqlite.NameParameter<String>('text', 'Bind by name.'),
    ]);
    await db.protectQuery<CustomRowObject>(
      'SELECT * FROM sample',
      creator: CustomRowObject.creator,
      block: (rows) async {
        while (rows.moveNext()) {
          print(rows.current);
        }
      },
    );
  });

  // create transaction
  await sqldb.protect('sqlite3', dsqlite.DataSource('test.db'), block: (db) async {
    final tx = await db.begin();
    try {
      await tx.exec('CREATE TABLE abc(id INTEGER);');
      tx.apply();
    } finally {
      tx.cancel();
    }
    // transaction is auto commit when block done execution or rollback if exception is throw within block
    // By default, `SQLiteTransactionControl` is omitted and it is up to sqlite3 to pick the default one
    await db.protectTransaction(block: (db, tx) => db.exec('CREATE TABLE sample1(text TEXT);'));
    // create transaction with custom control
    await db.protectTransaction(
      // see https://www.sqlite.org/lang_transaction.html
      creator: dsqlite.transactionCreator(dsqlite.SQLiteTransactionControl.exclusive),
      block: (db, tx) => db.exec('INSERT INTO abc VALUES(123);'),
    );
    // create a save pointer transaction.
    // Similar to transaction savepoint can use with protect api or a verbose code like above.
    final sp = await db.begin(creator: dsqlite.savePointCreator('my_savepoint'));
    try {
      await sp.exec('INSERT INTO abc VALUES(546);');
      sp.apply();
    } finally {
      sp.cancel();
    }
    // using protected api
    await db.protectTransaction<dsqlite.SavePoint>(
      creator: dsqlite.savePointCreator('savepoint1'),
      block: (db, sp) => sp.exec('INSERT INTO abc VALUES(867);'),
    );
  });
}
