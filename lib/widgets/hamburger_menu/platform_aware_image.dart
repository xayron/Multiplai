import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Platform-aware image widget: uses CachedNetworkImage on mobile, Image.network elsewhere.
class PlatformAwareImage extends StatelessWidget {
  final String url;
  final bool isDark;
  final BoxFit fit;
  final double? width;
  final double? height;

  const PlatformAwareImage({
    super.key,
    required this.url,
    required this.isDark,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        width: width,
        height: height,
        placeholder: (context, url) => Center(
          child: Icon(
            Icons.image,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            size: 16,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[700] : Colors.grey[300],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            Icons.smart_toy,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            size: 16,
          ),
        ),
      );
    } else {
      return Image.network(
        url,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[700] : Colors.grey[300],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            Icons.smart_toy,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            size: 16,
          ),
        ),
      );
    }
  }
}
