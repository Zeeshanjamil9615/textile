import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/textile_importers/buyer_model.dart';
import 'package:textile/widgets/dummy.dart';
import 'package:textile/views/drawer/garment_socks_knitted/filter_section.dart';
import 'package:textile/api_service/api_service.dart';

class GarmentSocksKnittedController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  final selectedCountry = 'All'.obs;
  final selectedProductCategory = 'All'.obs;
  final selectedBuyerRanking = 'All'.obs;
  final importerNameFilter = ''.obs;
  final entriesPerPage = 50.obs;
  
  final buyers = <BuyerModel>[].obs;
  final filteredBuyers = <BuyerModel>[].obs;
  final countries = <String>[].obs;
  final productCategories = <String>[].obs;
  final buyerRankings = <String>[].obs;
  
  final isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadData();
  }
  
  Future<void> loadData() async {
    buyers.value = DummyData.getBuyers().cast<BuyerModel>();
    buyerRankings.value = DummyData.getBuyerRankings();
    await Future.wait([fetchCountries(), fetchProductCategories()]);
    applyFilters();
  }

  Future<void> fetchCountries() async {
    try {
      isLoading.value = true;
      final apiService = ApiService();
      final response = await apiService.getCountriesList();
      if (response.status == 200 && response.data != null) {
        countries.value = response.data!;
      } else {
        countries.value = ['All'];
      }
    } catch (_) {
      countries.value = ['All'];
    } finally {
      if (!countries.contains('All')) {
        countries.insert(0, 'All');
      }
      if (!countries.contains(selectedCountry.value)) {
        selectedCountry.value = 'All';
      }
      isLoading.value = false;
    }
  }

  Future<void> fetchProductCategories() async {
    try {
      isLoading.value = true;
      final apiService = ApiService();
      final response = await apiService.getProductCategoriesList();
      if (response.status == 200 && response.data != null) {
        productCategories.value = response.data!;
      } else {
        productCategories.value = ['All'];
      }
    } catch (_) {
      productCategories.value = ['All'];
    } finally {
      if (!productCategories.contains('All')) {
        productCategories.insert(0, 'All');
      }
      if (!productCategories.contains(selectedProductCategory.value)) {
        selectedProductCategory.value = 'All';
      }
      isLoading.value = false;
    }
  }
  
  void applyFilters() {
    filteredBuyers.value = buyers.where((buyer) {
      bool matchesCountry =
          selectedCountry.value == 'All' || buyer.country == selectedCountry.value;
      bool matchesCategory = selectedProductCategory.value == 'All' || 
                            buyer.productCategory.contains(selectedProductCategory.value);
      bool matchesName = importerNameFilter.value.isEmpty || 
                        buyer.importerName.toLowerCase().contains(importerNameFilter.value.toLowerCase());
      return matchesCountry && matchesCategory && matchesName;
    }).toList();
    
    if (selectedBuyerRanking.value == 'High To Low') {
      filteredBuyers.sort((a, b) => b.buyersWorth.compareTo(a.buyersWorth));
    } else if (selectedBuyerRanking.value == 'Low to High') {
      filteredBuyers.sort((a, b) => a.buyersWorth.compareTo(b.buyersWorth));
    }
  }
  
  void updateCountryFilter(String? value) {
    if (value != null) {
      selectedCountry.value = value;
      applyFilters();
    }
  }
  
  void updateProductCategoryFilter(String? value) {
    if (value != null) {
      selectedProductCategory.value = value;
      applyFilters();
    }
  }
  
  void updateBuyerRankingFilter(String? value) {
    if (value != null) {
      selectedBuyerRanking.value = value;
      applyFilters();
    }
  }
  
  void updateImporterNameFilter(String value) {
    importerNameFilter.value = value;
    applyFilters();
  }
  
  void updateEntriesPerPage(int? value) {
    if (value != null) {
      entriesPerPage.value = value;
    }
  }
  
  void clearCountryFilter() {
    Get.snackbar('Info', 'Filter cleared');
  }
  
  void addBuyer(String buyerId) {
    Get.snackbar('Success', 'Buyer ' + buyerId + ' added', backgroundColor: Colors.green, colorText: Colors.white);
  }

  void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.95,
        // minChildSize: 0.5,
        // maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: const FilterSection(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}