## 0.0.2
  * Fix close without await

## 0.0.1 (Initial Release Version)

- Introduce Driver APIs
  * Register a driver method `registerDriver`
  * Ability to check driver with `isDriverRegistered`
  * Open Database connection via `open`
  * Open Database connection with `protect` to ensure database connection close after work done.
  
- Introduce Database APIs
  * Create transaction with `protect`
  * Prepare Read/Write Statement `prepare`
  * Query execution via `exec` and `query`
  * Protect query execution via `protectQuery`
  * Protect transaction execution via `protectTransaction`
  * For database engine with **server**/**client**, developer can check the connection via `ping` it will reestablished if the connection lost.
  
- Introduce Statement APIs
  * Query execution via `exec` on **WriteStatement** and `query` on **ReadStatement**
  * Ability to reset the statement to for reusable and multiple execution via `reset`

- Introduce Transaction APIs
  * Commit the transaction via `apply`
  * Rollback the transaction via `cancel`
  * Prepare Read/Write Statement `prepare`
  * Query execution via `exec` and `query`
  * Protect query execution via `protectQuery`
 
- Introduce 2 type of reader api
  * `ValueReader` provide ability to read data from database object
    - `valueAt` read value from database object by **index**. The value type is determine by database value type and the type of variable reciever in dart.
    - `intValueAt` read integer value.
    - `stringValueAt` read string value.
    - `doubleValueAt` read double value.
    - `blobValueAt` read binary value.
  * `RowReader` provide the ability to read data from database result set of the query selection result. It provide the same method to `ValueReader` with additional APIs to read data via column name `valueBy`, `intValueBy`, `stringValueBy`, `doubleValueBy` and `blobValueBy`.

- Introduce `SQLValue` an abstract class that provide a method `value` which return the data type that represent the object and compatible with database engine data type.
- Introduce `Changes` a result from writing query.
- Introduce `Rows` a result from reading query implement dart `iterator`.
- Introduce `Row` default row data of the result set.
- Introduce `RowCreator` a function that create an custom object to represent a row of the reading result set.
- Introduce `AggregatorFunction` a class that store aggregate function metadata. Depend on database engine, some database will not support custome function at all.
- Introduce `DatabaseFunction` a class that store function metadata. Depend on database engine, some database will not support custome function at all.