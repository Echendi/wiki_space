import '../entities/space_article.dart';

abstract class SpaceRepository {
  Future<List<SpaceArticle>> getSpaceArticles(String languageCode);
}
