import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/home_exceptions.dart';
import '../../domain/entities/space_article.dart';
import '../../domain/usecases/get_space_articles_use_case.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getSpaceArticlesUseCase, this._connectivity)
      : super(const HomeState()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
    );
    unawaited(_initializeConnectivityState());
  }

  final GetSpaceArticlesUseCase _getSpaceArticlesUseCase;
  final Connectivity _connectivity;
  static const int _pageSize = 4;
  late final StreamSubscription<List<ConnectivityResult>>
      _connectivitySubscription;
  bool _wasOffline = false;

  void _safeEmit(HomeState newState) {
    if (isClosed) {
      return;
    }
    emit(newState);
  }

  Future<void> _initializeConnectivityState() async {
    final initialResults = await _connectivity.checkConnectivity();
    final online = _hasInternet(initialResults);
    if (!online) {
      _wasOffline = true;
      _safeEmit(state.copyWith(isConnected: false, isOfflineMode: true));
    }
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final online = _hasInternet(results);

    if (!online) {
      _wasOffline = true;
      _safeEmit(
        state.copyWith(
          isConnected: false,
          isOfflineMode: true,
        ),
      );
      return;
    }

    _safeEmit(
      state.copyWith(
        isConnected: true,
        showReconnectAction: _wasOffline,
      ),
    );
    _wasOffline = false;
  }

  bool _hasInternet(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }

  Future<void> load(String languageCode, {String query = ''}) async {
    final normalizedQuery = query.trim();

    _safeEmit(
      state.copyWith(
        status: HomeStatus.loading,
        query: normalizedQuery,
        articles: const [],
        currentIndex: 0,
        isLoadingMore: false,
        hasMore: true,
        isUsingCachedData: false,
        clearError: true,
        clearReconnectAction: true,
      ),
    );

    try {
      final result = await _getSpaceArticlesUseCase(
        languageCode,
        query: normalizedQuery,
        limit: _pageSize,
        offset: 0,
      );
      final items = result.articles;

      if (items.isEmpty) {
        _safeEmit(
          state.copyWith(
            status: HomeStatus.failure,
            errorMessage: 'empty-results',
            articles: const [],
            currentIndex: 0,
            isLoadingMore: false,
            hasMore: false,
            isOfflineMode: result.isOfflineMode,
            isUsingCachedData: result.isFromCache,
            isConnected: result.hasConnection,
          ),
        );
        return;
      }

      _safeEmit(
        state.copyWith(
          status: HomeStatus.success,
          articles: items,
          currentIndex: 0,
          isLoadingMore: false,
          // Keep paging until backend/cache stops returning items.
          hasMore: items.isNotEmpty,
          isOfflineMode: result.isOfflineMode,
          isUsingCachedData: result.isFromCache,
          isConnected: result.hasConnection,
          clearError: true,
          clearReconnectAction: true,
        ),
      );
    } catch (error) {
      final isOfflineNoCache = error is OfflineNoCachedDataException;
      _safeEmit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage:
              isOfflineNoCache ? 'offline-no-cache' : error.toString(),
          isLoadingMore: false,
          isOfflineMode: isOfflineNoCache,
          isUsingCachedData: false,
          isConnected: !isOfflineNoCache,
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

    _safeEmit(state.copyWith(isLoadingMore: true, clearError: true));

    try {
      final result = await _getSpaceArticlesUseCase(
        languageCode,
        query: state.query,
        limit: _pageSize,
        offset: state.articles.length,
      );
      final items = result.articles;

      if (items.isEmpty) {
        _safeEmit(
          state.copyWith(
            isLoadingMore: false,
            hasMore: false,
            isOfflineMode: result.isOfflineMode,
            isUsingCachedData: result.isFromCache,
            isConnected: result.hasConnection,
          ),
        );
        return;
      }

      final byId = <int, SpaceArticle>{
        for (final article in state.articles) article.id: article,
      };
      final previousCount = byId.length;
      for (final article in items) {
        byId[article.id] = article;
      }
      final mergedItems = byId.values.toList(growable: false);
      final addedNewItems = mergedItems.length > previousCount;

      _safeEmit(
        state.copyWith(
          status: HomeStatus.success,
          articles: mergedItems,
          isLoadingMore: false,
          // Stop only when the next page doesn't add anything new.
          hasMore: addedNewItems,
          isOfflineMode: result.isOfflineMode,
          isUsingCachedData: result.isFromCache,
          isConnected: result.hasConnection,
          clearError: true,
        ),
      );
    } catch (error) {
      _safeEmit(
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
    _safeEmit(state.copyWith(currentIndex: index));
  }

  @override
  Future<void> close() async {
    await _connectivitySubscription.cancel();
    return super.close();
  }
}
