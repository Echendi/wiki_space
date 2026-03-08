/// Error de dominio cuando no hay internet ni contenido en cache.
class OfflineNoCachedDetailException implements Exception {
  const OfflineNoCachedDetailException();

  @override
  String toString() => 'detail-offline-no-cache';
}
