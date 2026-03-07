import '../../domain/entities/space_article.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState {
  const HomeState({
    this.status = HomeStatus.initial,
    this.articles = const <SpaceArticle>[],
    this.currentIndex = 0,
    this.errorMessage,
  });

  final HomeStatus status;
  final List<SpaceArticle> articles;
  final int currentIndex;
  final String? errorMessage;

  SpaceArticle? get currentArticle {
    if (articles.isEmpty) {
      return null;
    }
    if (currentIndex < 0 || currentIndex >= articles.length) {
      return articles.first;
    }
    return articles[currentIndex];
  }

  HomeState copyWith({
    HomeStatus? status,
    List<SpaceArticle>? articles,
    int? currentIndex,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
      currentIndex: currentIndex ?? this.currentIndex,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
