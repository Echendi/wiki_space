enum AuthViewStatus { idle, loading, success, failure }

enum AuthAction {
  none,
  signInEmail,
  signUpEmail,
  signInGoogle,
  signInFacebook,
  signOut,
}

class AuthState {
  const AuthState({
    this.status = AuthViewStatus.idle,
    this.action = AuthAction.none,
    this.errorCode,
  });

  final AuthViewStatus status;
  final AuthAction action;
  final String? errorCode;

  bool get isLoading => status == AuthViewStatus.loading;

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
