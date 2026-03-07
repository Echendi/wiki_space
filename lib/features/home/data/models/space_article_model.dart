import '../../domain/entities/space_article.dart';

class SpaceArticleModel extends SpaceArticle {
  const SpaceArticleModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.pageUrl,
  });

  factory SpaceArticleModel.fromJson(Map<String, dynamic> json) {
    final thumbnail = json['thumbnail'] as Map<String, dynamic>?;

    return SpaceArticleModel(
      id: (json['pageid'] as num?)?.toInt() ?? 0,
      title: (json['title'] as String?)?.trim() ?? '',
      description: (json['extract'] as String?)?.trim() ?? '',
      imageUrl: (thumbnail?['source'] as String?)?.trim() ?? '',
      pageUrl: (json['fullurl'] as String?)?.trim() ?? '',
    );
  }
}
