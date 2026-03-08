import 'dart:async';

import 'package:flutter/foundation.dart';

/// Adaptador simple de `Stream` a `Listenable` para GoRouter.
///
/// Cada evento del stream dispara `notifyListeners()`, lo que permite que
/// `GoRouter` re-evalue `redirect` cuando cambia el estado de autenticacion.
class AuthRefreshListenable extends ChangeNotifier {
  AuthRefreshListenable(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override

  /// Cancela la suscripcion activa para evitar fugas de memoria.
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
