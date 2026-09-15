import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';
import '../../controller/profile_controller.dart';
import '../../helpers/utils.dart';

class EditProfileScreen extends GetView<ProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: AppTextStyles.appBarTitle.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            if (controller.hasUnsavedChanges()) {
              _showDiscardDialog(context);
            } else {
              Get.back();
            }
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.appGradient,
          ),
        ),
      ),
      body: Obx(
        () => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.paddingMD),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Profile Image Picker
              Stack(
                children: [
                  Obx(() {
                    if (controller.selectedImage.value != null) {
                      return CircleAvatar(
                        radius: 54,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: FileImage(
                          controller.selectedImage.value!,
                        ),
                      );
                    } else if (controller.imagePath.value.isNotEmpty) {
                      return CircleAvatar(
                        radius: 54,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: NetworkImage(
                          controller.imagePath.value,
                        ),
                      );
                    } else {
                      return CircleAvatar(
                        radius: 54,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: const Icon(
                          Icons.person_rounded,
                          color: AppColors.primary,
                          size: 54,
                        ),
                      );
                    }
                  }),

                  // Camera Edit Badge
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: controller.pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Form Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Personal Information", style: AppTextStyles.h4),
                    const SizedBox(height: 16),

                    // Name Field
                    TextField(
                      controller: controller.nameController,
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primary),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Email Field
                    TextField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        labelText: "Email Address",
                        prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Contact Field
                    TextField(
                      controller: controller.contactController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
                        prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.primary),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        counterText: "",
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Update Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "UPDATE PROFILE",
                          style: AppTextStyles.button,
                        ),
                ),
              ),

              const SizedBox(height: 12),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    if (controller.hasUnsavedChanges()) {
                      _showDiscardDialog(context);
                    } else {
                      Get.back();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textDark,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "CANCEL",
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showDiscardDialog(BuildContext context) {
    Utils.showConfirmDialog(
      title: "Discard Changes?",
      message: "You have unsaved changes. Are you sure you want to discard them?",
      confirmText: "Discard",
      cancelText: "Keep Editing",
      confirmColor: Colors.red,
    ).then((confirm) {
      if (confirm == true) {
        Get.back();
      }
    });
  }
}
