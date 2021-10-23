import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';

import 'sha3.dart';
import 'util.dart';

class DownloadTracker extends Converter<List<int>, List<int>> implements ByteConversionSinkBase {
  DownloadTracker(this.totalSize, this.progressMsg, [this.onData]);

  late final Sink<List<int>> _sink;

  final void Function(List<int>)? onData;
  final AnsiProgress progressMsg;

  final int totalSize;
  var progress = 0;

  @override
  List<int> convert(input) {
    progress += input.length;
    if (onData != null) onData!(input);
    print(progressMsg.write('${((progress * 100) / totalSize).toStringAsFixed(2)}%').toString());
    return input;
  }

  @override
  ByteConversionSinkBase startChunkedConversion(Sink<List<int>> sink) {
    if (sink is! DownloadTracker) {
      _sink = sink;
    }
    return this;
  }

  @override
  void add(List<int> chunk) => _sink.add(convert(chunk));

  @override
  void close() => _sink.close();

  @override
  void addSlice(List<int> chunk, int start, int end, bool isLast) {
    add(chunk.sublist(start, end));
    if (isLast) close();
  }
}

final sourceFile = ['build', 'sqlite.zip'].join(Platform.pathSeparator);
final sourceDir = ['build', 'sqlite'].join(Platform.pathSeparator);

Future<void> downloadSource(String year, String dversion, String version, [String? verify]) async {
  final url = Uri.parse('https://sqlite.org/$year/sqlite-amalgamation-$dversion.zip');
  final cacheFile = File(sourceFile);
  final response = await (await HttpClient().getUrl(url)).close();
  if (response.statusCode != 200) {
    print(red.write('Unable to download sqlite $url.').toString());
    exit(1);
  }
  // let download
  SHA3? sha3;
  late final DownloadTracker dt;
  print('Target sqlite $url');
  final msg = 'Download sqlite amalgamation $version ... ';
  final progress = AnsiProgress(cyan.write(msg).toString(), msg.length);
  if (verify != null) {
    sha3 = SHA3(256, 256);
    dt = DownloadTracker(response.contentLength, progress, (data) => sha3!.update(data));
  } else {
    dt = DownloadTracker(response.contentLength, progress);
  }
  await response.transform(dt).pipe(cacheFile.openWrite());
  if (sha3 != null) {
    sha3.finalize();
    final dhex = hex.convert(sha3.digest());
    if (dhex != verify) {
      print(red.write('Invalid content expect SHA3 $verify but get $dhex.').toString());
      exit(2);
    }
  }
}

Future<void> extractSource() async {
  final input = File(sourceFile).readAsBytesSync();
  // Decode the Zip file
  final archive = ZipDecoder().decodeBytes(input);
  // Extract the contents of the Zip archive to disk.
  print('Extract source file @$sourceDir from @$sourceFile ...');
  for (final file in archive) {
    final outName = sourceDir + Platform.pathSeparator + file.name;
    if (file.isFile) {
      print('   extract $outName ...');
      final data = file.content as List<int>;
      File(outName)
        ..createSync(recursive: true)
        ..writeAsBytesSync(data);
    } else {
      Directory(outName).create(recursive: true);
    }
  }
}
