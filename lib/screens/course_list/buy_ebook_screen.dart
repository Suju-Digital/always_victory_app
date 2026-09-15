import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../controller/ebook_purchase_controller.dart';
import '../../data/app_config/app_config.dart';
import '../../models/ebook_model.dart';

class BuyEbookScreen extends StatelessWidget {
  final EbookModel ebook;

  const BuyEbookScreen({
    super.key,
    required this.ebook,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuyEbookController>();
    controller.selectedBook.value = ebook;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "E-Book Overview",
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
                /// 1. FULL-WIDTH CLEAR HERO E-BOOK POSTER FRAME
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
                      AppConfig.getEbookThumbnailUrl(ebook.thumbnail),
                      width: double.infinity,
                      height: 260,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          AppConfig.getImageUrl(
                            AppConfig.studentImageBaseUrl,
                            ebook.thumbnail,
                          ),
                          width: double.infinity,
                          height: 260,
                          fit: BoxFit.contain,
                          errorBuilder: (context2, error2, stack2) {
                            return Image.network(
                              AppConfig.getImageUrl(
                                AppConfig.imageBaseUrl,
                                ebook.thumbnail,
                              ),
                              width: double.infinity,
                              height: 260,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Container(
                                color: AppColors.primary
                                    .withValues(alpha: 0.08),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.menu_book_rounded,
                                      color: AppColors.primary,
                                      size: 60,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "E-BOOK COVER",
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
                          "OFFICIAL STUDY GUIDE",
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
                    ebook.title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 3. DESCRIPTION CARD
                Text(
                  "About This E-Book 📖",
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
                    ebook.description.isNotEmpty
                        ? ebook.description
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

                _buildHighlightRow("📱", "Instant In-App PDF Reading Access"),
                _buildHighlightRow("⚡", "Topic-wise Solved MCQs & Explanations"),
                _buildHighlightRow("🔒", "Secure Offline Reading Protection"),
                _buildHighlightRow("🏆", "Official Exam Syllabus Coverage"),
              ],
            ),
          ),

          /// 5. BOTTOM STICKY PRICE & PURCHASE BAR
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Total Price",
                          style: AppTextStyles.caption,
                        ),
                        Text(
                          "₹${ebook.price}",
                          style: AppTextStyles.h1.copyWith(
                            color: AppColors.primary,
                            fontSize: 28,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Buy Now Button
                    SizedBox(
                      height: 48,
                      width: 160,
                      child: ElevatedButton.icon(
                        onPressed: controller.startPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.shopping_bag_rounded, size: 18),
                        label: Text(
                          "Buy Now",
                          style: AppTextStyles.button,
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
    );
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
