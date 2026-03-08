import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/global_top_bar.dart';
import '../../../../core/widgets/space_scene_background.dart';
import '../../../../features/auth/presentation/widgets/space_logo.dart';
import '../../../../features/home/presentation/widgets/home_carousel_content.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../cubit/detail_cubit.dart';
import '../cubit/detail_state.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.articleId,
  });

  final String articleId;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final DetailCubit _detailCubit;
  late String _articleLanguageCode;
  String? _loadedArticleId;

  @override
  void initState() {
    super.initState();
    _detailCubit = serviceLocator<DetailCubit>();
    _articleLanguageCode = 'es';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _articleLanguageCode = Localizations.localeOf(context).languageCode;
    _loadIfNeeded();
  }

  @override
  void didUpdateWidget(covariant DetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.articleId != widget.articleId) {
      // New detail target: pin language at navigation moment.
      _articleLanguageCode = Localizations.localeOf(context).languageCode;
      _loadIfNeeded(force: true);
    }
  }

  void _loadIfNeeded({bool force = false}) {
    if (!force && _loadedArticleId == widget.articleId) {
      return;
    }

    _loadedArticleId = widget.articleId;
    _detailCubit.load(widget.articleId, _articleLanguageCode);
  }

  @override
  void dispose() {
    _detailCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const GlobalTopBar(showBackButton: true),
      body: BlocProvider.value(
        value: _detailCubit,
        child: BlocBuilder<DetailCubit, DetailState>(
          builder: (context, state) {
            switch (state.status) {
              case DetailStatus.initial:
              case DetailStatus.loading:
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 12),
                      Text(l10n.loadingLabel),
                    ],
                  ),
                );
              case DetailStatus.failure:
                final isOfflineNoCache =
                    state.errorMessage == 'detail-offline-no-cache';
                final message = isOfflineNoCache
                    ? l10n.detailOfflineNoCache
                    : l10n.detailLoadError;
                final retryLabel = l10n.homeRetry;

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 42,
                          color: isDark
                              ? AppPalette.onDarkMuted
                              : AppPalette.onPrimary,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMd(isDark),
                        ),
                        const SizedBox(height: 14),
                        FilledButton.tonal(
                          onPressed: () => context
                              .read<DetailCubit>()
                              .load(widget.articleId, _articleLanguageCode),
                          child: Text(retryLabel),
                        ),
                      ],
                    ),
                  ),
                );
              case DetailStatus.success:
                final detail = state.detail;
                if (detail == null) {
                  return const SizedBox.shrink();
                }

                final title =
                    detail.title.isEmpty ? widget.articleId : detail.title;
                final summary = detail.summary.trim().isEmpty
                    ? l10n.homeSummaryFallback
                    : detail.summary.trim();

                final metricLastUpdatedLabel = languageCode == 'es'
                    ? 'Ultima actualizacion'
                    : 'Last update';
                final metricLanguageLabel =
                    languageCode == 'es' ? 'Idioma' : 'Language';
                final metricLinkLabel =
                    languageCode == 'es' ? 'Articulo completo' : 'Full article';
                final metricArticleIdLabel = l10n.articleIdLabel;

                final metricLastUpdatedValue =
                    _formatLastUpdated(detail.lastUpdatedAt, languageCode);
                final metricLanguageValue = detail.languageCode.toUpperCase();
                final metricLinkValue =
                    detail.pageUrl.isEmpty ? '--' : detail.pageUrl;
                final metricArticleIdValue =
                    detail.articleId > 0 ? detail.articleId.toString() : '--';

                return SpaceSceneBackground(
                  isDark: isDark,
                  child: SafeArea(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                            child: _DetailVisualHero(
                              title: title,
                              imageUrl: detail.imageUrl,
                              fallbackLabel: l10n.homeImageUnavailable,
                              heroTag: detailHeroTag(widget.articleId),
                              isDark: isDark,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                            child: Text(
                              l10n.detailTitle,
                              style: AppTextStyles.screenTitle(isDark)
                                  .copyWith(fontSize: 20),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _MetricCard(
                                  label: metricLastUpdatedLabel,
                                  value: metricLastUpdatedValue,
                                  icon: Icons.schedule_rounded,
                                  isDark: isDark,
                                ),
                                _MetricCard(
                                  label: metricLanguageLabel,
                                  value: metricLanguageValue,
                                  icon: Icons.language_rounded,
                                  isDark: isDark,
                                ),
                                _MetricCard(
                                  label: metricArticleIdLabel,
                                  value: metricArticleIdValue,
                                  icon: Icons.fingerprint_rounded,
                                  isDark: isDark,
                                ),
                                _LinkMetricCard(
                                  label: metricLinkLabel,
                                  value: metricLinkValue,
                                  isDark: isDark,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: _DetailSummaryCard(
                              summary: summary,
                              isDark: isDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}

String _formatLastUpdated(DateTime? value, String languageCode) {
  if (value == null) {
    return '--';
  }

  final locale = languageCode == 'es' ? 'es' : 'en';
  return DateFormat('dd/MM/yyyy HH:mm', locale).format(value);
}

class _DetailVisualHero extends StatelessWidget {
  const _DetailVisualHero({
    required this.title,
    required this.imageUrl,
    required this.fallbackLabel,
    required this.heroTag,
    required this.isDark,
  });

  final String title;
  final String imageUrl;
  final String fallbackLabel;
  final String heroTag;
  final bool isDark;

  static const Map<String, String> _imageHeaders = <String, String>{
    'User-Agent': 'WikiSpaceApp/1.0 (Flutter)',
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 290,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: heroTag,
              child: imageUrl.isEmpty
                  ? _DetailImageFallback(
                      isDark: isDark,
                      label: fallbackLabel,
                    )
                  : CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      httpHeaders: _imageHeaders,
                      placeholder: (context, _) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2.2),
                      ),
                      errorWidget: (context, _, __) => _DetailImageFallback(
                        isDark: isDark,
                        label: fallbackLabel,
                      ),
                    ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.72),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 12,
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.screenTitle(true).copyWith(fontSize: 23),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailImageFallback extends StatelessWidget {
  const _DetailImageFallback({required this.isDark, required this.label});

  final bool isDark;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? AppPalette.surfaceDarkAlt : AppPalette.surfaceLightAlt,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SpaceLogo(size: 64, showWordmark: false),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.caption(isDark)),
        ],
      ),
    );
  }
}

