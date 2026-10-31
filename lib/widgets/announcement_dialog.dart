import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../controller/class_controller.dart';
import '../data/app_config/app_config.dart';
import '../models/carousel_model.dart';
import '../screens/home/all_classes_screen.dart';
import 'app_cached_image.dart';

/// A modal announcement popup dialog displaying featured banner images,
/// promotional badges, catchy headlines, and a call-to-action button.
class AnnouncementDialog extends StatelessWidget {
  final CarouselModel? carouselItem;
  final String? customImageUrl;
  final String? badgeText;
  final String? title;
  final String? description;
  final String? buttonText;
  final VoidCallback? onExplore;

  const AnnouncementDialog({
    super.key,
    this.carouselItem,
    this.customImageUrl,
    this.badgeText,
    this.title,
    this.description,
    this.buttonText,
    this.onExplore,
  });

  /// Tracks whether the popup was already displayed in the current app session.
  static bool _hasShownThisSession = false;

  /// Resets the session flag.
  static void resetSession() {
    _hasShownThisSession = false;
  }

  /// Automatically checks for available carousel banners and displays
  /// the popup with a graceful entrance delay once per session.
  static void checkAndShow({bool force = false}) {
    if (_hasShownThisSession && !force) return;

    if (!Get.isRegistered<ClassController>()) return;
    final classController = Get.find<ClassController>();

    void triggerPopup(CarouselModel item) {
      if (_hasShownThisSession && !force) return;
      _hasShownThisSession = true;

      Future.delayed(const Duration(milliseconds: 650), () {
        if (Get.context != null && Get.isDialogOpen != true) {
          show(carouselItem: item);
        }
      });
    }

    if (classController.carousal.isNotEmpty) {
      triggerPopup(classController.carousal.first);
    } else {
      late Worker worker;
      worker = ever(classController.carousal, (list) {
        if (list.isNotEmpty) {
          triggerPopup(list.first);
          worker.dispose();
        }
      });
    }
  }

  /// Explicitly opens the announcement dialog.
  static void show({
    CarouselModel? carouselItem,
    String? customImageUrl,
    String? badgeText,
    String? title,
    String? description,
    String? buttonText,
    VoidCallback? onExplore,
  }) {
    if (Get.context == null) return;
    Get.dialog(
      AnnouncementDialog(
        carouselItem: carouselItem,
        customImageUrl: customImageUrl,
        badgeText: badgeText,
        title: title,
        description: description,
        buttonText: buttonText,
        onExplore: onExplore,
      ),
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      transitionDuration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    String resolvedImageUrl = customImageUrl ?? '';
    if (resolvedImageUrl.isEmpty && carouselItem != null) {
      resolvedImageUrl = AppConfig.getImageUrl(
        AppConfig.carsouleImageBaseUrl,
        carouselItem!.imageUrl,
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = (screenWidth * 0.88).clamp(280.0, 360.0);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: SizedBox(
          width: dialogWidth,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topRight,
            children: [
              // Main Popup Card
              Container(
                margin: const EdgeInsets.only(top: 14, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.22),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🖼️ Top Banner Image
                      if (resolvedImageUrl.isNotEmpty)
                        AppCachedImage(
                          imageUrl: resolvedImageUrl,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.fill,
                          memCacheWidth: 800,
                          fallbackIcon: Icons.campaign_rounded,
                        )
                      else
                        Container(
                          height: 140,
                          width: double.infinity,
                          color: AppColors.primary.withValues(alpha: 0.08),
                          child: const Center(
                            child: Icon(
                              Icons.campaign_rounded,
                              color: AppColors.primary,
                              size: 54,
                            ),
                          ),
                        ),

                      // 📝 Bottom Content Section
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 🌟 Special Announcement Pill Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFECEB),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: const Color(0xFFFFCDD2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.stars_rounded,
                                    color: AppColors.primary,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    badgeText ?? "SPECIAL ANNOUNCEMENT",
                                    style: GoogleFonts.poppins(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // 🚀 Primary Headline Title
                            Text(
                              title ?? "Boost Your Exam Score! 🚀",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F172A),
                                height: 1.25,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Subtitle / Description
                            Text(
                              description ??
                                  "Unlock daily practice tests & study e-books for Nursery to 12th Class!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF64748B),
                                height: 1.45,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // 🚀 Gradient Call-to-Action Button
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Get.back(); // Dismiss dialog
                                  if (onExplore != null) {
                                    onExplore!();
                                  } else {
                                    Get.to(() => const AllClassesScreen());
                                  }
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Ink(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFF5722),
                                        Color(0xFFFF7043),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFF5722)
                                            .withValues(alpha: 0.38),
                                        blurRadius: 12,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "🚀",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        buttonText ?? "EXPLORE NOW",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ❌ Circular Floating Close Button
              Positioned(
                top: 0,
                right: 0,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF1E293B),
                        size: 22,
                      ),
                    ),
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
