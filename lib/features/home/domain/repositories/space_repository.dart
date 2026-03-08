import '../entities/space_articles_result.dart';

abstract class SpaceRepository {
  Future<SpaceArticlesResult> getSpaceArticles(
    String languageCode, {
    String query,
    int limit,
    int offset,
  });
}
