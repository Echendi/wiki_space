import 'package:flutter/material.dart';

import '../../domain/entities/space_article.dart';
import 'home_article_tile.dart';

class HomeArticlesSliverGrid extends StatelessWidget {
  const HomeArticlesSliverGrid({
    super.key,
    required this.items,
    required this.isDark,
    required this.onOpenDetail,
  });

  final List<SpaceArticle> items;
  final bool isDark;
  final void Function(String articleId) onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final columns = MediaQuery.sizeOf(context).width > 900
        ? 3
        : MediaQuery.sizeOf(context).width > 640
            ? 2
            : 1;

    final childAspectRatio = columns == 1
        ? 2.0
        : columns == 2
            ? 1.34
            : 1.22;

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: childAspectRatio,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = items[index];
          return HomeArticleTile(
            title: item.title,
            imageUrl: item.imageUrl,
            isDark: isDark,
            onTap: () => onOpenDetail(item.title),
          );
        },
        childCount: items.length,
      ),
    );
  }
}
