import 'package:get_it/get_it.dart';
import 'package:wiki_space/core/network/network_status.dart';

import '../data/datasources/space_local_data_source.dart';
import '../data/datasources/space_local_data_source_impl.dart';
import '../data/datasources/space_remote_data_source.dart';
import '../data/datasources/space_remote_data_source_impl.dart';
import '../data/repositories/space_repository_impl.dart';
import '../domain/repositories/space_repository.dart';
import '../domain/usecases/get_space_articles_use_case.dart';
import '../presentation/cubit/home_cubit.dart';

/// Registra todas las dependencias de la feature Home.
void registerHomeDependencies(GetIt serviceLocator) {
  if (!serviceLocator.isRegistered<SpaceRemoteDataSource>()) {
    serviceLocator.registerLazySingleton<SpaceRemoteDataSource>(
      () => SpaceRemoteDataSourceImpl(serviceLocator()),
    );
  }

  if (!serviceLocator.isRegistered<HomeCacheDatabase>()) {
    serviceLocator
        .registerLazySingleton<HomeCacheDatabase>(HomeCacheDatabase.new);
  }

  if (!serviceLocator.isRegistered<SpaceLocalDataSource>()) {
    serviceLocator.registerLazySingleton<SpaceLocalDataSource>(
      () => SpaceLocalDataSourceImpl(serviceLocator()),
    );
  }

  if (!serviceLocator.isRegistered<SpaceRepository>()) {
    serviceLocator.registerLazySingleton<SpaceRepository>(
      () => SpaceRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<GetSpaceArticlesUseCase>()) {
    serviceLocator.registerLazySingleton<GetSpaceArticlesUseCase>(
      () => GetSpaceArticlesUseCase(serviceLocator()),
    );
  }

  if (serviceLocator.isRegistered<HomeCubit>()) {
    serviceLocator.unregister<HomeCubit>();
  }

  serviceLocator.registerFactory<HomeCubit>(
    () => HomeCubit(
      serviceLocator(),
      serviceLocator<NetworkStatus>(),
    ),
  );
}
