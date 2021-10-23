import 'dart:async';
import 'dart:typed_data';

import 'package:database_sql/database_sql.dart' as sql;
import 'package:dsqlite/sqlite.dart' as sqlite;
import 'package:logging/logging.dart';

part 'argument.dart';
part 'driver.dart';
part 'exception.dart';
part 'info.dart';
part 'reader.dart';
part 'response.dart';
part 'statement.dart';
part 'transaction.dart';
part 'writer.dart';

/// SQLite base class for handling aggregate function.
class AggregatorFunction extends sql.AggregatorFunction<sqlite.PtrContext, dynamic> {
  /// AggregatorFunction
  AggregatorFunction(
    this.creator, {
    int argumentsNumber = 0,
    int optionalArgument = 0,
    int? dbArgument,
    sql.ArgumentConverter argConverter = sql.defaultArgumentConverter,
    sql.FunctionResultConverter? resultConverter,
    sql.FunctionResultHandler<sqlite.PtrContext, dynamic>? resultHandler,
  }) : super(
          argumentsNumber: argumentsNumber,
          optionalArgument: optionalArgument,
          dbArgument: dbArgument,
          argConverter: argConverter,
          resultConverter: resultConverter,
          resultHandler: resultHandler,
        );

  /// Store the data based on context id.
  Map<int, sql.AggregateHandler>? data;

  /// next counter id
  int next = 1;

  /// Return new [sql.AggregateHandler] object
  final sql.AggregateHandler Function() creator;

  /// Return new or exist value [D] based on the given SQLite context.
  TwoResult<int, sql.AggregateHandler> contextValue(sqlite.PtrContext ctx) {
    final val = Driver.binder.aggregate_context(ctx, 8)?.cast<sqlite.Int64>();
    if (val == null) throw sql.DatabaseException('Allocate sqlite context out of memory.');
    var d = data?[val.value];
    if (val.value == 0) {
      val.value = next;
      data ??= {};
      d = data![val.value] = creator();
      next++;
    }
    return TwoResult(val.value, d!);
  }
}

/// An update hook callback.
typedef UpdateHook = void Function(int operation, String databaseName, String tableName, int id);

/// Database connection
class Database implements sql.Database {
  Database._(sqlite.PtrSqlite3 db) : _db = db;

  // reference to c sqlite object, null if database has been close.
  sqlite.PtrSqlite3? _db;

  // use to trace save pointer
  int _savePointerCounter = 0;

  // use by savepoint class
  void _onSavePointUpdate(bool init) => _savePointerCounter += init ? 1 : -1;

  // use to trace open transaction
  bool _activeTransaction = false;

  // use by transaction class
  void _onTransactionUpdate(bool begin) => _activeTransaction = begin;

  // use to counter number of statement prepare within this connection
  int _statementCounter = 0;

  // use by statement and rows class
  void _onStatementUpdate(bool init) => _statementCounter += init ? 1 : -1;

  // ensure that database connection is still open
  void _ensureDatabaseOpen() {
    if (isClosed) throw sql.DatabaseException('Database connection has been closed.');
  }

  /// Provide an access to c native pointer database in expose api is not enough.
  Future<void> withNative(Future<void> Function(sqlite.PtrSqlite3) block) =>
      isClosed ? Future.error('Database has been closed.') : block(_db!);

  /// get access to native c pointer
  sqlite.PtrSqlite3 get native {
    _ensureDatabaseOpen();
    return _db!;
  }

  // -- common utility helper

  static TwoResult<sqlite.Pointer, T>? _removeReference<T>(
    int id,
    Map<int, sqlite.Pointer>? listRef,
    Map<sqlite.Pointer, dynamic>? store,
  ) {
    if (listRef?.containsKey(id) == true) {
      final key = listRef!.remove(id)!;
      return TwoResult(key, store!.remove(key));
    }
    return null;
  }

  static TwoResult<sqlite.Pointer, T>? _findReference<T>(
    int id,
    Map<int, sqlite.Pointer>? listRef,
    Map<sqlite.Pointer, T>? store,
  ) {
    if (listRef?.containsKey(id) != true) {
      return null;
    } else {
      final key = listRef![id]!;
      return TwoResult(key, store![key]!);
    }
  }

