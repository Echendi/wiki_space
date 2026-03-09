import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/space_article_model.dart';

part 'space_local_data_source.g.dart';
part 'cached_space_articles.dart';
part 'home_cache_database.dart';

/// Contrato de acceso a cache local de articulos espaciales.
abstract class SpaceLocalDataSource {
  /// Guarda articulos en cache por idioma.
  Future<void> cacheArticles(
    String languageCode,
    List<SpaceArticleModel> articles, {
    required bool clearExisting,
  });

  /// Recupera articulos cacheados filtrando por query, pagina y limite.
  Future<List<SpaceArticleModel>> getCachedArticles(
    String languageCode, {
    String query,
    int limit,
    int offset,
  });

  /// Indica si existe al menos un elemento cacheado para idioma/query.
  Future<bool> hasCachedArticles(String languageCode, {String query});
}
