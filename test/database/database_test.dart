import 'package:duplicate_file_finder/database/database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('can insert and read a file record', () async {
    final file = FileRecordsCompanion.insert(
      path: '/tmp/test.txt',
      size: 1024,
      modifiedAt: DateTime.now(),
      hash: const Value('abc123hash'),
    );

    await database.into(database.fileRecords).insert(file);

    final allFiles = await database.select(database.fileRecords).get();
    expect(allFiles.length, 1);
    expect(allFiles.first.path, '/tmp/test.txt');
  });
}
