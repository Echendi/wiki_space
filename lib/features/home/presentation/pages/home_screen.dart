import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/global_top_bar/global_top_bar.dart';
import '../../../../core/widgets/space_scene_background/space_scene_background.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_status.dart';
import '../cubit/home_state.dart';
import '../widgets/widgets.dart';

/// Pantalla principal de Home con feed, carrusel y estados de carga/error.
class HomeScreen extends StatefulWidget {
  /// Crea la pantalla Home.
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// Estado asociado a [HomeScreen] para coordinar controladores y acciones.
class _HomeScreenState extends State<HomeScreen> {
  static const int _minSearchChars = 3;

  /// Evita warnings cuando no se requiere reaccionar al evento `onChanged`.
  static void _ignoreSearchChanged(String _) {}

  late final PageController _pageController =
      PageController(viewportFraction: 0.68);
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// Ejecuta una busqueda valida en el cubit.
  void _submitSearch(HomeCubit cubit, String languageCode) {
    final query = _searchController.text.trim();
    if (!_shouldSearch(query)) {
      return;
    }

    if (!cubit.isClosed) {
      cubit.search(languageCode, query);
    }
  }

  /// Define si la query cumple la regla minima para buscar.
  bool _shouldSearch(String query) {
    return query.isEmpty || query.length >= _minSearchChars;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final languageCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const GlobalTopBar(),
      body: SpaceSceneBackground(
        isDark: isDark,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: BlocProvider(
              key: ValueKey(languageCode),
              create: (_) => serviceLocator<HomeCubit>()..load(languageCode),
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  final homeCubit = context.read<HomeCubit>();

                  switch (state.status) {
                    case HomeStatus.loading:
                    case HomeStatus.initial:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HomeHeader(isDark: isDark),
                          const SizedBox(height: 8),
                          HomeSearchBar(
                            controller: _searchController,
                            onChanged: _ignoreSearchChanged,
                            onSubmitted: (_) =>
                                _submitSearch(homeCubit, languageCode),
                            onSearchTap: () =>
                                _submitSearch(homeCubit, languageCode),
                            isDark: isDark,
                          ),
                          HomeConnectivityBanner(
                            isDark: isDark,
                            isOfflineMode: state.isOfflineMode,
                            showReconnectAction: state.showReconnectAction,
                            offlineMessage: l10n.homeOfflineBanner,
                            reconnectMessage: l10n.homeReconnectBanner,
                            syncLabel: l10n.homeSyncAction,
                            onSync: () => homeCubit.load(languageCode,
                                query: state.query),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: HomeLoadingView(
                              isDark: isDark,
                              label: l10n.homeLoading,
                            ),
                          ),
                        ],
                      );
                    case HomeStatus.failure:
                      final isEmpty = state.errorMessage == 'empty-results';
                      final isOfflineNoCache =
                          state.errorMessage == 'offline-no-cache';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HomeHeader(isDark: isDark),
                          const SizedBox(height: 8),
                          HomeSearchBar(
                            controller: _searchController,
                            onChanged: _ignoreSearchChanged,
                            onSubmitted: (_) =>
                                _submitSearch(homeCubit, languageCode),
                            onSearchTap: () =>
                                _submitSearch(homeCubit, languageCode),
                            isDark: isDark,
                          ),
                          HomeConnectivityBanner(
                            isDark: isDark,
                            isOfflineMode: state.isOfflineMode,
                            showReconnectAction: state.showReconnectAction,
                            offlineMessage: l10n.homeOfflineBanner,
                            reconnectMessage: l10n.homeReconnectBanner,
                            syncLabel: l10n.homeSyncAction,
                            onSync: () => homeCubit.load(languageCode,
                                query: state.query),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: HomeErrorView(
                              isDark: isDark,
                              message: isOfflineNoCache
                                  ? l10n.homeOfflineNoCache
                                  : (isEmpty
                                      ? l10n.homeEmptyResults
                                      : l10n.homeLoadError),
                              retryLabel: l10n.homeRetry,
                              onRetry: () => homeCubit.load(languageCode),
                            ),
                          ),
                        ],
                      );
                    case HomeStatus.success:
                      return HomeSuccessView(
                        state: state,
                        isDark: isDark,
                        l10n: l10n,
                        pageController: _pageController,
                        searchController: _searchController,
                        onSearchChanged: _ignoreSearchChanged,
                        onSearchSubmitted: () =>
                            _submitSearch(homeCubit, languageCode),
                        onRetryLoad: () => homeCubit.load(languageCode),
                        onLoadMore: () => homeCubit.loadMore(languageCode),
                        showOfflineBanner: state.isOfflineMode,
                        showReconnectAction: state.showReconnectAction,
                        offlineMessage: l10n.homeOfflineBanner,
                        reconnectMessage: l10n.homeReconnectBanner,
                        syncLabel: l10n.homeSyncAction,
                        onSync: () =>
                            homeCubit.load(languageCode, query: state.query),
                        onOpenDetail: (articleId) {
                          final encoded = Uri.encodeQueryComponent(articleId);
                          context.push('${AppRoutes.detail}?id=$encoded');
                        },
                      );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
