import '../../domain/entities/space_article.dart';
import '../../domain/repositories/space_repository.dart';
import '../datasources/space_remote_data_source.dart';

class SpaceRepositoryImpl implements SpaceRepository {
  SpaceRepositoryImpl(this._remoteDataSource);

  final SpaceRemoteDataSource _remoteDataSource;

  @override
  Future<List<SpaceArticle>> getSpaceArticles(
    String languageCode, {
    String query = '',
    int limit = 24,
    int offset = 0,
  }) {
    return _remoteDataSource.fetchSpaceArticles(
      languageCode,
      query: query,
      limit: limit,
      offset: offset,
    );
  }
}
