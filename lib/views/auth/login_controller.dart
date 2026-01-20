import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/api_service/api_service.dart';
import 'package:textile/api_service/local_storage_service.dart';
import 'package:textile/views/drawer/dashboard/dashboard.dart';
import 'package:textile/widgets/custom_snackbar.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  // API Service instance
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    // Pre-fill email for testing (remove in production)
    emailController.text = 'hhq_797@hotmail.com';
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    // Validate inputs first
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      CustomSnackbar.error('Please fill all fields', title: 'Validation Error');
      return;
    }

    isLoading.value = true;

    try {
      // Call login API
      final response = await _apiService.login(
        username: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      isLoading.value = false;

      // Check if login was successful
      if (response.isSuccess && response.data != null) {
        // Save user data to local storage
        final saved = await LocalStorageService.saveUserData(response.data!);

        if (saved) {
          // Show success message
          CustomSnackbar.success(response.message, title: 'Welcome');

          // Navigate to Dashboard screen after successful login
          Get.offAll(() => const Dashboard());
        } else {
          CustomSnackbar.error(
            'Failed to save user data',
            title: 'Storage Error',
          );
        }
      } else {
        // Show error message from API
        CustomSnackbar.error(response.message, title: 'Login Failed');
      }
    } catch (e) {
      isLoading.value = false;
      CustomSnackbar.error(
        'An unexpected error occurred. Please try again.',
        title: 'Error',
      );
    }
  }

  void forgotPassword() {
    CustomSnackbar.info(
      'Password reset link will be sent to your email',
      title: 'Forgot Password',
    );
  }

  void socialLogin(String platform) {
    CustomSnackbar.info(
      'Login with $platform is coming soon',
      title: 'Social Login',
    );
  }
}
