import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_article_detail_use_case.dart';
import 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  DetailCubit(this._getArticleDetailUseCase, this._connectivity)
      : super(const DetailState()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
    );
  }

  final GetArticleDetailUseCase _getArticleDetailUseCase;
  final Connectivity _connectivity;
  late final StreamSubscription<List<ConnectivityResult>>
      _connectivitySubscription;

  String? _lastArticleId;
  String? _lastLanguageCode;
  bool _wasOffline = false;

  Future<void> load(String articleId, String languageCode) async {
    _lastArticleId = articleId;
    _lastLanguageCode = languageCode;

    emit(state.copyWith(status: DetailStatus.loading, clearError: true));

    try {
      final detail = await _getArticleDetailUseCase(articleId, languageCode);
      _wasOffline = false;
      emit(
        state.copyWith(
          status: DetailStatus.success,
          detail: detail,
          clearError: true,
        ),
      );
    } catch (error) {
      final isOfflineNoCache = error.toString() == 'detail-offline-no-cache';
      if (isOfflineNoCache) {
        _wasOffline = true;
      }

      emit(
        state.copyWith(
          status: DetailStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onConnectivityChanged(List<ConnectivityResult> results) async {
    final hasInternet =
        results.any((result) => result != ConnectivityResult.none);
    if (!hasInternet || !_wasOffline) {
      return;
    }

    final articleId = _lastArticleId;
    final languageCode = _lastLanguageCode;
    if (articleId == null || languageCode == null) {
      return;
    }

    await load(articleId, languageCode);
  }

  @override
  Future<void> close() async {
    await _connectivitySubscription.cancel();
    return super.close();
  }
}
