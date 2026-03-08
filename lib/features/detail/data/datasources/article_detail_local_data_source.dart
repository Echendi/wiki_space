import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/space_article_detail_model.dart';

part 'article_detail_local_data_source.g.dart';

abstract class ArticleDetailLocalDataSource {
  Future<void> cacheDetail(String articleId, SpaceArticleDetailModel detail);

  Future<SpaceArticleDetailModel?> getCachedDetail(
    String articleId,
    String languageCode,
  );
}

class ArticleDetailLocalDataSourceImpl implements ArticleDetailLocalDataSource {
  ArticleDetailLocalDataSourceImpl(this._database);

  final ArticleDetailCacheDatabase _database;

  @override
  Future<void> cacheDetail(String articleId, SpaceArticleDetailModel detail) {
    return _database.cacheDetail(articleId, detail);
  }

  @override
  Future<SpaceArticleDetailModel?> getCachedDetail(
    String articleId,
    String languageCode,
  ) {
    return _database.getCachedDetail(articleId, languageCode);
  }
}

class CachedArticleDetails extends Table {
  TextColumn get articleId => text()();

  TextColumn get languageCode => text()();

  IntColumn get pageId => integer().withDefault(const Constant(0))();

  TextColumn get title => text()();

  TextColumn get summary => text().withDefault(const Constant(''))();

  TextColumn get imageUrl => text().withDefault(const Constant(''))();

  TextColumn get pageUrl => text().withDefault(const Constant(''))();

  DateTimeColumn get articleLastUpdated => dateTime().nullable()();

  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {articleId, languageCode};
}

@DriftDatabase(tables: [CachedArticleDetails])
class ArticleDetailCacheDatabase extends _$ArticleDetailCacheDatabase {
  ArticleDetailCacheDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> cacheDetail(String articleId, SpaceArticleDetailModel detail) {
    return into(cachedArticleDetails).insertOnConflictUpdate(
      CachedArticleDetailsCompanion.insert(
        articleId: articleId,
        languageCode: detail.languageCode,
        pageId: Value(detail.articleId),
        title: detail.title,
        summary: Value(detail.summary),
        imageUrl: Value(detail.imageUrl),
        pageUrl: Value(detail.pageUrl),
        articleLastUpdated: Value(detail.lastUpdatedAt),
        cachedAt: DateTime.now(),
      ),
    );
  }

  Future<SpaceArticleDetailModel?> getCachedDetail(
    String articleId,
    String languageCode,
  ) async {
    final row = await (select(cachedArticleDetails)
          ..where((t) =>
              t.articleId.equals(articleId) &
              t.languageCode.equals(languageCode))
          ..limit(1))
        .getSingleOrNull();

    if (row == null) {
      return null;
    }

    return SpaceArticleDetailModel(
      articleId: row.pageId,
      title: row.title,
      summary: row.summary,
      imageUrl: row.imageUrl,
      pageUrl: row.pageUrl,
      languageCode: row.languageCode,
      lastUpdatedAt: row.articleLastUpdated,
    );
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'space_detail_cache');
}
