import '../models/space_article_detail_model.dart';
import 'article_detail_local_data_source.dart';

/// Implementacion de [ArticleDetailLocalDataSource] apoyada en Drift.
class ArticleDetailLocalDataSourceImpl implements ArticleDetailLocalDataSource {
  ArticleDetailLocalDataSourceImpl(this._database);

  final ArticleDetailCacheDatabase _database;

  /// Guarda o actualiza cache de detalle para un articulo.
  @override
  Future<void> cacheDetail(String articleId, SpaceArticleDetailModel detail) {
    return _database.cacheDetail(articleId, detail);
  }

  /// Lee detalle cacheado por `articleId` + `languageCode`.
  @override
  Future<SpaceArticleDetailModel?> getCachedDetail(
    String articleId,
    String languageCode,
  ) {
    return _database.getCachedDetail(articleId, languageCode);
  }
}
