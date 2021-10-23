part of 'database.dart';

/// SQLite database driver.
class Driver implements sql.Driver<DataSource> {
  // singleton instance
  static Driver? _instance;

  // sqlite binder, it initial when first call initialize
  static sqlite.SQLiteLibrary? _binder;

  /// A logger
  static late final Logger? logger;

  /// SQLite C APi binder.
  ///
  /// The value should be access after initialize has been call.
  static sqlite.SQLiteLibrary get binder {
    if (_binder != null) return _binder!;
    throw sql.DatabaseException('Access binder before calling initialize.');
  }

  /// Initialize SQLite driver.
  ///
  /// if provide [connectHook], the hook will be call upon successfully open sqlite database.
  static Future<Driver> initialize({
    String? path,
    Level logLevel = Level.OFF,
    void Function(Driver driver, Database db, DataSource ds)? connectHook,
  }) async {
    if (_instance == null) {
      _binder = await sqlite.SQLiteLibrary.instance(path);
      _instance = Driver._(connectHook);
      Logger.root.level = logLevel;
      logger = logLevel == Level.OFF ? null : Logger('SQLiteDriver');
    }
    return _instance!;
  }

  // ensure singleton
  Driver._(this._connectHook);

  // a connect hook which can be use to register function ...etc
  final void Function(Driver driver, Database db, DataSource ds)? _connectHook;

  @override
  sql.Database open(DataSource ds) {
    final outDb = sqlite.malloc<sqlite.PtrSqlite3>();
    final result = Driver.binder.open_compat(ds.name, outDb, ds.flags, ds.moduleName);
    final dbPtr = outDb.value;
    sqlite.free(outDb);
    if (result != sqlite.OK) {
      try {
        throw SQLiteException(cdb: dbPtr, returnCode: result);
      } finally {
        Driver.binder.close_v2(dbPtr);
      }
    }
    Driver.binder.extended_result_codes(dbPtr, 1);

    // invoke code that initial setup on database connection
    final database = Database._(dbPtr);
    if (_connectHook != null) _connectHook!(this, database, ds);
    return database;
  }
}

/// The database source represent the configuration when open database connection
class DataSource {
  /// Create database object.
  ///
  /// The flag is value final value of bit operator of the value from [sqlite.OPEN_READWRITE],
  /// [sqlite.OPEN_READONLY], [sqlite.OPEN_MEMORY]. By default, the flag value is set to
  /// [sqlite.OPEN_READWRITE].
  const DataSource(
    this.name, {
    this.flags = sqlite.OPEN_READWRITE | sqlite.OPEN_CREATE,
    this.moduleName,
  });

  /// database name
  final String name;

  /// open connection flag
  final int flags;

  /// The name of VFT module to be used.
  final String? moduleName;

  @override // coverage:ignore-line
  String toString() => '$name, $flags, $moduleName'; // coverage:ignore-line
}
