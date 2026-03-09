/// Entidad base de un articulo mostrado en Home.
class SpaceArticle {
  /// Crea una instancia inmutable de articulo.
  const SpaceArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.pageUrl,
  });

  /// Identificador estable del articulo (Wikipedia `pageid`).
  final int id;

  /// Titulo principal mostrado en tarjetas y carrusel.
  final String title;

  /// Resumen corto utilizado en previsualizaciones.
  final String description;

  /// URL de miniatura o imagen principal.
  final String imageUrl;

  /// URL absoluta de la pagina origen.
  final String pageUrl;
}
