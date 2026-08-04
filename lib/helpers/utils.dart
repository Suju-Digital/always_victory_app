import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';

class Utils {
  static bool _isShowing = false;
  static bool _isSnackbarShowing = false;

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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
      // Ignore if cannot close
    }
  }

  static void show({
    required String message,
    bool isError = false,
    bool isSuccess = false,
    Duration duration = const Duration(seconds: 2),
  }) {
    try {
      // Close any existing snackbars safely
      _closeAllSnackbars();

      final color = isError
          ? AppColors.wrong
          : isSuccess
          ? AppColors.correct
          : AppColors.textDark;

      final title = isError
          ? "Error"
          : isSuccess
          ? "Success"
          : "Message";

      // Use ScaffoldMessenger as fallback if GetX snackbar fails
      final context = Get.context;
      if (context != null) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  isError ? Icons.error_outline : Icons.check_circle_outline,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        message,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: color,
            duration: duration,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      } else {
        // Fallback to GetX snackbar
        _showGetxSnackbar(title, message, color, duration);
      }
    } catch (e) {
      // Ultimate fallback - print to console
      print("Snackbar Error: $e - Message: $message");
    }
  }

  static void _showGetxSnackbar(String title, String message, Color color, Duration duration) {
    try {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: color,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: duration,
        forwardAnimationCurve: Curves.easeOut,
        reverseAnimationCurve: Curves.easeIn,
        isDismissible: true,
        mainButton: TextButton(
          onPressed: () {
            try {
              Get.closeCurrentSnackbar();
            } catch (e) {
              // Ignore
            }
          },
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } catch (e) {
      // Ignore
    }
  }

  static void _closeAllSnackbars() {
    try {
      // Try ScaffoldMessenger first
      final context = Get.context;
      if (context != null) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).clearSnackBars();
      }
    } catch (e) {
      // Ignore
    }

    try {
      // Try GetX
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
    } catch (e) {
      // Ignore
    }
  }

  // ====================== HELPER METHODS ======================

  static void showSuccess(String message, {Duration duration = const Duration(seconds: 2)}) {
    show(
      message: message,
      isSuccess: true,
      duration: duration,
    );
  }

  static void showError(String message, {Duration duration = const Duration(seconds: 3)}) {
    show(
      message: message,
      isError: true,
      duration: duration,
    );
  }

  static void showInfo(String message, {Duration duration = const Duration(seconds: 2)}) {
    show(
      message: message,
      isSuccess: false,
      isError: false,
      duration: duration,
    );
  }

  static void showWarning(String message, {Duration duration = const Duration(seconds: 3)}) {
    show(
      message: message,
      isError: true,
      duration: duration,
    );
  }

  // ====================== DIALOG METHODS ======================

  static Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = "Yes",
    String cancelText = "No",
    Color confirmColor = Colors.red,
  }) async {
    try {
      return await Get.dialog<bool>(
        AlertDialog(
          title: Text(title),
          content: Text(message),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text(cancelText),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(confirmText),
            ),
          ],
        ),
      );
    } catch (e) {
      return false;
    }
  }

  static void showCustomDialog({
    required String title,
    required String message,
    String buttonText = "OK",
    VoidCallback? onPressed,
    IconData? icon,
    Color? iconColor,
  }) {
    try {
      Get.dialog(
        AlertDialog(
          title: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: iconColor ?? Colors.blue, size: 30),
                const SizedBox(width: 12),
              ],
              Text(title),
            ],
          ),
          content: Text(message),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back();
                if (onPressed != null) onPressed();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      );
    } catch (e) {
      // Ignore
    }
  }

  // ====================== TOAST METHODS ======================

  static void showToast(String message, {Duration duration = const Duration(seconds: 2)}) {
    show(
      message: message,
      duration: duration,
    );
  }

  // ====================== LOADING WITH OVERLAY ======================

  static void showLoadingOverlay({String message = "Loading..."}) {
    if (_isShowing) return;
    _isShowing = true;

    Get.dialog(
      PopScope(
        canPop: false,
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                      strokeWidth: 4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoadingOverlay() {
    hide();
  }

  // ====================== UTILITY METHODS ======================

  static bool isShowingDialog() {
    return Get.isDialogOpen ?? false;
  }

  static bool isShowingSnackbar() {
    return Get.isSnackbarOpen;
  }

  static void dismissAll() {
    try {
      hide();
      _closeAllSnackbars();
    } catch (e) {
      // Ignore
    }
  }

  // ====================== FORMATTING METHODS ======================

  static String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  static String formatTime(DateTime date) {
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  static String formatDateTime(DateTime date) {
    return "${formatDate(date)} ${formatTime(date)}";
  }

  static String formatCurrency(double amount) {
    return "₹${amount.toStringAsFixed(2)}";
  }

  static String formatNumber(int number) {
    if (number >= 1000000) {
      return "${(number / 1000000).toStringAsFixed(1)}M";
    } else if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(1)}K";
    }
    return number.toString();
  }

  // ====================== VALIDATION METHODS ======================

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidMobile(String mobile) {
    return RegExp(r'^[0-9]{10}$').hasMatch(mobile);
  }

  static bool isValidName(String name) {
    return RegExp(r'^[a-zA-Z\s]{2,50}$').hasMatch(name);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }
}