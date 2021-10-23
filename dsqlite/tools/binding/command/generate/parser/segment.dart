// is segment of text is eligible to be an identifier
final isIdentifier = RegExp(r'[a-zA-Z_0-9]+$');

class Segment {
  late final String raw;

  final int line;
  final int column;
  final int lineOffset;

  Segment(this.raw, this.line, this.column, this.lineOffset);

  @override
  String toString() => raw;
}

class CodeSegmentIterator implements Iterator<Segment> {
  final Iterator<Segment> _iterator;
  final Exception Function(Segment se, {List<String>? expected}) errorHandle;

  CodeSegmentIterator(this._iterator, this.errorHandle) {
    _next = _iterator.moveNext() ? _iterator.current : null;
  }

  Segment? _current;
  Segment? _next;

  @override
  get current => _current!;

  Segment? get peek => _next;

  @override
  bool moveNext() {
    if (_next != null) {
      _current = _next;
      _next = _iterator.moveNext() ? _iterator.current : null;
      return true;
    }
    return false;
  }

  void next() {
    if (!moveNext()) errorHandle(current);
  }

  String identifier({bool next = false}) {
    if (next) this.next();
    if (!isIdentifier.hasMatch(current.raw)) syntaxError();
    return current.raw;
  }

  // purely use to count *
  void occurred(String test, void Function() cb) {
    // skip volatile and const
    while (moveNext()) {
      if (current.raw == test) {
        cb();
        continue;
      }
      if (current.raw == 'volatile' || current.raw == 'const') continue;
      break;
    }
  }

  void skip(List<String> l) {
    while (moveNext() && l.contains(current.raw)) {}
  }

  void expected(List<String> tests) {
    if (!tests.contains(current.raw)) syntaxError();
  }

  Exception syntaxError() => errorHandle(current);
}

class CodeSegments {
  late int _start;
  late int _index;
  late int _next;
  late int _line;
  late int _column;
  late int _lineOffset;
  late String? _ch;

  final String code;
  final bool debug;

  CodeSegments(this.code, {this.debug = false}) {
    if (code.isNotEmpty) {
      _next = 0;
      _line = 1;
      _lineOffset = _column = 0;
      _start = -1;
    } else {
      _next = -1;
      _line = 0;
      _start = _lineOffset = _column = -1;
    }
    _index = _next - 1;
  }

  int get line => _line;

  bool get _hasAnySegment => _start < _index;

  bool get _eof => _next == code.length;

  String get _current => _ch!;

  String? get _peak => _next < code.length ? code[_next] : null;

  bool _moveNext() {
    if (_next < code.length) {
      _index = _next++;
      _ch = code[_index];
      if (_ch == '\n' || _ch == '\r') {
        if (_ch == '\r' && _peak == '\n') _next++;
        _line++;
        _lineOffset = _next;
        _column = 0;
        _ch = '\n';
      } else {
        _column++;
      }
      return true;
    } else {
      _index = code.length;
      _ch = null;
      return false;
    }
  }

  void _mark() => _start = _next;

  int _skipSpace() {
    int count = 0;
    final isAtMarkStart = _start == _index;
    while (!_eof && (_current == ' ' || _current == '\t')) {
      count++;
      _moveNext();
    }
    if (isAtMarkStart) _start = _index;
    return count;
  }

  void _skipUntilWS() {
    while (_current != ' ' &&
        _current != '\t' &&
        _current != '\r' &&
        _current != '\n' &&
        _moveNext()) {}
  }

  bool _skipComment() {
    if (_peak == '*') {
      // skip until */
      _moveNext();
      while (_moveNext()) {
        if (_current == '*' && _peak == '/') {
          // found the end of the comment
          _moveNext();
          _mark();
          return true;
        }
      }
    } else if (_peak == '/') {
      // a single line comment skip until newline
      _moveNext();
      while (_moveNext() && _current != '\n') {}
      _mark();
      return true;
    }
    return false;
  }

  String? _codeSegment() => _hasAnySegment ? code.substring(_start, _index) : null;

  // ====================================

  CodeSegmentIterator get iterator => CodeSegmentIterator(segments().iterator, errorHandler);

  Segment handleWordSegment() {
    if (_start == -1) throw Exception('Forget to mark ?');
    final txt = code.substring(_start, _index);
    _start = -1;
    return Segment(txt, _line, _column, _lineOffset);
  }

