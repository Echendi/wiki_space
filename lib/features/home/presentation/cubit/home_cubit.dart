import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_space_articles_use_case.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getSpaceArticlesUseCase) : super(const HomeState());

  final GetSpaceArticlesUseCase _getSpaceArticlesUseCase;

  Future<void> load(String languageCode) async {
    emit(state.copyWith(status: HomeStatus.loading, clearError: true));

    try {
      final items = await _getSpaceArticlesUseCase(languageCode);
      if (items.isEmpty) {
        emit(
          state.copyWith(
            status: HomeStatus.failure,
            errorMessage: 'empty-results',
            articles: const [],
            currentIndex: 0,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: HomeStatus.success,
          articles: items,
          currentIndex: 0,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void onPageChanged(int index) {
    if (index == state.currentIndex) {
      return;
    }
    emit(state.copyWith(currentIndex: index));
  }
}
