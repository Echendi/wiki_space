import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/auth_use_cases.dart';
import 'auth_session_state.dart';

/// Mantiene una sesion global de usuario para toda la aplicacion.
class AuthSessionCubit extends Cubit<AuthSessionState> {
  /// Inicializa el estado desde usuario actual y escucha cambios reactivos.
  AuthSessionCubit(this._authUseCases)
      : super(AuthSessionState(user: _authUseCases.getCurrentUser())) {
    _subscription = _authUseCases.watchAuthState().listen((user) {
      if (isClosed) {
        return;
      }
      emit(AuthSessionState(user: user));
    });
  }

  final AuthUseCases _authUseCases;
  late final StreamSubscription _subscription;

  /// Delega cierre de sesion al caso de uso global.
  Future<void> signOut() {
    return _authUseCases.signOut.call();
  }

  /// Cancela suscripcion de auth antes de cerrar el cubit.
  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
