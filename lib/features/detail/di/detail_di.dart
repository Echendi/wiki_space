import 'package:get_it/get_it.dart';
import 'package:wiki_space/core/network/network_status.dart';

import '../data/datasources/article_detail_local_data_source.dart';
import '../data/datasources/article_detail_local_data_source_impl.dart';
import '../data/datasources/article_detail_remote_data_source.dart';
import '../data/datasources/article_detail_remote_data_source_impl.dart';
import '../data/repositories/article_detail_repository_impl.dart';
import '../domain/repositories/article_detail_repository.dart';
import '../domain/usecases/get_article_detail_use_case.dart';
import '../presentation/cubit/detail_cubit.dart';

/// Registra dependencias de la feature de detalle.
void registerDetailDependencies(GetIt serviceLocator) {
  if (!serviceLocator.isRegistered<ArticleDetailRemoteDataSource>()) {
    serviceLocator.registerLazySingleton<ArticleDetailRemoteDataSource>(
      () => ArticleDetailRemoteDataSourceImpl(serviceLocator()),
    );
  }

  if (!serviceLocator.isRegistered<ArticleDetailCacheDatabase>()) {
    serviceLocator.registerLazySingleton<ArticleDetailCacheDatabase>(
      ArticleDetailCacheDatabase.new,
    );
  }

  if (!serviceLocator.isRegistered<ArticleDetailLocalDataSource>()) {
    serviceLocator.registerLazySingleton<ArticleDetailLocalDataSource>(
      () => ArticleDetailLocalDataSourceImpl(serviceLocator()),
    );
  }

  if (!serviceLocator.isRegistered<ArticleDetailRepository>()) {
    serviceLocator.registerLazySingleton<ArticleDetailRepository>(
      () => ArticleDetailRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<GetArticleDetailUseCase>()) {
    serviceLocator.registerLazySingleton<GetArticleDetailUseCase>(
      () => GetArticleDetailUseCase(serviceLocator()),
    );
  }

  if (serviceLocator.isRegistered<DetailCubit>()) {
    serviceLocator.unregister<DetailCubit>();
  }

  serviceLocator.registerFactory<DetailCubit>(
    () => DetailCubit(
      serviceLocator(),
      serviceLocator<NetworkStatus>(),
    ),
  );
}
