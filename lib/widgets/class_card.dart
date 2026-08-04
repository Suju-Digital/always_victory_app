  import 'package:always_victory/data/app_config/app_config.dart';
import 'package:always_victory/widgets/custom_button.dart';
  import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/class_model.dart';

  class ClassCard extends StatelessWidget {
    final ClassModel data;
    final VoidCallback? onTap;

    final double progress; // 0.0 → 1.0
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
        margin: const EdgeInsets.only(bottom: 20), // Only bottom margin needed
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🖼️ Image Section
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    child: Image.network(
                      "${AppConfig.studentImageBaseUrl}${data.posterImage}",
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 160,
                        color: Colors.grey.shade50,
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                  
                  // Status Overlay
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isLocked ? Colors.black.withOpacity(0.7) : AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isLocked ? Icons.lock_outline : Icons.play_circle_fill,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isLocked ? "LOCKED" : "START",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (data.discountPercent > 0)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.wrong,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          "${data.discountPercent}% OFF",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            data.className.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        if (totalEnroll != null && totalEnroll! > 0)
                          Row(
                            children: [
                              const Icon(Icons.people_alt_rounded, size: 12, color: AppColors.textGrey),
                              const SizedBox(width: 4),
                              Text(
                                "$totalEnroll students",
                                style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    /// Title
                    Text(
                      data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Description
                    Text(
                      data.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textGrey.withOpacity(0.7),
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Footer
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox( // Prevent price overflow
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "₹${data.finalPrice}",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ),
                              if (data.originalPrice > data.finalPrice)
                                Text(
                                  "₹${data.originalPrice}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade400,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        CustomButton(
                          text: isLocked ? "Join Now" : (progress > 0 ? "Resume" : "Start"),
                          onPressed: onTap,
                          width: 120,
                          color: isLocked ? AppColors.textDark : AppColors.primary,
                        ),
                      ],
                    ),
                    
                    if (progress > 0) ...[
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress / 100,
                          minHeight: 4,
                          backgroundColor: AppColors.primary.withOpacity(0.05),
                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${progress.toInt()}% Completed",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
