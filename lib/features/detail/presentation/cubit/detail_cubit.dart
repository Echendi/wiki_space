import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiki_space/core/network/network_status.dart';

import '../../domain/usecases/get_article_detail_use_case.dart';
import 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  DetailCubit(this._getArticleDetailUseCase, this._networkStatus)
      : super(const DetailState()) {
    _connectivitySubscription = _networkStatus.onStatusChanged.listen(
      _onConnectivityChanged,
    );
  }

  final GetArticleDetailUseCase _getArticleDetailUseCase;
  final NetworkStatus _networkStatus;
  late final StreamSubscription<bool> _connectivitySubscription;

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

  Future<void> _onConnectivityChanged(bool hasInternet) async {
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
