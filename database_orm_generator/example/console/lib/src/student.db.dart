// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// ClassGenerator
// **************************************************************************

/// A class represent table student
class Student with StudentMixin {
  /// A constructor to create a new object of [Student], no data existed in database yet until save is call.
  Student(
      {int? studentId,
      required String firstName,
      String? middleName,
      required String lastName,
      required String clazz,
      required String studentNo,
      required String studentRec,
      required int age,
      required DateTime birthday}) {
    _fieldState = 2042;
    if (studentId != null) {
      _studentId = studentId;
      _fieldState = _fieldState | 1;
    }
    _firstName = firstName;
    if (_middleName != null) _fieldState = _fieldState | 4;
    _middleName = middleName;
    _lastName = lastName;
    _clazz = clazz;
    _studentNo = studentNo;
    _studentRec = studentRec;
    _age = age;
    _birthday = birthday;
    _createdAt = DateTimeUtil.now();
    _updatedAt = DateTimeUtil.now();
  }

  /// A constructor use to create from row result set from SELECT query.
  Student.db(RowReader reader) {
    _studentId = reader.intValueBy('student_id')!;
    _firstName = reader.stringValueBy('first_name')!;
    _middleName = reader.stringValueBy('middle_name');
    _lastName = reader.stringValueBy('last_name')!;
    _clazz = reader.stringValueBy('clazz')!;
    _studentNo = reader.stringValueBy('student_no')!;
    _studentRec = reader.stringValueBy('student_rec')!;
    _age = reader.intValueBy('age')!;
    _birthday = DateTime.parse(reader.stringValueBy('birthday')!);
    _createdAt = DateTime.parse(reader.stringValueBy('created_at')!);
    _updatedAt = DateTime.parse(reader.stringValueBy('updated_at')!);
  }

// state to keep track change of non-readonly field
  int _fieldState = 0;

  /// Constant value for table name student
  static const tableName = 'student';

  /// Column student_id for table student.
  static const columnStudentId = 'student_id;';

  /// Column first_name for table student.
  static const columnFirstName = 'first_name;';

  /// Column middle_name for table student.
  static const columnMiddleName = 'middle_name;';

  /// Column last_name for table student.
  static const columnLastName = 'last_name;';

  /// Column clazz for table student.
  static const columnClazz = 'clazz;';

  /// Column student_no for table student.
  static const columnStudentNo = 'student_no;';

  /// Column student_rec for table student.
  static const columnStudentRec = 'student_rec;';

  /// Column age for table student.
  static const columnAge = 'age;';

  /// Column birthday for table student.
  static const columnBirthday = 'birthday;';

  /// Column created_at for table student.
  static const columnCreatedAt = 'created_at;';

  /// Column updated_at for table student.
  static const columnUpdatedAt = 'updated_at;';

  /// Create table student schema.
  static Future<void> createSQLTable(Database db) async {
    db.exec('CREATE TABLE IF NOT EXISTS `student` ('
        '`student_id` INTEGER PRIMARY KEY AUTOINCREMENT,'
        '`first_name` TEXT NOT NULL,'
        '`middle_name` TEXT,'
        '`last_name` TEXT NOT NULL,'
        '`clazz` TEXT NOT NULL,'
        '`student_no` TEXT NOT NULL UNIQUE,'
        '`student_rec` TEXT NOT NULL,'
        '`age` INTEGER NOT NULL,'
        '`birthday` NUMERIC NOT NULL,'
        '`created_at` NUMERIC NOT NULL,'
        '`updated_at` NUMERIC NOT NULL,'
        'UNIQUE (`student_no`, `student_rec`)'
        ') WITHOUT ROWID;');
  }

  /// static function creator use to provide to [Database.query], [Statement.query] and [Transaction.query].
  static Student creator(RowReader reader) => Student.db(reader);

  /// Return true if any field in class has changed otherwise false.
  bool get hasAnyChange => _fieldState != 0;

  /// Value of column student_id
  ///
  /// Value null mean the object has not been insert into database otherwise non-null is returned.
  int? get studentId => _studentId;

  /// Value of column first_name
  String get firstName => _firstName!;

  /// Value of column middle_name
  String? get middleName => _middleName;

  /// Value of column last_name
  String get lastName => _lastName!;

  /// Value of column clazz
  String get clazz => _clazz!;

  /// Value of column student_no
  String get studentNo => _studentNo!;

  /// Value of column student_rec
  String get studentRec => _studentRec!;

  /// Value of column age
  int get age => _age!;

  /// Value of column birthday
  DateTime get birthday => _birthday!;

  /// Value of column created_at
  DateTime get createdAt => _createdAt!;

