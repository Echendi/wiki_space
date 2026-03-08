part of 'article_detail_local_data_source.dart';

/// Base de datos Drift para persistencia local de detalles.
@DriftDatabase(tables: [CachedArticleDetails])
class ArticleDetailCacheDatabase extends _$ArticleDetailCacheDatabase {
  ArticleDetailCacheDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// Inserta o actualiza una entrada de cache de detalle.
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

  /// Obtiene detalle cacheado por articulo/idioma.
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
