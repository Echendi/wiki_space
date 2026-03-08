import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wiki_space/features/home/domain/entities/space_article.dart';
import 'package:wiki_space/features/home/domain/entities/space_articles_result.dart';
import 'package:wiki_space/features/home/domain/repositories/space_repository.dart';
import 'package:wiki_space/features/home/domain/usecases/get_space_articles_use_case.dart';

class _MockSpaceRepository extends Mock implements SpaceRepository {}

void main() {
  // Verifica el contrato del caso de uso.
  // Este tipo de prueba evita que cambios futuros rompan la delegacion
  // de parametros entre capa de dominio y repositorio.
  group('GetSpaceArticlesUseCase', () {
    late _MockSpaceRepository repository;
    late GetSpaceArticlesUseCase useCase;

    setUp(() {
      repository = _MockSpaceRepository();
      useCase = GetSpaceArticlesUseCase(repository);
    });

    test('delega la llamada al repositorio con los parametros recibidos',
        () async {
      // Arrange: resultado esperado que el repositorio retornaria.
      const expected = SpaceArticlesResult(
        articles: [
          SpaceArticle(
            id: 1,
            title: 'ISS',
            description: 'Orbiting lab',
            imageUrl: 'https://img',
            pageUrl: 'https://wiki',
          ),
        ],
        isOfflineMode: false,
        isFromCache: false,
        hasConnection: true,
      );

      // Arrange: se configura el mock con parametros especificos.
      when(
        () => repository.getSpaceArticles(
          'es',
          query: 'apollo',
          limit: 7,
          offset: 14,
        ),
      ).thenAnswer((_) async => expected);

      // Act: se ejecuta el caso de uso con esos mismos parametros.
      final result = await useCase(
        'es',
        query: 'apollo',
        limit: 7,
        offset: 14,
      );

      // Assert 1: retorna exactamente la misma instancia proveniente del repo.
      expect(result, same(expected));
      // Assert 2: el repositorio fue invocado una sola vez con argumentos correctos.
      verify(
        () => repository.getSpaceArticles(
          'es',
          query: 'apollo',
          limit: 7,
          offset: 14,
        ),
      ).called(1);
      // Assert 3: no hubo llamadas extra inesperadas al mock.
      verifyNoMoreInteractions(repository);
    });
  });
}
