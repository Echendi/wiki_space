import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/space_article_detail_model.dart';

part 'article_detail_local_data_source.g.dart';
part 'cached_article_details.dart';
part 'article_detail_cache_database.dart';

/// Contrato para cache local de detalles de articulos.
abstract class ArticleDetailLocalDataSource {
  /// Guarda o actualiza en cache el detalle de un articulo.
  Future<void> cacheDetail(String articleId, SpaceArticleDetailModel detail);

  /// Recupera detalle cacheado por articulo e idioma, o `null` si no existe.
  Future<SpaceArticleDetailModel?> getCachedDetail(
    String articleId,
    String languageCode,
  );
}
