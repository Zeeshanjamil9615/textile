import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/widgets/custom_snackbar.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> sendMyPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      CustomSnackbar.error('Please enter your email address', title: 'Validation Error');
      return;
    }

    isLoading.value = true;
    try {
      // Placeholder until backend endpoint is available.
      await Future.delayed(const Duration(milliseconds: 700));

      CustomSnackbar.success(
        'If this email exists, we will send reset instructions shortly.',
        title: 'Request Sent',
      );
      Get.back();
    } catch (_) {
      CustomSnackbar.error(
        'An unexpected error occurred. Please try again.',
        title: 'Error',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void cancel() {
    Get.back();
  }
}

