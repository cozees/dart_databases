// coverage:ignore-file
part of 'database.dart';

/// A class describe table information
class TableInfo {
  static Future<TableInfo?> show(sql.Database db, String name) async {
    // purposely crash the execution if given database connection is not SQLite database connection.
    final _ = db as Database;
    final tbInfo = TableInfo._(name);
    final rows = await db.query<sql.Row>('PRAGMA table_info(`$name`);');
    final autoincrement = sqlite.malloc<sqlite.Int32>();
    // TODO: resolve issue with table name and autoincrement being copy in the loop
    while (rows.moveNext()) {
      final row = rows.current;
      final columnName = row.stringValueAt(1)!;
      final collation = sqlite.malloc<sqlite.Pointer<sqlite.Utf8>>();
      await db.withNative((ndb) async {
        Driver.binder.table_column_metadata(
          ndb,
          null,
          // database name
          name,
          columnName,
          sqlite.nullptr,
          collation,
          sqlite.nullptr,
          // not null
          sqlite.nullptr,
          // primary key
          autoincrement,
        );
      });
      tbInfo.columns.add(ColumnInfo(
        columnName,
        row.stringValueAt(2)!,
        collation.value.toDartString(),
        row.intValueAt(3) != 1,
        row.stringValueAt(4),
        row.intValueBy('pk') == 1,
        autoincrement.value == 1,
      ));
      sqlite.free(collation);
    }
    rows.close();
    sqlite.free(autoincrement);
    return tbInfo.columns.isNotEmpty ? tbInfo : null;
  }

  TableInfo._(this.name) : columns = [];

  final String name;
  final List<ColumnInfo> columns;
}

/// A class represent column information
class ColumnInfo {
  ColumnInfo(
    this.name,
    this.dataType,
    this.collation,
    this.nullable,
    this.defaultValue,
    this.primaryKey,
    this.autoincrement,
  );

  final String name;
  final String dataType;
  final String collation;
  final bool nullable;
  final String? defaultValue;
  final bool primaryKey;
  final bool autoincrement;

  @override
  int get hashCode => '$name:$dataType:$nullable:$defaultValue:$primaryKey'.hashCode;

  @override
  bool operator ==(covariant ColumnInfo other) {
    return name == other.name &&
        dataType == other.dataType &&
        collation == other.collation &&
        nullable == other.nullable &&
        defaultValue == other.defaultValue &&
        primaryKey == other.primaryKey &&
        autoincrement == other.autoincrement;
  }

  @override
  String toString() =>
      '$name, $dataType, $collation, $nullable, $defaultValue, $primaryKey, $autoincrement';
}