  // -- SQLite function
  // store reference as to registered function
  static Map<sqlite.Pointer, sql.DatabaseFunction<sqlite.PtrContext, dynamic>>? _function;

  //  use to keep pointer reference for map storage
  Map<int, sqlite.Pointer>? _funcRef;

  static void _functionInvoke(sqlite.PtrContext ctx, int count, sqlite.PtrPtrValue values) {
    final pArg = Driver.binder.user_data(ctx);
    final df = _function![pArg]!;
    if (df.argumentsNumber != -1) {
      if (df.argumentsNumber < count) {
        final msg = 'Too many argument ($count) function only accept '
            '${df.argumentsNumber} argument(s).';
        applyErrorResult(ctx, msg);
        Driver.logger?.finest(msg);
        return;
      } else if (count < df.argumentsNumber && count < df.argumentsNumber - df.optionalArgument) {
        final msg = 'Not enough argument ($count) function required at least '
            '${df.argumentsNumber - df.optionalArgument} argument(s).';
        applyErrorResult(ctx, msg);
        Driver.logger?.finest(msg);
        return;
      }
    }
    try {
      List<dynamic>? args;
      if (count > 0) {
        final reader = ValueReader(values);
        args = <dynamic>[for (var i = 0; i < count; i++) df.argConverter(i, reader)];
      }
      // invoke dart function
      if (df.argumentsNumber < 0 && args != null) args = [args];
      final result = df.resultConverter != null
          ? df.resultConverter!(Function.apply(df.func, args))
          : Function.apply(df.func, args);
      final rh = df.resultHandler ?? applyResult;
      rh(ctx, result);
    } catch (e, s) {
      applyErrorResult(ctx, e.toString());
      Driver.logger?.finest('Error execute function', e, s);
    }
  }

  /// Register function [df.func] with the given name.
  void registerFunction(String name, sql.DatabaseFunction<sqlite.PtrContext, dynamic> df) {
    final id = name.hashCode;
    final previous = _findReference(id, _funcRef, _function);
    // same function and name has been registered thus nothing to do
    if (previous?.d != df) {
      // same name but different comparator thus we don't need to register C-api agains just
      // replace comparator in static _function
      late final sqlite.Pointer<sqlite.Void> pArg;
      if (previous != null) {
        pArg = previous.t.cast();
        // due to SQLite support multiple function with the same name to handle different encode
        // or different argument this is easily create confusion thus we maintain only a single
        // definition in SQLite since dart container optional positional argument already including
        // dynamic type.
        Driver.binder.create_function_compat(
            _db!,
            name,
            previous.d.dbFunctionArgsCount,
            sqlite.UTF8,
            sqlite.nullptr,
            sqlite.nullptr,
            sqlite.nullptr,
            sqlite.nullptr,
            sqlite.nullptr);
        // replace previous
        _function![previous.t] = df;
      } else {
        // as dart:ffi required given function must be a static thus we have to keep reference to
        // the comparator in the static field by using name hashcode as key
        pArg = sqlite.malloc<sqlite.Int8>(1).cast<sqlite.Void>();
        (_function ??= {})[pArg] = df;
        (_funcRef ??= {}).putIfAbsent(id, () => pArg);
      }
      final xFunc = sqlite.Pointer.fromFunction<sqlite.DefpxFunc>(_functionInvoke);
      Driver.binder.create_function_compat(_db!, name, df.dbFunctionArgsCount, sqlite.UTF8, pArg,
          xFunc, sqlite.nullptr, sqlite.nullptr, sqlite.nullptr);
    }
  }

  /// Unregister function of the given [name].
  void unregisterFunction(String name) {
    final id = name.hashCode;
    final previous = _removeReference(id, _funcRef, _function);
    if (previous != null) {
      Driver.binder.create_function_compat(_db!, name, previous.d.dbFunctionArgsCount, sqlite.UTF8,
          sqlite.nullptr, sqlite.nullptr, sqlite.nullptr, sqlite.nullptr, sqlite.nullptr);
      sqlite.free(previous.t);
    }
  }

  // -- SQLite Aggregate Function

