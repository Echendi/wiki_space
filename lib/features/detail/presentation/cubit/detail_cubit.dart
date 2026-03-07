import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_article_detail_use_case.dart';
import 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  DetailCubit(this._getArticleDetailUseCase) : super(const DetailState());

  final GetArticleDetailUseCase _getArticleDetailUseCase;

  Future<void> load(String articleId, String languageCode) async {
    emit(state.copyWith(status: DetailStatus.loading, clearError: true));

    try {
      final detail = await _getArticleDetailUseCase(articleId, languageCode);
      emit(
        state.copyWith(
          status: DetailStatus.success,
          detail: detail,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: DetailStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
