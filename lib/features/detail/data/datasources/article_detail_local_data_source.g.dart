// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_detail_local_data_source.dart';

// ignore_for_file: type=lint
class $CachedArticleDetailsTable extends CachedArticleDetails
    with TableInfo<$CachedArticleDetailsTable, CachedArticleDetail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedArticleDetailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _articleIdMeta =
      const VerificationMeta('articleId');
  @override
  late final GeneratedColumn<String> articleId = GeneratedColumn<String>(
      'article_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _languageCodeMeta =
      const VerificationMeta('languageCode');
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
      'language_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pageIdMeta = const VerificationMeta('pageId');
  @override
  late final GeneratedColumn<int> pageId = GeneratedColumn<int>(
      'page_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, false,
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
  static const VerificationMeta _articleLastUpdatedMeta =
      const VerificationMeta('articleLastUpdated');
  @override
  late final GeneratedColumn<DateTime> articleLastUpdated =
      GeneratedColumn<DateTime>('article_last_updated', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _cachedAtMeta =
      const VerificationMeta('cachedAt');
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
      'cached_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        articleId,
        languageCode,
        pageId,
        title,
        summary,
        imageUrl,
        pageUrl,
        articleLastUpdated,
        cachedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_article_details';
  @override
  VerificationContext validateIntegrity(
      Insertable<CachedArticleDetail> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('article_id')) {
      context.handle(_articleIdMeta,
          articleId.isAcceptableOrUnknown(data['article_id']!, _articleIdMeta));
    } else if (isInserting) {
      context.missing(_articleIdMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
          _languageCodeMeta,
          languageCode.isAcceptableOrUnknown(
              data['language_code']!, _languageCodeMeta));
    } else if (isInserting) {
      context.missing(_languageCodeMeta);
    }
    if (data.containsKey('page_id')) {
      context.handle(_pageIdMeta,
          pageId.isAcceptableOrUnknown(data['page_id']!, _pageIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('page_url')) {
      context.handle(_pageUrlMeta,
          pageUrl.isAcceptableOrUnknown(data['page_url']!, _pageUrlMeta));
    }
    if (data.containsKey('article_last_updated')) {
      context.handle(
          _articleLastUpdatedMeta,
          articleLastUpdated.isAcceptableOrUnknown(
              data['article_last_updated']!, _articleLastUpdatedMeta));
    }
    if (data.containsKey('cached_at')) {
      context.handle(_cachedAtMeta,
          cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta));
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {articleId, languageCode};
  @override
  CachedArticleDetail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedArticleDetail(
      articleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}article_id'])!,
      languageCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language_code'])!,
      pageId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}page_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary'])!,
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url'])!,
      pageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}page_url'])!,
      articleLastUpdated: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}article_last_updated']),
      cachedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}cached_at'])!,
    );
  }

  @override
  $CachedArticleDetailsTable createAlias(String alias) {
    return $CachedArticleDetailsTable(attachedDatabase, alias);
  }
}

