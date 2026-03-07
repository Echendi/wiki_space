import '../../domain/entities/space_article_detail.dart';
import '../../domain/repositories/article_detail_repository.dart';
import '../datasources/article_detail_remote_data_source.dart';

class ArticleDetailRepositoryImpl implements ArticleDetailRepository {
  const ArticleDetailRepositoryImpl(this._remoteDataSource);

  final ArticleDetailRemoteDataSource _remoteDataSource;

  @override
  Future<SpaceArticleDetail> getArticleDetail(
    String articleId,
    String languageCode,
  ) {
    return _remoteDataSource.fetchArticleDetail(articleId, languageCode);
  }
}
