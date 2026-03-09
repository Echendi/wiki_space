import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// Banner de conectividad para modo offline y accion de resincronizacion.
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
