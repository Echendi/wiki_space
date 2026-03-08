import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../data/auth_service.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/auth_use_cases.dart';
import '../presentation/cubit/auth_cubit.dart';

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

  if (!serviceLocator.isRegistered<AuthRepository>()) {
    serviceLocator.registerLazySingleton<AuthRepository>(
      () => serviceLocator<AuthService>(),
    );
  }

  if (!serviceLocator.isRegistered<AuthUseCases>()) {
    serviceLocator.registerLazySingleton<AuthUseCases>(
      () => AuthUseCases.fromRepository(serviceLocator<AuthRepository>()),
    );
  }

  if (!serviceLocator.isRegistered<AuthCubit>()) {
    serviceLocator.registerFactory<AuthCubit>(
      () => AuthCubit(serviceLocator<AuthUseCases>()),
    );
  }
}
