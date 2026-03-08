import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Tarjeta de metrica con enlace tocable al articulo original.
class DetailLinkMetricCard extends StatelessWidget {
  const DetailLinkMetricCard({
    super.key,
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
          onTap: value == '--' ? null : () => _openOrCopyLink(context),
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

  /// Intenta abrir URL externa; si falla, copia el enlace al portapapeles.
  Future<void> _openOrCopyLink(BuildContext context) async {
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

    final languageCode = Localizations.localeOf(context).languageCode;
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
  }
}
