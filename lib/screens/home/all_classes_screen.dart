import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../controller/class_controller.dart';
import '../../controller/days_controller.dart';
import '../../helpers/utils.dart';
import '../../routes/app_routes.dart';
import '../../widgets/class_card.dart';

class AllClassesScreen extends StatelessWidget {
  const AllClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ClassController classController = Get.find<ClassController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "All Classes",
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        if (classController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (classController.classes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.school_outlined,
                  size: 60,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  "No Classes Found",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppConstants.paddingMD),
          physics: const BouncingScrollPhysics(),
          itemCount: classController.classes.length,
          itemBuilder: (context, i) {
            final c = classController.classes[i];
            final progressModel = i < classController.questionProgress.length
                ? classController.questionProgress[i]
                : null;
            final totalStudents = classController.enrollmentCounts[c.id] ?? 0;
            final isPurchased = classController.purchaseClass[c.id] ?? true;
            final isLocked = !isPurchased;

            return ClassCard(
              progress: progressModel?.percentage ?? 0,
              isHighlighted: (progressModel?.percentage ?? 0) > 0,
              data: c,
              totalEnroll: totalStudents,
              isLocked: isLocked,
              onTap: () async {
                if (isLocked) {
                  final result = await Get.toNamed(
                    AppRoutes.purchase,
                    arguments: {
                      "ClassModel": c,
                      "EnrollStudent": totalStudents,
                    },
                  );
                  if (result == true) {
                    await classController.loadClass();
                    classController.loadPurchaseClass();
                    classController.update();
                  }
                } else {
                  Utils.showLoading(message: "Loading Days...");
                  await DayController.instance.getDays(classId: c.id);
                  Utils.hide();
                  Get.toNamed(AppRoutes.days, arguments: c);
                }
              },
            );
          },
        );
      }),
    );
  }
}
