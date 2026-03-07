import '../entities/space_article.dart';
import '../repositories/space_repository.dart';

class GetSpaceArticlesUseCase {
  const GetSpaceArticlesUseCase(this._repository);

  final SpaceRepository _repository;

  Future<List<SpaceArticle>> call(
    String languageCode, {
    String query = '',
    int limit = 24,
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
