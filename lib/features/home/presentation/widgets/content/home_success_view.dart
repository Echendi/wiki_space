import 'package:flutter/material.dart';

import '../../../../../l10n/generated/app_localizations.dart';
import '../../cubit/home_state.dart';
import '../components/home_ambient_backdrop.dart';
import 'home_articles_sliver_grid.dart';
import 'home_carousel_content.dart';
import '../feedback/home_feedback_views.dart';
import '../components/home_feed_header_sliver.dart';
import '../components/home_header.dart';
import '../components/home_load_more_sliver.dart';
import '../components/home_search_bar.dart';

/// Vista principal de Home cuando hay contenido disponible.
class HomeSuccessView extends StatelessWidget {
  const HomeSuccessView({
    super.key,
    required this.state,
    required this.isDark,
    required this.l10n,
    required this.pageController,
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.onRetryLoad,
    required this.onLoadMore,
    required this.onOpenDetail,
    required this.showOfflineBanner,
    required this.showReconnectAction,
    required this.offlineMessage,
    required this.reconnectMessage,
    required this.syncLabel,
    required this.onSync,
  });

  final HomeState state;
  final bool isDark;
  final AppLocalizations l10n;
  final PageController pageController;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchSubmitted;
  final VoidCallback onRetryLoad;
  final VoidCallback onLoadMore;
  final void Function(String articleId) onOpenDetail;
  final bool showOfflineBanner;
  final bool showReconnectAction;
  final String offlineMessage;
  final String reconnectMessage;
  final String syncLabel;
  final VoidCallback onSync;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final carouselHeight =
            (constraints.maxHeight * 0.56).clamp(250.0, 380.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 74,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: IgnorePointer(
                      child: HomeAmbientBackdrop(isDark: isDark),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: HomeHeader(isDark: isDark),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            HomeSearchBar(
              controller: searchController,
              onChanged: onSearchChanged,
              onSubmitted: (_) => onSearchSubmitted(),
              onSearchTap: onSearchSubmitted,
              isDark: isDark,
            ),
            HomeConnectivityBanner(
              isDark: isDark,
              isOfflineMode: showOfflineBanner,
              showReconnectAction: showReconnectAction,
              offlineMessage: offlineMessage,
              reconnectMessage: reconnectMessage,
              syncLabel: syncLabel,
              onSync: onSync,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  final isVertical = notification.metrics.axis == Axis.vertical;
                  final shouldEvaluate =
                      notification is ScrollUpdateNotification ||
                          notification is ScrollEndNotification ||
                          notification is OverscrollNotification;
                  final hasScrollableExtent =
                      notification.metrics.maxScrollExtent > 0;
                  final nearBottom = notification.metrics.extentAfter < 520;

                  if (isVertical &&
                      shouldEvaluate &&
                      hasScrollableExtent &&
                      nearBottom) {
                    onLoadMore();
                  }
                  return false;
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SizedBox(
                          height: carouselHeight,
                          child: HomeCarouselContent(
                            state: state,
                            pageController: pageController,
                            isDark: isDark,
                            onRetry: onRetryLoad,
                            onOpenDetail: onOpenDetail,
                          ),
                        ),
                      ),
                    ),
                    HomeFeedHeaderSliver(
                      isDark: isDark,
                      title: l10n.homeSpaceFeedTitle,
                    ),
                    HomeArticlesSliverGrid(
                      items: state.articles,
                      isDark: isDark,
                      onOpenDetail: onOpenDetail,
                    ),
                    HomeLoadMoreSliver(
                      isLoadingMore: state.isLoadingMore,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
