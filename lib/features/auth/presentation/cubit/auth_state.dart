/// Estado visual del flujo de autenticacion.
enum AuthViewStatus { idle, loading, success, failure }

/// Accion de autenticacion actualmente en ejecucion o finalizada.
enum AuthAction {
  none,
  signInEmail,
  signUpEmail,
  signInGoogle,
  signInFacebook,
  signOut,
}

/// Estado inmutable consumido por pantallas de autenticacion.
class AuthState {
  const AuthState({
    this.status = AuthViewStatus.idle,
    this.action = AuthAction.none,
    this.errorCode,
  });

  final AuthViewStatus status;
  final AuthAction action;
  final String? errorCode;

  /// Indica si la UI debe mostrar bloqueo/carga de accion actual.
  bool get isLoading => status == AuthViewStatus.loading;

  /// Crea una nueva instancia inmutable con cambios parciales.
  ///
  /// `clearError` fuerza limpieza de `errorCode` aunque no se pase uno nuevo.
  AuthState copyWith({
    AuthViewStatus? status,
    AuthAction? action,
    String? errorCode,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      action: action ?? this.action,
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
    );
  }
}
