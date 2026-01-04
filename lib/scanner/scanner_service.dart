import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:duplicate_file_finder/scanner/file_walker.dart';
import 'package:duplicate_file_finder/utils/file_utils.dart';

abstract class ScanEvent {}

class ScanProgress extends ScanEvent {
  final int scannedCount;
  final String currentFile;
  ScanProgress({required this.scannedCount, required this.currentFile});
}

class FileItem extends ScanEvent {
  final String path;
  final int size;
  final DateTime modified;

  FileItem({required this.path, required this.size, required this.modified});
}

class ScannerService {
  Future<Stream<ScanEvent>> scan(String directoryPath) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_isolateEntryPoint, receivePort.sendPort);
    
    final streamController = StreamController<ScanEvent>();
    
    // Wait for the isolate to send its SendPort
    final isolateSendPort = await receivePort.first as SendPort;
    
    // Create a new ReceivePort for results
    final resultPort = ReceivePort();
    isolateSendPort.send(_ScanRequest(directoryPath, resultPort.sendPort));
    
    resultPort.listen((message) {
      if (message is _ScanComplete) {
        streamController.close();
        resultPort.close();
        receivePort.close();
      } else if (message is ScanEvent) {
        streamController.add(message);
      }
    });
    
    return streamController.stream;
  }

  static void _isolateEntryPoint(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    
    receivePort.listen((message) async {
      if (message is _ScanRequest) {
        final walker = FileWalker();
        final Map<int, List<FileItem>> filesBySize = {};
        int scannedCount = 0;

        await for (final file in walker.walk(message.path)) {
           scannedCount++;
           // Emit progress every 10 files or for the first one
           if (scannedCount == 1 || scannedCount % 10 == 0) {
             message.replyPort.send(ScanProgress(
               scannedCount: scannedCount,
               currentFile: file.path,
             ));
           }

           try {
             final stat = await file.stat();
             final item = FileItem(
               path: file.path,
               size: stat.size,
               modified: stat.modified,
             );
             filesBySize.putIfAbsent(item.size, () => []).add(item);
           } catch (e) {
             // Ignore access errors
           }
        }
        
        // Send final progress
        message.replyPort.send(ScanProgress(
           scannedCount: scannedCount,
           currentFile: "Scanning complete",
        ));

        // Stage 1: Filter by size
        for (final entry in filesBySize.entries) {
          if (entry.value.length > 1) {
            // Stage 2: Filter by partial hash
            final Map<String, List<FileItem>> filesByPartialHash = {};

            for (final item in entry.value) {
              try {
                final hash = await FileUtils.calculatePartialHash(File(item.path));
                filesByPartialHash.putIfAbsent(hash, () => []).add(item);
              } catch (e) {
                // Ignore hash errors
              }
            }

            for (final hashEntry in filesByPartialHash.entries) {
              if (hashEntry.value.length > 1) {
                for (final item in hashEntry.value) {
                  message.replyPort.send(item);
                }
              }
            }
          }
        }

        message.replyPort.send(_ScanComplete());
      }
    });
  }
}

class _ScanRequest {
  final String path;
  final SendPort replyPort;
  _ScanRequest(this.path, this.replyPort);
}

class _ScanComplete {}