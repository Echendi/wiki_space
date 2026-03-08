import '../models/space_article_detail_model.dart';

/// Contrato de origen remoto para detalle de articulos.
abstract class ArticleDetailRemoteDataSource {
  /// Solicita detalle de articulo por titulo/id visible e idioma.
  Future<SpaceArticleDetailModel> fetchArticleDetail(
    String articleId,
    String languageCode,
  );
}
