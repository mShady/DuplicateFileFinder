import 'dart:io';
import 'package:crypto/crypto.dart';

class FileUtils {
  static Future<String> calculateFileHash(File file) async {
    final stream = file.openRead();
    final digest = await sha256.bind(stream).first;
    return digest.toString();
  }
}
