import 'dart:io';

class FileWalker {
  Stream<File> walk(String directoryPath) async* {
    final dir = Directory(directoryPath);
    if (!await dir.exists()) return;

    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        yield entity;
      }
    }
  }
}
