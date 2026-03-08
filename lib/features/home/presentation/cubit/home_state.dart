import '../../domain/entities/space_article.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState {
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

  final HomeStatus status;
  final List<SpaceArticle> articles;
  final int currentIndex;
  final String? errorMessage;
  final String query;
  final bool isLoadingMore;
  final bool hasMore;
  final bool isOfflineMode;
  final bool isUsingCachedData;
  final bool isConnected;
  final bool showReconnectAction;

  List<SpaceArticle> get carouselArticles {
    if (articles.length <= 10) {
      return articles;
    }
    return articles.take(10).toList(growable: false);
  }

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