  // use to keep reference to registered aggregate function
  static Map<sqlite.Pointer, AggregatorFunction>? _aggregate;

  // use to keep pointer allow reference, free it when database close
  Map<int, sqlite.Pointer>? _aggregateRef;

  static void _aggregateXStep(sqlite.PtrContext ctx, int count, sqlite.PtrPtrValue values) {
    final pArg = Driver.binder.user_data(ctx);
    final af = _aggregate![pArg]!;
    if (af.argumentsNumber != -1) {
      if (af.argumentsNumber < count) {
        final msg = 'Too many argument ($count) function only accept ${af.argumentsNumber}'
            ' argument(s).';
        applyErrorResult(ctx, msg);
        Driver.logger?.finest(msg);
        return;
      } else if (count < af.argumentsNumber && count < af.argumentsNumber - af.optionalArgument) {
        final msg = 'Not enough argument ($count) function required at least '
            '${af.argumentsNumber - af.optionalArgument} argument(s).';
        applyErrorResult(ctx, msg);
        Driver.logger?.finest(msg);
        return;
      }
    }
    try {
      List<dynamic>? args;
      if (count > 0) {
        final reader = ValueReader(values);
        args = <dynamic>[for (var i = 0; i < count; i++) af.argConverter(i, reader)];
      }
      // invoke dart function with unlimited argument
      if (af.argumentsNumber < 0 && args != null) args = [args];
      final ref = af.contextValue(ctx);
      Function.apply(ref.d.step, args);
    } catch (e, s) {
      applyErrorResult(ctx, e.toString());
      Driver.logger?.finest('Error execute aggregate step', e, s);
    }
  }

  static void _aggregateXFinal(sqlite.PtrContext ctx) {
    final pArg = Driver.binder.user_data(ctx);
    try {
      final af = _aggregate![pArg]!;
      final val = af.contextValue(ctx).d.finalize();
      final rh = af.resultHandler ?? applyResult;
      rh(ctx, af.resultConverter != null ? af.resultConverter!(val) : val);
    } catch (e, s) {
      applyErrorResult(ctx, e.toString());
      Driver.logger?.finest('Error execute aggregate finalize', e, s);
    }
  }

  /// Register aggregator function with the given [name]
  void registerAggregate(String name, AggregatorFunction af) {
    final id = name.hashCode;
    final previous = _findReference(id, _aggregateRef, _aggregate);
    // same function and name has been registered thus nothing to do
    if (previous?.d != af) {
      // register new or replace
      final xStep = sqlite.Pointer.fromFunction<sqlite.DefpxFunc>(_aggregateXStep);
      final xFinal = sqlite.Pointer.fromFunction<sqlite.DefxFinal>(_aggregateXFinal);
      late final sqlite.Pointer<sqlite.Void> pArg;
      // same name but different comparator thus we don't need to register C-api agains just
      // replace comparator in static _collating
      if (previous != null) {
        pArg = previous.t.cast();
        // due to SQLite support multiple function with the same name to handle different encode
        // or different argument this is easily create confusion thus we maintain only a single
        // definition in SQLite since dart container optional positional argument already including
        // dynamic type.
        Driver.binder.create_function(_db!, name, previous.d.dbFunctionArgsCount, sqlite.UTF8, pArg,
            sqlite.nullptr, sqlite.nullptr, sqlite.nullptr);
        // replace
        _aggregate![previous.t] = af;
      } else {
        // as dart:ffi required given function must be a static thus we have to keep reference to
        // the comparator in the static field by using name hashcode as key
        pArg = sqlite.malloc<sqlite.Int8>(1).cast();
        (_aggregate ??= {})[pArg] = af;
        (_aggregateRef ??= {}).putIfAbsent(id, () => pArg);
      }
      Driver.binder.create_function(
          _db!, name, af.dbFunctionArgsCount, sqlite.UTF8, pArg, sqlite.nullptr, xStep, xFinal);
    }
  }

  /// Unregister aggregator function with the given [name]
  void unregisterAggregate(String name) {
    final id = name.hashCode;
    final previous = _removeReference(id, _aggregateRef, _aggregate);
    if (previous != null) {
      Driver.binder.create_function(_db!, name, previous.d.dbFunctionArgsCount, sqlite.UTF8,
          previous.t.cast(), sqlite.nullptr, sqlite.nullptr, sqlite.nullptr);
      sqlite.free(previous.t);
    }
  }

