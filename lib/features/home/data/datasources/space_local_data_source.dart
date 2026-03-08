import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/space_article_model.dart';

part 'space_local_data_source.g.dart';

abstract class SpaceLocalDataSource {
  Future<void> cacheArticles(
    String languageCode,
    List<SpaceArticleModel> articles, {
    required bool clearExisting,
  });

  Future<List<SpaceArticleModel>> getCachedArticles(
    String languageCode, {
    String query,
    int limit,
    int offset,
  });

  Future<bool> hasCachedArticles(String languageCode, {String query});
}

class SpaceLocalDataSourceImpl implements SpaceLocalDataSource {
  SpaceLocalDataSourceImpl(this._database);

  final HomeCacheDatabase _database;

  @override
  Future<void> cacheArticles(
    String languageCode,
    List<SpaceArticleModel> articles, {
    required bool clearExisting,
  }) {
    return _database.cacheArticles(
      languageCode,
      articles,
      clearExisting: clearExisting,
    );
  }

  @override
  Future<List<SpaceArticleModel>> getCachedArticles(
    String languageCode, {
    String query = '',
    int limit = 24,
    int offset = 0,
  }) {
    return _database.getCachedArticles(
      languageCode,
      query: query,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<bool> hasCachedArticles(String languageCode, {String query = ''}) {
    return _database.hasCachedArticles(languageCode, query: query);
  }
}

class CachedSpaceArticles extends Table {
  IntColumn get pageId => integer()();

  TextColumn get languageCode => text()();

  TextColumn get title => text()();

  TextColumn get description => text().withDefault(const Constant(''))();

  TextColumn get imageUrl => text().withDefault(const Constant(''))();

  TextColumn get pageUrl => text().withDefault(const Constant(''))();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {pageId, languageCode};
}

@DriftDatabase(tables: [CachedSpaceArticles])
class HomeCacheDatabase extends _$HomeCacheDatabase {
  HomeCacheDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> cacheArticles(
    String languageCode,
    List<SpaceArticleModel> articles, {
    required bool clearExisting,
  }) async {
    if (articles.isEmpty && !clearExisting) {
      return;
    }

    await transaction(() async {
      if (clearExisting) {
        await (delete(cachedSpaceArticles)
              ..where((t) => t.languageCode.equals(languageCode)))
            .go();
      }

      if (articles.isEmpty) {
        return;
      }

      final now = DateTime.now();
      await batch((batch) {
        batch.insertAllOnConflictUpdate(
          cachedSpaceArticles,
          articles
              .where((article) => article.id > 0)
              .map(
                (article) => CachedSpaceArticlesCompanion.insert(
                  pageId: article.id,
                  languageCode: languageCode,
                  title: article.title,
                  description: Value(article.description),
                  imageUrl: Value(article.imageUrl),
                  pageUrl: Value(article.pageUrl),
                  updatedAt: now,
                ),
              )
              .toList(growable: false),
        );
      });
    });
  }

  Future<List<SpaceArticleModel>> getCachedArticles(
    String languageCode, {
    String query = '',
    int limit = 24,
    int offset = 0,
  }) async {
    final normalizedQuery = query.trim().toLowerCase();
    final likePattern = '%$normalizedQuery%';

    final request = select(cachedSpaceArticles)
      ..where((t) => t.languageCode.equals(languageCode));

    if (normalizedQuery.isNotEmpty) {
      request.where(
        (t) =>
            t.title.lower().like(likePattern) |
            t.description.lower().like(likePattern),
      );
    }

    request
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
      ..limit(limit, offset: offset);

    final rows = await request.get();
    return rows
        .map(
          (row) => SpaceArticleModel(
            id: row.pageId,
            title: row.title,
            description: row.description,
            imageUrl: row.imageUrl,
            pageUrl: row.pageUrl,
          ),
        )
        .toList(growable: false);
  }

  Future<bool> hasCachedArticles(String languageCode,
      {String query = ''}) async {
    final items = await getCachedArticles(
      languageCode,
      query: query,
      limit: 1,
      offset: 0,
    );
    return items.isNotEmpty;
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'space_home_cache');
}
