import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'home_feedback_views.dart';

class HomeCarouselContent extends StatelessWidget {
  const HomeCarouselContent({
    super.key,
    required this.state,
    required this.pageController,
    required this.isDark,
    required this.onRetry,
    required this.onOpenDetail,
  });

  final HomeState state;
  final PageController pageController;
  final bool isDark;
  final VoidCallback onRetry;
  final void Function(String articleId) onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final current = state.currentArticle;

    if (current == null) {
      return HomeErrorView(
        isDark: isDark,
        message: l10n.homeEmptyResults,
        retryLabel: l10n.homeRetry,
        onRetry: onRetry,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _MainPreviewCard(
            title: current.title,
            summary: current.description,
            imageUrl: current.imageUrl,
            isDark: isDark,
            onTap: () => onOpenDetail(current.title),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            l10n.homeSlideCounter(
                state.currentIndex + 1, state.articles.length),
            style: AppTextStyles.overline(isDark),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: pageController,
            itemCount: state.articles.length,
            onPageChanged: context.read<HomeCubit>().onPageChanged,
            itemBuilder: (context, index) {
              final item = state.articles[index];
              return AnimatedBuilder(
                animation: pageController,
                builder: (context, child) {
                  final page = pageController.hasClients
                      ? (pageController.page ?? state.currentIndex.toDouble())
                      : state.currentIndex.toDouble();
                  final distance = (page - index).abs();
                  final scale = (1 - (distance * 0.14)).clamp(0.84, 1.0);
                  final isCenter = distance < 0.45;

                  return Transform.scale(
                    scale: scale,
                    child: _CarouselCard(
                      title: item.title,
                      imageUrl: item.imageUrl,
                      highlighted: isCenter,
                      onTap: () => onOpenDetail(item.title),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MainPreviewCard extends StatelessWidget {
  const _MainPreviewCard({
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
              _ArticleImage(
                imageUrl: imageUrl,
                fallbackLabel: l10n.homeImageUnavailable,
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

class _CarouselCard extends StatelessWidget {
  const _CarouselCard({
    required this.title,
    required this.imageUrl,
    required this.highlighted,
    required this.onTap,
  });

  final String title;
  final String imageUrl;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: highlighted
                  ? AppPalette.primary.withValues(alpha: 0.95)
                  : AppPalette.accent.withValues(alpha: 0.35),
              width: highlighted ? 2.2 : 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _ArticleImage(
                  imageUrl: imageUrl,
                  fallbackLabel: l10n.homeImageUnavailable,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.62),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMd(true).copyWith(
                      color: AppPalette.onDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArticleImage extends StatelessWidget {
  const _ArticleImage({required this.imageUrl, required this.fallbackLabel});

  final String imageUrl;
  final String fallbackLabel;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _ImageFallback(label: fallbackLabel);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, _) => const Center(
        child: CircularProgressIndicator(strokeWidth: 2.2),
      ),
      errorWidget: (context, _, __) => _ImageFallback(label: fallbackLabel),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppPalette.surfaceDarkAlt : AppPalette.surfaceLightAlt,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.image_not_supported_rounded, size: 34),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.caption(isDark)),
        ],
      ),
    );
  }
}
