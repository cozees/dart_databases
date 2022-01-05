import 'package:code_builder/code_builder.dart';
import 'package:test/test.dart';

import 'allocator.dart';
import 'emitter.dart';
import 'custom.dart';

void main() {
  final emitter = GenCodeEmitter(allocator: PrefixedAllocator(true));
  test('Test IfElse Block', () {
    // if only
    var result = If(refer('test').notEqualTo(literalNull), Block((b) {
      b.statements.add(refer('print').call([literalNum(123)]).statement);
    })).accept(emitter);
    expect(result.toString(), 'if (test != null) {print(123);}');
    // if elseif only
    result = If(refer('test').notEqualTo(literalNull), Block((b) {
      b.statements.add(refer('print').call([literalNum(123)]).statement);
    })).elseif(refer('test').equalTo(refer('another')), Block((b) {
      b.statements.add(refer('print').call([literalString('abc')]).statement);
    })).accept(emitter);
    expect(result.toString(),
        "if (test != null) {print(123);}else if (test == another) {print('abc');}");
    // if elseif else
    result = If(refer('test').notEqualTo(literalNull), Block((b) {
      b.statements.add(refer('print').call([literalNum(123)]).statement);
    })).elseif(refer('test').equalTo(refer('another')), Block((b) {
      b.statements.add(refer('print').call([literalString('abc')]).statement);
    })).else$(Block((b) {
      b.statements.add(refer('print').call([literalString('abc123')]).statement);
    })).accept(emitter);
    expect(result.toString(),
        "if (test != null) {print(123);}else if (test == another) {print('abc');}else {print('abc123');}");
    // error
    expect(() {
      If(refer('test').notEqualTo(literalTrue), Block())
          .else$(Block())
          .elseif(refer('test'), Block())
          .accept(emitter);
    }, throwsException);
  });

  test('Test return', () {
    // test code
    var result = Return(refer('test')).accept(emitter);
    expect(result.toString(), 'return test;');
    // test with function
    result =  Method.returnsVoid((mb) => mb
      ..name = 'test'
      ..body = Return(literalNum(123))).accept(emitter);
    expect(result.toString(), 'void test() { return 123; } ');
  });

  test('Test Try Catch', () {
    final dummy = refer('print').call([literalTrue]).statement;
    // test all error
    expect(() => Try(Block((b) => b.statements.add(dummy))).accept(emitter), throwsException);
    expect(
      () => Try(Block())
          .catch$((e, s) => Block())
          .on$catch(refer('Exception'), (e, s) => Block())
          .accept(emitter),
      throwsException,
    );
    expect(
      () => Try(Block())
          .catch$((e, s) => Block())
          .on$(
            refer('Exception'),
            Block(),
          )
          .accept(emitter),
      throwsException,
    );
    expect(
      () => Try(Block()).finally$(Block()).catch$((e, s) => Block()).accept(emitter),
      throwsException,
    );
    expect(
      () => Try(Block())
          .finally$(Block())
          .on$catch(refer('Exception'), (e, s) => Block())
          .accept(emitter),
      throwsException,
    );
    expect(
      () => Try(Block()).finally$(Block()).on$(refer('Exception'), Block()).accept(emitter),
      throwsException,
    );
    // test result
    var result = Try(Block((b) => b.statements.add(dummy)))
        .catch$((e, s) => Block((b) => b.statements.add(dummy)))
        .accept(emitter);
    expect(result.toString(), 'try {print(true);} catch(e, s) {print(true);}');
    result = Try(Block((b) => b.statements.add(dummy)))
        .on$(refer('SomeException'), Block((b) => b.statements.add(dummy)))
        .accept(emitter);
    expect(result.toString(), 'try {print(true);}on SomeException {print(true);}');
    result = Try(Block((b) => b.statements.add(dummy)))
        .on$(refer('SomeException'), Block((b) => b.statements.add(dummy)))
        .on$catch(refer('SomeException1'), (e, s) => Block((b) => b.statements.add(dummy)))
        .accept(emitter);
    expect(result.toString(),
        'try {print(true);}on SomeException {print(true);}on SomeException1 catch(e, s) {print(true);}');
    result = Try(Block((b) => b.statements.add(dummy)))
        .on$(refer('SomeException'), Block((b) => b.statements.add(dummy)))
        .finally$(Block((b) => b.statements.add(dummy)))
        .accept(emitter);
    expect(result.toString(),
        'try {print(true);}on SomeException {print(true);}finally {print(true);}');
  });
}
