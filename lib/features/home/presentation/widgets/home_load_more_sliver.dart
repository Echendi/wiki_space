import 'package:flutter/material.dart';

class HomeLoadMoreSliver extends StatelessWidget {
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
