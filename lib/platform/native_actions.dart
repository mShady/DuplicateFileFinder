import 'package:flutter/services.dart';

class NativeActions {
  static const MethodChannel _channel = MethodChannel('com.example.duplicateFileFinder/native');

  Future<bool> moveToTrash(String filePath) async {
    try {
      final bool? result = await _channel.invokeMethod<bool>('moveToTrash', filePath);
      return result ?? false;
    } on PlatformException catch (_) {
      return false;
    }
  }
}
