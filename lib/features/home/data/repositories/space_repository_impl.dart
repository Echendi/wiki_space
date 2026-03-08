import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/entities/home_exceptions.dart';
import '../../domain/entities/space_articles_result.dart';
import '../../domain/repositories/space_repository.dart';
import '../datasources/space_local_data_source.dart';
import '../datasources/space_remote_data_source.dart';

class SpaceRepositoryImpl implements SpaceRepository {
  SpaceRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._connectivity,
  );

  final SpaceRemoteDataSource _remoteDataSource;
  final SpaceLocalDataSource _localDataSource;
  final Connectivity _connectivity;

  @override
  Future<SpaceArticlesResult> getSpaceArticles(
    String languageCode, {
    String query = '',
    int limit = 24,
    int offset = 0,
  }) async {
    final normalizedQuery = query.trim();
    final hasConnection = await _hasInternetConnection();

    if (hasConnection) {
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

  Future<bool> _hasInternetConnection() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }
}
