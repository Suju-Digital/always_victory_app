import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../controller/buy_course_controller.dart';
import '../../data/app_config/app_config.dart';
import '../../models/class_model.dart';

class BuyClassScreen extends StatefulWidget {
  const BuyClassScreen({super.key});

  @override
  State<BuyClassScreen> createState() => _BuyClassScreenState();
}

class _BuyClassScreenState extends State<BuyClassScreen> {
  final BuyCourseController controller = Get.find<BuyCourseController>();

  Timer? _timer;
  Duration _timeLeft = Duration.zero;
  bool _timerInitialized = false;

  void _initDynamicTimer(ClassModel item) {
    if (_timerInitialized) return;
    _timerInitialized = true;

    final now = DateTime.now();

    // 1. Try parsing offer_ends_at / expiryDate from Database (e.g. "2026-09-16 10:46:32")
    final rawExpiry = item.expiryDate?.trim();
    if (rawExpiry != null &&
        rawExpiry.isNotEmpty &&
        rawExpiry.toUpperCase() != 'NULL') {
      try {
        final parsedExpiry = DateTime.parse(rawExpiry);
        if (parsedExpiry.isAfter(now)) {
          _timeLeft = parsedExpiry.difference(now);
          _startTimer();
          return;
        }
      } catch (e) {
        debugPrint("Expiry date parse error: $e");
      }
    }

    // 2. Try offerHours from Database if offer_ends_at was null
    if (item.offerHours != null && item.offerHours! > 0) {
      _timeLeft = Duration(hours: item.offerHours!);
      _startTimer();
      return;
    }

    // 3. If DB did NOT specify any expiry_date or offer_hours, DO NOT start any timer!
    _timer?.cancel();
    _timeLeft = Duration.zero;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        if (mounted) {
          setState(() {
            _timeLeft -= const Duration(seconds: 1);
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    if (_timeLeft.inSeconds <= 0) return "00h 00m 00s";

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final totalHours = twoDigits(_timeLeft.inHours);
    final minutes = twoDigits(_timeLeft.inMinutes.remainder(60));
    final seconds = twoDigits(_timeLeft.inSeconds.remainder(60));

    return "${totalHours}h ${minutes}m ${seconds}s";
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final item = controller.selectedClass.value;

      if (item == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      // Initialize dynamic timer strictly if DB timer fields exist
      _initDynamicTimer(item);

      final double originalPrice =
          double.tryParse(item.originalPrice.toString()) ?? 0;
      final double finalPrice =
          double.tryParse(item.finalPrice.toString()) ?? 0;

      final rawExpiry = item.expiryDate?.trim();
      final bool hasDbTimer = ((rawExpiry != null &&
                  rawExpiry.isNotEmpty &&
                  rawExpiry.toUpperCase() != 'NULL') ||
              (item.offerHours != null && item.offerHours! > 0)) &&
          _timeLeft.inSeconds > 0;

      final bool hasDiscount = originalPrice > finalPrice || item.discountPercent > 0;

      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: Text(
            "Course Overview",
            style: AppTextStyles.appBarTitle.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.appGradient,
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 1. FULL-WIDTH CLEAR HERO COURSE POSTER FRAME
                  Container(
                    width: double.infinity,
                    height: 260,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        AppConfig.getClassPosterUrl(item.posterImage),
                        width: double.infinity,
                        height: 260,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            AppConfig.getImageUrl(
                              AppConfig.imageBaseUrl,
                              item.posterImage,
                            ),
                            width: double.infinity,
                            height: 260,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.school_rounded,
                                    color: AppColors.primary,
                                    size: 60,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "COURSE POSTER",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 2. TITLE & CATEGORY BADGE
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified_rounded,
                            color: AppColors.primary,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.className.toUpperCase(),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.primary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Center(
                    child: Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 3. DESCRIPTION CARD
                  Text(
                    "About This Course 📖",
                    style: AppTextStyles.h4,
                  ),

                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      item.description.isNotEmpty
                          ? item.description
                          : "Comprehensive chapter-wise study guide with solved MCQs, key concepts, and revision notes.",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey.shade800,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 4. KEY HIGHLIGHTS
                  Text(
                    "What's Included 🎯",
                    style: AppTextStyles.h4,
                  ),

                  const SizedBox(height: 12),

                  _buildHighlightRow("📱", "Daily Interactive MCQ Practice"),
                  _buildHighlightRow("⚡", "Chapter-wise Tests & Solutions"),
                  _buildHighlightRow("🔒", "Instant Course Unlock & Progress Tracking"),
                  _buildHighlightRow("🏆", "Rankings & Star Rewards"),
                ],
              ),
            ),

            /// 5. BOTTOM STICKY PRICE & PURCHASE BAR WITH CONDITIONAL TIMER
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Countdown Timer Strip ONLY IF timer data exists in Database!
                  if (hasDbTimer)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF3CD),
                        border: Border(
                          top: BorderSide(color: Color(0xFFFFE082), width: 1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Limited Discount Ends in: ",
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            _formattedTime,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: const Color(0xFFD84315),
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Action Price Bar
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF5227),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            // Price Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (originalPrice > finalPrice)
                                    Text(
                                      "₹$originalPrice",
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: Colors.white70,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          "₹$finalPrice",
                                          style: AppTextStyles.h2.copyWith(
                                            color: Colors.white,
                                            fontSize: 28,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              hasDiscount ? "Only Today" : "Best Price",
                                              style: AppTextStyles.caption.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            Text(
                                              "${controller.enrollStudents} Enrolled",
                                              style: AppTextStyles.caption.copyWith(
                                                color: Colors.white
                                                    .withValues(alpha: 0.9),
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Enroll Now Button
                            ElevatedButton(
                              onPressed: controller.startPayment,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFFFF5227),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "Enroll Now",
                                style: AppTextStyles.button.copyWith(
                                  color: const Color(0xFFFF5227),
                                  fontSize: 15,
                                ),
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
      );
    });
  }

  Widget _buildHighlightRow(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
