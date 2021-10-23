// ***************************************************************
// **************** GENERATED CODE DOT NOT MODIFY ****************
// ***************************************************************

part of 'library.g.dart';

typedef _def_sqlite3_aggregate_context = int Function(int, int);
typedef _def_sqlite3_user_data = int Function(int);

// Mixin for Context
mixin _MixinContext on _SQLiteLibrary {
  late final _def_sqlite3_aggregate_context _h_sqlite3_aggregate_context =
      _wasm.cwrap('sqlite3_aggregate_context', 'number', ['number', 'number']);

  late final _def_sqlite3_user_data _h_sqlite3_user_data =
      _wasm.cwrap('sqlite3_user_data', 'number', ['number']);

  PtrVoid? aggregate_context(PtrContext arg1, int nBytes) {
    var result = _h_sqlite3_aggregate_context(arg1.address, nBytes);
    return result == 0 ? null : Pointer.fromAddress(result);
  }

  PtrVoid? user_data(PtrContext arg1) {
    var result = _h_sqlite3_user_data(arg1.address);
    return result == 0 ? null : Pointer.fromAddress(result);
  }
}
