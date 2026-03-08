import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wiki_space/core/network/network_status.dart';
import 'package:wiki_space/features/home/domain/entities/home_exceptions.dart';
import 'package:wiki_space/features/home/domain/entities/space_article.dart';
import 'package:wiki_space/features/home/domain/entities/space_articles_result.dart';
import 'package:wiki_space/features/home/domain/usecases/get_space_articles_use_case.dart';
import 'package:wiki_space/features/home/presentation/cubit/home_cubit.dart';
import 'package:wiki_space/features/home/presentation/cubit/home_state.dart';

class _MockGetSpaceArticlesUseCase extends Mock
    implements GetSpaceArticlesUseCase {}

class _MockNetworkStatus extends Mock implements NetworkStatus {}

void main() {
  // Pruebas de comportamiento del cubit principal de Home.
  // Se valida la maquina de estados ante carga normal, error offline
  // y reconexion de red.
  group('HomeCubit', () {
    late _MockGetSpaceArticlesUseCase useCase;
    late _MockNetworkStatus networkStatus;
    late StreamController<bool> connectivityController;

    setUp(() {
      useCase = _MockGetSpaceArticlesUseCase();
      networkStatus = _MockNetworkStatus();
      connectivityController = StreamController<bool>.broadcast();

      when(
        () => networkStatus.onStatusChanged,
      ).thenAnswer((_) => connectivityController.stream);
      when(
        () => networkStatus.hasInternetConnection(),
      ).thenAnswer((_) async => true);
    });

    tearDown(() async {
      await connectivityController.close();
    });

    blocTest<HomeCubit, HomeState>(
      'load emite loading y luego success, normalizando el query',
      build: () {
        // Arrange: el caso de uso devuelve una lista valida de articulos.
        when(
          () => useCase(
            'es',
            query: 'mars',
            limit: 4,
            offset: 0,
          ),
        ).thenAnswer(
          (_) async => const SpaceArticlesResult(
            articles: [
              SpaceArticle(
                id: 1,
                title: 'Mars',
                description: 'Planet',
                imageUrl: 'https://img',
                pageUrl: 'https://wiki',
              ),
            ],
            isOfflineMode: false,
            isFromCache: false,
            hasConnection: true,
          ),
        );

        return HomeCubit(useCase, networkStatus);
      },
      // Act: se ejecuta la carga con espacios para comprobar trim del query.
      act: (cubit) => cubit.load('es', query: '  mars  '),
      expect: () => [
        // Assert 1: primero entra en loading y guarda query normalizado.
        isA<HomeState>()
            .having((s) => s.status, 'status', HomeStatus.loading)
            .having((s) => s.query, 'query', 'mars'),
        // Assert 2: luego finaliza en success con articulos y conectado.
        isA<HomeState>()
            .having((s) => s.status, 'status', HomeStatus.success)
            .having((s) => s.articles.length, 'articles', 1)
            .having((s) => s.isConnected, 'isConnected', true),
      ],
      verify: (_) {
        // Verifica contrato: HomeCubit debe pedir pagina inicial al use case.
        verify(
          () => useCase(
            'es',
            query: 'mars',
            limit: 4,
            offset: 0,
          ),
        ).called(1);
      },
    );

    blocTest<HomeCubit, HomeState>(
      'load maneja offline sin cache y termina en failure',
      build: () {
        // Arrange: se simula escenario real sin internet y sin datos cacheados.
        when(
          () => useCase(
            'en',
            query: '',
            limit: 4,
            offset: 0,
          ),
        ).thenThrow(const OfflineNoCachedDataException());

        return HomeCubit(useCase, networkStatus);
      },
      // Act: intento de carga normal del home.
      act: (cubit) => cubit.load('en'),
      expect: () => [
        // Assert 1: al iniciar siempre emite loading.
        isA<HomeState>().having((s) => s.status, 'status', HomeStatus.loading),
        // Assert 2: mapea la excepcion de dominio al estado de UI esperado.
        isA<HomeState>()
            .having((s) => s.status, 'status', HomeStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', 'offline-no-cache')
            .having((s) => s.isOfflineMode, 'isOfflineMode', true)
            .having((s) => s.isConnected, 'isConnected', false),
      ],
    );

    test('al reconectar despues de estar offline activa showReconnectAction',
        () async {
      // Arrange: estado inicial offline al crear el cubit.
      when(
        () => networkStatus.hasInternetConnection(),
      ).thenAnswer((_) async => false);

      final cubit = HomeCubit(useCase, networkStatus);
      addTearDown(cubit.close);

      // Act/Assert parcial: despues de inicializar, debe reflejar modo offline.
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.isConnected, false);
      expect(cubit.state.isOfflineMode, true);

      // Act: la conectividad publica evento de reconexion.
      connectivityController.add(true);
      await Future<void>.delayed(Duration.zero);

      // Assert final: vuelve a conectado y pide mostrar accion de reconexion.
      expect(cubit.state.isConnected, true);
      expect(cubit.state.showReconnectAction, true);
    });
  });
}
