part of 'space_local_data_source.dart';

/// Tabla Drift de cache de articulos Home por idioma.
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
