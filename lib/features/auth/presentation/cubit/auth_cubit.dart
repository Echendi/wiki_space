import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/auth_exception.dart';
import '../../domain/usecases/auth_use_cases.dart';
import 'auth_state.dart';

/// Orquesta acciones de autenticacion y publica estado para UI.
class AuthCubit extends Cubit<AuthState> {
  /// Crea el cubit en estado `idle` con fachada de casos de uso inyectada.
  AuthCubit(this._authUseCases) : super(const AuthState());

  final AuthUseCases _authUseCases;

  /// Ejecuta login con email/contrasena y publica progreso/resultado.
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await _run(
      action: AuthAction.signInEmail,
      run: () => _authUseCases.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  /// Ejecuta registro con email y, si aplica, actualiza nombre visible.
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    await _run(
      action: AuthAction.signUpEmail,
      run: () async {
        await _authUseCases.signUpWithEmailAndPassword(
          email: email,
          password: password,
        );
        final normalizedName = displayName.trim();
        if (normalizedName.isNotEmpty) {
          await _authUseCases.updateDisplayName(normalizedName);
        }
      },
    );
  }

  /// Ejecuta inicio de sesion con Google.
  Future<void> signInWithGoogle() async {
    await _run(
      action: AuthAction.signInGoogle,
      run: _authUseCases.signInWithGoogle.call,
    );
  }

  /// Ejecuta inicio de sesion con Facebook.
  Future<void> signInWithFacebook() async {
    await _run(
      action: AuthAction.signInFacebook,
      run: _authUseCases.signInWithFacebook.call,
    );
  }

  /// Ejecuta cierre de sesion del usuario actual.
  Future<void> signOut() async {
    await _run(
      action: AuthAction.signOut,
      run: _authUseCases.signOut.call,
    );
  }

  /// Reinicia estado visual a `idle` y limpia errores.
  void resetToIdle() {
    _safeEmit(const AuthState());
  }

  /// Emite estado solo si el cubit sigue abierto para evitar excepciones.
  void _safeEmit(AuthState newState) {
    if (isClosed) {
      return;
    }
    emit(newState);
  }

  /// Pipeline comun para acciones de auth con mapeo de errores a `errorCode`.
  Future<void> _run({
    required AuthAction action,
    required Future<void> Function() run,
  }) async {
    _safeEmit(
      state.copyWith(
        status: AuthViewStatus.loading,
        action: action,
        clearError: true,
      ),
    );

    try {
      await run();
      _safeEmit(
        state.copyWith(
          status: AuthViewStatus.success,
          action: action,
          clearError: true,
        ),
      );
    } on AuthException catch (error) {
      _safeEmit(
        state.copyWith(
          status: AuthViewStatus.failure,
          action: action,
          errorCode: error.code,
        ),
      );
    } on PlatformException catch (error) {
      final code = error.code.toLowerCase();
      final details = (error.details ?? '').toString().toLowerCase();

      if (details.contains('apiexception: 10') ||
          details.contains('developer_error') ||
          code.contains('sign_in_failed')) {
        _safeEmit(
          state.copyWith(
            status: AuthViewStatus.failure,
            action: action,
            errorCode: 'google-config-error',
          ),
        );
        return;
      }

      if (code.contains('network_error')) {
        _safeEmit(
          state.copyWith(
            status: AuthViewStatus.failure,
            action: action,
            errorCode: 'network-request-failed',
          ),
        );
        return;
      }

      _safeEmit(
        state.copyWith(
          status: AuthViewStatus.failure,
          action: action,
          errorCode: 'social-sign-in-unavailable',
        ),
      );
    } catch (_) {
      _safeEmit(
        state.copyWith(
          status: AuthViewStatus.failure,
          action: action,
          errorCode: 'unknown',
        ),
      );
    }
  }
}
