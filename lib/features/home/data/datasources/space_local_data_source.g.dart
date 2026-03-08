// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_local_data_source.dart';

// ignore_for_file: type=lint
class $CachedSpaceArticlesTable extends CachedSpaceArticles
    with TableInfo<$CachedSpaceArticlesTable, CachedSpaceArticle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedSpaceArticlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pageIdMeta = const VerificationMeta('pageId');
  @override
  late final GeneratedColumn<int> pageId = GeneratedColumn<int>(
      'page_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _languageCodeMeta =
      const VerificationMeta('languageCode');
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
      'language_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _pageUrlMeta =
      const VerificationMeta('pageUrl');
  @override
  late final GeneratedColumn<String> pageUrl = GeneratedColumn<String>(
      'page_url', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [pageId, languageCode, title, description, imageUrl, pageUrl, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_space_articles';
  @override
  VerificationContext validateIntegrity(Insertable<CachedSpaceArticle> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('page_id')) {
      context.handle(_pageIdMeta,
          pageId.isAcceptableOrUnknown(data['page_id']!, _pageIdMeta));
    } else if (isInserting) {
      context.missing(_pageIdMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
          _languageCodeMeta,
          languageCode.isAcceptableOrUnknown(
              data['language_code']!, _languageCodeMeta));
    } else if (isInserting) {
      context.missing(_languageCodeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('page_url')) {
      context.handle(_pageUrlMeta,
          pageUrl.isAcceptableOrUnknown(data['page_url']!, _pageUrlMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {pageId, languageCode};
  @override
  CachedSpaceArticle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedSpaceArticle(
      pageId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}page_id'])!,
      languageCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language_code'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url'])!,
      pageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}page_url'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CachedSpaceArticlesTable createAlias(String alias) {
    return $CachedSpaceArticlesTable(attachedDatabase, alias);
  }
}

class CachedSpaceArticle extends DataClass
    implements Insertable<CachedSpaceArticle> {
  final int pageId;
  final String languageCode;
  final String title;
  final String description;
  final String imageUrl;
  final String pageUrl;
  final DateTime updatedAt;
  const CachedSpaceArticle(
      {required this.pageId,
      required this.languageCode,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.pageUrl,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['page_id'] = Variable<int>(pageId);
    map['language_code'] = Variable<String>(languageCode);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['image_url'] = Variable<String>(imageUrl);
    map['page_url'] = Variable<String>(pageUrl);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CachedSpaceArticlesCompanion toCompanion(bool nullToAbsent) {
    return CachedSpaceArticlesCompanion(
      pageId: Value(pageId),
      languageCode: Value(languageCode),
      title: Value(title),
      description: Value(description),
      imageUrl: Value(imageUrl),
      pageUrl: Value(pageUrl),
      updatedAt: Value(updatedAt),
    );
  }

  factory CachedSpaceArticle.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedSpaceArticle(
      pageId: serializer.fromJson<int>(json['pageId']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      pageUrl: serializer.fromJson<String>(json['pageUrl']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pageId': serializer.toJson<int>(pageId),
      'languageCode': serializer.toJson<String>(languageCode),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'pageUrl': serializer.toJson<String>(pageUrl),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CachedSpaceArticle copyWith(
          {int? pageId,
          String? languageCode,
          String? title,
          String? description,
          String? imageUrl,
          String? pageUrl,
          DateTime? updatedAt}) =>
      CachedSpaceArticle(
        pageId: pageId ?? this.pageId,
        languageCode: languageCode ?? this.languageCode,
        title: title ?? this.title,
        description: description ?? this.description,
        imageUrl: imageUrl ?? this.imageUrl,
        pageUrl: pageUrl ?? this.pageUrl,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CachedSpaceArticle copyWithCompanion(CachedSpaceArticlesCompanion data) {
    return CachedSpaceArticle(
      pageId: data.pageId.present ? data.pageId.value : this.pageId,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      pageUrl: data.pageUrl.present ? data.pageUrl.value : this.pageUrl,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedSpaceArticle(')
          ..write('pageId: $pageId, ')
          ..write('languageCode: $languageCode, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('pageUrl: $pageUrl, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      pageId, languageCode, title, description, imageUrl, pageUrl, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedSpaceArticle &&
          other.pageId == this.pageId &&
          other.languageCode == this.languageCode &&
          other.title == this.title &&
          other.description == this.description &&
          other.imageUrl == this.imageUrl &&
          other.pageUrl == this.pageUrl &&
          other.updatedAt == this.updatedAt);
}

class CachedSpaceArticlesCompanion extends UpdateCompanion<CachedSpaceArticle> {
  final Value<int> pageId;
  final Value<String> languageCode;
  final Value<String> title;
  final Value<String> description;
  final Value<String> imageUrl;
  final Value<String> pageUrl;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CachedSpaceArticlesCompanion({
    this.pageId = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.pageUrl = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedSpaceArticlesCompanion.insert({
    required int pageId,
    required String languageCode,
    required String title,
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.pageUrl = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : pageId = Value(pageId),
        languageCode = Value(languageCode),
        title = Value(title),
        updatedAt = Value(updatedAt);
  static Insertable<CachedSpaceArticle> custom({
    Expression<int>? pageId,
    Expression<String>? languageCode,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? imageUrl,
    Expression<String>? pageUrl,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (pageId != null) 'page_id': pageId,
      if (languageCode != null) 'language_code': languageCode,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
      if (pageUrl != null) 'page_url': pageUrl,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedSpaceArticlesCompanion copyWith(
      {Value<int>? pageId,
      Value<String>? languageCode,
      Value<String>? title,
      Value<String>? description,
      Value<String>? imageUrl,
      Value<String>? pageUrl,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return CachedSpaceArticlesCompanion(
      pageId: pageId ?? this.pageId,
      languageCode: languageCode ?? this.languageCode,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      pageUrl: pageUrl ?? this.pageUrl,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pageId.present) {
      map['page_id'] = Variable<int>(pageId.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (pageUrl.present) {
      map['page_url'] = Variable<String>(pageUrl.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedSpaceArticlesCompanion(')
          ..write('pageId: $pageId, ')
          ..write('languageCode: $languageCode, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('pageUrl: $pageUrl, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$HomeCacheDatabase extends GeneratedDatabase {
  _$HomeCacheDatabase(QueryExecutor e) : super(e);
  $HomeCacheDatabaseManager get managers => $HomeCacheDatabaseManager(this);
  late final $CachedSpaceArticlesTable cachedSpaceArticles =
      $CachedSpaceArticlesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cachedSpaceArticles];
}

typedef $$CachedSpaceArticlesTableCreateCompanionBuilder
    = CachedSpaceArticlesCompanion Function({
  required int pageId,
  required String languageCode,
  required String title,
  Value<String> description,
  Value<String> imageUrl,
  Value<String> pageUrl,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$CachedSpaceArticlesTableUpdateCompanionBuilder
    = CachedSpaceArticlesCompanion Function({
  Value<int> pageId,
  Value<String> languageCode,
  Value<String> title,
  Value<String> description,
  Value<String> imageUrl,
  Value<String> pageUrl,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$CachedSpaceArticlesTableFilterComposer
    extends Composer<_$HomeCacheDatabase, $CachedSpaceArticlesTable> {
  $$CachedSpaceArticlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get pageId => $composableBuilder(
      column: $table.pageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get languageCode => $composableBuilder(
      column: $table.languageCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pageUrl => $composableBuilder(
      column: $table.pageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$CachedSpaceArticlesTableOrderingComposer
    extends Composer<_$HomeCacheDatabase, $CachedSpaceArticlesTable> {
  $$CachedSpaceArticlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get pageId => $composableBuilder(
      column: $table.pageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get languageCode => $composableBuilder(
      column: $table.languageCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pageUrl => $composableBuilder(
      column: $table.pageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CachedSpaceArticlesTableAnnotationComposer
    extends Composer<_$HomeCacheDatabase, $CachedSpaceArticlesTable> {
  $$CachedSpaceArticlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get pageId =>
      $composableBuilder(column: $table.pageId, builder: (column) => column);

  GeneratedColumn<String> get languageCode => $composableBuilder(
      column: $table.languageCode, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get pageUrl =>
      $composableBuilder(column: $table.pageUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CachedSpaceArticlesTableTableManager extends RootTableManager<
    _$HomeCacheDatabase,
    $CachedSpaceArticlesTable,
    CachedSpaceArticle,
    $$CachedSpaceArticlesTableFilterComposer,
    $$CachedSpaceArticlesTableOrderingComposer,
    $$CachedSpaceArticlesTableAnnotationComposer,
    $$CachedSpaceArticlesTableCreateCompanionBuilder,
    $$CachedSpaceArticlesTableUpdateCompanionBuilder,
    (
      CachedSpaceArticle,
      BaseReferences<_$HomeCacheDatabase, $CachedSpaceArticlesTable,
          CachedSpaceArticle>
    ),
    CachedSpaceArticle,
    PrefetchHooks Function()> {
  $$CachedSpaceArticlesTableTableManager(
      _$HomeCacheDatabase db, $CachedSpaceArticlesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedSpaceArticlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedSpaceArticlesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedSpaceArticlesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> pageId = const Value.absent(),
            Value<String> languageCode = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> imageUrl = const Value.absent(),
            Value<String> pageUrl = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedSpaceArticlesCompanion(
            pageId: pageId,
            languageCode: languageCode,
            title: title,
            description: description,
            imageUrl: imageUrl,
            pageUrl: pageUrl,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int pageId,
            required String languageCode,
            required String title,
            Value<String> description = const Value.absent(),
            Value<String> imageUrl = const Value.absent(),
            Value<String> pageUrl = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedSpaceArticlesCompanion.insert(
            pageId: pageId,
            languageCode: languageCode,
            title: title,
            description: description,
            imageUrl: imageUrl,
            pageUrl: pageUrl,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedSpaceArticlesTableProcessedTableManager = ProcessedTableManager<
    _$HomeCacheDatabase,
    $CachedSpaceArticlesTable,
    CachedSpaceArticle,
    $$CachedSpaceArticlesTableFilterComposer,
    $$CachedSpaceArticlesTableOrderingComposer,
    $$CachedSpaceArticlesTableAnnotationComposer,
    $$CachedSpaceArticlesTableCreateCompanionBuilder,
    $$CachedSpaceArticlesTableUpdateCompanionBuilder,
    (
      CachedSpaceArticle,
      BaseReferences<_$HomeCacheDatabase, $CachedSpaceArticlesTable,
          CachedSpaceArticle>
    ),
    CachedSpaceArticle,
    PrefetchHooks Function()>;

class $HomeCacheDatabaseManager {
  final _$HomeCacheDatabase _db;
  $HomeCacheDatabaseManager(this._db);
  $$CachedSpaceArticlesTableTableManager get cachedSpaceArticles =>
      $$CachedSpaceArticlesTableTableManager(_db, _db.cachedSpaceArticles);
}
