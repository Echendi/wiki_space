import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/auth_use_cases.dart';
import 'auth_session_state.dart';

class AuthSessionCubit extends Cubit<AuthSessionState> {
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

  Future<void> signOut() {
    return _authUseCases.signOut.call();
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
