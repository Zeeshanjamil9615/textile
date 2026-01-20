import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/widgets/colors.dart';

enum SnackbarType { success, error, info, warning }

class CustomSnackbar {
  static void show({
    required String title,
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    Color backgroundColor;
    Color textColor = AppColors.textWhite;
    IconData icon;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = const Color(0xFF10B981); // Green
        icon = Icons.check_circle_outline;
        break;
      case SnackbarType.error:
        backgroundColor = const Color(0xFFEF4444); // Red
        icon = Icons.error_outline;
        break;
      case SnackbarType.warning:
        backgroundColor = const Color(0xFFF59E0B); // Orange
        icon = Icons.warning_amber_outlined;
        break;
      case SnackbarType.info:
      default:
        backgroundColor = const Color(0xFF3B82F6); // Blue
        icon = Icons.info_outline;
        break;
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: textColor,
      icon: Icon(icon, color: textColor),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: duration,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      boxShadows: [
        BoxShadow(
          color: backgroundColor.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Convenience methods
  static void success(String message, {String title = 'Success'}) {
    show(title: title, message: message, type: SnackbarType.success);
  }

  static void error(String message, {String title = 'Error'}) {
    show(title: title, message: message, type: SnackbarType.error);
  }

  static void warning(String message, {String title = 'Warning'}) {
    show(title: title, message: message, type: SnackbarType.warning);
  }

  static void info(String message, {String title = 'Info'}) {
    show(title: title, message: message, type: SnackbarType.info);
  }
}
