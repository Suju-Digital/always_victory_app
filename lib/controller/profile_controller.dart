import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../controller/auth_controller.dart';
import '../../helpers/debug_loger.dart';
import '../../helpers/utils.dart';
import '../../data/app_config/app_config.dart';

class ProfileController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  // Text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  // Observables
  final isLoading = false.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxString imagePath = "".obs;

  @override
  void onInit() {
    super.onInit();
    _loadStudentData();
  }

  /// Load student data from AuthController
  void _loadStudentData() {
    try {
      final student = authController.student.value;

      nameController.text = student.name ?? "";
      emailController.text = student.email ?? "";
      contactController.text = student.mobile ?? "";

      // Set image path if exists
      if (student.photo != null && student.photo!.isNotEmpty) {
        imagePath.value = "${AppConfig.studentProfileImageBaseUrl}${student.photo}";
      }

      AppLog.info("Profile data loaded: ${student.name}");
    } catch (e) {
      AppLog.error("Error loading student data: $e");
    }
  }

  /// Update profile
  Future<void> updateProfile() async {
    // Validate inputs
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final contact = contactController.text.trim();

    if (name.isEmpty) {
      Utils.showError("Please enter your name");
      return;
    }

    if (contact.isEmpty) {
      Utils.showError("Please enter your contact number");
      return;
    }

    if (contact.length < 10) {
      Utils.showError("Please enter a valid 10-digit mobile number");
      return;
    }

    if (email.isEmpty) {
      Utils.showError("Please enter your email");
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Utils.showError("Please enter a valid email address");
      return;
    }

    try {
      isLoading.value = true;
      AppLog.info("Updating profile for student: ${authController.student.value.id}");

      // Call update profile from AuthController
      await authController.updateProfile(
        name: name,
        email: email,
        mobile: contact,
        imageFile: selectedImage.value,
      );

      // Show success message - this will be handled by AuthController
      // But we can show a success message here as well
      Utils.showSuccess("Profile updated successfully! 🎉");

    } catch (e) {
      AppLog.error("Update Profile Error: $e");
      Utils.showError("Failed to update profile. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  /// Pick image from gallery
  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        final file = File(image.path);
        selectedImage.value = file;
        imagePath.value = file.path;
        AppLog.info("Image selected: ${image.name}");

        Utils.showSuccess("Image selected successfully! 📸");
      }
    } catch (e) {
      AppLog.error("Error picking image: $e");
      Utils.showError("Failed to pick image. Please try again.");
    }
  }

  /// Remove selected image
  void removeImage() {
    selectedImage.value = null;
    imagePath.value = "";
    AppLog.info("Image removed");
  }

  /// Reset form to original data
  void resetForm() {
    _loadStudentData();
    selectedImage.value = null;
    Utils.showSuccess("Form reset to original data");
  }

  /// Check if there are unsaved changes
  bool hasUnsavedChanges() {
    final student = authController.student.value;
    final nameChanged = nameController.text.trim() != (student.name ?? "");
    final emailChanged = emailController.text.trim() != (student.email ?? "");
    final contactChanged = contactController.text.trim() != (student.mobile ?? "");
    final imageChanged = selectedImage.value != null;

    return nameChanged || emailChanged || contactChanged || imageChanged;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    contactController.dispose();
    super.onClose();
  }
}