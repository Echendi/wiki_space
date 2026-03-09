import '../entities/space_articles_result.dart';
import '../repositories/space_repository.dart';

/// Caso de uso que expone la carga de articulos para Home.
class GetSpaceArticlesUseCase {
  /// Recibe el repositorio que resuelve remoto/cache.
  const GetSpaceArticlesUseCase(this._repository);

  final SpaceRepository _repository;

  /// Ejecuta la consulta paginada de articulos.
  Future<SpaceArticlesResult> call(
    String languageCode, {
    String query = '',
    int limit = 5,
    int offset = 0,
  }) {
    return _repository.getSpaceArticles(
      languageCode,
      query: query,
      limit: limit,
      offset: offset,
    );
  }
}
