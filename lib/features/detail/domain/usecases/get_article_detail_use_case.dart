import '../entities/space_article_detail.dart';
import '../repositories/article_detail_repository.dart';

/// Caso de uso para consultar detalle de articulo desde dominio.
class GetArticleDetailUseCase {
  const GetArticleDetailUseCase(this._repository);

  final ArticleDetailRepository _repository;

  /// Ejecuta consulta de detalle para articulo e idioma.
  Future<SpaceArticleDetail> call(String articleId, String languageCode) {
    return _repository.getArticleDetail(articleId, languageCode);
  }
}
