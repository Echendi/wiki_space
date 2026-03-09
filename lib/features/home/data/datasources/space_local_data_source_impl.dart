import '../models/space_article_model.dart';
import 'space_local_data_source.dart';

/// Implementacion local de articulos Home basada en Drift.
class SpaceLocalDataSourceImpl implements SpaceLocalDataSource {
  SpaceLocalDataSourceImpl(this._database);

  final HomeCacheDatabase _database;

  /// Guarda articulos en cache local por idioma.
  @override
  Future<void> cacheArticles(
    String languageCode,
    List<SpaceArticleModel> articles, {
    required bool clearExisting,
  }) {
    return _database.cacheArticles(
      languageCode,
      articles,
      clearExisting: clearExisting,
    );
  }

  /// Consulta articulos cacheados por idioma/query/paginacion.
  @override
  Future<List<SpaceArticleModel>> getCachedArticles(
    String languageCode, {
    String query = '',
    int limit = 24,
    int offset = 0,
  }) {
    return _database.getCachedArticles(
      languageCode,
      query: query,
      limit: limit,
      offset: offset,
    );
  }

  /// Verifica existencia de cache para idioma y query.
  @override
  Future<bool> hasCachedArticles(String languageCode, {String query = ''}) {
    return _database.hasCachedArticles(languageCode, query: query);
  }
}