class _DetailSummaryCard extends StatelessWidget {
  const _DetailSummaryCard({required this.summary, required this.isDark});

  final String summary;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: (isDark ? AppPalette.surfaceDarkAlt : AppPalette.surfaceLight)
            .withValues(alpha: isDark ? 0.82 : 0.94),
        border: Border.all(
          color: AppPalette.accent.withValues(alpha: 0.24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Text(summary, style: AppTextStyles.bodyMd(isDark)),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.sizeOf(context).width - 52) / 2;

    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: (isDark ? AppPalette.surfaceDark : AppPalette.surfaceLight)
              .withValues(alpha: isDark ? 0.82 : 0.94),
          border: Border.all(
            color: AppPalette.accent.withValues(alpha: 0.22),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: AppPalette.star),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption(isDark),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMd(isDark).copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppPalette.onDark : AppPalette.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkMetricCard extends StatelessWidget {
  const _LinkMetricCard({
    required this.label,
    required this.value,
    required this.isDark,
  });

  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.sizeOf(context).width - 52) / 2;

    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: (isDark ? AppPalette.surfaceDark : AppPalette.surfaceLight)
              .withValues(alpha: isDark ? 0.82 : 0.94),
          border: Border.all(
            color: AppPalette.accent.withValues(alpha: 0.22),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: value == '--'
              ? null
              : () async {
                  var launched = false;

                  try {
                    final uri = Uri.tryParse(value);
                    if (uri != null) {
                      final canOpen = await canLaunchUrl(uri);
                      if (canOpen) {
                        launched = await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    }
                  } catch (_) {
                    launched = false;
                  }

                  if (!launched) {
                    await Clipboard.setData(ClipboardData(text: value));
                  }

                  if (!context.mounted) {
                    return;
                  }
                  final languageCode =
                      Localizations.localeOf(context).languageCode;
                  final message = launched
                      ? (languageCode == 'es'
                          ? 'Abriendo articulo en el navegador'
                          : 'Opening article in browser')
                      : (languageCode == 'es'
                          ? 'No se pudo abrir. Enlace copiado'
                          : 'Could not open. Link copied');
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(message)));
                },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.link_rounded, size: 16, color: AppPalette.star),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption(isDark),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMd(isDark).copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppPalette.star : AppPalette.secondary,
                    decoration: value == '--'
                        ? TextDecoration.none
                        : TextDecoration.underline,
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
