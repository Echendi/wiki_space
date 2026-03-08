import '../entities/space_article_detail.dart';

/// Contrato de acceso a detalle de articulo independiente de infraestructura.
abstract class ArticleDetailRepository {
  /// Obtiene detalle por identificador visible e idioma.
  Future<SpaceArticleDetail> getArticleDetail(
    String articleId,
    String languageCode,
  );
}
