/// Entidad de dominio para el detalle de un articulo espacial.
class SpaceArticleDetail {
  const SpaceArticleDetail({
    required this.articleId,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.pageUrl,
    required this.languageCode,
    required this.lastUpdatedAt,
  });

  final int articleId;
  final String title;
  final String summary;
  final String imageUrl;
  final String pageUrl;
  final String languageCode;
  final DateTime? lastUpdatedAt;
}
