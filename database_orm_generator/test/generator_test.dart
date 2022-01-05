import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:database_orm_generator/builder.dart';
import 'package:test/test.dart';

void main() {
  test('Generate class', () async {
    var assetReader = await PackageAssetReader.currentIsolate();
    final builder = classLibraryBuilder(BuilderOptions.empty);
    final writer = InMemoryAssetWriter();
    await testBuilder(builder, _inputMap, reader: assetReader, writer: writer);
    File('example/console/lib/src/student.db.dart')
        .writeAsBytesSync(writer.assets.isNotEmpty ? writer.assets.values.first : []);
  });
}

final _inputMap = {
  'console|lib/src/student.dart': File('example/console/lib/src/student.dart').readAsStringSync(),
};
