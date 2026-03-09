import '../../domain/entities/space_article.dart';

/// Modelo de datos para mapear respuestas de Wikipedia a dominio.
class SpaceArticleModel extends SpaceArticle {
  /// Crea un modelo inmutable reutilizando la entidad base.
  const SpaceArticleModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.pageUrl,
  });

  /// Construye un modelo desde el JSON de `query.pages`.
  factory SpaceArticleModel.fromJson(Map<String, dynamic> json) {
    final thumbnail = json['thumbnail'] as Map<String, dynamic>?;

    return SpaceArticleModel(
      id: (json['pageid'] as num?)?.toInt() ?? 0,
      title: (json['title'] as String?)?.trim() ?? '',
      description: (json['extract'] as String?)?.trim() ?? '',
      imageUrl: _normalizeUrl((thumbnail?['source'] as String?)?.trim() ?? ''),
      pageUrl: _normalizeUrl((json['fullurl'] as String?)?.trim() ?? ''),
    );
  }

  /// Normaliza URLs relativas/inseguras a formato absoluto HTTPS valido.
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
