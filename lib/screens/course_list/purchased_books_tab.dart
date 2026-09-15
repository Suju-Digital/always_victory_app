import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';
import '../../controller/class_controller.dart';
import '../../data/app_config/app_config.dart';
import 'buy_ebook_screen.dart';
import 'ebook_reader.dart';

class PurchasedBooksTab extends StatelessWidget {
  PurchasedBooksTab({super.key});

  final ClassController controller = ClassController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.ebooks.isEmpty) {
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await controller.loadEbooks();
            await controller.loadPurchasedBooks();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        size: 64,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No E-Books Available Yet',
                      style: AppTextStyles.h3,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Check back soon for new study materials!',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          await controller.loadEbooks();
          await controller.loadPurchasedBooks();
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(AppConstants.paddingMD),
          physics: const BouncingScrollPhysics(),
          itemCount: controller.ebooks.length,
          itemBuilder: (context, index) {
            final ebook = controller.ebooks[index];
            final isPurchased = controller.purchasedBooks[ebook.id] ?? false;

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
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(16),
                    ),
                    child: Image.network(
                      AppConfig.getEbookThumbnailUrl(ebook.thumbnail),
                      width: 90,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 90,
                        height: 120,
                        color: AppColors.primary.withValues(alpha: 0.08),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          size: 36,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ebook.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ebook.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "₹${ebook.price}",
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (isPurchased) {
                                    Get.to(() => EbookReaderScreen(ebook: ebook));
                                  } else {
                                    Get.to(() => BuyEbookScreen(ebook: ebook));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isPurchased
                                      ? const Color(0xFF10B981)
                                      : AppColors.primary,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  isPurchased ? "Read 📖" : "Buy Now 🛒",
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
