// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FileRecordsTable extends FileRecords
    with TableInfo<$FileRecordsTable, FileRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FileRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
    'size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedAtMeta = const VerificationMeta(
    'modifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
    'modified_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<String> hash = GeneratedColumn<String>(
    'hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, path, size, modifiedAt, hash];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'file_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<FileRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('size')) {
      context.handle(
        _sizeMeta,
        size.isAcceptableOrUnknown(data['size']!, _sizeMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
        _modifiedAtMeta,
        modifiedAt.isAcceptableOrUnknown(data['modified_at']!, _modifiedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    if (data.containsKey('hash')) {
      context.handle(
        _hashMeta,
        hash.isAcceptableOrUnknown(data['hash']!, _hashMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FileRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FileRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size'],
      )!,
      modifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified_at'],
      )!,
      hash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hash'],
      ),
    );
  }

  @override
  $FileRecordsTable createAlias(String alias) {
    return $FileRecordsTable(attachedDatabase, alias);
  }
}

class FileRecord extends DataClass implements Insertable<FileRecord> {
  final int id;
  final String path;
  final int size;
  final DateTime modifiedAt;
  final String? hash;
  const FileRecord({
    required this.id,
    required this.path,
    required this.size,
    required this.modifiedAt,
    this.hash,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['path'] = Variable<String>(path);
    map['size'] = Variable<int>(size);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    if (!nullToAbsent || hash != null) {
      map['hash'] = Variable<String>(hash);
    }
    return map;
  }

  FileRecordsCompanion toCompanion(bool nullToAbsent) {
    return FileRecordsCompanion(
      id: Value(id),
      path: Value(path),
      size: Value(size),
      modifiedAt: Value(modifiedAt),
      hash: hash == null && nullToAbsent ? const Value.absent() : Value(hash),
    );
  }

  factory FileRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FileRecord(
      id: serializer.fromJson<int>(json['id']),
      path: serializer.fromJson<String>(json['path']),
      size: serializer.fromJson<int>(json['size']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
      hash: serializer.fromJson<String?>(json['hash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'path': serializer.toJson<String>(path),
      'size': serializer.toJson<int>(size),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
      'hash': serializer.toJson<String?>(hash),
    };
  }

  FileRecord copyWith({
    int? id,
    String? path,
    int? size,
    DateTime? modifiedAt,
    Value<String?> hash = const Value.absent(),
  }) => FileRecord(
    id: id ?? this.id,
    path: path ?? this.path,
    size: size ?? this.size,
    modifiedAt: modifiedAt ?? this.modifiedAt,
    hash: hash.present ? hash.value : this.hash,
  );
  FileRecord copyWithCompanion(FileRecordsCompanion data) {
    return FileRecord(
      id: data.id.present ? data.id.value : this.id,
      path: data.path.present ? data.path.value : this.path,
      size: data.size.present ? data.size.value : this.size,
      modifiedAt: data.modifiedAt.present
          ? data.modifiedAt.value
          : this.modifiedAt,
      hash: data.hash.present ? data.hash.value : this.hash,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FileRecord(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('size: $size, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('hash: $hash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, path, size, modifiedAt, hash);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FileRecord &&
          other.id == this.id &&
          other.path == this.path &&
          other.size == this.size &&
          other.modifiedAt == this.modifiedAt &&
          other.hash == this.hash);
}

class FileRecordsCompanion extends UpdateCompanion<FileRecord> {
  final Value<int> id;
  final Value<String> path;
  final Value<int> size;
  final Value<DateTime> modifiedAt;
  final Value<String?> hash;
  const FileRecordsCompanion({
    this.id = const Value.absent(),
    this.path = const Value.absent(),
    this.size = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.hash = const Value.absent(),
  });
  FileRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String path,
    required int size,
    required DateTime modifiedAt,
    this.hash = const Value.absent(),
  }) : path = Value(path),
       size = Value(size),
       modifiedAt = Value(modifiedAt);
  static Insertable<FileRecord> custom({
    Expression<int>? id,
    Expression<String>? path,
    Expression<int>? size,
    Expression<DateTime>? modifiedAt,
    Expression<String>? hash,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (path != null) 'path': path,
      if (size != null) 'size': size,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (hash != null) 'hash': hash,
    });
  }

  FileRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? path,
    Value<int>? size,
    Value<DateTime>? modifiedAt,
    Value<String?>? hash,
  }) {
    return FileRecordsCompanion(
      id: id ?? this.id,
      path: path ?? this.path,
      size: size ?? this.size,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      hash: hash ?? this.hash,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FileRecordsCompanion(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('size: $size, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('hash: $hash')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FileRecordsTable fileRecords = $FileRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [fileRecords];
}

typedef $$FileRecordsTableCreateCompanionBuilder =
    FileRecordsCompanion Function({
      Value<int> id,
      required String path,
      required int size,
      required DateTime modifiedAt,
      Value<String?> hash,
    });
typedef $$FileRecordsTableUpdateCompanionBuilder =
    FileRecordsCompanion Function({
      Value<int> id,
      Value<String> path,
      Value<int> size,
      Value<DateTime> modifiedAt,
      Value<String?> hash,
    });

class $$FileRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $FileRecordsTable> {
  $$FileRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FileRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $FileRecordsTable> {
  $$FileRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FileRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FileRecordsTable> {
  $$FileRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<int> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hash =>
      $composableBuilder(column: $table.hash, builder: (column) => column);
}

class $$FileRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FileRecordsTable,
          FileRecord,
          $$FileRecordsTableFilterComposer,
          $$FileRecordsTableOrderingComposer,
          $$FileRecordsTableAnnotationComposer,
          $$FileRecordsTableCreateCompanionBuilder,
          $$FileRecordsTableUpdateCompanionBuilder,
          (
            FileRecord,
            BaseReferences<_$AppDatabase, $FileRecordsTable, FileRecord>,
          ),
          FileRecord,
          PrefetchHooks Function()
        > {
  $$FileRecordsTableTableManager(_$AppDatabase db, $FileRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FileRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FileRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FileRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<int> size = const Value.absent(),
                Value<DateTime> modifiedAt = const Value.absent(),
                Value<String?> hash = const Value.absent(),
              }) => FileRecordsCompanion(
                id: id,
                path: path,
                size: size,
                modifiedAt: modifiedAt,
                hash: hash,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String path,
                required int size,
                required DateTime modifiedAt,
                Value<String?> hash = const Value.absent(),
              }) => FileRecordsCompanion.insert(
                id: id,
                path: path,
                size: size,
                modifiedAt: modifiedAt,
                hash: hash,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FileRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FileRecordsTable,
      FileRecord,
      $$FileRecordsTableFilterComposer,
      $$FileRecordsTableOrderingComposer,
      $$FileRecordsTableAnnotationComposer,
      $$FileRecordsTableCreateCompanionBuilder,
      $$FileRecordsTableUpdateCompanionBuilder,
      (
        FileRecord,
        BaseReferences<_$AppDatabase, $FileRecordsTable, FileRecord>,
      ),
      FileRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FileRecordsTableTableManager get fileRecords =>
      $$FileRecordsTableTableManager(_db, _db.fileRecords);
}
