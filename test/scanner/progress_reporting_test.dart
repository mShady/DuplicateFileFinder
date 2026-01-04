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
    
    // Verify walking phase
    final walkingEvents = progressEvents.where((e) => e.phase == ScanPhase.walking).toList();
    expect(walkingEvents.isNotEmpty, isTrue);
    
    int lastCount = -1;
    for (final p in walkingEvents) {
      expect(p.scannedCount, greaterThanOrEqualTo(lastCount));
      lastCount = p.scannedCount;
    }
    expect(lastCount, equals(50));

    // Verify hashing phase (all files have same size 0, so all go to stage 2)
    final hashingEvents = progressEvents.where((e) => e.phase == ScanPhase.hashing).toList();
    expect(hashingEvents.isNotEmpty, isTrue);

    lastCount = -1;
    for (final p in hashingEvents) {
      expect(p.scannedCount, greaterThanOrEqualTo(lastCount));
      lastCount = p.scannedCount;
    }
    expect(lastCount, equals(50));

    await tempDir.delete(recursive: true);
  });
}
