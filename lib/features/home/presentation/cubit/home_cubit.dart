import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiki_space/core/network/network_status.dart';

import '../../domain/entities/home_exceptions.dart';
import '../../domain/entities/space_article.dart';
import '../../domain/usecases/get_space_articles_use_case.dart';
import 'home_status.dart';
import 'home_state.dart';

/// Gestiona estado de Home: carga inicial, paginacion, busqueda y conectividad.
class HomeCubit extends Cubit<HomeState> {
  /// Crea el cubit y se suscribe a cambios de red.
  HomeCubit(this._getSpaceArticlesUseCase, this._networkStatus)
      : super(const HomeState()) {
    _connectivitySubscription = _networkStatus.onStatusChanged.listen(
      _onConnectivityChanged,
    );
    unawaited(_initializeConnectivityState());
  }

  final GetSpaceArticlesUseCase _getSpaceArticlesUseCase;
  final NetworkStatus _networkStatus;
  static const int _pageSize = 5;
  late final StreamSubscription<bool> _connectivitySubscription;
  bool _wasOffline = false;

  /// Emite estado solo si el cubit sigue activo.
  void _safeEmit(HomeState newState) {
    if (isClosed) {
      return;
    }
    emit(newState);
  }

  /// Sincroniza el estado inicial de conectividad al crear el cubit.
  Future<void> _initializeConnectivityState() async {
    final online = await _networkStatus.hasInternetConnection();
    if (!online) {
      _wasOffline = true;
      _safeEmit(state.copyWith(isConnected: false, isOfflineMode: true));
    }
  }

  /// Reacciona a cambios online/offline para actualizar banners de UI.
  void _onConnectivityChanged(bool online) {
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

  /// Carga la primera pagina de articulos con query opcional.
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

  /// Carga mas articulos tomando el offset actual de la lista.
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

  /// Ejecuta busqueda reutilizando el flujo de `load`.
  Future<void> search(String languageCode, String query) {
    return load(languageCode, query: query);
  }

  /// Actualiza indice activo del carrusel principal.
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
