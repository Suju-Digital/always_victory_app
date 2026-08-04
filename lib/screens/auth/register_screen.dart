import 'package:always_victory/constants/app_colors.dart';
import 'package:always_victory/controller/auth_controller.dart';
import 'package:always_victory/controller/class_controller.dart';
import 'package:always_victory/models/class_model.dart';
import 'package:always_victory/widgets/custom_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/custome_text_feild.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.appGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.person_add_alt_1,
                      size: 70,
                      color: AppColors.primary,
                    ),

                    const SizedBox(height: 15),

                    const Center(
                      child: Text(
                        "Student Registration",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    CustomTextField(
                      controller: controller.nameController,
                      hintText: "Student Name",
                      prefixIcon: Icons.person,
                    ),

                    const SizedBox(height: 15),

                    CustomTextField(
                      controller: controller.contactController,
                      hintText: "Contact Number",
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                    ),

                    const SizedBox(height: 15),


                    Obx(
                          () => CustomDropdown<ClassModel>(
                        items: ClassController.instance.classes,
                        prefixIcon: const Icon(Icons.school),
                        hint: "Select Class",
                       value: ClassController.instance.classes.contains(controller.selectedClass.value)
                              ? controller.selectedClass.value
                              : null,
                        itemText: (item) => item.className,
                        onChanged: (ClassModel? value) {
                          controller.selectedClass.value = value;
                        },
                      ),
                    ),

                    const SizedBox(height: 15),

                    CustomTextField(
                      controller: controller.emailController,
                      hintText: "Email",
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 15),

                    Obx(
                          () => CustomTextField(
                        controller: controller.registerPasswordController,
                        hintText: "Password",
                        prefixIcon: Icons.lock,
                        obscureText: controller.isPasswordHidden.value,
                        suffixIcon: IconButton(
                          onPressed: controller.togglePasswordVisibility,
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Obx(
                          () => SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.registerStudent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                              : const Text(
                            "REGISTER",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: Get.back,
                      child: const Text(
                        "Already have an account? Login",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}