  Iterable<Segment> segments() sync* {
    // extract word segment
    _mark();
    loop:
    while (_moveNext()) {
      final validMacro = takeMacros();
      if (validMacro != null) {
        for (final s in validMacro) {
          yield s;
        }
        _mark();
        continue;
      }
      final section = takeSection();
      if (section != null) {
        yield section;
        _mark();
        continue;
      }
      switch (_current) {
        case ' ':
        case '\t':
          if (_hasAnySegment) yield handleWordSegment();
          _mark();
          continue loop;
        case '*':
        case ',':
        case ';':
        case ')':
        case '(':
        case '[':
        case ']':
        case '|':
        case '#':
          if (_hasAnySegment) yield handleWordSegment();
          yield Segment(_current, _line, _column, _lineOffset);
          _mark();
          continue loop;
        case '\n':
          if (_hasAnySegment) yield handleWordSegment();
          _mark();
          continue loop;
        case '/':
          if (_skipComment()) continue loop;
          throw Exception('Error comment syntax at ${code.substring(_lineOffset, _index)}');
      }
    }
    if (_hasAnySegment) yield handleWordSegment();
  }

  Segment? takeSection() {
    if (_current != ':') return null;
    int count = 1, oe = 1, end = -1;
    while (_moveNext()) {
      switch (_current) {
        case ':':
          count += oe;
          if (count == 3) {
            oe = -1;
          } else if (count == 0) {
            end = _next;
          }
          break;
        case '\n':
          if (count != 0 || end == -1 || !_hasAnySegment) return null;
          return handleWordSegment();
        case ' ':
          if (count < 3) return null;
          continue;
      }
    }
    if (_eof) return handleWordSegment();
  }

  // it is not perfect for reading C macro however we only interest in #define or context below
  // #if, #ifndef or #ifdef. The #else, #elif or #elseif most likely is a conditional to the #if
  // case as the environment or platform maybe not support and required a placeholder defined
  List<Segment>? takeMacros() {
    if (_current == '#') {
      _mark();
      _moveNext();
      _skipSpace();
      _skipUntilWS();
      // check if it was define macro other ignore everything
      // we only interest in define macro for constant
      var txt = _codeSegment();
      if (txt == 'define') {
        final defineSegment = handleWordSegment();
        _mark();
        _skipSpace();
        _skipUntilWS();
        // invalid define macro
        final name = _codeSegment();
        // invalid macro identifier
        if (name != null && isIdentifier.hasMatch(name)) {
          final nameSegment = handleWordSegment();
          _mark();
          _moveNext();
          _skipSpace();
          var skipPthCount = 0;
          // special case we do not concern about multiple line or string constant
          // currently SQLite only have marco constant value of number or arithmetic expression only
          valueOrExprLookUp:
          do {
            switch (_current) {
              case '\n':
                if (skipPthCount == 0) {
                  final valueSegment = handleWordSegment();
                  return [defineSegment, nameSegment, valueSegment];
                }
                throw errorHandler(nameSegment);
              case ' ':
                if (skipPthCount == 0) break valueOrExprLookUp;
                break;
              case '(':
                skipPthCount++;
                break;
              case ')':
                skipPthCount--;
                if (skipPthCount == 0) {
                  _moveNext();
                  break valueOrExprLookUp;
                }
            }
          } while (_moveNext());
          if (skipPthCount != 0) throw errorHandler(nameSegment);
          // skip space, maybe better to check tab \t however doc only introduce space
          final valueSegment = handleWordSegment();
          _skipSpace();
          _mark();
          // skip comment if nay
          if (_eof || _current == '\n' || (_current == '/' && _skipComment())) {
            return [defineSegment, nameSegment, valueSegment];
          }
          throw errorHandler(nameSegment);
        }
      }
      // nothing is important here so skip it all
      while (_current != '\r' && _current != '\n' && _moveNext()) {}
      return [];
    }
  }

  Exception errorHandler(Segment se, {List<String>? expected}) {
    var msg = 'Error syntax at ${code.substring(se.lineOffset, se.lineOffset + se.column)}'
        ' near ${se.raw} at ${se.line}:${se.column}.';
    if (expected != null) {
      final exp = expected.length == 1 ? expected[0] : 'once of ${expected.join(', ')}';
      msg = '$msg, expect $exp';
    }
    throw Exception(msg);
  }
}
