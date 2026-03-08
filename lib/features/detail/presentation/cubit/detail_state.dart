import '../../domain/entities/space_article_detail.dart';
import 'detail_status.dart';

/// Estado inmutable consumido por `DetailScreen`.
class DetailState {
  const DetailState({
    this.status = DetailStatus.initial,
    this.detail,
    this.errorMessage,
  });

  final DetailStatus status;
  final SpaceArticleDetail? detail;
  final String? errorMessage;

  /// Crea una nueva instancia de estado con cambios parciales.
  DetailState copyWith({
    DetailStatus? status,
    SpaceArticleDetail? detail,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DetailState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
