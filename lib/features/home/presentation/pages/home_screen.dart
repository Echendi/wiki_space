import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/global_top_bar.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/data/auth_service.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.authService,
    required this.locale,
    required this.themeMode,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
  });

  final AuthService authService;
  final Locale locale;
  final ThemeMode themeMode;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _pageController =
      PageController(viewportFraction: 0.68);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _signOut(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await widget.authService.signOut();
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.signOutSuccess)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final languageCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: GlobalTopBar(
        locale: widget.locale,
        themeMode: widget.themeMode,
        onLocaleChanged: widget.onLocaleChanged,
        onThemeModeChanged: widget.onThemeModeChanged,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? AppPalette.homeDarkGradient
                : AppPalette.homeLightGradient,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
            child: BlocProvider(
              key: ValueKey(languageCode),
              create: (_) => serviceLocator<HomeCubit>()..load(languageCode),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHeader(
                    isDark: isDark,
                    onSignOut: () => _signOut(context),
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        switch (state.status) {
                          case HomeStatus.loading:
                          case HomeStatus.initial:
                            return HomeLoadingView(
                              isDark: isDark,
                              label: l10n.homeLoading,
                            );
                          case HomeStatus.failure:
                            final isEmpty =
                                state.errorMessage == 'empty-results';
                            return HomeErrorView(
                              isDark: isDark,
                              message: isEmpty
                                  ? l10n.homeEmptyResults
                                  : l10n.homeLoadError,
                              retryLabel: l10n.homeRetry,
                              onRetry: () =>
                                  context.read<HomeCubit>().load(languageCode),
                            );
                          case HomeStatus.success:
                            return HomeCarouselContent(
                              state: state,
                              pageController: _pageController,
                              isDark: isDark,
                              onRetry: () =>
                                  context.read<HomeCubit>().load(languageCode),
                              onOpenDetail: (articleId) {
                                final encoded =
                                    Uri.encodeQueryComponent(articleId);
                                context.push('${AppRoutes.detail}?id=$encoded');
                              },
                            );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
