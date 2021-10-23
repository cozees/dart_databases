part of 'apis.g.dart';

///
///
extension CompatApi on SQLiteLibrary {
  ///
  cpf.SQLiteLibrary get nativeLibrary => _sqlite;

  ///
  int open_compat(String filename, cpf.PtrPtrSqlite3 ppDb, int flags, String? zVfs) =>
      libVersionNumber < 3005000 ? open(filename, ppDb) : open_v2(filename, ppDb, flags, zVfs);

  /* 3.7.14 :: 2012-09-03 */

  ///
  int close_compat(cpf.PtrSqlite3 db) => libVersionNumber < 3007014 ? close(db) : close_v2(db);

  ///
  int prepare_compat(
    cpf.PtrSqlite3 db,
    String zSql,
    int prepFlags,
    cpf.PtrPtrStmt ppStmt,
    cpf.PtrPtrUtf8 pzTail,
  ) {
    if (libVersionNumber >= 3020000) return prepare_v3(db, zSql, prepFlags, ppStmt, pzTail);
    if (libVersionNumber >= 3003009) return prepare_v2(db, zSql, ppStmt, pzTail);
    return prepare(db, zSql, ppStmt, pzTail);
  }

  ///
  int create_function_compat(
      cpf.PtrSqlite3 db,
      String name,
      int nArg,
      int eTextRep,
      cpf.PtrVoid pApp,
      cpf.PtrDefpxFunc xFunc,
      cpf.PtrDefpxFunc xStep,
      cpf.PtrDefxFinal xFinal,
      cpf.PtrDefxFree xDestroy) {
    if (libVersionNumber >= 3007003) {
      return create_function_v2(db, name, nArg, eTextRep, pApp, xFunc, xStep, xFinal, xDestroy);
    }
    return create_function(db, name, nArg, eTextRep, pApp, xFunc, xStep, xFinal);
  }
}
