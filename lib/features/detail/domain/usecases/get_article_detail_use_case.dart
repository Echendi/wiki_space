import '../entities/space_article_detail.dart';
import '../repositories/article_detail_repository.dart';

class GetArticleDetailUseCase {
  const GetArticleDetailUseCase(this._repository);

  final ArticleDetailRepository _repository;

  Future<SpaceArticleDetail> call(String articleId, String languageCode) {
    return _repository.getArticleDetail(articleId, languageCode);
  }
}
