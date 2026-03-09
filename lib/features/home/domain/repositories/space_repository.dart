import '../entities/space_articles_result.dart';

/// Contrato del repositorio de articulos para la feature Home.
abstract class SpaceRepository {
  /// Obtiene articulos por idioma, query y ventana de paginacion.
  Future<SpaceArticlesResult> getSpaceArticles(
    String languageCode, {
    String query,
    int limit,
    int offset,
  });
}
