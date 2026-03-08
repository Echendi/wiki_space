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

    final normalizedQuery = query.trim();
    final safeLimit = limit <= 0 ? 1 : limit;
    final categories = _categoriesFor(normalizedLanguage);
    final pagingPlan = _buildPagingPlan(
      categories: categories,
      limit: safeLimit,
      offset: offset,
    );
    final perCategoryLimit = pagingPlan.perCategoryLimit;
    final perCategoryOffset = pagingPlan.perCategoryOffset;
    final activeCategories = pagingPlan.activeCategories;

    try {
      final aggregated = <int, SpaceArticleModel>{};

      for (final category in activeCategories) {
        final searchClause = normalizedQuery.isEmpty
            ? 'incategory:"$category"'
            : '$normalizedQuery incategory:"$category"';

        final items = await _fetchBySearchClause(
          endpoint,
          searchClause,
          limit: perCategoryLimit,
          offset: perCategoryOffset,
        );

        for (final item in items) {
          if (item.id > 0) {
            aggregated[item.id] = item;
          }
        }

        if (aggregated.length >= safeLimit) {
          break;
        }
      }

      if (aggregated.isNotEmpty) {
        return aggregated.values.take(safeLimit).toList(growable: false);
      }

      if (normalizedQuery.isNotEmpty) {
        // Last fallback: run a broad query without category filter.
        return _fetchBySearchClause(
          endpoint,
          normalizedQuery,
          limit: safeLimit,
          offset: offset,
        );
      }

      return const <SpaceArticleModel>[];
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

  List<String> _categoriesFor(String languageCode) {
    return switch (languageCode) {
      'es' => const <String>[
          'Espacio exterior',
          'Astronomía',
          'NASA',
          'Sistema Solar',
          'Cosmología',
          'Exploración espacial',
          'Telescopios',
          'Misiones espaciales',
        ],
      _ => const <String>[
          'Space',
          'Astronomy',
          'NASA',
          'Solar System',
          'Cosmology',
          'Space exploration',
          'Space telescopes',
          'Space missions',
        ],
    };
  }

  Future<List<SpaceArticleModel>> _fetchBySearchClause(
    String endpoint,
    String searchClause, {
    required int limit,
    required int offset,
  }) async {
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
  }

  _CategoryPagingPlan _buildPagingPlan({
    required List<String> categories,
    required int limit,
    required int offset,
  }) {
    final categoriesPerPage = categories.length < 4 ? categories.length : 4;
    final pageIndex = offset <= 0 ? 0 : (offset ~/ limit);
    final pagesPerCycle = (categories.length / categoriesPerPage).ceil();

    final windowStart = (pageIndex % pagesPerCycle) * categoriesPerPage;
    final categoryCycleOffset = pageIndex ~/ pagesPerCycle;

    final activeCategories = List<String>.generate(
      categoriesPerPage,
      (index) => categories[(windowStart + index) % categories.length],
      growable: false,
    );

    final perCategoryLimit =
        ((limit / categoriesPerPage).ceil()).clamp(1, limit);
    final perCategoryOffset = categoryCycleOffset * perCategoryLimit;

    return _CategoryPagingPlan(
      activeCategories: activeCategories,
      perCategoryLimit: perCategoryLimit,
      perCategoryOffset: perCategoryOffset,
    );
  }
}

class _CategoryPagingPlan {
  const _CategoryPagingPlan({
    required this.activeCategories,
    required this.perCategoryLimit,
    required this.perCategoryOffset,
  });

  final List<String> activeCategories;
  final int perCategoryLimit;
  final int perCategoryOffset;
}
