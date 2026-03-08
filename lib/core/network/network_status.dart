/// Contrato de dominio para consultar estado real de internet.
///
/// Este puerto abstrae la implementacion concreta (plugin/SDK) para que las
/// capas de presentacion y datos no dependan de APIs externas directamente.
abstract class NetworkStatus {
  /// Retorna `true` solo cuando hay salida real a internet.
  Future<bool> hasInternetConnection();

  /// Emite cambios de conectividad real como valores booleanos.
  ///
  /// `true`: hay internet utilizable.
  /// `false`: no hay salida real o no hay transporte.
  Stream<bool> get onStatusChanged;
}