  // -- Collating function

  // use to keep reference to registered collation function
  static Map<sqlite.Pointer, Comparator<String>>? _collating;

  // use to keep pointer allow reference, free it when database close
  Map<int, sqlite.Pointer>? _collatingRef;

  static int _collatingCompare(
    sqlite.Pointer<sqlite.Void> pArg,
    int sizeA,
    sqlite.Pointer<sqlite.Void> a,
    int sizeB,
    sqlite.Pointer<sqlite.Void> b,
  ) {
    try {
      final sa = a.cast<sqlite.Utf8>().toDartString(length: sizeA);
      final sb = b.cast<sqlite.Utf8>().toDartString(length: sizeB);
      return _collating![pArg]!(sa, sb);
    } catch (e, s) {
      // See https://www.sqlite.org/c3ref/create_collation.html
      // There is mention how it handle error while perform comparision. So logging is only way to
      // trace error.
      Driver.logger?.finest('Error execute comparision', e, s);
      // only webassembly that throw an error when calling collation function.
      // Exception is trapped inside dart:ffi native thus this will never reach.
      // IMPORTANT: We attempt to unify behavior between native vm and web
      if (!sqlite.isNative) return sqlite.FAIL;
      rethrow;
    }
  }

  /// Register collation [comparator] with the given name.
  void registerCollation(String name, Comparator<String> comparator) {
    final previous = _findReference(name.hashCode, _collatingRef, _collating);
    // same function and name has been registered thus nothing to do
    if (previous?.d != comparator) {
      // register new or replace
      final xCompare =
          sqlite.Pointer.fromFunction<sqlite.DefxCompare>(_collatingCompare, sqlite.FAIL);
      late final sqlite.Pointer<sqlite.Void> pArg;
      // same name but different comparator thus we don't need to register C-api agains just
      // replace comparator in static _collating
      if (previous != null) {
        pArg = previous.t.cast();
        Driver.binder.create_collation(_db!, name, sqlite.UTF8, pArg, sqlite.nullptr);
        _collating![previous.t] = comparator;
      } else {
        // as dart:ffi required given function must be a static thus we have to keep reference to
        // the comparator in the static field by using name hashcode as key
        pArg = sqlite.malloc<sqlite.Int8>(1).cast();
        (_collating ??= {})[pArg] = comparator;
        (_collatingRef ??= {}).putIfAbsent(name.hashCode, () => pArg);
      }
      Driver.binder.create_collation(_db!, name, sqlite.UTF8, pArg, xCompare);
    }
  }

  /// Unregister collation [name]
  void unregisterCollation(String name) {
    final id = name.hashCode;
    final previous = _removeReference(id, _collatingRef, _collating);
    if (previous != null) {
      Driver.binder.create_collation(_db!, name, sqlite.UTF8, previous.t.cast(), sqlite.nullptr);
      sqlite.free(previous.t);
    }
  }

  // -- hook api

  // use to store all hook register for all connection.
  static List<Map<sqlite.Pointer, dynamic>?>? _callbackHooks;

  // pointer hook key to retrieve
  List<sqlite.Pointer?>? _hookKey;

  sqlite.Pointer? _unregisterHook(int index, Function api) {
    final key = _hookKey?[index];
    if (key != null) {
      Function.apply(api, [_db!, sqlite.nullptr, sqlite.nullptr]);
      _callbackHooks?[index]?.remove(key);
      sqlite.free(key);
    }
  }

  // binder callback for commit hook
  static int _commitHookCallback(sqlite.PtrVoid pArg) => _callbackHooks![0]![pArg]!();

