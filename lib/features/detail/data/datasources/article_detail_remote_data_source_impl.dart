import 'package:dio/dio.dart';

import '../../../../../core/config/app_env.dart';
import '../models/space_article_detail_model.dart';
import 'article_detail_remote_data_source.dart';

/// Implementacion remota basada en Wikipedia API.
class ArticleDetailRemoteDataSourceImpl
    implements ArticleDetailRemoteDataSource {
  /// Crea data source remoto basado en cliente HTTP inyectado.
  ArticleDetailRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  /// Ejecuta consulta a Wikipedia y mapea el resultado a modelo de datos.
  @override
  Future<SpaceArticleDetailModel> fetchArticleDetail(
    String articleId,
    String languageCode,
  ) async {
    final normalizedLanguage = _normalizeLanguage(languageCode);
    final endpoint = AppEnv.wikipediaApiEndpoint(normalizedLanguage);

    final response = await _dio.get<Map<String, dynamic>>(
      endpoint,
      queryParameters: {
        'action': 'query',
        'format': 'json',
        'formatversion': '2',
        'titles': articleId,
        'prop': 'extracts|pageimages|info',
        'inprop': 'url',
        'piprop': 'thumbnail',
        'pithumbsize': '1100',
        'exintro': '0',
        'explaintext': '1',
        'exchars': '1400',
        'origin': '*',
      },
      options: Options(
        sendTimeout: AppEnv.wikiRequestTimeout,
        receiveTimeout: AppEnv.wikiRequestTimeout,
      ),
    );

    final queryMap = response.data?['query'] as Map<String, dynamic>?;
    final pages = queryMap?['pages'] as List<dynamic>?;
    if (pages == null || pages.isEmpty) {
      throw Exception('detail-empty');
    }

    final page = pages.whereType<Map<String, dynamic>>().firstWhere(
        (item) => (item['missing'] as bool?) != true,
        orElse: () => <String, dynamic>{});

    if (page.isEmpty) {
      throw Exception('detail-not-found');
    }

    return SpaceArticleDetailModel.fromJson(page, normalizedLanguage);
  }

  /// Normaliza idioma soportado por endpoint (solo `es` o `en`).
  String _normalizeLanguage(String languageCode) {
    final code = languageCode.toLowerCase();
    if (code == 'es') {
      return 'es';
    }
    return 'en';
  }
}
