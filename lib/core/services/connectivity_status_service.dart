import 'dart:async';

import 'package:flutter/foundation.dart';

import '../network/network_status.dart';

class ConnectivityStatusService {
  ConnectivityStatusService(this._networkStatus);

  final NetworkStatus _networkStatus;
  final ValueNotifier<bool> isOnline = ValueNotifier<bool>(true);

  StreamSubscription<bool>? _subscription;
  bool _initialized = false;

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

  Future<void> dispose() async {
    await _subscription?.cancel();
    isOnline.dispose();
  }
}
