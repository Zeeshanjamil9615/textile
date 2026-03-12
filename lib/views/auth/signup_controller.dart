import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/api_service/api_service.dart';

class SignupController extends GetxController {
  // Personal details
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final cellController = TextEditingController();
  final designationController = TextEditingController();

  // Company details
  final companyNameController = TextEditingController();
  final ntnController = TextEditingController();
  final officeAddressController = TextEditingController();
  final cityController = TextEditingController();

  // Country dropdown
  final countries = <String>[].obs;
  final selectedCountry = ''.obs;

  // Loading states
  final isLoadingCountries = false.obs;
  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    try {
      isLoadingCountries.value = true;
      final apiService = ApiService();
      final response = await apiService.getCountriesList();
      if (response.status == 200 && response.data != null) {
        // Remove "All" option for signup form if present
        final list = response.data!
            .where((country) => country.toLowerCase() != 'all')
            .toList();
        countries.assignAll(list);
      } else {
        countries.assignAll([]);
      }
    } catch (_) {
      countries.assignAll([]);
    } finally {
      isLoadingCountries.value = false;
    }
  }

  Future<void> submit() async {
    if (isSubmitting.value) return;

    // Basic validation for required fields
    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        cellController.text.trim().isEmpty ||
        companyNameController.text.trim().isEmpty ||
        cityController.text.trim().isEmpty ||
        selectedCountry.value.isEmpty) {
      Get.snackbar(
        'Validation',
        'Please fill all required fields marked with *',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSubmitting.value = true;
    try {
      // TODO: Integrate real signup API when available.
      await Future.delayed(const Duration(seconds: 1));
      Get.snackbar(
        'Register',
        'Registration submitted (demo).',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    cellController.dispose();
    designationController.dispose();
    companyNameController.dispose();
    ntnController.dispose();
    officeAddressController.dispose();
    cityController.dispose();
    super.onClose();
  }
}

