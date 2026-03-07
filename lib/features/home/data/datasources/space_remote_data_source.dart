import 'package:dio/dio.dart';

import '../models/space_article_model.dart';

abstract class SpaceRemoteDataSource {
  Future<List<SpaceArticleModel>> fetchSpaceArticles(String languageCode);
}

class SpaceRemoteDataSourceImpl implements SpaceRemoteDataSource {
  SpaceRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<SpaceArticleModel>> fetchSpaceArticles(
      String languageCode) async {
    final normalizedLanguage = _normalizeLanguage(languageCode);
    final endpoint = 'https://$normalizedLanguage.wikipedia.org/w/api.php';

    final categoryTitles = _categoryTitlesFor(normalizedLanguage);
    final itemsById = <int, SpaceArticleModel>{};

    for (final categoryTitle in categoryTitles) {
      final response = await _dio.get<Map<String, dynamic>>(
        endpoint,
        queryParameters: {
          'action': 'query',
          'format': 'json',
          'formatversion': '2',
          'generator': 'categorymembers',
          'gcmtitle': categoryTitle,
          'gcmnamespace': '0',
          'gcmlimit': '40',
          'prop': 'pageimages|extracts|info',
          'inprop': 'url',
          'piprop': 'thumbnail',
          'pithumbsize': '900',
          'exintro': '1',
          'explaintext': '1',
          'exsentences': '3',
          'origin': '*',
        },
      );

      final query = response.data?['query'] as Map<String, dynamic>?;
      final pages = query?['pages'] as List<dynamic>?;

      if (pages == null || pages.isEmpty) {
        continue;
      }

      final parsedItems = pages
          .whereType<Map<String, dynamic>>()
          .map(SpaceArticleModel.fromJson)
          .where((item) => item.title.isNotEmpty && item.imageUrl.isNotEmpty);

      for (final item in parsedItems) {
        itemsById[item.id] = item;
      }

      if (itemsById.length >= 24) {
        break;
      }
    }

    return itemsById.values.take(24).toList(growable: false);
  }

  String _normalizeLanguage(String languageCode) {
    final code = languageCode.toLowerCase();
    if (code == 'es') {
      return 'es';
    }
    return 'en';
  }

  List<String> _categoryTitlesFor(String languageCode) {
    switch (languageCode) {
      case 'es':
        return const <String>[
          'Categoría:Espacio exterior',
          'Categoría:Exploración espacial',
          'Categoría:Astronomía',
        ];
      default:
        return const <String>[
          'Category:Space',
          'Category:Outer space',
          'Category:Spaceflight',
        ];
    }
  }
}
