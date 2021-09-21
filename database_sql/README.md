# Introduction

Package database_sql provides a generic interface around SQL-like databases. The sql package must be used in conjunction with
a database driver.

The package provide common generic APIs to access the database such as `exec`, `query`, `begin` ..etc.

# Usage
Add [database_sql](https://pub.dev/packages/database_sql) and implemented driver to your `pubspec.yaml`
```yaml
dependencies:
  database_sql: 0.0.1
  # driver_package: m.n.p
```

```dart
import 'package:database_sql/database_sql.dart' as sqldb;

...
// register driver (Should register against in different isolate process)
sqldb.registerDriver(
  'my-database',
  // Driver initialization`
  ),
);

...

await sqldb.protect('my-database', /* Driver DataSource */, block: (db) async {
    /* Your code to access database here */
});
```