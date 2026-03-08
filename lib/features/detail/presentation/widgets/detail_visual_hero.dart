import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import 'detail_image_fallback.dart';

/// Hero visual principal del detalle con imagen, gradiente y titulo.
class DetailVisualHero extends StatelessWidget {
  const DetailVisualHero({
    super.key,
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
                  ? DetailImageFallback(
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
                      errorWidget: (context, _, __) => DetailImageFallback(
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
