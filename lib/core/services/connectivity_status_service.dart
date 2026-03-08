import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityStatusService {
  ConnectivityStatusService(this._connectivity);

  final Connectivity _connectivity;
  final ValueNotifier<bool> isOnline = ValueNotifier<bool>(true);

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    final initial = await _connectivity.checkConnectivity();
    isOnline.value = _hasInternet(initial);

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      isOnline.value = _hasInternet(results);
    });
  }

  bool _hasInternet(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    isOnline.dispose();
  }
}
