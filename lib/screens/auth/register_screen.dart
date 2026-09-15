import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../controller/auth_controller.dart';
import '../../controller/class_controller.dart';
import '../../models/class_model.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_text_field.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            /// 1. TOP HERO GRADIENT HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 54, 24, 32),
              decoration: const BoxDecoration(
                gradient: AppColors.appGradient,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(36),
                ),
              ),
              child: Column(
                children: [
                  // Back Button & Header Icon Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: Get.back,
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.person_add_alt_1_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(width: 40), // Balance alignment
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Join Always Victory! 🚀",
                    style: AppTextStyles.h1.copyWith(
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Register for Nursery to 12th MCQ Practice",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            /// 2. FORM CONTAINER
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create Account",
                    style: AppTextStyles.h2,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Fill in your details to start daily practice tests",
                    style: AppTextStyles.bodySmall,
                  ),

                  const SizedBox(height: 24),

                  // Student Name
                  CustomTextField(
                    controller: controller.nameController,
                    hintText: "Student Full Name",
                    prefixIcon: Icons.person_outline_rounded,
                  ),

                  const SizedBox(height: 16),

                  // Contact Number
                  CustomTextField(
                    controller: controller.contactController,
                    hintText: "Contact Mobile Number",
                    prefixIcon: Icons.phone_android_rounded,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                  ),

                  const SizedBox(height: 16),

                  // Class Dropdown Selection
                  Obx(
                    () => CustomDropdown<ClassModel>(
                      items: ClassController.instance.classes,
                      prefixIcon: const Icon(
                        Icons.school_outlined,
                        color: AppColors.primary,
                      ),
                      hint: "Select Your Class / Grade",
                      value: ClassController.instance.classes
                              .contains(controller.selectedClass.value)
                          ? controller.selectedClass.value
                          : null,
                      itemText: (item) => item.className,
                      onChanged: (ClassModel? value) {
                        controller.selectedClass.value = value;
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Email
                  CustomTextField(
                    controller: controller.emailController,
                    hintText: "Email Address ",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  // Password with Eye Toggle
                  Obx(
                    () => CustomTextField(
                      controller: controller.registerPasswordController,
                      hintText: "Account Password",
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: controller.isRegisterPasswordHidden.value,
                      suffixIcon: IconButton(
                        onPressed:
                            controller.toggleRegisterPasswordVisibility,
                        icon: Icon(
                          controller.isRegisterPasswordHidden.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Submit Register Button
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.registerStudent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "REGISTER NOW",
                                    style: AppTextStyles.button,
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.rocket_launch_rounded,
                                    size: 20,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Redirect to Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: AppTextStyles.bodySmall,
                      ),
                      TextButton(
                        onPressed: Get.back,
                        child: Text(
                          "Login Here",
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.primary,
                          ),
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
    );
  }
}
