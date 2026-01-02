import 'package:drift/drift.dart';

class FileRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get path => text()();
  IntColumn get size => integer()();
  DateTimeColumn get modifiedAt => dateTime()();
  TextColumn get hash => text().nullable()();
}
