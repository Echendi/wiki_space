import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'home_image_fallback.dart';

/// Imagen de articulo con soporte de placeholder, error y Hero opcional.
class HomeArticleImage extends StatelessWidget {
  const HomeArticleImage({
    super.key,
    required this.imageUrl,
    required this.fallbackLabel,
    this.heroTag,
  });

  final String imageUrl;
  final String fallbackLabel;
  final String? heroTag;

  static const Map<String, String> _imageHeaders = <String, String>{
    'User-Agent': 'WikiSpaceApp/1.0 (Flutter)',
  };

  @override
  Widget build(BuildContext context) {
    final child = imageUrl.isEmpty
        ? HomeImageFallback(label: fallbackLabel)
        : CachedNetworkImage(
            imageUrl: imageUrl,
            httpHeaders: _imageHeaders,
            fit: BoxFit.cover,
            placeholder: (context, _) => const Center(
              child: CircularProgressIndicator(strokeWidth: 2.2),
            ),
            errorWidget: (context, _, __) =>
                HomeImageFallback(label: fallbackLabel),
          );

    if (heroTag == null || heroTag!.isEmpty) {
      return child;
    }

    return Hero(tag: heroTag!, child: child);
  }
}
