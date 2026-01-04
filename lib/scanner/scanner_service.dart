import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:duplicate_file_finder/scanner/file_walker.dart';
import 'package:duplicate_file_finder/utils/file_utils.dart';

abstract class ScanEvent {}

enum ScanPhase {
  walking,
  hashing,
}

class ScanProgress extends ScanEvent {
  final int scannedCount;
  final String currentFile;
  final ScanPhase phase;
  
  ScanProgress({
    required this.scannedCount,
    required this.currentFile,
    required this.phase,
  });
}

class ScanError extends ScanEvent {
  final String message;
  final String? path;
  ScanError({required this.message, this.path});
}

class FileItem extends ScanEvent {
  final String path;
  final int size;
  final DateTime modified;

  FileItem({required this.path, required this.size, required this.modified});
}

class ScannerService {
  static const int progressInterval = 10;

  Future<Stream<ScanEvent>> scan(String directoryPath, {int maxStage = 2}) async {
    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(_isolateEntryPoint, receivePort.sendPort);
    
    final streamController = StreamController<ScanEvent>();
    
    // Ensure isolate is killed if the stream is cancelled by UI
    streamController.onCancel = () {
      isolate.kill(priority: Isolate.immediate);
      receivePort.close();
    };
    
    // Wait for the isolate to send its SendPort
    final isolateSendPort = await receivePort.first as SendPort;
    
    // Create a new ReceivePort for results
    final resultPort = ReceivePort();
    isolateSendPort.send(_ScanRequest(directoryPath, resultPort.sendPort, maxStage));
    
    resultPort.listen(
      (message) {
        if (message is _ScanComplete) {
          streamController.close();
          resultPort.close();
          receivePort.close();
        } else if (message is ScanEvent) {
          streamController.add(message);
        }
      },
      onError: (error) {
        streamController.addError(error);
      },
      onDone: () {
        if (!streamController.isClosed) {
          streamController.close();
        }
      },
    );
    
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
           // Emit progress every N files or for the first one
           if (scannedCount == 1 || scannedCount % ScannerService.progressInterval == 0) {
             message.replyPort.send(ScanProgress(
               scannedCount: scannedCount,
               currentFile: file.path,
               phase: ScanPhase.walking,
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
             message.replyPort.send(ScanError(
               message: "Failed to stat file",
               path: file.path,
             ));
           }
        }
        
        // Send final progress for walking phase
        message.replyPort.send(ScanProgress(
           scannedCount: scannedCount,
           currentFile: "",
           phase: ScanPhase.walking,
        ));

        // Stage 1: Filter by size
        // If maxStage is 0 (walking only) we'd stop here? But usually we want duplicates.
        // Let's assume maxStage 1 means "Filter by Size" and return results.
        
        int hashedCount = 0;
        for (final entry in filesBySize.entries) {
          if (entry.value.length > 1) {
            
            if (message.maxStage < 2) {
              // Just return size duplicates if limited to Stage 1
              for (final item in entry.value) {
                message.replyPort.send(item);
              }
              continue;
            }

            // Stage 2: Filter by partial hash
            final Map<String, List<FileItem>> filesByPartialHash = {};

            for (final item in entry.value) {
              hashedCount++;
              if (hashedCount == 1 || hashedCount % ScannerService.progressInterval == 0) {
                 message.replyPort.send(ScanProgress(
                   scannedCount: hashedCount,
                   currentFile: item.path,
                   phase: ScanPhase.hashing,
                 ));
              }

              try {
                final hash = await FileUtils.calculatePartialHash(File(item.path));
                filesByPartialHash.putIfAbsent(hash, () => []).add(item);
              } catch (e) {
                message.replyPort.send(ScanError(
                  message: "Failed to calculate partial hash",
                  path: item.path,
                ));
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

        // Send final progress for hashing phase only if we did it
        if (message.maxStage >= 2) {
          message.replyPort.send(ScanProgress(
             scannedCount: hashedCount,
             currentFile: "",
             phase: ScanPhase.hashing,
          ));
        }

        message.replyPort.send(_ScanComplete());
      }
    });
  }
}

class _ScanRequest {
  final String path;
  final SendPort replyPort;
  final int maxStage;
  _ScanRequest(this.path, this.replyPort, this.maxStage);
}

class _ScanComplete {}