import 'dart:io';
import 'package:duplicate_file_finder/scanner/scanner_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ScannerService filters out unique files (Stage 1)', () async {
    final tempDir = Directory.systemTemp.createTempSync();
    
    // Create files
    final fileA = File('${tempDir.path}/a.txt');
    final fileB = File('${tempDir.path}/b.txt'); // Unique size
    final fileC = File('${tempDir.path}/c.txt');
    
    fileA.writeAsStringSync('12345'); // Size 5
    fileB.writeAsStringSync('1234567890'); // Size 10
    fileC.writeAsStringSync('12345'); // Size 5 (same as A, same content)
    
    final service = ScannerService();
    final stream = await service.scan(tempDir.path);
    final files = await stream.toList();
    
    // Expect A and C to be present, B to be absent
    final paths = files.map((f) => f.path).toList();
    
    expect(paths, contains(fileA.path));
    expect(paths, contains(fileC.path));
    expect(paths, isNot(contains(fileB.path)));
    expect(files.length, 2);

    await tempDir.delete(recursive: true);
  });
}
