import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_colors.dart';

/// High-performance cached network image widget with shimmer placeholder and error fallback.
class AppCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final IconData fallbackIcon;
  final int? memCacheWidth;
  final int? memCacheHeight;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.fallbackIcon = Icons.school_rounded,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imageUrl.trim().isEmpty) {
      imageWidget = _buildError();
    } else {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: memCacheWidth,
        memCacheHeight: memCacheHeight,
        fadeInDuration: const Duration(milliseconds: 150),
        fadeOutDuration: const Duration(milliseconds: 100),
        placeholder: (context, url) =>
            placeholder ??
            Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: width,
                height: height,
                color: Colors.white,
              ),
            ),
        errorWidget: (context, url, error) => errorWidget ?? _buildError(),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildError() {
    return Container(
      width: width,
      height: height,
      color: AppColors.primary.withValues(alpha: 0.08),
      child: Center(
        child: Icon(
          fallbackIcon,
          color: AppColors.primary,
          size: (height != null && height! < 50) ? 20 : 32,
        ),
      ),
    );
  }
}



