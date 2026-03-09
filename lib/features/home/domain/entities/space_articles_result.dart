import 'space_article.dart';

/// Resultado de carga de articulos para Home con metadatos de origen.
class SpaceArticlesResult {
  /// Construye una respuesta de articulos y estado de conectividad.
  const SpaceArticlesResult({
    required this.articles,
    required this.isOfflineMode,
    required this.isFromCache,
    required this.hasConnection,
  });

  /// Coleccion de articulos obtenidos en la consulta.
  final List<SpaceArticle> articles;

  /// Indica si la respuesta se obtuvo en modo offline.
  final bool isOfflineMode;

  /// Indica si el origen de datos fue cache local.
  final bool isFromCache;

  /// Estado de conectividad detectado durante la consulta.
  final bool hasConnection;
}
