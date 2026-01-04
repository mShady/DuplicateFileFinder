import 'dart:io';
import 'package:crypto/crypto.dart';

class FileUtils {
  static Future<String> calculateFileHash(File file) async {
    final stream = file.openRead();
    final digest = await sha256.bind(stream).first;
    return digest.toString();
  }

  static Future<String> calculatePartialHash(File file) async {
    final len = await file.length();
    final end = len < 4096 ? len : 4096;
    if (end == 0) return ''; // Empty file

    final stream = file.openRead(0, end);
    final digest = await sha256.bind(stream).first;
    return digest.toString();
  }
}
