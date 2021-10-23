import 'dart:io';

const _escStart = '\x1B[';
const _escEnd = '${_escStart}0m';

const red = AnsiColor('31'), magenta = AnsiColor('35'), cyan = AnsiColor('36');

class AnsiColor {
  const AnsiColor(this.color);

  final String color;

  StringBuffer write(Object object, [StringBuffer? buffer]) {
    buffer ??= StringBuffer();
    buffer.write(_escStart);
    buffer.write('1;${color}m');
    buffer.write(object);
    buffer.write(_escEnd);
    return buffer;
  }
}

class AnsiProgress {
  AnsiProgress([String? message, int? minimum]) {
    if (message == null) {
      print('');
      this.minimum = minimum ?? 0;
    } else {
      print(message);
      this.minimum = minimum ?? message.length;
    }
  }

  late final int minimum;

  StringBuffer write(Object object, [StringBuffer? buffer]) {
    buffer ??= StringBuffer();
    if (minimum > 0) {
      // same line
      buffer.write(_escStart);
      buffer.write('1A'); // move cursor up
      buffer.write(_escStart);
      buffer.write('${minimum}C'); // move cursor forward n character
    } else {
      buffer.write(_escStart);
      buffer.write('1F'); // move cursor up
    }
    buffer.write(object);
    return buffer;
  }
}

extension ListUtility on List<String> {
  String joinWrap({int indent = 0, int length = 80}) {
    if (isEmpty) return '';
    final buffer = StringBuffer();
    final sindent = ''.padRight(indent, ' ');
    length = 0;
    buffer.write(sindent);
    for (var txt in this) {
      length += txt.length + 2; // 2 characters for comma and space
      if (length > 80) {
        buffer.writeln();
        buffer.write(sindent);
        length = txt.length + 2;
      }
      buffer.write(txt);
      buffer.write(', ');
    }
    return buffer.toString().substring(0, buffer.length - 2);
  }
}