class CachedArticleDetail extends DataClass
    implements Insertable<CachedArticleDetail> {
  final String articleId;
  final String languageCode;
  final int pageId;
  final String title;
  final String summary;
  final String imageUrl;
  final String pageUrl;
  final DateTime? articleLastUpdated;
  final DateTime cachedAt;
  const CachedArticleDetail(
      {required this.articleId,
      required this.languageCode,
      required this.pageId,
      required this.title,
      required this.summary,
      required this.imageUrl,
      required this.pageUrl,
      this.articleLastUpdated,
      required this.cachedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['article_id'] = Variable<String>(articleId);
    map['language_code'] = Variable<String>(languageCode);
    map['page_id'] = Variable<int>(pageId);
    map['title'] = Variable<String>(title);
    map['summary'] = Variable<String>(summary);
    map['image_url'] = Variable<String>(imageUrl);
    map['page_url'] = Variable<String>(pageUrl);
    if (!nullToAbsent || articleLastUpdated != null) {
      map['article_last_updated'] = Variable<DateTime>(articleLastUpdated);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CachedArticleDetailsCompanion toCompanion(bool nullToAbsent) {
    return CachedArticleDetailsCompanion(
      articleId: Value(articleId),
      languageCode: Value(languageCode),
      pageId: Value(pageId),
      title: Value(title),
      summary: Value(summary),
      imageUrl: Value(imageUrl),
      pageUrl: Value(pageUrl),
      articleLastUpdated: articleLastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(articleLastUpdated),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedArticleDetail.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedArticleDetail(
      articleId: serializer.fromJson<String>(json['articleId']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      pageId: serializer.fromJson<int>(json['pageId']),
      title: serializer.fromJson<String>(json['title']),
      summary: serializer.fromJson<String>(json['summary']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      pageUrl: serializer.fromJson<String>(json['pageUrl']),
      articleLastUpdated:
          serializer.fromJson<DateTime?>(json['articleLastUpdated']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'articleId': serializer.toJson<String>(articleId),
      'languageCode': serializer.toJson<String>(languageCode),
      'pageId': serializer.toJson<int>(pageId),
      'title': serializer.toJson<String>(title),
      'summary': serializer.toJson<String>(summary),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'pageUrl': serializer.toJson<String>(pageUrl),
      'articleLastUpdated': serializer.toJson<DateTime?>(articleLastUpdated),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedArticleDetail copyWith(
          {String? articleId,
          String? languageCode,
          int? pageId,
          String? title,
          String? summary,
          String? imageUrl,
          String? pageUrl,
          Value<DateTime?> articleLastUpdated = const Value.absent(),
          DateTime? cachedAt}) =>
      CachedArticleDetail(
        articleId: articleId ?? this.articleId,
        languageCode: languageCode ?? this.languageCode,
        pageId: pageId ?? this.pageId,
        title: title ?? this.title,
        summary: summary ?? this.summary,
        imageUrl: imageUrl ?? this.imageUrl,
        pageUrl: pageUrl ?? this.pageUrl,
        articleLastUpdated: articleLastUpdated.present
            ? articleLastUpdated.value
            : this.articleLastUpdated,
        cachedAt: cachedAt ?? this.cachedAt,
      );
  CachedArticleDetail copyWithCompanion(CachedArticleDetailsCompanion data) {
    return CachedArticleDetail(
      articleId: data.articleId.present ? data.articleId.value : this.articleId,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      pageId: data.pageId.present ? data.pageId.value : this.pageId,
      title: data.title.present ? data.title.value : this.title,
      summary: data.summary.present ? data.summary.value : this.summary,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      pageUrl: data.pageUrl.present ? data.pageUrl.value : this.pageUrl,
      articleLastUpdated: data.articleLastUpdated.present
          ? data.articleLastUpdated.value
          : this.articleLastUpdated,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedArticleDetail(')
          ..write('articleId: $articleId, ')
          ..write('languageCode: $languageCode, ')
          ..write('pageId: $pageId, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('pageUrl: $pageUrl, ')
          ..write('articleLastUpdated: $articleLastUpdated, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(articleId, languageCode, pageId, title,
      summary, imageUrl, pageUrl, articleLastUpdated, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedArticleDetail &&
          other.articleId == this.articleId &&
          other.languageCode == this.languageCode &&
          other.pageId == this.pageId &&
          other.title == this.title &&
          other.summary == this.summary &&
          other.imageUrl == this.imageUrl &&
          other.pageUrl == this.pageUrl &&
          other.articleLastUpdated == this.articleLastUpdated &&
          other.cachedAt == this.cachedAt);
}

class CachedArticleDetailsCompanion
    extends UpdateCompanion<CachedArticleDetail> {
  final Value<String> articleId;
  final Value<String> languageCode;
  final Value<int> pageId;
  final Value<String> title;
  final Value<String> summary;
  final Value<String> imageUrl;
  final Value<String> pageUrl;
  final Value<DateTime?> articleLastUpdated;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const CachedArticleDetailsCompanion({
    this.articleId = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.pageId = const Value.absent(),
    this.title = const Value.absent(),
    this.summary = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.pageUrl = const Value.absent(),
    this.articleLastUpdated = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedArticleDetailsCompanion.insert({
    required String articleId,
    required String languageCode,
    this.pageId = const Value.absent(),
    required String title,
    this.summary = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.pageUrl = const Value.absent(),
    this.articleLastUpdated = const Value.absent(),
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  })  : articleId = Value(articleId),
        languageCode = Value(languageCode),
        title = Value(title),
        cachedAt = Value(cachedAt);
  static Insertable<CachedArticleDetail> custom({
    Expression<String>? articleId,
    Expression<String>? languageCode,
    Expression<int>? pageId,
    Expression<String>? title,
    Expression<String>? summary,
    Expression<String>? imageUrl,
    Expression<String>? pageUrl,
    Expression<DateTime>? articleLastUpdated,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (articleId != null) 'article_id': articleId,
      if (languageCode != null) 'language_code': languageCode,
      if (pageId != null) 'page_id': pageId,
      if (title != null) 'title': title,
      if (summary != null) 'summary': summary,
      if (imageUrl != null) 'image_url': imageUrl,
      if (pageUrl != null) 'page_url': pageUrl,
      if (articleLastUpdated != null)
        'article_last_updated': articleLastUpdated,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedArticleDetailsCompanion copyWith(
      {Value<String>? articleId,
      Value<String>? languageCode,
      Value<int>? pageId,
      Value<String>? title,
      Value<String>? summary,
      Value<String>? imageUrl,
      Value<String>? pageUrl,
      Value<DateTime?>? articleLastUpdated,
      Value<DateTime>? cachedAt,
      Value<int>? rowid}) {
    return CachedArticleDetailsCompanion(
      articleId: articleId ?? this.articleId,
      languageCode: languageCode ?? this.languageCode,
      pageId: pageId ?? this.pageId,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      imageUrl: imageUrl ?? this.imageUrl,
      pageUrl: pageUrl ?? this.pageUrl,
      articleLastUpdated: articleLastUpdated ?? this.articleLastUpdated,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (articleId.present) {
      map['article_id'] = Variable<String>(articleId.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (pageId.present) {
      map['page_id'] = Variable<int>(pageId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (pageUrl.present) {
      map['page_url'] = Variable<String>(pageUrl.value);
    }
    if (articleLastUpdated.present) {
      map['article_last_updated'] =
          Variable<DateTime>(articleLastUpdated.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedArticleDetailsCompanion(')
          ..write('articleId: $articleId, ')
          ..write('languageCode: $languageCode, ')
          ..write('pageId: $pageId, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('pageUrl: $pageUrl, ')
          ..write('articleLastUpdated: $articleLastUpdated, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ArticleDetailCacheDatabase extends GeneratedDatabase {
  _$ArticleDetailCacheDatabase(QueryExecutor e) : super(e);
  $ArticleDetailCacheDatabaseManager get managers =>
      $ArticleDetailCacheDatabaseManager(this);
  late final $CachedArticleDetailsTable cachedArticleDetails =
      $CachedArticleDetailsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cachedArticleDetails];
}

typedef $$CachedArticleDetailsTableCreateCompanionBuilder
    = CachedArticleDetailsCompanion Function({
  required String articleId,
  required String languageCode,
  Value<int> pageId,
  required String title,
  Value<String> summary,
  Value<String> imageUrl,
  Value<String> pageUrl,
  Value<DateTime?> articleLastUpdated,
  required DateTime cachedAt,
  Value<int> rowid,
});
typedef $$CachedArticleDetailsTableUpdateCompanionBuilder
    = CachedArticleDetailsCompanion Function({
  Value<String> articleId,
  Value<String> languageCode,
  Value<int> pageId,
  Value<String> title,
  Value<String> summary,
  Value<String> imageUrl,
  Value<String> pageUrl,
  Value<DateTime?> articleLastUpdated,
  Value<DateTime> cachedAt,
  Value<int> rowid,
});

class $$CachedArticleDetailsTableFilterComposer
    extends Composer<_$ArticleDetailCacheDatabase, $CachedArticleDetailsTable> {
  $$CachedArticleDetailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get articleId => $composableBuilder(
      column: $table.articleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get languageCode => $composableBuilder(
      column: $table.languageCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pageId => $composableBuilder(
      column: $table.pageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pageUrl => $composableBuilder(
      column: $table.pageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get articleLastUpdated => $composableBuilder(
      column: $table.articleLastUpdated,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnFilters(column));
}

class $$CachedArticleDetailsTableOrderingComposer
    extends Composer<_$ArticleDetailCacheDatabase, $CachedArticleDetailsTable> {
  $$CachedArticleDetailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get articleId => $composableBuilder(
      column: $table.articleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get languageCode => $composableBuilder(
      column: $table.languageCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pageId => $composableBuilder(
      column: $table.pageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pageUrl => $composableBuilder(
      column: $table.pageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get articleLastUpdated => $composableBuilder(
      column: $table.articleLastUpdated,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnOrderings(column));
}

class $$CachedArticleDetailsTableAnnotationComposer
    extends Composer<_$ArticleDetailCacheDatabase, $CachedArticleDetailsTable> {
  $$CachedArticleDetailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get articleId =>
      $composableBuilder(column: $table.articleId, builder: (column) => column);

  GeneratedColumn<String> get languageCode => $composableBuilder(
      column: $table.languageCode, builder: (column) => column);

  GeneratedColumn<int> get pageId =>
      $composableBuilder(column: $table.pageId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get pageUrl =>
      $composableBuilder(column: $table.pageUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get articleLastUpdated => $composableBuilder(
      column: $table.articleLastUpdated, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CachedArticleDetailsTableTableManager extends RootTableManager<
    _$ArticleDetailCacheDatabase,
    $CachedArticleDetailsTable,
    CachedArticleDetail,
    $$CachedArticleDetailsTableFilterComposer,
    $$CachedArticleDetailsTableOrderingComposer,
    $$CachedArticleDetailsTableAnnotationComposer,
    $$CachedArticleDetailsTableCreateCompanionBuilder,
    $$CachedArticleDetailsTableUpdateCompanionBuilder,
    (
      CachedArticleDetail,
      BaseReferences<_$ArticleDetailCacheDatabase, $CachedArticleDetailsTable,
          CachedArticleDetail>
    ),
    CachedArticleDetail,
    PrefetchHooks Function()> {
  $$CachedArticleDetailsTableTableManager(
      _$ArticleDetailCacheDatabase db, $CachedArticleDetailsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedArticleDetailsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedArticleDetailsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedArticleDetailsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> articleId = const Value.absent(),
            Value<String> languageCode = const Value.absent(),
            Value<int> pageId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> summary = const Value.absent(),
            Value<String> imageUrl = const Value.absent(),
            Value<String> pageUrl = const Value.absent(),
            Value<DateTime?> articleLastUpdated = const Value.absent(),
            Value<DateTime> cachedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedArticleDetailsCompanion(
            articleId: articleId,
            languageCode: languageCode,
            pageId: pageId,
            title: title,
            summary: summary,
            imageUrl: imageUrl,
            pageUrl: pageUrl,
            articleLastUpdated: articleLastUpdated,
            cachedAt: cachedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String articleId,
            required String languageCode,
            Value<int> pageId = const Value.absent(),
            required String title,
            Value<String> summary = const Value.absent(),
            Value<String> imageUrl = const Value.absent(),
            Value<String> pageUrl = const Value.absent(),
            Value<DateTime?> articleLastUpdated = const Value.absent(),
            required DateTime cachedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedArticleDetailsCompanion.insert(
            articleId: articleId,
            languageCode: languageCode,
            pageId: pageId,
            title: title,
            summary: summary,
            imageUrl: imageUrl,
            pageUrl: pageUrl,
            articleLastUpdated: articleLastUpdated,
            cachedAt: cachedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedArticleDetailsTableProcessedTableManager
    = ProcessedTableManager<
        _$ArticleDetailCacheDatabase,
        $CachedArticleDetailsTable,
        CachedArticleDetail,
        $$CachedArticleDetailsTableFilterComposer,
        $$CachedArticleDetailsTableOrderingComposer,
        $$CachedArticleDetailsTableAnnotationComposer,
        $$CachedArticleDetailsTableCreateCompanionBuilder,
        $$CachedArticleDetailsTableUpdateCompanionBuilder,
        (
          CachedArticleDetail,
          BaseReferences<_$ArticleDetailCacheDatabase,
              $CachedArticleDetailsTable, CachedArticleDetail>
        ),
        CachedArticleDetail,
        PrefetchHooks Function()>;

class $ArticleDetailCacheDatabaseManager {
  final _$ArticleDetailCacheDatabase _db;
  $ArticleDetailCacheDatabaseManager(this._db);
  $$CachedArticleDetailsTableTableManager get cachedArticleDetails =>
      $$CachedArticleDetailsTableTableManager(_db, _db.cachedArticleDetails);
}
