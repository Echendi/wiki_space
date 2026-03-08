part of 'article_detail_local_data_source.dart';

/// Tabla Drift de cache de detalles de articulos por idioma.
class CachedArticleDetails extends Table {
  TextColumn get articleId => text()();

  TextColumn get languageCode => text()();

  IntColumn get pageId => integer().withDefault(const Constant(0))();

  TextColumn get title => text()();

  TextColumn get summary => text().withDefault(const Constant(''))();

  TextColumn get imageUrl => text().withDefault(const Constant(''))();

  TextColumn get pageUrl => text().withDefault(const Constant(''))();

  DateTimeColumn get articleLastUpdated => dateTime().nullable()();

  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {articleId, languageCode};
}
