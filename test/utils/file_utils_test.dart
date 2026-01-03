import 'dart:io';
import 'package:duplicate_file_finder/utils/file_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('calculateFileHash returns correct SHA-256 hash', () async {
    final tempDir = Directory.systemTemp.createTempSync();
    final file = File('${tempDir.path}/test_file.txt');
    await file.writeAsString('Hello World');

    // Echo -n "Hello World" | shasum -a 256
    // a591a6d40bf420404a011733cfb7b190d62c65bf0bcda32b57b277d9ad9f146e
    const expectedHash = 'a591a6d40bf420404a011733cfb7b190d62c65bf0bcda32b57b277d9ad9f146e';

    final hash = await FileUtils.calculateFileHash(file);
    
    expect(hash, expectedHash);

    await tempDir.delete(recursive: true);
  });
}
