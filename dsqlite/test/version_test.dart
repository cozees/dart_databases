// required running standalone due to static access to dynamic library or webassembly.
@Tags(['version-solo'])
library version_dependent;

import 'package:database_sql/database_sql.dart' as sqldb;
import 'package:dsqlite/dsqlite.dart' as dsqlite;
import 'package:dsqlite/sqlite.dart' as sqlite;
import 'package:logging/logging.dart';
import 'package:test/test.dart';

import 'common/common.dart';

void main() async {
  const driverName = 'sqlite_version';
  final dbFiles = <Future Function()>[];
  final ds = IncrementalDataSource.ds('version');

  tearDownAll(() async {
    for (var f in dbFiles) {
      await f();
    }
  });

  setUpAll(() async {
    sqldb.registerDriver(
      driverName,
      await dsqlite.Driver.initialize(
        path: dLibraries.last.libraryPath,
        webMountPath: dLibraries.last.mountPoint,
        logLevel: Level.ALL,
      ),
    );
  });

  test('Test throw for lower version', () async {
    await sqldb.protect(driverName, ds.next(dbFiles), block: (db) async {
      final _ = db as dsqlite.Database;
      db.withNative((ndb) async {
        final tail = sqlite.malloc<sqlite.Pointer<sqlite.Utf8>>();
        final ppStmt = sqlite.malloc<sqlite.PtrStmt>();
        expect(
          () => dsqlite.Driver.binder
              .prepare_v3(ndb, 'CREATE TABLE `simple`(name TEXT);', 0, ppStmt, tail),
          throwsA(TypeMatcher<Exception>().having(
            (e) => e.toString(),
            'message',
            'DatabaseException: API sqlite3_prepare_v3 is not available before 3.20.0',
          )),
        );
      });
    });
  });
}
