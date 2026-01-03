import 'dart:io';
import 'package:duplicate_file_finder/scanner/file_walker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FileWalker streams files from directory', () async {
    final tempDir = Directory.systemTemp.createTempSync();
    File('${tempDir.path}/a.txt').createSync();
    File('${tempDir.path}/b.txt').createSync();
    Directory('${tempDir.path}/subdir').createSync();
    File('${tempDir.path}/subdir/c.txt').createSync();

    final walker = FileWalker();
    final files = await walker.walk(tempDir.path).toList();

    expect(files.length, 3);
    expect(files.any((f) => f.path.endsWith('a.txt')), isTrue);
    expect(files.any((f) => f.path.endsWith('b.txt')), isTrue);
    expect(files.any((f) => f.path.endsWith('c.txt')), isTrue);

    await tempDir.delete(recursive: true);
  });
}
