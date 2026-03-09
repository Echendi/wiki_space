part of 'space_local_data_source.dart';

/// Base de datos local de Home para articulos cacheados.
@DriftDatabase(tables: [CachedSpaceArticles])
class HomeCacheDatabase extends _$HomeCacheDatabase {
  /// Inicializa la BD local de Home usando el ejecutor por defecto.
  HomeCacheDatabase() : super(_openConnection());

  /// Version de esquema Drift para migraciones futuras.
  @override
  int get schemaVersion => 1;

  /// Guarda batch de articulos y opcionalmente limpia cache previa.
  Future<void> cacheArticles(
    String languageCode,
    List<SpaceArticleModel> articles, {
    required bool clearExisting,
  }) async {
    if (articles.isEmpty && !clearExisting) {
      return;
    }

    await transaction(() async {
      if (clearExisting) {
        await (delete(cachedSpaceArticles)
              ..where((t) => t.languageCode.equals(languageCode)))
            .go();
      }

      if (articles.isEmpty) {
        return;
      }

      final now = DateTime.now();
      await batch((batch) {
        batch.insertAllOnConflictUpdate(
          cachedSpaceArticles,
          articles
              .where((article) => article.id > 0)
              .map(
                (article) => CachedSpaceArticlesCompanion.insert(
                  pageId: article.id,
                  languageCode: languageCode,
                  title: article.title,
                  description: Value(article.description),
                  imageUrl: Value(article.imageUrl),
                  pageUrl: Value(article.pageUrl),
                  updatedAt: now,
                ),
              )
              .toList(growable: false),
        );
      });
    });
  }

  /// Lee articulos cacheados por idioma, query y paginacion.
  Future<List<SpaceArticleModel>> getCachedArticles(
    String languageCode, {
    String query = '',
    int limit = 24,
    int offset = 0,
  }) async {
    final normalizedQuery = query.trim().toLowerCase();
    final likePattern = '%$normalizedQuery%';

    final request = select(cachedSpaceArticles)
      ..where((t) => t.languageCode.equals(languageCode));

    if (normalizedQuery.isNotEmpty) {
      request.where(
        (t) =>
            t.title.lower().like(likePattern) |
            t.description.lower().like(likePattern),
      );
    }

    request
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
      ..limit(limit, offset: offset);

    final rows = await request.get();
    return rows
        .map(
          (row) => SpaceArticleModel(
            id: row.pageId,
            title: row.title,
            description: row.description,
            imageUrl: row.imageUrl,
            pageUrl: row.pageUrl,
          ),
        )
        .toList(growable: false);
  }

  /// Retorna `true` si existe al menos un articulo cacheado.
  Future<bool> hasCachedArticles(String languageCode,
      {String query = ''}) async {
    final items = await getCachedArticles(
      languageCode,
      query: query,
      limit: 1,
      offset: 0,
    );
    return items.isNotEmpty;
  }
}

/// Abre/crea la base de datos persistente de cache de Home.
QueryExecutor _openConnection() {
  return driftDatabase(name: 'space_home_cache');
}
