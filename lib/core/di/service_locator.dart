import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../network/connectivity_network_status_adapter.dart';
import '../network/network_status.dart';
import '../services/connectivity_status_service.dart';
import '../../features/auth/di/auth_di.dart';
import '../../features/detail/di/detail_di.dart';
import '../../features/home/di/home_di.dart';

final GetIt serviceLocator = GetIt.instance;

/// Configura todos los registros globales de dependencias.
Future<void> setupDependencies() async {
  _registerCoreDependencies();
  _registerFeatureDependencies();

  await serviceLocator<ConnectivityStatusService>().initialize();
}

void _registerCoreDependencies() {
  if (!serviceLocator.isRegistered<Dio>()) {
    serviceLocator.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      ),
    );
  }

  if (!serviceLocator.isRegistered<Connectivity>()) {
    serviceLocator.registerLazySingleton<Connectivity>(Connectivity.new);
  }

  if (!serviceLocator.isRegistered<ConnectivityStatusService>()) {
    serviceLocator.registerLazySingleton<ConnectivityStatusService>(
      () => ConnectivityStatusService(serviceLocator()),
    );
  }

  if (!serviceLocator.isRegistered<NetworkStatus>()) {
    serviceLocator.registerLazySingleton<NetworkStatus>(
      () => ConnectivityNetworkStatusAdapter(
        serviceLocator(),
        serviceLocator(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<FlutterSecureStorage>()) {
    serviceLocator.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    );
  }

  if (!serviceLocator.isRegistered<FirebaseAuth>()) {
    serviceLocator
        .registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  }
}

void _registerFeatureDependencies() {
  registerAuthDependencies(serviceLocator);
  registerHomeDependencies(serviceLocator);
  registerDetailDependencies(serviceLocator);
}
