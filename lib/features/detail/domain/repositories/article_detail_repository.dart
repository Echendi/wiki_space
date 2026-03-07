import '../entities/space_article_detail.dart';

abstract class ArticleDetailRepository {
  Future<SpaceArticleDetail> getArticleDetail(
    String articleId,
    String languageCode,
  );
}
