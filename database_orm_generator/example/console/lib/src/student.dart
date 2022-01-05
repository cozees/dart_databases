import 'dart:async';

import 'package:database_orm_generator/sqlite.dart' as sqlite;
import 'package:database_sql/orm.dart';
import 'package:database_sql/database_sql.dart';

part 'student.db.dart';

///
///
@Table(additional: sqlite.withoutROWID)
mixin StudentMixin {
  @Column(type: sqlite.integer, primaryKey: true, autoIncrement: true)
  int? _studentId;

  @Column(type: sqlite.text)
  late String? _firstName;

  @Column(type: sqlite.text, notNull: false)
  late String? _middleName;

  @Column(type: sqlite.text)
  late String? _lastName;

  @Column(type: sqlite.text)
  late String? _clazz;

  @Column(type: sqlite.text, unique: true, uniqueGroup: '_student_code_number')
  late String? _studentNo;

  @Column(type: sqlite.text, uniqueGroup: '_student_code_number')
  late String? _studentRec;

  @Column(type: sqlite.integer)
  late int? _age;

  @Column(type: sqlite.datetime)
  late DateTime? _birthday;

  @Column(type: sqlite.datetime, defaultValue: DateTimeUtil.now, readonly: true)
  late DateTime? _createdAt;

  @Column(type: sqlite.datetime, defaultValue: DateTimeUtil.now, readonly: true)
  late DateTime? _updatedAt;
}
