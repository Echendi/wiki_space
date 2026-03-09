/// Plan de paginacion por categorias para consultas remotas de Home.
class SpaceRemotePagingPlan {
  /// Crea un plan con ventana de categorias y offsets derivados.
  const SpaceRemotePagingPlan({
    required this.activeCategories,
    required this.perCategoryLimit,
    required this.perCategoryOffset,
  });

  /// Categorias activas para la ventana de la pagina actual.
  final List<String> activeCategories;

  /// Limite aplicado por categoria dentro de la consulta.
  final int perCategoryLimit;

  /// Offset por categoria dentro del ciclo de paginacion.
  final int perCategoryOffset;
}
