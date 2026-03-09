import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../cards/home_article_image.dart';
import 'home_carousel_content.dart';

/// Tarjeta principal de previsualizacion en el carrusel home.
class HomeMainPreviewCard extends StatelessWidget {
  const HomeMainPreviewCard({
    super.key,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.isDark,
    required this.onTap,
  });

  final String title;
  final String summary;
  final String imageUrl;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final previewSummary = summary.isEmpty ? l10n.homeSummaryFallback : summary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              HomeArticleImage(
                imageUrl: imageUrl,
                fallbackLabel: l10n.homeImageUnavailable,
                heroTag: detailHeroTag(title),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.74),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.screenTitle(isDark)
                          .copyWith(color: AppPalette.onDark, fontSize: 22),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      previewSummary,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMd(true),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