  /// Value of column updated_at
  DateTime get updatedAt => _updatedAt!;

  /// Set value for column student_id
  ///
  /// Note: primary key auto increment type declaration should be nullable as when create
  /// a new object, the ID cannot be known before insert into database. Dart compile required
  /// setter and getter to have identical declaration thus we throw exception instead when
  /// setting primary key value with null.
  set studentId(int? val) {
    if (val == null) {
      throw DatabaseException('primary key value cannot be null.');
    }
    if (_studentId != val) {
      _fieldState = _fieldState | 1;
      _studentId = val;
    }
  }

  /// Set value for column first_name
  set firstName(String val) {
    if (_firstName != val) {
      _fieldState = _fieldState | 2;
      _firstName = val;
    }
  }

  /// Set value for column middle_name
  set middleName(String? val) {
    if (_middleName != val) {
      _fieldState = _fieldState | 4;
      _middleName = val;
    }
  }

  /// Set value for column last_name
  set lastName(String val) {
    if (_lastName != val) {
      _fieldState = _fieldState | 8;
      _lastName = val;
    }
  }

  /// Set value for column clazz
  set clazz(String val) {
    if (_clazz != val) {
      _fieldState = _fieldState | 16;
      _clazz = val;
    }
  }

  /// Set value for column student_no
  set studentNo(String val) {
    if (_studentNo != val) {
      _fieldState = _fieldState | 32;
      _studentNo = val;
    }
  }

  /// Set value for column student_rec
  set studentRec(String val) {
    if (_studentRec != val) {
      _fieldState = _fieldState | 64;
      _studentRec = val;
    }
  }

  /// Set value for column age
  set age(int val) {
    if (_age != val) {
      _fieldState = _fieldState | 128;
      _age = val;
    }
  }

  /// Set value for column birthday
  set birthday(DateTime val) {
    if (_birthday != val) {
      _fieldState = _fieldState | 256;
      _birthday = val;
    }
  }

  /// Insert a row record into table student
  Future<Changes> insert(Database db) {
    final sql = 'INSERT INTO `student` ('
        '`student_id`,'
        '`first_name`,'
        '`middle_name`,'
        '`last_name`,'
        '`clazz`,'
        '`student_no`,'
        '`student_rec`,'
        '`age`,'
        '`birthday`,'
        '`created_at`,'
        '`updated_at`'
        ') VALUES(?,?,?,?,?,?,?,?,?,?)';
    return db.exec(sql, parameters: [
      _studentId,
      _firstName,
      _middleName,
      _lastName,
      _clazz,
      _studentNo,
      _studentRec,
      _age,
      _birthday,
      _createdAt,
      _updatedAt
    ]);
  }

  /// Update any change on into table student
  Future<Changes?> update(Database db) {
    final params = [];
    final fieldSet = [];
    if (_fieldState & 1 == 1) {
      params.add(_studentId);
      fieldSet.add('`student_id`=?');
    }
    if (_fieldState & 2 == 2) {
      params.add(_firstName);
      fieldSet.add('`first_name`=?');
    }
    if (_fieldState & 4 == 4) {
      params.add(_middleName);
      fieldSet.add('`middle_name`=?');
    }
    if (_fieldState & 8 == 8) {
      params.add(_lastName);
      fieldSet.add('`last_name`=?');
    }
    if (_fieldState & 16 == 16) {
      params.add(_clazz);
      fieldSet.add('`clazz`=?');
    }
    if (_fieldState & 32 == 32) {
      params.add(_studentNo);
      fieldSet.add('`student_no`=?');
    }
    if (_fieldState & 64 == 64) {
      params.add(_studentRec);
      fieldSet.add('`student_rec`=?');
    }
    if (_fieldState & 128 == 128) {
      params.add(_age);
      fieldSet.add('`age`=?');
    }
    if (_fieldState & 256 == 256) {
      params.add(_birthday);
      fieldSet.add('`birthday`=?');
    }
    if (_fieldState & 512 == 512) {
      params.add(_createdAt);
      fieldSet.add('`created_at`=?');
    }
    if (_fieldState & 1024 == 1024) {
      params.add(_updatedAt);
      fieldSet.add('`updated_at`=?');
    }
    final sql =
        'UPDATE `student` SET ${fieldSet.join(',')} WHERE `student_id`=?';
    params.addAll([_studentId]);
    return db.exec(sql, parameters: params);
  }

  /// Delete a row record from table student
  Future<Changes> delete(Database db) =>
      db.exec('DELETE FROM `student` WHERE `student_id`=?',
          parameters: [_studentId]);
}
