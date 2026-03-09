import '../../../../core/network/network_status.dart';

import '../../domain/entities/home_exceptions.dart';
import '../../domain/entities/space_articles_result.dart';
import '../../domain/repositories/space_repository.dart';
import '../datasources/space_local_data_source.dart';
import '../datasources/space_remote_data_source.dart';

/// Repositorio que combina fuente remota y cache local para Home.
class SpaceRepositoryImpl implements SpaceRepository {
  /// Recibe dependencias de fuentes de datos y estado de red.
  SpaceRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkStatus,
  );

  final SpaceRemoteDataSource _remoteDataSource;
  final SpaceLocalDataSource _localDataSource;
  final NetworkStatus _networkStatus;

  /// Obtiene articulos remotos cuando hay red y usa cache como fallback.
  @override
  Future<SpaceArticlesResult> getSpaceArticles(
    String languageCode, {
    String query = '',
    int limit = 24,
    int offset = 0,
  }) async {
    final normalizedQuery = query.trim();
    final hasConnection = await _networkStatus.hasInternetConnection();

    if (hasConnection) {
      try {
        final remoteItems = await _remoteDataSource.fetchSpaceArticles(
          languageCode,
          query: normalizedQuery,
          limit: limit,
          offset: offset,
        );

        await _localDataSource.cacheArticles(
          languageCode,
          remoteItems,
          clearExisting: normalizedQuery.isEmpty && offset == 0,
        );

        return SpaceArticlesResult(
          articles: remoteItems,
          isOfflineMode: false,
          isFromCache: false,
          hasConnection: true,
        );
      } catch (_) {
        // Connectivity may report transport available while internet access
        // is actually unavailable. Fallback to cache before failing.
      }
    }

    final cachedItems = await _localDataSource.getCachedArticles(
      languageCode,
      query: normalizedQuery,
      limit: limit,
      offset: offset,
    );

    if (cachedItems.isEmpty) {
      throw const OfflineNoCachedDataException();
    }

    return SpaceArticlesResult(
      articles: cachedItems,
      isOfflineMode: true,
      isFromCache: true,
      hasConnection: false,
    );
  }
}
