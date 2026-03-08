import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/global_top_bar/global_top_bar.dart';
import '../../../../core/widgets/space_scene_background/space_scene_background.dart';
import '../../../../features/home/presentation/widgets/home_carousel_content.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../cubit/detail_cubit.dart';
import '../cubit/detail_status.dart';
import '../cubit/detail_state.dart';
import '../utils/detail_formatters.dart';
import '../widgets/widgets.dart';

/// Pantalla de detalle de articulo espacial.
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

  /// Crea cubit y define idioma por defecto mientras llegan dependencias de UI.
  @override
  void initState() {
    super.initState();
    _detailCubit = serviceLocator<DetailCubit>();
    _articleLanguageCode = 'es';
  }

  /// Captura locale actual y dispara carga inicial de detalle si aplica.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _articleLanguageCode = Localizations.localeOf(context).languageCode;
    _loadIfNeeded();
  }

  /// Recarga detalle cuando cambia el id objetivo de la pantalla.
  @override
  void didUpdateWidget(covariant DetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.articleId != widget.articleId) {
      _articleLanguageCode = Localizations.localeOf(context).languageCode;
      _loadIfNeeded(force: true);
    }
  }

  /// Evita cargas duplicadas del mismo articulo/lenguaje.
  void _loadIfNeeded({bool force = false}) {
    if (!force && _loadedArticleId == widget.articleId) {
      return;
    }

    _loadedArticleId = widget.articleId;
    _detailCubit.load(widget.articleId, _articleLanguageCode);
  }

  /// Libera cubit local de la pantalla.
  @override
  void dispose() {
    _detailCubit.close();
    super.dispose();
  }

  /// Construye estados de loading/error/success del detalle.
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
                    DetailFormatters.formatLastUpdated(
                  detail.lastUpdatedAt,
                  languageCode,
                );
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
                            child: DetailVisualHero(
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
                                DetailMetricCard(
                                  label: metricLastUpdatedLabel,
                                  value: metricLastUpdatedValue,
                                  icon: Icons.schedule_rounded,
                                  isDark: isDark,
                                ),
                                DetailMetricCard(
                                  label: metricLanguageLabel,
                                  value: metricLanguageValue,
                                  icon: Icons.language_rounded,
                                  isDark: isDark,
                                ),
                                DetailMetricCard(
                                  label: metricArticleIdLabel,
                                  value: metricArticleIdValue,
                                  icon: Icons.fingerprint_rounded,
                                  isDark: isDark,
                                ),
                                DetailLinkMetricCard(
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
                            child: DetailSummaryCard(
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
