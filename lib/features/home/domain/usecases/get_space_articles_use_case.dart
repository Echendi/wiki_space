import '../entities/space_article.dart';
import '../repositories/space_repository.dart';

class GetSpaceArticlesUseCase {
  const GetSpaceArticlesUseCase(this._repository);

  final SpaceRepository _repository;

  Future<List<SpaceArticle>> call(String languageCode) {
    return _repository.getSpaceArticles(languageCode);
  }
}
