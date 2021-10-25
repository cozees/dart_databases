part of 'database.dart';

/// Database driver, each database is required to implement this interface in order to user
/// database interface api.
abstract class Driver<D> {
  /// Open returns a new [Database] object represent connection to the database.
  ///
  /// The [dataSource] is an optional data that provide specific driver to interpret it into
  /// their own additional data that required when open a database connection.
  Database open(D dataSource);
}

// driver storage
final _drivers = <String, Driver>{};

/// register a new database driver.
///
/// If the database driver with same name has been registered then an exception is throw.
void registerDriver(String driverName, Driver driver) {
  if (_drivers.containsKey(driverName)) {
    throw DatabaseException('Driver $driverName has been registered.');
  }
  _drivers[driverName] = driver;
}

/// Return true if driver has been registered otherwise false.
bool isDriverRegistered(String driverName) => _drivers.containsKey(driverName);

// ensure that the driver is existed
Driver _ensureDriverAvailability(String driverName) {
  if (!_drivers.containsKey(driverName)) {
    throw DatabaseException('Driver $driverName is not exist.');
  }
  return _drivers[driverName]!;
}

/// Open a connection to database without pool connection management.
///
/// The database connection in this form is not store or manage its lifetime by pool connection
/// management. Therefore its end user's responsibility to manage the connection.
Database open(String driverName, Object dataSource) =>
    _ensureDriverAvailability(driverName).open(dataSource);

/// Open a connection to the database and automatically close it when the [block] callback execution done.
Future<void> protect(String driverName, Object dataSource,
    {required Future<void> Function(Database) block}) async {
  final db = open(driverName, dataSource);
  try {
    await block(db);
  } finally {
    await db.close();
  }
}