  /// register a commit hook, it invoke when a commit occurred.
  ///
  /// Note: the commit hook only trigger for the current connection. A commit from another
  /// connection will not trigger the callback.
  void registerCommitHook(int Function() callback) {
    _hookKey ??= [null, null, null];
    _hookKey![0] ??= sqlite.malloc<sqlite.Int32>(4);
    final key = _hookKey![0]!;
    _callbackHooks ??= [null, null, null];
    _callbackHooks![0] ??= <sqlite.Pointer, int Function()>{};
    _callbackHooks![0]![key] = callback;
    final ptr = sqlite.Pointer.fromFunction<sqlite.DefxSize>(_commitHookCallback, sqlite.FAIL);
    Driver.binder.commit_hook(_db!, ptr, key.cast());
  }

  /// unregister a commit hook.
  void unregisterCommitHook() => _hookKey![0] = _unregisterHook(0, Driver.binder.commit_hook);

  // binder callback for rollback hook
  static void _rollbackHookCallback(sqlite.PtrVoid pArg) => _callbackHooks![1]![pArg]!();

  /// register a rollback hook, it invoke when a rollback occurred.
  ///
  /// Note: the rollback hook only trigger for the current connection. A rollback from another
  /// connection will not trigger the callback.
  void registerRollbackHook(void Function() callback) {
    _hookKey ??= [null, null, null];
    _hookKey![1] ??= sqlite.malloc<sqlite.Int8>();
    final key = _hookKey![1]!;
    _callbackHooks ??= [null, null, null];
    _callbackHooks![1] ??= <sqlite.Pointer, void Function()>{};
    _callbackHooks![1]![key] = callback;
    final ptr = sqlite.Pointer.fromFunction<sqlite.DefxFree>(_rollbackHookCallback);
    Driver.binder.rollback_hook(_db!, ptr, key.cast());
  }

  /// unregister a rollback hook.
  void unregisterRollbackHook() => _hookKey![1] = _unregisterHook(1, Driver.binder.rollback_hook);

  // binder callback for update hook
  static void _updateHookCallback(
    sqlite.PtrVoid pArg,
    int operation,
    sqlite.Pointer<sqlite.Utf8> databaseName,
    sqlite.Pointer<sqlite.Utf8> tableName,
    int id,
  ) {
    final cb = _callbackHooks![2]![pArg]!;
    cb(operation, databaseName.toDartString(), tableName.toDartString(), id);
  }

  /// register a update hook, it invoke when an update occurred.
  ///
  /// Note: the update hook only trigger for the current connection. An update from another
  /// connection will not trigger the callback.
  void registerUpdateHook(UpdateHook callback) {
    _hookKey ??= [null, null, null];
    _hookKey![2] ??= sqlite.malloc<sqlite.Int8>();
    final key = _hookKey![2]!;
    _callbackHooks ??= [null, null, null];
    _callbackHooks![2] ??= <sqlite.Pointer, UpdateHook>{};
    _callbackHooks![2]![key] = callback;
    final ptr = sqlite.Pointer.fromFunction<sqlite.DefDefTypeGen10>(_updateHookCallback);
    Driver.binder.update_hook(_db!, ptr, key.cast());
  }

  /// unregister a update hook.
  void unregisterUpdateHook() => _hookKey![2] = _unregisterHook(2, Driver.binder.update_hook);

  // -- implement generate api

  /// Set runtime limit. See https://www.sqlite.org/c3ref/limit.html
  void setLimit(int id, int val) => Driver.binder.limit(_db!, id, val);

  /// Attach an database with the current connection.
  ///
  /// More information see https://www.sqlite.org/lang_attach.html
  Future<void> attach(String filename, String schemaName) =>
      exec('ATTACH DATABASE \'$filename\' AS $schemaName');

  /// Detach a database from the current conncetion.
  ///
  /// More information see https://www.sqlite.org/lang_detach.html
  Future<void> detach(String schemaName) => exec('DETACH DATABASE `$schemaName`;');

