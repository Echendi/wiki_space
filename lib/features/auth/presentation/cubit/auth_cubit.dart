import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/auth_exception.dart';
import '../../domain/usecases/auth_use_cases.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authUseCases) : super(const AuthState());

  final AuthUseCases _authUseCases;

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

  Future<void> signInWithGoogle() async {
    await _run(
      action: AuthAction.signInGoogle,
      run: _authUseCases.signInWithGoogle.call,
    );
  }

  Future<void> signInWithFacebook() async {
    await _run(
      action: AuthAction.signInFacebook,
      run: _authUseCases.signInWithFacebook.call,
    );
  }

  Future<void> signOut() async {
    await _run(
      action: AuthAction.signOut,
      run: _authUseCases.signOut.call,
    );
  }

  void resetToIdle() {
    _safeEmit(const AuthState());
  }

  void _safeEmit(AuthState newState) {
    if (isClosed) {
      return;
    }
    emit(newState);
  }

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
