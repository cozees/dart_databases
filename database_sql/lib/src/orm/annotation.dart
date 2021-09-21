import 'dart:convert';
import 'dart:typed_data';

/// Naming conversion between Dart and SQL name.
typedef NameConversion = String Function(String, [bool toSQL]);

/// default naming conversion function
///
/// This default function use snake lower case for SQL naming while follow Dart capital case.
String snakeCapitalCaseConversion(String name, [bool toSQL = true]) {
  if (toSQL) {
    final buffer = StringBuffer();
    final ucodes = name.codeUnits;
    for (var i = 0; i < ucodes.length; i++) {
      if (ucodes[i] == 95) {
        // underscore _, first one is ignored
        if (i == 0) continue;
        buffer.writeCharCode(ucodes[i]);
      } else if ((96 < ucodes[i] && ucodes[i] < 123) || (47 < ucodes[i] && ucodes[i] < 58)) {
        // a-z 0-9
        buffer.writeCharCode(ucodes[i]);
      } else if (64 < ucodes[i] && ucodes[i] < 91) {
        // underscore _
        if (i > 0) buffer.writeCharCode(95);
        // A-Z -> a-z
        buffer.writeCharCode(ucodes[i] + 32);
      } else {
        throw Exception('Invalid dart identifier $name.');
      }
    }
    return buffer.toString();
  } else if (name.contains('_')) {
    final buffer = StringBuffer();
    var index = 0, start = 0;
    while ((index = name.indexOf('_', start)) != -1) {
      if (buffer.isEmpty) {
        buffer.write(name.substring(start, index));
      } else {
        buffer.write(name[start].toUpperCase());
        buffer.write(name.substring(++start, index));
      }
      start = index + 1;
    }
    if (start < name.length) {
      buffer.write(name[start].toUpperCase());
      buffer.write(name.substring(++start));
    }
    return buffer.toString();
  } else {
    return name;
  }
}

/// Class helper for sql engine library to provide the of predefined value.
class PredefinedDefaultValue {
  /// parsing string value into Pre-Defined Class
  static List<PredefinedDefaultValue> parse(String val) {
    final result = <PredefinedDefaultValue>[];
    final segments = <String>[];
    for (var line in LineSplitter().convert(val)) {
      int start = 0, index = -1;
      while (segments.length < 4) {
        index = line.indexOf(',', start);
        if (index == -1) throw Exception('Invalid pre-defined default value $line.');
        segments.add(line.substring(start, index));
        start = ++index;
      }
      result.add(PredefinedDefaultValue(segments[0], segments[1], segments[2], segments[4]));
      segments.clear();
    }
    return result;
  }

  /// create pre-defined value
  const PredefinedDefaultValue(this.defined, this.dartValue, this.dartType, this.sqlType);

  /// the text that defined the default value
  final String defined;

  /// a compatible dart value encoded or not encoded from actual dart value.
  final dynamic dartValue;

  /// a compatible dart type
  final String dartType;

  /// the sql type for the value
  final String sqlType;

  /// convert value into string
  String encode() => '$defined,$dartType,$sqlType,$dartValue';
}

/// helper to encode list of [PredefinedDefaultValue] into multiple line of string where each line
/// represent individual [PredefinedDefaultValue] value.
extension ListPredefinedDefaultValue on Iterable<PredefinedDefaultValue> {
  String encode() {
    final buffer = StringBuffer();
    for (var pddv in this) {
      buffer.writeln(pddv.encode());
    }
    return buffer.toString();
  }
}

/// SQL data type.
abstract class SQLDataType {
  /// constant constructor need by annotation
  const SQLDataType(this.dartTypeAffinity, [this.dartType]);

  /// type affinity to determine what type to read from database reader
  ///
  /// These type [String], [int], [double], [bool], [Uint8List], [DateTime] is basic support
  /// for most of sql engine where [DateTime] will be using a string value when exchange between
  /// Dart and Database Engine.
  final Type dartTypeAffinity;

  /// An actual dart type.
  final Type? dartType;

  /// return sql data type
  String sqlDataType();
}

/// An interface that provide method to convert custom object into compatible data type.
abstract class SQLDefaultValueValue<T, D> {
  /// define for annotation usage.
  const SQLDefaultValueValue();

  /// return data type that is suitable for sql database engine.
  T toSQLValue();

  /// return value that can be assgin to dart field
  D toDartValue();
}

/// An interface that provide method to generate an id value.
abstract class IdGenerator<T> {
  /// define for annotation usage.
  const IdGenerator();

  /// return a data type that assign able to dart field
  T generate();
}

/// Database engine that required or wanted to have additional definition or declaration when create
/// the table can provide the implemented of this class.
abstract class SQLTableAdditionalDefinition {
  /// define for annotation usage.
  const SQLTableAdditionalDefinition();

  /// return a definition that add to the tail of query create table.
  ///
  /// The definition result in example below is `engine = USEFUL_ENGINE`.
  /// ```sql
  /// CREATE TABLE sample (id PRIMARY KEY) engine = USEFUL_ENGINE;
  /// ```
  String definition();
}

/// a function callback to return specific string declaration of
/// each engine.
typedef DBEngineDataType<T> = String Function(T);

/// Table annotation use on mixin to identify
class Table {
  /// create table annotation
  ///
  /// By default, if name is not provided generate will use naming conversion function convert the
  /// name of mixin into sql snake case and omit prefix or suffix word 'Mixin'.
  const Table({
    this.name,
    this.nameConversion = snakeCapitalCaseConversion,
    this.additional,
    this.annotations,
    this.constantClass = false,
  });

