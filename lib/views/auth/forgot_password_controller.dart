import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/api_service/api_service.dart';
import 'package:textile/widgets/custom_snackbar.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;
  final ApiService _apiService = ApiService();

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
      final res = await _apiService.forgotPassword(email: email);
      if (res.status == 200) {
        CustomSnackbar.success(res.message, title: 'Success');
        await Future.delayed(const Duration(milliseconds: 600));
        Get.back();
      } else {
        CustomSnackbar.error(res.message, title: 'Failed');
      }
    } catch (e) {
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

