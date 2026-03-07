import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/space_article.dart';
import '../../domain/usecases/get_space_articles_use_case.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getSpaceArticlesUseCase) : super(const HomeState());

  final GetSpaceArticlesUseCase _getSpaceArticlesUseCase;
  static const int _pageSize = 12;

  Future<void> load(String languageCode, {String query = ''}) async {
    final normalizedQuery = query.trim();

    emit(
      state.copyWith(
        status: HomeStatus.loading,
        query: normalizedQuery,
        articles: const <SpaceArticle>[],
        currentIndex: 0,
        isLoadingMore: false,
        hasMore: true,
        clearError: true,
      ),
    );

    try {
      final items = await _getSpaceArticlesUseCase(
        languageCode,
        query: normalizedQuery,
        limit: _pageSize,
        offset: 0,
      );
      if (items.isEmpty) {
        emit(
          state.copyWith(
            status: HomeStatus.failure,
            errorMessage: 'empty-results',
            articles: const [],
            currentIndex: 0,
            isLoadingMore: false,
            hasMore: false,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: HomeStatus.success,
          articles: items,
          currentIndex: 0,
          isLoadingMore: false,
          hasMore: items.length >= _pageSize,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: error.toString(),
          isLoadingMore: false,
        ),
      );
    }
  }

  Future<void> loadMore(String languageCode) async {
    if (state.status != HomeStatus.success ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, clearError: true));

    try {
      final items = await _getSpaceArticlesUseCase(
        languageCode,
        query: state.query,
        limit: _pageSize,
        offset: state.articles.length,
      );

      if (items.isEmpty) {
        emit(state.copyWith(isLoadingMore: false, hasMore: false));
        return;
      }

      final byId = <int, SpaceArticle>{
        for (final article in state.articles) article.id: article,
      };
      for (final article in items) {
        byId[article.id] = article;
      }

      emit(
        state.copyWith(
          status: HomeStatus.success,
          articles: byId.values.toList(growable: false),
          isLoadingMore: false,
          hasMore: items.length >= _pageSize,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoadingMore: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> search(String languageCode, String query) {
    return load(languageCode, query: query);
  }

  void onPageChanged(int index) {
    if (index == state.currentIndex) {
      return;
    }
    emit(state.copyWith(currentIndex: index));
  }
}
