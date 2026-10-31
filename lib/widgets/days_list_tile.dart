import 'package:always_victory/data/app_config/app_config.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/day_model.dart';
import 'app_cached_image.dart';

class DaysListTile extends StatelessWidget {
  const DaysListTile({
    super.key,
    required this.day,
    required this.index,
    this.isUnlocked = true,
    this.isCompleted = false,
  });

  final DayModel day;
  final int index;
  final bool isUnlocked;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.white : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFF81C784).withValues(alpha: 0.5)
              : isUnlocked
                  ? Colors.grey.shade200
                  : Colors.grey.shade300,
          width: isCompleted ? 1.5 : 1.0,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Thumbnail Image Frame with Lock overlay if locked
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 75,
              width: 85,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: isUnlocked ? 1.0 : 0.5,
                      child: AppCachedImage(
                        imageUrl: day.thumbnail.isNotEmpty
                            ? "${AppConfig.imageBaseUrl}${day.thumbnail}"
                            : "",
                        height: 75,
                        width: 85,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(12),
                        memCacheWidth: 170,
                        memCacheHeight: 150,
                        fallbackIcon: isUnlocked
                            ? Icons.quiz_rounded
                            : Icons.lock_rounded,
                      ),
                    ),
                  ),
                  if (!isUnlocked)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.25),
                        child: const Center(
                          child: Icon(
                            Icons.lock_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  if (isCompleted)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2E7D32),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                ],
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
                // Day Status Pill
                _buildStatusPill(),

                const SizedBox(height: 4),

                // Title
                Text(
                  day.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isUnlocked ? Colors.black87 : Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 2),

                // Description
                Text(
                  !isUnlocked
                      ? "Complete previous day to unlock 🔒"
                      : isCompleted
                          ? "Completed! Practice again anytime ✨"
                          : day.description.isNotEmpty
                              ? day.description
                              : "Practice questions & test concepts",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: !isUnlocked
                        ? Colors.grey.shade500
                        : isCompleted
                            ? const Color(0xFF2E7D32)
                            : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          /// Action Icon (Lock / Check / Play)
          _buildActionIcon(),
        ],
      ),
    );
  }

  Widget _buildStatusPill() {
    if (!isUnlocked) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_rounded, size: 10, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              day.dayName.isNotEmpty
                  ? "${day.dayName} • Locked"
                  : "Day ${index + 1} • Locked",
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.grey.shade600,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    if (isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              size: 11,
              color: Color(0xFF2E7D32),
            ),
            const SizedBox(width: 4),
            Text(
              day.dayName.isNotEmpty
                  ? "${day.dayName} • Done"
                  : "Day ${index + 1} • Done",
              style: AppTextStyles.labelSmall.copyWith(
                color: const Color(0xFF2E7D32),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        day.dayName.isNotEmpty ? day.dayName : "Day ${index + 1}",
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.primary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionIcon() {
    if (!isUnlocked) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.lock_outline_rounded,
          color: Colors.grey.shade500,
          size: 18,
        ),
      );
    }

    if (isCompleted) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFFE8F5E9),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_rounded,
          color: Color(0xFF2E7D32),
          size: 18,
        ),
      );
    }

    return Container(
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
    );
  }
}
