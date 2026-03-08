import '../entities/space_articles_result.dart';
import '../repositories/space_repository.dart';

class GetSpaceArticlesUseCase {
  const GetSpaceArticlesUseCase(this._repository);

  final SpaceRepository _repository;

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
