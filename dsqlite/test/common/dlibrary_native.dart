import 'dart:io';

import 'package:dsqlite/sqlite.dart';
import 'package:dsqlite/src/database.dart';

import 'common.dart';

/// path to compiled sqlite dynamic library
PlatformLibrary platformLibraries(String version) => _DNativeLibrary(version);

class _DNativeLibrary implements PlatformLibrary {
  const _DNativeLibrary(this.version);

  final String version;

  @override
  String get libraryPath => File(_libPath).absolute.path;

  @override
  String? get mountPoint => null;

  // return relative only, Dynamic library need absolute path.
  String get _libPath {
    if (Platform.isMacOS) {
      return ['build', 'sqlite', version, 'sqlite-amalgamation-$version', 'libsqlite3.dylib']
          .join(Platform.pathSeparator);
    } else if (Platform.isWindows) {
      final fname = ['build', 'sqlite', version, 'sqlite-amalgamation-$version', 'libsqlite3.dll']
          .join(Platform.pathSeparator);
    } else if (Platform.isLinux) {
      return ['build', 'sqlite', version, 'sqlite-amalgamation-$version', 'libsqlite3.so']
          .join(Platform.pathSeparator);
    } else if (Platform.isAndroid) {
      // file '/system/lib/libsqlite.so' is only accessible to Java thus we it have to embedded;
      return 'libsqlite3.so';
    } else if (Platform.isIOS) {
      // TODO: test with iOS
    }
    throw Exception(
        'Unsupported operating system ${Platform.operatingSystem} ${Platform.version}.');
  }
}

IncrementalDataSource createDataSource(String test) => _NativeIncrementalDataSource(test);

class _NativeIncrementalDataSource extends IncrementalDataSource {
  _NativeIncrementalDataSource(String test) : super(Directory.systemTemp.path, test);

  @override
  DataSource next(List<Function> registered,
      {int flags = OPEN_CREATE | OPEN_READWRITE, String? modName}) {
    final filepath =
        [root, '$test${IncrementalDataSource.name}${++count}.db'].join(Platform.pathSeparator);
    registered.add(() => File(filepath).delete());
    return DataSource(filepath, flags: flags, moduleName: modName);
  }
}
