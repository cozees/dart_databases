@JS()
library testjs;

import 'package:dsqlite/dsqlite.dart';
import 'package:dsqlite/sqlite.dart' as sqlite;
import 'package:js/js.dart';

import 'common.dart';

// path to compiled sqlite webassembly form emscripten
// This is just dummy as dart not release provide a way to load javascript from test
// The only have custom javascript is provide custom template
PlatformLibrary platformLibraries(String version) => _DWebLibrary(version);

class _DWebLibrary implements PlatformLibrary {
  static const host = 'https://localhost/';

  const _DWebLibrary(this.version);

  final String version;

  @override
  String get libraryPath => '$host$version/sqlite.wasm';
}

IncrementalDataSource createDataSource(String test) {
  return _WebIncrementalDataSource(test);
}

@JS('FS.unlink')
external void unlink(String path);

class _WebIncrementalDataSource extends IncrementalDataSource {
  _WebIncrementalDataSource(String test) : super('.', test);

  @override
  DataSource next(List<Future Function()> registered,
      {int flags = sqlite.OPEN_CREATE | sqlite.OPEN_READWRITE, String? modName}) {
    final filepath = [root, '$test${IncrementalDataSource.name}${++count}.db'].join('/');
    registered.add(() async => () => allowInterop(() => unlink(filepath)));
    return DataSource(filepath, flags: flags, moduleName: modName);
  }
}