  /// function use to convert name between dart and sql
  final NameConversion nameConversion;

  /// table name
  final String? name;

  /// A function that return a tail sql definition for create table definition.
  ///
  /// The definition result in example below is `engine = USEFUL_ENGINE`.
  /// ```sql
  /// CREATE TABLE sample (id PRIMARY KEY) engine = USEFUL_ENGINE;
  /// ```
  final SQLTableAdditionalDefinition? additional;

  /// The output annotations for the class generated by this the generator.
  final List<dynamic>? annotations;

  /// The generate class will be a constant class.
  ///
  /// If true then all column become read only and corresponded field will be generate with final
  /// keyword. The save and delete will method will be generated however update method will be ignored.
  /// By default, generator will not generate a constant class and field at is not readonly field will
  /// have setter and getter access generated.
  final bool constantClass;
}

/// Table column annotation
class Column {
  /// create column annotation
  const Column({
    this.nameConversion = snakeCapitalCaseConversion,
    this.name,
    this.dartName,
    this.dartType,
    required this.type,
    this.primaryKey = false,
    this.autoIncrement = false,
    this.idGenerator,
    this.defaultValue,
    this.unique = false,
    this.uniqueGroup,
    this.notNull = true,
    this.readonly = false,
    this.reader,
    this.writer,
  });

  /// function use to convert name between dart and sql
  final NameConversion nameConversion;

  /// name of column if given otherwise field name is use instead.
  final String? name;

  /// name of dart class field represent this column value.
  ///
  /// By default, the generate will try to convert a snake case into dart variable naming convention.
  /// If the name of column is not a snake case then the origin value if column name will be used to
  /// generate dart class field.
  final String? dartName;

  /// An actual dart type for the field that represent the current column
  ///
  /// If not provided, the generator will use [SQLDataType.dartTypeAffinity] to determine the actual
  /// type of dart field.
  final Type? dartType;

  /// indicate whether the current field is represent primary key
  final bool primaryKey;

  /// indicate whether the current field is primary key and auto increment
  final bool autoIncrement;

  /// Data type of current field in the sqlite table
  final SQLDataType type;

  /// Indicate whether the column is nullable.
  final bool notNull;

  /// Default value for this field
  ///
  /// If the value provide is a scalar type then it value will be use directly as default value
  /// to the database schema. However if the value is not a scalar type then the schema will set to
  /// NOT NULL if field is not null however it value will set when create dart object. Aside from a
  /// few known value such as [DateTime], [Uri] which will be handle by generator automatically the
  /// other custom object value must implement [SQLDefaultValueValue].
  final dynamic defaultValue;

  /// indicate whether the column is unique
  final bool unique;

  /// a string id represent unique group or a single unique column
  ///
  /// When multiple field annotated with the same unique id all of them group as a single unique
  /// constraint. If no more than 1 then this is single column unique constraint.
  final String? uniqueGroup;

  /// indicate that the field or column is not allow to be editable.
  final bool readonly;

  /// A reference to a function use as generator to create new id for a new object.
  ///
  /// This is useful when table id is not an integer type there system auto increment can be done
  /// therefore when create a new object an id will be pre-generated.
  /// ```dart
  /// @Column(type: SQLiteDataType.text)
  /// String get id;
  /// ```
  final dynamic idGenerator;

  /// A reference function use to parse data from SQLite to Dart object.
  ///
  /// For example: A field map object is not supported by SQLite however we can store this value
  /// in the form of JSON encoded thus we can use [json.encode] as reader.
  /// ```dart
  /// @Column(type: SQLiteDataType.text, reader: json.encode)
  /// late final Map<String,int> dictionary;
  /// ```
  /// For complex conversion, please provide your own function or implement a method 'toSQL' where
  /// it return SQLite Data Type.
  /// ```dart
  /// class A {
  ///   // normal creation
  ///   A(this.a);
  ///
  ///   // use by RowCreator to create this class based on value from SQLite database.
  ///   A.fromSQLite(int val): a = val;
  ///
  ///   final int a;
  ///
  ///   // Return encode data that represent this class
  ///   int toSQLite() => a;
  /// }
  ///
  /// @Table('sample')
  /// mixin B {
  ///   @Column(type: SQLiteDataType.integer)
  ///   late final A a;
  /// }
  /// ```
  final dynamic reader;

  /// A reference function use to convert unsupported database to SQLite Data Type.
  ///
  /// For example: A field map object is not supported by SQLite however we can store this value
  /// in the form of JSON encoded thus we can use [json.decode] as writer.
  /// ```dart
  /// @Column(type: SQLiteDataType.text, reader: json.encode, writer: json.decode)
  /// late final Map<String,int> dictionary;
  /// ```
  /// For complex conversion, please provide your own function or implement a constructor 'fromSQL' where
  /// it accept a single SQLite Data Type.
  /// ```dart
  /// class A {
  ///   // normal creation
  ///   A(this.a);
  ///
  ///   // use by RowCreator to create this class based on value from SQLite database.
  ///   A.fromSQLite(int val): a = val;
  ///
  ///   final int a;
  ///
  ///   // Return encode data that represent this class
  ///   int toSQLite() => a;
  /// }
  ///
  /// @Table('sample')
  /// mixin B {
  ///   @Column(type: SQLiteDataType.integer)
  ///   late final A a;
  /// }
  /// ```
  final dynamic writer;
}

