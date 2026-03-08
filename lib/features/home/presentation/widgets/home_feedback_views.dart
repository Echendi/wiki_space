import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomeLoadingView extends StatelessWidget {
  const HomeLoadingView({super.key, required this.isDark, required this.label});

  final bool isDark;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(label, style: AppTextStyles.bodyMd(isDark)),
        ],
      ),
    );
  }
}

class HomeErrorView extends StatelessWidget {
  const HomeErrorView({
    super.key,
    required this.isDark,
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final bool isDark;
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.travel_explore_rounded,
            size: 40,
            color: isDark ? AppPalette.onDarkMuted : AppPalette.onPrimary,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMd(isDark),
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: onRetry,
            child: Text(retryLabel),
          ),
        ],
      ),
    );
  }
}

class HomeConnectivityBanner extends StatelessWidget {
  const HomeConnectivityBanner({
    super.key,
    required this.isDark,
    required this.isOfflineMode,
    required this.showReconnectAction,
    required this.offlineMessage,
    required this.reconnectMessage,
    required this.syncLabel,
    required this.onSync,
  });

  final bool isDark;
  final bool isOfflineMode;
  final bool showReconnectAction;
  final String offlineMessage;
  final String reconnectMessage;
  final String syncLabel;
  final VoidCallback onSync;

  @override
  Widget build(BuildContext context) {
    if (!isOfflineMode && !showReconnectAction) {
      return const SizedBox.shrink();
    }

    final hasReconnectAction = showReconnectAction && !isOfflineMode;
    final message = hasReconnectAction ? reconnectMessage : offlineMessage;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? AppPalette.surfaceDarkAlt.withValues(alpha: 0.94)
            : AppPalette.surfaceLightAlt.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppPalette.borderMuted.withValues(alpha: isDark ? 0.7 : 0.45),
        ),
      ),
      child: Row(
        children: [
          Icon(
            hasReconnectAction ? Icons.wifi_rounded : Icons.wifi_off_rounded,
            size: 18,
            color: isDark ? AppPalette.onDark : AppPalette.onPrimary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyMd(isDark),
            ),
          ),
          if (hasReconnectAction)
            TextButton(
              onPressed: onSync,
              child: Text(syncLabel),
            ),
        ],
      ),
    );
  }
}
