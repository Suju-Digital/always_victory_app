import 'package:always_victory/data/app_config/app_config.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/day_model.dart';

class DaysListTile extends StatelessWidget {
  const DaysListTile({
    super.key,
    required this.day,
    required this.index,
  });

  final DayModel day;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Thumbnail Image Frame
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: day.thumbnail.isNotEmpty
                ? Image.network(
                    "${AppConfig.imageBaseUrl}${day.thumbnail}",
                    height: 75,
                    width: 85,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 75,
                      width: 85,
                      color: AppColors.primary.withValues(alpha: 0.08),
                      child: const Icon(
                        Icons.quiz_rounded,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),
                  )
                : Container(
                    height: 75,
                    width: 85,
                    color: AppColors.primary.withValues(alpha: 0.08),
                    child: const Icon(
                      Icons.quiz_rounded,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
          ),

          const SizedBox(width: 12),

          /// Content Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Day Tag Pill
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
                    day.dayName.isNotEmpty ? day.dayName : "Day ${index + 1}",
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontSize: 10,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // Title
                Text(
                  day.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 2),

                // Description
                Text(
                  day.description.isNotEmpty
                      ? day.description
                      : "Practice questions & test concepts",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          /// Play Action Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
