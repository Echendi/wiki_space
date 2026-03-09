import '../../domain/entities/space_article.dart';
import 'home_status.dart';

/// Estado inmutable consumido por vistas de la feature Home.
class HomeState {
  /// Crea el snapshot inicial o derivado del estado Home.
  const HomeState({
    this.status = HomeStatus.initial,
    this.articles = const <SpaceArticle>[],
    this.currentIndex = 0,
    this.errorMessage,
    this.query = '',
    this.isLoadingMore = false,
    this.hasMore = true,
    this.isOfflineMode = false,
    this.isUsingCachedData = false,
    this.isConnected = true,
    this.showReconnectAction = false,
  });

  /// Estado de la vista: inicial, carga, exito o fallo.
  final HomeStatus status;

  /// Lista completa de articulos visibles en el feed.
  final List<SpaceArticle> articles;

  /// Indice activo del carrusel superior.
  final int currentIndex;

  /// Mensaje tecnico o clave de error para la UI.
  final String? errorMessage;

  /// Query de busqueda aplicada actualmente.
  final String query;

  /// Marca de carga incremental (infinite scroll).
  final bool isLoadingMore;

  /// Indica si aun se puede intentar paginar.
  final bool hasMore;

  /// Indica si se opera con conectividad ausente.
  final bool isOfflineMode;

  /// Indica si los datos actuales provienen de cache local.
  final bool isUsingCachedData;

  /// Ultimo estado de conectividad observado.
  final bool isConnected;

  /// Muestra accion de resincronizacion al reconectar.
  final bool showReconnectAction;

  /// Subconjunto para carrusel superior.
  List<SpaceArticle> get carouselArticles {
    if (articles.length <= 5) {
      return articles;
    }
    return articles.take(5).toList(growable: false);
  }

  /// Articulo actualmente seleccionado en el carrusel.
  SpaceArticle? get currentArticle {
    final carousel = carouselArticles;
    if (carousel.isEmpty) {
      return null;
    }
    if (currentIndex < 0 || currentIndex >= carousel.length) {
      return carousel.first;
    }
    return carousel[currentIndex];
  }

  /// Crea una copia inmutable del estado aplicando cambios parciales.
  HomeState copyWith({
    HomeStatus? status,
    List<SpaceArticle>? articles,
    int? currentIndex,
    String? errorMessage,
    String? query,
    bool? isLoadingMore,
    bool? hasMore,
    bool? isOfflineMode,
    bool? isUsingCachedData,
    bool? isConnected,
    bool? showReconnectAction,
    bool clearError = false,
    bool clearReconnectAction = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
      currentIndex: currentIndex ?? this.currentIndex,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      query: query ?? this.query,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      isOfflineMode: isOfflineMode ?? this.isOfflineMode,
      isUsingCachedData: isUsingCachedData ?? this.isUsingCachedData,
      isConnected: isConnected ?? this.isConnected,
      showReconnectAction: clearReconnectAction
          ? false
          : (showReconnectAction ?? this.showReconnectAction),
    );
  }
}
