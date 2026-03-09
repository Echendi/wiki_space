import 'package:flutter/material.dart';

/// Indicador de carga incremental al final del feed de Home.
class HomeLoadMoreSliver extends StatelessWidget {
  /// Crea el sliver que muestra spinner cuando se carga mas contenido.
  const HomeLoadMoreSliver({
    super.key,
    required this.isLoadingMore,
  });

  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: isLoadingMore
            ? const Center(child: CircularProgressIndicator())
            : const SizedBox.shrink(),
      ),
    );
  }
}
