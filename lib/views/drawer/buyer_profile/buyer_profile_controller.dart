import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/api_service/api_service.dart';
import 'package:textile/api_service/local_storage_service.dart';
import 'package:textile/models/buyer_details_response.dart';

class BuyerProfileController extends GetxController {
  final String buyerName;

  BuyerProfileController({required this.buyerName});

  final isLoading = true.obs;
  final details = Rxn<BuyerDetailsResponse>();
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final user = await LocalStorageService.getUserData();
      final importing = user?.id ?? '';
      final apiService = ApiService();
      final response = await apiService.getBuyerDetails(
        buyer: buyerName,
        importing: importing,
        blatlong: '',
      );
      if (response.status == 200 && response.data != null) {
        details.value = response.data!;
      } else {
        details.value = null;
        errorMessage.value = response.message.isNotEmpty ? response.message : 'Failed to load details';
      }
    } catch (e) {
      details.value = null;
      errorMessage.value = 'Failed to load: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  BuyerProfile get profile => details.value!.buyerProfile;
  BuyerWorth get worth => details.value!.buyerWorth;
  List<String> get suppliers => details.value!.suppliers;
  List<String> get productCategories => details.value!.productCategories;
  List<BuyerTransactionItem> get transactions => details.value!.transactions;
}
