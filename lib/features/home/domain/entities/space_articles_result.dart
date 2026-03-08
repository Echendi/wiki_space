import 'space_article.dart';

class SpaceArticlesResult {
  const SpaceArticlesResult({
    required this.articles,
    required this.isOfflineMode,
    required this.isFromCache,
    required this.hasConnection,
  });

  final List<SpaceArticle> articles;
  final bool isOfflineMode;
  final bool isFromCache;
  final bool hasConnection;
}
