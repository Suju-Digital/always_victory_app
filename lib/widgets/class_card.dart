import 'package:always_victory/data/app_config/app_config.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/class_model.dart';
import 'app_cached_image.dart';

class ClassCard extends StatelessWidget {
  final ClassModel data;
  final VoidCallback? onTap;

  final double progress; // 0.0 → 100.0
  final bool isHighlighted;
  final int? totalEnroll;
  final bool isLocked;

  const ClassCard({
    super.key,
    required this.data,
    this.onTap,
    this.progress = 0.0,
    this.isHighlighted = false,
    this.totalEnroll = 0,
    this.isLocked = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              /// 🖼️ Compact Thumbnail Image
              Stack(
                children: [
                  AppCachedImage(
                    imageUrl: "${AppConfig.studentImageBaseUrl}${data.posterImage}",
                    height: 80,
                    width: 85,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(12),
                    memCacheHeight: 160,
                    memCacheWidth: 170,
                    fallbackIcon: Icons.school_rounded,
                  ),
                  if (isLocked)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.lock_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 12),

              /// 📝 Class Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Class Name Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        data.className,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Title
                    Text(
                      data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 2),

                    // Description / Subtitle
                    Text(
                      data.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall,
                    ),

                    const SizedBox(height: 8),

                    // Price & Action Button Row
                    Row(
                      children: [
                        Text(
                          "₹${data.finalPrice}",
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (data.originalPrice > data.finalPrice) ...[
                          const SizedBox(width: 6),
                          Text(
                            "₹${data.originalPrice}",
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.grey.shade400,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                        const Spacer(),

                        // Compact Action Button
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isLocked
                                ? Colors.grey.shade800
                                : AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            isLocked
                                ? "Unlock 🔒"
                                : (progress > 0 ? "Resume ⚡" : "Start ▶"),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Progress indicator if active
                    if (progress > 0) ...[
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress / 100,
                          minHeight: 4,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
