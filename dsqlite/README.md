# Introduction

Package dsqlite provides an implementation driver of package [database_sql](https://pub.dev/packages/database_sql).
The sql package must be used in conjunction with [database_sql](https://pub.dev/packages/database_sql) package.

The package provide a complete implementation of [database_sql](https://pub.dev/packages/database_sql) package.
It's using WebAssembly api compiled from sqlite3 source code by [emscripten](https://emscripten.org/) when running
on web browser. All latest of the major browser such as Chrome, FireFox, Safari is supported.

> Important: The web version in this package is using webassembly running output from [emscripten](https://emscripten.org/).
> Although it work, the performance compare to native IndexedDB Javascript is very slow, plus all sqlite data
> is loaded all into memory which cause a huge amount of memory being consume by the application. In addition, [emscripten](https://emscripten.org/)
> does not provide official document to implement File System APIs with browser Native [File System APIs](https://developer.mozilla.org/en-US/docs/Web/API/FileSystem)
> which could reduce a significant amount of memory need for virtual file system.
> [Emscripten](https://emscripten.org/) issue tracking for the request and better apis for implement custom File System APIs:
> * [Web File System Access API ](https://github.com/emscripten-core/emscripten/issues/15277)
> * [New File System Implementation](https://github.com/emscripten-core/emscripten/issues/15041)
>
> **What's next ?**
> - Explore possibility to implement [VFS](https://sqlite.org/vfs.html) with or without [15041](https://github.com/emscripten-core/emscripten/issues/15041)
> - Explore possibility to implement module or [virtual table](https://sqlite.org/vtab.html) to redirect data to IndexedDB. The downside is that not all
>   sqlite feature is supported when running with virtual table.
> - Move sqlite functionality into web worker or service worker instead of main thread.

# Usage
Add [database_sql](https://pub.dev/packages/database_sql) and [dsqlite](https://pub.dev/packages/dsqlite) to `pubspec.yaml`
```yaml
dependencies:
  database_sql: 0.0.1
  dsqlite: 0.0.1
```

```dart
import 'package:database_sql/database_sql.dart' as sqldb;
import 'package:dsqlite/dsqlite.dart' as dsqlite;

void main() async {
// register driver (Should register against in different isolate process)
sqldb.registerDriver(
  'sqlite3',
  await dsqlite.Driver.initialize(
    // on iOS it's not required to provide path.
    // on Web it's the same as iOS, web required index.html to load javascript file and webassembly
    path: '/* path to dynamic library */',
    // connectHook is optional however it's useful when required to have registration for hook event
    // or create a custom function.
    connectHook: (driver, db, ds) {
      /* your initialization code such as register function, hook event */
    },
  ),
);
// Ensure database connection is close properly even in an event of exception occurred. 
await sqldb.protect('sqlite3', dsqlite.DataSource('test.db'), block: (db) async {
  await db.exec('CREATE TABLE sample(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT);');
  final changes = await db.exec("INSERT INTO sample(text) VALUES('sqlite3-driver')");
  // should print 'Last ID: 1, affected: 1'
  print('Last ID: ${changes.lastInsertId}, affected: ${changes.rowsAffected}');
  // Ensure result of query is close properly even in an event of exception occurred.
  await db.protectQuery<sqldb.Row>('SELECT * FROM sample;', block: (rows) async {
    while(rows.moveNext()) {
      // should print 'ID: 1, text: sqlite3-driver'
      print('ID: ${rows.current.intValueBy('id')}, text: ${rows.current.stringValueBy('text')}');
    }
  });
});
}
```

Compile WebAssembly from sqlite3 source code using [emscripten](https://emscripten.org/). Before you
can compile a webassembly, you must have [emscripten](https://emscripten.org/) install and available
in your PATH environment variable visit [Getting Started](https://emscripten.org/docs/getting_started/downloads.html)
for instruction how to install [emscripten](https://emscripten.org/).

After you have [emscripten](https://emscripten.org/) installed, run below command to generate WebAssembly file.
By default, it's using pre-define build configuration within package this package. The default setting
generate multiple output with format [ASM](http://asmjs.org/) and [WASM](https://webassembly.org/) in
conjunction with a non support and a support to javascript `bigint`. 

```shell script
dart run dsqlite -b -d --release 2021:3.36.00 -o /* directory to store the generate file */
```

To disable multiple build or include your own desire optimization then you can provide custom build
configuration. Create configuration file name `sqlite_webassembly_build.yaml` in your root repository.

```yaml
# this is the minimum runtime export api use by dsqlite when running in web browser
# If your application is not using UTF-16 then you can omit `UTF16ToString`, `stringToUTF16` and 
# `lengthBytesUTF16` apis. Same binary or blob which you can omit `writeArrayToMemory`.
# If your application does not required sqlite3 api such as create function or callback then you 
# omit `addFunction` and `removeFunction` as well. It can optimize the generated javascript size to 
# a bit smaller.
runtime:
  - 'cwrap'
  - 'setValue'
  - 'getValue'
  - 'UTF8ToString'
  - 'stringToUTF8'
  - 'UTF16ToString'
  - 'stringToUTF16'
  - 'writeArrayToMemory'
  - 'lengthBytesUTF8'
  - 'lengthBytesUTF16'
  - 'addFunction'
  - 'removeFunction'
# by default, all function describe by key `apis` in file `sqlite_api_meta.yaml` is used for exposing
# webassembly api to javascript. However if you know that you don't use certain api then you can list
# only the desired api here.

exported:
#  - 'sqlite3_changes'
#  - 'sqlite3_last_insert_rowid'
#  - 'sqlite3_extended_result_codes'

emitBitInt: true # true to emit both none support to bigint and a support to bigint

# If not provided, it utilize cflag from configuration file in this package.
# cflag:
#   - '-O2'
#   - '-DSQLITE_THREADSAFE=0' # javascript is a single thread anyway

# If not provided, it utilize emflag from configuration file in this package.
# emflag:

# If not provided, it utilize `release` from configuration file in this package.
# This is emcc flag for release build
# release:

# If not provided, it utilize `debug` from configuration file in this package.
# This is emcc flag for debug build
# debug:

# provide wasm key to indacate that the generated out is in webassembly wasm format
# must provide emcc flag
# wasm:
#   - '-s ALLOW_MEMORY_GROWTH=1'

# provide asm key to indacate that the generated out is in asmjs format
# must provide emcc flag
# asm:
#   - '-s ALLOW_MEMORY_GROWTH=1'
```  

# Testing

Before running test, it required to download sqlite source code and build locally therefore you must
has [emscripten](https://emscripten.org/) installed and necessary tools to build sqlite from source code.

The test code expect a dynamic library location at:
```shell script
# Window platform
sqlite/latest/sqlite3.dll
# linux, this library is auto generate by sqlite3 source code make file.
sqlite/latest/.libs/libsqlite3.so
# macos, this library is auto generate by sqlite3 source code make file.
sqlite/latest/.libs/libsqlite3.dylib
```

For Windows user, it's required to build sqlite3 library `sqlite3.dll` manually follow the documentation
description [here](https://www.sqlite.org/howtocompile.html#building_a_windows_dll) at sqlite website.

For user running platform otherwise Windows, use make to build and run the test. Windows user may use
`powershell` or other other command line application to run makefile.
```shell script
make requisition
# test both browser (debug webassembly only) and vm
make dsqlite_test_local
# full test for both browser (debug and release) and vm
make dsqlite_test
```
