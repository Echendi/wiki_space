import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../data/auth_service.dart';

void registerAuthDependencies(GetIt serviceLocator) {
  if (!serviceLocator.isRegistered<GoogleSignIn>()) {
    serviceLocator.registerLazySingleton<GoogleSignIn>(GoogleSignIn.new);
  }

  if (!serviceLocator.isRegistered<AuthService>()) {
    serviceLocator.registerLazySingleton<AuthService>(
      () => AuthService(
        firebaseAuth: serviceLocator(),
        secureStorage: serviceLocator(),
        googleSignIn: serviceLocator(),
      ),
    );
  }
}
