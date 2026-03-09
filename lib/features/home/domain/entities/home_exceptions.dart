/// Error de dominio cuando no hay internet ni datos cacheados.
class OfflineNoCachedDataException implements Exception {
  /// Crea la excepcion de ausencia de cache en modo offline.
  const OfflineNoCachedDataException();

  @override
  String toString() => 'offline-no-cache';
}