  @override
  Future<void> close() async {
    _ensureDatabaseOpen();
    if (_savePointerCounter > 0) {
      throw sql.DatabaseException(
          'There are $_savePointerCounter savepoint still not apply or cancel.');
    }
    if (_activeTransaction) {
      throw sql.DatabaseException('There is an active transaction that still not apply or cancel.');
    }
    if (_statementCounter > 0) {
      throw sql.DatabaseException('There are $_statementCounter unclosed statement');
    }
    // -- free pointer if available
    var cachePtr = _funcRef?.values ?? [];
    for (var ptr in cachePtr) {
      _function?.remove(ptr);
      sqlite.free(ptr);
    }
    _funcRef?.clear();
    cachePtr = _aggregateRef?.values ?? [];
    for (var ptr in cachePtr) {
      _aggregate?.remove(ptr);
      sqlite.free(ptr);
    }
    _aggregateRef?.clear();
    cachePtr = _collatingRef?.values ?? [];
    for (var ptr in cachePtr) {
      _collating?.remove(ptr);
      sqlite.free(ptr);
    }
    _collatingRef?.clear();
    final size = _hookKey?.length ?? 0;
    for (var i = 0; i < size; i++) {
      var ptr = _hookKey![i];
      if (ptr != null) {
        _callbackHooks![i]?.remove(ptr);
        sqlite.free(ptr);
      }
    }
    // close Database
    Driver.binder.close_compat(_db!);
    _db = null;
  }

  @override
  bool get isClosed => _db == null;

  @override
  Future<T> begin<T extends sql.Transaction>({
    sql.TransactionCreator<T>? creator,
    Duration? timeout,
  }) async =>
      creator != null ? creator(this) : Transaction._(this) as T;

  @override
  Future<sql.Statement> prepare(String query, [dynamic option]) async {
    if (option is int || option == null) return Statement._(this, query, option ?? 0);
    throw sql.DatabaseException('Unsupported option $option integer value is needed');
  }

  @override
  Future<sql.Changes> exec(String sql, {Iterable<dynamic>? parameters}) async {
    if (parameters != null && parameters.isNotEmpty) {
      final stmt = (await prepare(sql)).write();
      return await stmt.exec(parameters: parameters, reusable: false);
    } else {
      final errmsg = sqlite.malloc<sqlite.Pointer<sqlite.Utf8>>();
      final resultCode = Driver.binder.exec(_db!, sql, sqlite.nullptr, sqlite.nullptr, errmsg);
      if ((errmsg.value != sqlite.nullptr || errmsg.value.address != 0) &&
          resultCode != sqlite.OK) {
        final msg = errmsg.value.toDartString();
        sqlite.free(errmsg);
        throw SQLiteException(cdb: _db!, message: msg, returnCode: resultCode);
      }
      sqlite.free(errmsg);
      return Changes._(this);
    }
  }

  /* Not a server/client database engine thus do nothing */
  @override
  Future<void> ping() async {} // coverage:ignore-line

  @override
  Future<sql.Rows<T>> query<T>(String query,
      {Iterable<dynamic>? parameters, sql.RowCreator<T>? creator}) async {
    final stmt = (await prepare(query)).read();
    return await stmt.query(parameters: parameters, creator: creator);
  }
}

// use for return result of 2 value
class TwoResult<T, D> {
  TwoResult(this.t, this.d);

  final T t;
  final D d;
}

// extension _AllocationInt on int {
//   ffi.Pointer toNative() {
//     final byteCount = (bitLength / 8).ceil();
//     if (byteCount < 2) return pkgffi.malloc.allocate<ffi.Int8>(byteCount)..value = this;
//     if (byteCount < 4) return pkgffi.malloc.allocate<ffi.Int16>(byteCount)..value = this;
//     if (byteCount < 8) return pkgffi.malloc.allocate<ffi.Int32>(byteCount)..value = this;
//     return pkgffi.malloc.allocate<ffi.Int64>(byteCount)..value = this; // coverage:ignore-line
//   }
//
//   bool isEqualTo(ffi.Pointer other) {
//     final byteCount = (bitLength / 8).ceil();
//     if (byteCount < 2) return other.cast<ffi.Int8>().value == this;
//     if (byteCount < 4) return other.cast<ffi.Int16>().value == this;
//     if (byteCount < 8) return other.cast<ffi.Int32>().value == this;
//     return other.cast<ffi.Int64>().value == this; // coverage:ignore-line
//   }
// }
//
// extension _CastPointer on List<ffi.Pointer> {
//   int indexOfIntValue(int id) {
//     for (var i = 0; i < length; i++) {
//       if (id.isEqualTo(this[i])) {
//         return i;
//       }
//     }
//     return -1;
//   }
// }
