import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class Utils {
  static bool _isShowing = false;

  // ====================== LOADING DIALOG ======================

  static void showLoading({String message = "Please wait..."}) {
    if (_isShowing) return;
    _isShowing = true;

    Get.dialog(
      PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    strokeWidth: 3.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hide() {
    if (!_isShowing) return;
    _isShowing = false;

    try {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    } catch (e) {
      // Ignore
    }
  }

  // ====================== ULTRA-STYLISH FLOATING SNACKBAR ======================

  static void showSnackBar({
    required String title,
    required String message,
    required Color color,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    try {
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }

      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: AppColors.textDark,
        titleText: Text(
          title,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        messageText: Text(
          message,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.grey.shade700,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderRadius: 16,
        borderWidth: 1.5,
        borderColor: color.withValues(alpha: 0.3),
        boxShadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        icon: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon ?? Icons.notifications_active_rounded,
            color: color,
            size: 20,
          ),
        ),
        duration: duration,
        forwardAnimationCurve: Curves.easeOutBack,
        reverseAnimationCurve: Curves.easeIn,
      );
    } catch (e) {
      debugPrint("Snackbar error: $e");
    }
  }

  // ====================== HELPER METHODS ======================

  static void showSuccess(
    String message, {
    String title = "Success 🎉",
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      title: title,
      message: message,
      color: const Color(0xFF10B981), // Mint Green
      icon: Icons.check_circle_rounded,
      duration: duration,
    );
  }

  static void showError(
    String message, {
    String title = "Error 😅",
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      title: title,
      message: message,
      color: const Color(0xFFFF5252), // Red
      icon: Icons.error_rounded,
      duration: duration,
    );
  }

  static void showInfo(
    String message, {
    String title = "Info ℹ️",
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      title: title,
      message: message,
      color: const Color(0xFF3B82F6), // Blue
      icon: Icons.info_rounded,
      duration: duration,
    );
  }

  static void showWarning(
    String message, {
    String title = "Warning ⚠️",
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      title: title,
      message: message,
      color: const Color(0xFFF59E0B), // Gold
      icon: Icons.warning_rounded,
      duration: duration,
    );
  }

  // Backward compatibility method
  static void show({
    required String message,
    bool isError = false,
    bool isSuccess = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (isError) {
      showError(message, duration: duration);
    } else if (isSuccess) {
      showSuccess(message, duration: duration);
    } else {
      showInfo(message, duration: duration);
    }
  }

  // ====================== DIALOG METHODS ======================

  static Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = "Yes",
    String cancelText = "No",
    Color confirmColor = AppColors.primary,
  }) async {
    try {
      return await Get.dialog<bool>(
        AlertDialog(
          title: Text(title, style: AppTextStyles.h3),
          content: Text(message, style: AppTextStyles.bodyMedium),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text(cancelText, style: AppTextStyles.labelMedium),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(confirmText, style: AppTextStyles.button),
            ),
          ],
        ),
      );
    } catch (e) {
      return false;
    }
  }

  // ====================== UTILITY & FORMATTING ======================

  static bool isShowingDialog() {
    return Get.isDialogOpen ?? false;
  }

  static bool isShowingSnackbar() {
    return Get.isSnackbarOpen;
  }

  static void dismissAll() {
    try {
      hide();
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
    } catch (e) {
      // Ignore
    }
  }

  static String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  static String formatCurrency(double amount) {
    return "₹${amount.toStringAsFixed(2)}";
  }
}
