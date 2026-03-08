import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/entities/detail_exceptions.dart';
import '../../domain/entities/space_article_detail.dart';
import '../../domain/repositories/article_detail_repository.dart';
import '../datasources/article_detail_local_data_source.dart';
import '../datasources/article_detail_remote_data_source.dart';

class ArticleDetailRepositoryImpl implements ArticleDetailRepository {
  const ArticleDetailRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._connectivity,
  );

  final ArticleDetailRemoteDataSource _remoteDataSource;
  final ArticleDetailLocalDataSource _localDataSource;
  final Connectivity _connectivity;

  @override
  Future<SpaceArticleDetail> getArticleDetail(
    String articleId,
    String languageCode,
  ) async {
    final results = await _connectivity.checkConnectivity();
    final hasConnection =
        results.any((result) => result != ConnectivityResult.none);

    if (hasConnection) {
      final remoteDetail =
          await _remoteDataSource.fetchArticleDetail(articleId, languageCode);
      await _localDataSource.cacheDetail(articleId, remoteDetail);
      return remoteDetail;
    }

    final cachedDetail =
        await _localDataSource.getCachedDetail(articleId, languageCode);
    if (cachedDetail != null) {
      return cachedDetail;
    }

    throw const OfflineNoCachedDetailException();
  }
}
