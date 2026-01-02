import 'package:duplicate_file_finder/platform/native_actions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('com.example.duplicateFileFinder/native');
  final NativeActions nativeActions = NativeActions();

  test('moveToTrash invokes correct platform method', () async {
    final List<MethodCall> log = <MethodCall>[];
    
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      log.add(methodCall);
      return true;
    });

    await nativeActions.moveToTrash('/tmp/test.txt');

    expect(log, hasLength(1));
    expect(log.single.method, 'moveToTrash');
    expect(log.single.arguments, '/tmp/test.txt');
  });
}
