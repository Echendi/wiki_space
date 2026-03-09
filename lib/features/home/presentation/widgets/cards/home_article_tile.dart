import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import 'home_image_fallback.dart';

/// Tarjeta de articulo usada en el grid inferior de Home.
class HomeArticleTile extends StatelessWidget {
  const HomeArticleTile({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.isDark,
    required this.onTap,
  });

  final String title;
  final String imageUrl;
  final bool isDark;
  final VoidCallback onTap;
  static const Map<String, String> _imageHeaders = <String, String>{
    'User-Agent': 'WikiSpaceApp/1.0 (Flutter)',
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tileBackground =
        (isDark ? AppPalette.surfaceDarkAlt : AppPalette.surfaceLight)
            .withValues(alpha: isDark ? 0.82 : 0.95);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: tileBackground,
          border: Border.all(
            color: AppPalette.accent.withValues(alpha: 0.22),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (imageUrl.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  httpHeaders: _imageHeaders,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: tileBackground,
                    alignment: Alignment.center,
                    child: const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (_, __, ___) => ColoredBox(
                    color: tileBackground,
                    child: HomeImageFallback(label: l10n.homeImageUnavailable),
                  ),
                )
              else
                ColoredBox(
                  color: tileBackground,
                  child: HomeImageFallback(label: l10n.homeImageUnavailable),
                ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.08),
                      Colors.black.withValues(alpha: 0.72),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
