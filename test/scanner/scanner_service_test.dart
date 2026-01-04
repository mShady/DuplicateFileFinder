import 'dart:io';
import 'package:duplicate_file_finder/scanner/scanner_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ScannerService scans files via isolate', () async {
    final tempDir = Directory.systemTemp.createTempSync();
    
    // Create files directly
    File('${tempDir.path}/a.txt').writeAsStringSync('content');
    File('${tempDir.path}/copy.txt').writeAsStringSync('content');

    final service = ScannerService();
    final stream = await service.scan(tempDir.path);
    final events = await stream.toList();
    final files = events.whereType<FileItem>().toList();

    expect(files.length, 2);
    expect(files.any((f) => f.path.endsWith('a.txt')), isTrue);
    expect(files.any((f) => f.path.endsWith('copy.txt')), isTrue);
    expect(files.first.size, greaterThan(0));

    await tempDir.delete(recursive: true);
  });
}
