import 'dart:async';

import 'package:flutter/foundation.dart';

import '../network/network_status.dart';

/// Servicio de conectividad para UI basado en `ValueNotifier<bool>`.
///
/// Expone un estado simple (`isOnline`) para widgets que solo necesitan
/// reaccionar visualmente al cambio de conectividad.
class ConnectivityStatusService {
  ConnectivityStatusService(this._networkStatus);

  final NetworkStatus _networkStatus;
  final ValueNotifier<bool> isOnline = ValueNotifier<bool>(true);

  StreamSubscription<bool>? _subscription;
  bool _initialized = false;

  /// Inicializa la escucha de conectividad una sola vez.
  ///
  /// Primero obtiene estado inicial y luego se suscribe a cambios en tiempo real.
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    isOnline.value = await _networkStatus.hasInternetConnection();

    _subscription = _networkStatus.onStatusChanged.listen((isConnected) {
      isOnline.value = isConnected;
    });
  }

  /// Libera recursos internos cuando la app/servicio termina.
  Future<void> dispose() async {
    await _subscription?.cancel();
    isOnline.dispose();
  }
}
