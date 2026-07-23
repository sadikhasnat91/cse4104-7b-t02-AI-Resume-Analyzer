import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/message_dialogs.dart';

/// Service for displaying success, error, and info messages
class MessageService {
  /// Show success dialog
  static Future<void> showSuccess({
    required String title,
    required String message,
    VoidCallback? onConfirm,
    String confirmButtonText = 'Done',
  }) async {
    return Get.dialog(
      SuccessDialog(
        title: title,
        message: message,
        onConfirm: onConfirm,
        confirmButtonText: confirmButtonText,
      ),
      barrierDismissible: false,
    );
  }

  /// Show error dialog
  static Future<void> showError({
    required String title,
    required String message,
    VoidCallback? onRetry,
    VoidCallback? onClose,
    String retryButtonText = 'Retry',
    String closeButtonText = 'Close',
    bool showRetry = true,
  }) async {
    return Get.dialog(
      ErrorDialog(
        title: title,
        message: message,
        onRetry: onRetry,
        onClose: onClose,
        retryButtonText: retryButtonText,
        closeButtonText: closeButtonText,
        showRetry: showRetry,
      ),
      barrierDismissible: false,
    );
  }

  /// Show info dialog
  static Future<void> showInfo({
    required String title,
    required String message,
    VoidCallback? onConfirm,
    String confirmButtonText = 'OK',
    IconData icon = Icons.info_outline,
    Color iconColor = const Color(0xFF2196F3),
  }) async {
    return Get.dialog(
      InfoDialog(
        title: title,
        message: message,
        onConfirm: onConfirm,
        confirmButtonText: confirmButtonText,
        icon: icon,
        iconColor: iconColor,
      ),
      barrierDismissible: false,
    );
  }

  /// Show success snackbar (non-blocking)
  static void showSuccessSnackbar({
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message ?? '',
      backgroundColor: const Color(0xFF4CAF50),
      colorText: Colors.white,
      duration: duration,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      snackPosition: SnackPosition.TOP,
    );
  }

  /// Show error snackbar (non-blocking)
  static void showErrorSnackbar({
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message ?? '',
      backgroundColor: const Color(0xFFF44336),
      colorText: Colors.white,
      duration: duration,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      snackPosition: SnackPosition.TOP,
    );
  }

  /// Show info snackbar (non-blocking)
  static void showInfoSnackbar({
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message ?? '',
      backgroundColor: const Color(0xFF2196F3),
      colorText: Colors.white,
      duration: duration,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.info, color: Colors.white),
      snackPosition: SnackPosition.TOP,
    );
  }

  /// Show confirmation dialog
  static Future<bool?> showConfirmation({
    required String title,
    required String message,
    String confirmButtonText = 'Confirm',
    String cancelButtonText = 'Cancel',
  }) async {
    return Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelButtonText),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              confirmButtonText,
              style: const TextStyle(color: Color(0xFFFF6B6B)),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Show warning snackbar
  static void showWarningSnackbar({
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message ?? '',
      backgroundColor: const Color(0xFFFFC107),
      colorText: Colors.black87,
      duration: duration,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.warning_outlined, color: Colors.black87),
      snackPosition: SnackPosition.TOP,
    );
  }
}
