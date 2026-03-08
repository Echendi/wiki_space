import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import 'network_status.dart';

class ConnectivityNetworkStatusAdapter implements NetworkStatus {
  ConnectivityNetworkStatusAdapter(
    this._connectivity,
    this._dio,
  );

  final Connectivity _connectivity;
  final Dio _dio;

  static const String _probeUrl = 'https://www.google.com/generate_204';
  static const Duration _probeTimeout = Duration(seconds: 4);

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
        _probeUrl,
        options: Options(
          sendTimeout: _probeTimeout,
          receiveTimeout: _probeTimeout,
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

  @override
  Stream<bool> get onStatusChanged =>
      _connectivity.onConnectivityChanged.asyncMap((_) {
        return hasInternetConnection();
      }).distinct();
}
