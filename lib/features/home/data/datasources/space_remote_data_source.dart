import '../models/space_article_model.dart';

/// Contrato de fuente remota para articulos de Home.
abstract class SpaceRemoteDataSource {
  /// Recupera articulos para un idioma con soporte de query y paginacion.
  Future<List<SpaceArticleModel>> fetchSpaceArticles(
    String languageCode, {
    String query,
    int limit,
    int offset,
  });
}
