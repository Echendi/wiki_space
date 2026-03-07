import 'package:dio/dio.dart';

import '../models/space_article_model.dart';

abstract class SpaceRemoteDataSource {
  Future<List<SpaceArticleModel>> fetchSpaceArticles(
    String languageCode, {
    String query,
    int limit,
    int offset,
  });
}

class SpaceRemoteDataSourceImpl implements SpaceRemoteDataSource {
  SpaceRemoteDataSourceImpl(this._dio);

  final Dio _dio;
  static const Duration _requestTimeout = Duration(seconds: 12);

  @override
  Future<List<SpaceArticleModel>> fetchSpaceArticles(
    String languageCode, {
    String query = '',
    int limit = 24,
    int offset = 0,
  }) async {
    final normalizedLanguage = _normalizeLanguage(languageCode);
    final endpoint = 'https://$normalizedLanguage.wikipedia.org/w/api.php';

    final categoryLabel = _categoryLabelFor(normalizedLanguage);
    final normalizedQuery = query.trim();
    final searchClause = normalizedQuery.isEmpty
        ? 'incategory:"$categoryLabel"'
        : '$normalizedQuery incategory:"$categoryLabel"';

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        endpoint,
        queryParameters: {
          'action': 'query',
          'format': 'json',
          'formatversion': '2',
          'generator': 'search',
          'gsrsearch': searchClause,
          'gsrnamespace': '0',
          'gsrlimit': '$limit',
          'gsroffset': '$offset',
          'prop': 'pageimages|extracts|info',
          'inprop': 'url',
          'piprop': 'thumbnail',
          'pithumbsize': '560',
          'exintro': '1',
          'explaintext': '1',
          'exsentences': '3',
          'origin': '*',
        },
        options: Options(
          sendTimeout: _requestTimeout,
          receiveTimeout: _requestTimeout,
        ),
      );

      final queryMap = response.data?['query'] as Map<String, dynamic>?;
      final pages = queryMap?['pages'] as List<dynamic>?;
      if (pages == null || pages.isEmpty) {
        return const <SpaceArticleModel>[];
      }

      return pages
          .whereType<Map<String, dynamic>>()
          .map(SpaceArticleModel.fromJson)
          .where((item) => item.title.isNotEmpty)
          .toList(growable: false);
    } on DioException catch (error) {
      final isTimeout = error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout;
      if (isTimeout) {
        throw Exception('request-timeout');
      }
      rethrow;
    }
  }

  String _normalizeLanguage(String languageCode) {
    final code = languageCode.toLowerCase();
    if (code == 'es') {
      return 'es';
    }
    return 'en';
  }

  String _categoryLabelFor(String languageCode) {
    switch (languageCode) {
      case 'es':
        return 'Espacio exterior';
      default:
        return 'Space';
    }
  }
}
