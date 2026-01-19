import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/dashboard/dashboard.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    emailController.text = 'zainmajeed346@gmail.com';
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
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    isLoading.value = true;
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    isLoading.value = false;

    // Navigate to Dashboard screen after successful login
    Get.offAll(() => const Dashboard());
    
    // Show success message
    Get.snackbar(
      'Success',
      'Login successful!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
  
  void forgotPassword() {
    Get.snackbar(
      'Info',
      'Password reset link will be sent to your email',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void socialLogin(String platform) {
    Get.snackbar(
      'Info',
      'Login with $platform',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}