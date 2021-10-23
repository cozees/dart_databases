## 0.0.1 (Initial Release Version)

- Implement Driver for [database_sql](https://pub.dev/packages/database_sql) package.

- Introduce compatible APIs for both Web and Dart VM
  * On any Native VM, the driver use dynamic library via dart:ffi 
  * On Web platform the driver use the compiled WebAssembly from emscripten.
  * All api is compatible with any version SQLite version.

- Introduce a complete generated binding to interacted with dynamic library via dart:ffi package.  
