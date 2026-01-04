import 'dart:io';
import 'package:duplicate_file_finder/scanner/scanner_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ScannerService emits progress events', () async {
    final tempDir = Directory.systemTemp.createTempSync();
    
    // Create 50 files
    for (var i = 0; i < 50; i++) {
      File('${tempDir.path}/file_$i.txt').createSync();
    }
    
    final service = ScannerService();
    final stream = await service.scan(tempDir.path);
    
    final events = await stream.toList();
    final progressEvents = events.whereType<ScanProgress>().toList();
    
    // Verify we got some progress events
    // (Implementation detail: we might not emit for EVERY file, but should emit SOME)
    // If I implement "emit every 10 files", I expect at least 4-5 events.
    // If I implement "emit every file", 50 events.
    // Let's expect at least 1 event if > 0 files.
    
    expect(progressEvents.isNotEmpty, isTrue);
    
    // Verify count increases
    int lastCount = -1;
    for (final p in progressEvents) {
      expect(p.scannedCount, greaterThanOrEqualTo(lastCount));
      expect(p.phase, equals(ScanPhase.walking));
      lastCount = p.scannedCount;
    }
    
    expect(lastCount, equals(50)); // Should report total at end? Or close to it.

    await tempDir.delete(recursive: true);
  });
}
