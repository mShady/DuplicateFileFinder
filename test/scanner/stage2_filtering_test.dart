import 'dart:io';
import 'package:duplicate_file_finder/scanner/scanner_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ScannerService filters out unique partial hashes (Stage 2)', () async {
    final tempDir = Directory.systemTemp.createTempSync();
    
    // Create files with same size (10 bytes)
    final fileA = File('${tempDir.path}/a.txt');
    final fileB = File('${tempDir.path}/b.txt'); // Diff header
    final fileC = File('${tempDir.path}/c.txt'); // Same header as A

    // A: 5 bytes "AAAAA" + 5 bytes "AAAAA"
    fileA.writeAsStringSync('AAAAA' 'AAAAA'); 
    
    // B: 5 bytes "BBBBB" + 5 bytes "BBBBB" (Same size 10, diff header)
    fileB.writeAsStringSync('BBBBB' 'BBBBB'); 
    
    // C: 5 bytes "AAAAA" + 5 bytes "CCCCC" (Same size 10, same header "AAAAA" if chunk < 5?? No 4KB)
    // Wait, partial hash reads 4KB.
    // My files are 10 bytes. So it reads everything.
    // So "Partial Hash" == "Full Hash" for small files.
    // To test "Partial" specific logic, I need files > 4KB.
    
    // Let's make files 5000 bytes.
    // A: 4096 'A' + rest 'A'
    // B: 4096 'B' + rest 'B' (Diff header)
    // C: 4096 'A' + rest 'C' (Same header as A, diff rest)
    
    final contentA = List.filled(4096, 65) + List.filled(904, 65); // All 'A'
    fileA.writeAsBytesSync(contentA);
    
    final contentB = List.filled(4096, 66) + List.filled(904, 66); // All 'B'
    fileB.writeAsBytesSync(contentB);
    
    final contentC = List.filled(4096, 65) + List.filled(904, 67); // Header 'A', rest 'C'
    fileC.writeAsBytesSync(contentC);
    
    final service = ScannerService();
    final stream = await service.scan(tempDir.path);
    final files = await stream.toList();
    
    final paths = files.map((f) => f.path).toList();
    
    // Stage 1 (Size): All have size 5000. So all pass Stage 1.
    // Stage 2 (Partial Hash): 
    // A has header 'A...'. Hash(A_header)
    // B has header 'B...'. Hash(B_header) != Hash(A_header)
    // C has header 'A...'. Hash(C_header) == Hash(A_header)
    
    // Result: A and C share partial hash. B is unique.
    // So B should be filtered out. A and C returned.
    
    expect(paths, contains(fileA.path));
    expect(paths, contains(fileC.path));
    expect(paths, isNot(contains(fileB.path)));
    expect(files.length, 2);

    await tempDir.delete(recursive: true);
  });
}
