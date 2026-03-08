import '../../../../core/network/network_status.dart';

import '../../domain/entities/detail_exceptions.dart';
import '../../domain/entities/space_article_detail.dart';
import '../../domain/repositories/article_detail_repository.dart';
import '../datasources/article_detail_local_data_source.dart';
import '../datasources/article_detail_remote_data_source.dart';

/// Repositorio de detalle con estrategia online-first y fallback local.
class ArticleDetailRepositoryImpl implements ArticleDetailRepository {
  const ArticleDetailRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkStatus,
  );

  final ArticleDetailRemoteDataSource _remoteDataSource;
  final ArticleDetailLocalDataSource _localDataSource;
  final NetworkStatus _networkStatus;

  /// Obtiene detalle remoto cuando hay internet; si falla usa cache local.
  @override
  Future<SpaceArticleDetail> getArticleDetail(
    String articleId,
    String languageCode,
  ) async {
    final hasConnection = await _networkStatus.hasInternetConnection();

    if (hasConnection) {
      try {
        final remoteDetail =
            await _remoteDataSource.fetchArticleDetail(articleId, languageCode);
        await _localDataSource.cacheDetail(articleId, remoteDetail);
        return remoteDetail;
      } catch (_) {
        // Transport can be available while internet access is not.
        // Try cache before surfacing an error.
      }
    }

    final cachedDetail =
        await _localDataSource.getCachedDetail(articleId, languageCode);
    if (cachedDetail != null) {
      return cachedDetail;
    }

    throw const OfflineNoCachedDetailException();
  }
}
