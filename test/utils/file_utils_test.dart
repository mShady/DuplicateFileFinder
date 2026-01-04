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

  test('calculatePartialHash reads only first 4KB', () async {
    final tempDir = Directory.systemTemp.createTempSync();
    final file = File('${tempDir.path}/large_file.txt');
    
    // Create content larger than 4KB (4096 bytes)
    // 5000 bytes. First 4096 are 'A', rest are 'B'.
    final content = List.filled(4096, 65) + List.filled(904, 66); // 65='A', 66='B'
    await file.writeAsBytes(content);

    // File 2: Same first 4KB, different rest
    final file2 = File('${tempDir.path}/large_file_2.txt');
    final content2 = List.filled(4096, 65) + List.filled(904, 67); // 67='C'
    await file2.writeAsBytes(content2);

    final hash1 = await FileUtils.calculatePartialHash(file);
    final hash2 = await FileUtils.calculatePartialHash(file2);

    expect(hash1, hash2); // Should be equal because headers match

    // File 3: Different header
    final file3 = File('${tempDir.path}/large_file_3.txt');
    final content3 = List.filled(4096, 66) + List.filled(904, 66);
    await file3.writeAsBytes(content3);
    
    final hash3 = await FileUtils.calculatePartialHash(file3);
    expect(hash1, isNot(hash3));

    await tempDir.delete(recursive: true);
  });
}
