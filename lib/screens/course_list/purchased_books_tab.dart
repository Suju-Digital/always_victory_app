import 'package:always_victory/controller/class_controller.dart';
import 'package:always_victory/data/app_config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../controller/ebook_purchase_controller.dart';
import '../../routes/app_routes.dart';
import 'ebook_reader.dart';

class PurchasedBooksTab extends StatelessWidget {
  PurchasedBooksTab({super.key});

  final ClassController controller = ClassController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.ebooks.isEmpty) {
        return RefreshIndicator(
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
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '📚',
                        style: TextStyle(fontSize: 64),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'No Books Available Yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Check back soon for new study materials!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          await controller.loadEbooks();
          await controller.loadPurchasedBooks();
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.ebooks.length,
          itemBuilder: (context, index) {
            final ebook = controller.ebooks[index];
            final isPurchased = controller.purchasedBooks[ebook.id] ?? false;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
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
                      "${AppConfig.studentImageBaseUrl}${ebook.thumbnail}",
                      width: 100,
                      height: 130,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 100,
                        height: 130,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.menu_book,
                          size: 40,
                          color: Colors.grey,
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
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ebook.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "₹${ebook.price}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (isPurchased) {
                                    Get.to(() => EbookReaderScreen(ebook: ebook));
                                  } else {
                                    BuyEbookController.instance.selectedBook.value = ebook;
                                    BuyEbookController.instance.startPayment();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isPurchased ? Colors.green : AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  isPurchased ? "Read" : "Buy Now",
                                  style: const TextStyle(color: Colors.white),
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
