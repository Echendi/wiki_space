import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../cubit/home_cubit.dart';
import '../../cubit/home_state.dart';
import '../cards/home_carousel_card.dart';
import '../feedback/home_feedback_views.dart';
import 'home_main_preview_card.dart';

/// Tag de Hero compartido entre Home y Detail para transicion de imagen.
String detailHeroTag(String articleId) {
  return 'detail-hero-${articleId.toLowerCase()}';
}

/// Contenido principal del carrusel superior en Home.
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
    final carouselItems = state.carouselArticles;
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
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 340),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              final slide = Tween<Offset>(
                begin: const Offset(0.06, 0),
                end: Offset.zero,
              ).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: slide, child: child),
              );
            },
            child: HomeMainPreviewCard(
              key: ValueKey(current.title),
              title: current.title,
              summary: current.description,
              imageUrl: current.imageUrl,
              isDark: isDark,
              onTap: () => onOpenDetail(current.title),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color:
                  (isDark ? AppPalette.surfaceDarkAlt : AppPalette.surfaceLight)
                      .withValues(alpha: isDark ? 0.7 : 0.86),
              border: Border.all(
                color: AppPalette.accent.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              l10n.homeSlideCounter(
                  state.currentIndex + 1, carouselItems.length),
              style: AppTextStyles.overline(isDark).copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        SizedBox(
          height: 132,
          child: PageView.builder(
            controller: pageController,
            itemCount: carouselItems.length,
            onPageChanged: context.read<HomeCubit>().onPageChanged,
            itemBuilder: (context, index) {
              final item = carouselItems[index];
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
                    child: HomeCarouselCard(
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
