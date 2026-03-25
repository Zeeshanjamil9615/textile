import 'dart:convert';
import 'package:dio/dio.dart';
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
      final dio = Dio();

      final data = json.encode({
        'csgender': 'Male',
        'csfname': firstNameController.text.trim(),
        'cslname': lastNameController.text.trim(),
        'csemail': emailController.text.trim(),
        'csphno': cellController.text.trim(),
        'cscompany': companyNameController.text.trim(),
        'cscountry': selectedCountry.value,
        'csadd': officeAddressController.text.trim(),
        'cscity': cityController.text.trim(),
        'csntn': ntnController.text.trim(),
        'csdesignation': designationController.text.trim(),
      });

      final response = await dio.request(
        'https://textileanalytics.pk/api/registerRequest',
        options: Options(
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = Map<String, dynamic>.from(
              response.data as Map<dynamic, dynamic>);
        } else {
          throw Exception('Unexpected response format');
        }

        final statusCode = responseData['status'] as int? ?? 0;
        final message = responseData['message'] as String? ?? '';
        final dataJson = responseData['data'] as Map<String, dynamic>?;
        final registrationStatus = dataJson?['status'] as String? ?? '';

        Get.snackbar(
          'Register ($statusCode)',
          registrationStatus.isNotEmpty
              ? '$message\nStatus: $registrationStatus'
              : message,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Error',
          response.statusMessage ?? 'Registration failed',
          snackPosition: SnackPosition.TOP,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        try {
          final data = e.response?.data;
          if (data is Map && data['message'] != null) {
            errorMessage = data['message'] as String;
          } else {
            errorMessage = 'Server error occurred';
          }
        } catch (_) {
          errorMessage = 'Server error occurred';
        }
      } else if (e.type == DioExceptionType.cancel) {
        errorMessage = 'Request cancelled';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
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

