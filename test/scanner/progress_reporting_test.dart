import 'dart:io';
import 'package:duplicate_file_finder/scanner/scanner_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ScannerService emits progress events', () async {
    final tempDir = Directory.systemTemp.createTempSync();
    
    // Create 50 files with identical content to trigger Stage 2
    for (var i = 0; i < 50; i++) {
      File('${tempDir.path}/file_$i.txt').writeAsStringSync('constant_content');
    }
    
    final service = ScannerService();
    final stream = await service.scan(tempDir.path);
    
    final events = await stream.toList();
    final progressEvents = events.whereType<ScanProgress>().toList();
    
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

    // Verify hashing phase
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
