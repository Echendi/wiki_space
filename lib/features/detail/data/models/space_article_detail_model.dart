import '../../domain/entities/space_article_detail.dart';

class SpaceArticleDetailModel extends SpaceArticleDetail {
  const SpaceArticleDetailModel({
    required super.articleId,
    required super.title,
    required super.summary,
    required super.imageUrl,
    required super.pageUrl,
    required super.languageCode,
    required super.lastUpdatedAt,
  });

  factory SpaceArticleDetailModel.fromJson(
    Map<String, dynamic> json,
    String languageCode,
  ) {
    final thumbnail = json['thumbnail'] as Map<String, dynamic>?;

    return SpaceArticleDetailModel(
      articleId: (json['pageid'] as num?)?.toInt() ?? 0,
      title: (json['title'] as String?)?.trim() ?? '',
      summary: (json['extract'] as String?)?.trim() ?? '',
      imageUrl: _normalizeUrl((thumbnail?['source'] as String?)?.trim() ?? ''),
      pageUrl: _normalizeUrl((json['fullurl'] as String?)?.trim() ?? ''),
      languageCode: languageCode,
      lastUpdatedAt: _parseDate((json['touched'] as String?)?.trim()),
    );
  }

  static DateTime? _parseDate(String? rawValue) {
    if (rawValue == null || rawValue.isEmpty) {
      return null;
    }
    return DateTime.tryParse(rawValue)?.toLocal();
  }

  static String _normalizeUrl(String rawUrl) {
    if (rawUrl.isEmpty) {
      return '';
    }

    var value = rawUrl;
    if (value.startsWith('//')) {
      value = 'https:$value';
    }
    if (value.startsWith('http://')) {
      value = 'https://${value.substring('http://'.length)}';
    }

    final parsed = Uri.tryParse(value);
    if (parsed == null || !parsed.hasScheme || !parsed.hasAuthority) {
      return '';
    }

    return parsed.toString();
  }
}
