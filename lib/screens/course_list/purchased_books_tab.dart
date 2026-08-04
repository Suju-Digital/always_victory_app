import 'package:always_victory/controller/class_controller.dart';
import 'package:always_victory/data/app_config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../controller/purchase_course/ebook_purchase.dart';
import '../../routes/app_routes.dart';
import 'ebook_reader.dart';

class PurchasedBooksTab extends StatelessWidget {
  PurchasedBooksTab({super.key});

  final ClassController controller =
      ClassController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {

      if (controller.ebooks.isEmpty) {
        return RefreshIndicator(
          onRefresh:()async {
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
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: AppColors.primary,
                        size: 80,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "No Books Found",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "Explore our library to find the perfect study material for your child!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppColors.textGrey.withOpacity(0.8),
                        ),
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
        onRefresh: controller.loadEbooks,
        child: ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: controller.ebooks.length,
          itemBuilder: (context, index) {
            final ebook = controller.ebooks[index];
            print(
                "ebook.id = ${ebook.id} | purchased = ${controller.purchasedBooks[ebook.id]}"
            );

            final isPurchased =
                controller.purchasedBooks[ebook.id] ?? false;

            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(12),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// BOOK IMAGE
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(
                            "${AppConfig.pdfThumbnailBaseUrl}${ebook.thumbnail}",
                            width: 100,
                            height: 145,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 100,
                              height: 145,
                              color: Colors.grey.shade100,
                              child: const Icon(Icons.broken_image, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: (isPurchased ? AppColors.correct : Colors.black).withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isPurchased ? Icons.lock_open_rounded : Icons.lock_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 16),

                  /// DETAILS
                  Expanded(
                    child: SizedBox(
                      height: 145,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ebook.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                              color: AppColors.textDark,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Expanded(
                            child: Text(
                              ebook.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.textGrey.withOpacity(0.8),
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Price",
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey),
                                  ),
                                  Text(
                                    "₹${ebook.price}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 42,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isPurchased
                                        ? AppColors.correct
                                        : AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (isPurchased) {
                                      Get.to(() => EbookReaderScreen(ebook: ebook));
                                    } else {
                                      BuyEbookController.instance.selectedBook.value = ebook;
                                      BuyEbookController.instance.startPayment();
                                    }
                                  },
                                  child: Text(
                                    isPurchased ? "READ" : "BUY",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12,
                                      letterSpacing: 1,
                                    ),
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