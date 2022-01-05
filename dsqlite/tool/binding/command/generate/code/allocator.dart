import 'package:code_builder/code_builder.dart' as cb;

class PrefixedAllocator implements cb.Allocator {
  static const _doNotPrefix = ['dart:core'];

  bool emitImport;
  bool emitTypeReference;

  final Map<String, String> _knownImport;
  final _imports = <String, String>{};
  var _keys = 1;

  PrefixedAllocator(this.emitImport, [this._knownImport = const {}]) : emitTypeReference = false;

  @override
  String allocate(cb.Reference reference) {
    String typeGeneric = '';
    if (emitTypeReference && reference is cb.TypeReference && reference.types.isNotEmpty) {
      typeGeneric = '<${reference.types.map((e) => allocate(e)).join(', ')}>';
    }
    final symbol = reference.symbol;
    final url = reference.url;
    if (url == null || _doNotPrefix.contains(url)) {
      return '$symbol$typeGeneric';
    }
    if (_knownImport[url] != null) {
      return '${_imports.putIfAbsent(url, () => _knownImport[url]!)}.$symbol$typeGeneric';
    }
    return '${_imports.putIfAbsent(url, _nextKey)}.$symbol$typeGeneric';
  }

  String _nextKey() => '_i${_keys++}';

  @override
  Iterable<cb.Directive> get imports =>
      emitImport ? _imports.keys.map((u) => cb.Directive.import(u, as: _imports[u])) : [];
}
