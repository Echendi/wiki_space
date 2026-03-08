import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import '../config/app_env.dart';
import 'network_status.dart';

/// Implementacion de [NetworkStatus] basada en `connectivity_plus` + probe HTTP.
///
/// Combina dos verificaciones:
/// - Transporte disponible (wifi/movil/ethernet) via plugin de conectividad.
/// - Alcance real de internet via una solicitud HTTP liviana.
///
/// Esto evita falsos positivos cuando existe transporte local pero no salida.
class ConnectivityNetworkStatusAdapter implements NetworkStatus {
  ConnectivityNetworkStatusAdapter(
    this._connectivity,
    this._dio,
  );

  final Connectivity _connectivity;
  final Dio _dio;

  /// Evalua conectividad efectiva a internet en dos pasos.
  ///
  /// 1) Verifica transporte disponible.
  /// 2) Ejecuta probe HTTP con timeout corto.
  ///
  /// Cualquier excepcion de red se interpreta como falta de internet real.
  @override
  Future<bool> hasInternetConnection() async {
    final results = await _connectivity.checkConnectivity();
    final hasTransport =
        results.any((result) => result != ConnectivityResult.none);
    if (!hasTransport) {
      return false;
    }

    try {
      final response = await _dio.get<void>(
        AppEnv.networkProbeUrl,
        options: Options(
          sendTimeout: AppEnv.networkProbeTimeout,
          receiveTimeout: AppEnv.networkProbeTimeout,
          responseType: ResponseType.plain,
          followRedirects: false,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final status = response.statusCode ?? 0;
      return status >= 200 && status < 500;
    } on DioException {
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Emite cambios de estado de internet real a partir del stream del plugin.
  ///
  /// `distinct()` evita emisiones repetidas del mismo valor consecutivo.
  @override
  Stream<bool> get onStatusChanged =>
      _connectivity.onConnectivityChanged.asyncMap((_) {
        return hasInternetConnection();
      }).distinct();
}
