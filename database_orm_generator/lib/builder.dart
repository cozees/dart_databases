/// Support for doing something awesome.
///
/// More dartdocs go here.
library database_orm_generator;

import 'package:build/build.dart';
import 'package:database_orm_generator/src/class_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder classLibraryBuilder(BuilderOptions options) =>
    PartBuilder([ClassGenerator(options)], '.db.dart');
