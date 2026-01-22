import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/textile_importers/buyer_model.dart';
import 'package:textile/views/drawer/garment_socks_knitted/filter_section.dart';
import 'package:textile/api_service/api_service.dart';
import 'package:textile/models/product_category_model.dart';

class GarmentSocksKnittedController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  final selectedCountry = 'All'.obs;
  final selectedProductCategory = 'All'.obs;
  final selectedProductCategoryId = 'All'.obs; // Store the ID for API
  final selectedBuyerRanking = 'All'.obs;
  final importerNameFilter = ''.obs;
  final entriesPerPage = 50.obs;
  
  final buyers = <BuyerModel>[].obs;
  final filteredBuyers = <BuyerModel>[].obs;
  final countries = <String>[].obs;
  final productCategories = <String>[].obs;
  final productCategoriesWithIds = <ProductCategoryModel>[].obs;
  final buyerRankings = <String>[].obs;
  
  final isLoading = false.obs;
  final isFilterSheetOpen = false.obs;
  final hasLoadedData = false.obs; // Track if data has been loaded at least once
  
  @override
  void onInit() {
    super.onInit();
    loadData();
  }
  
  Future<void> loadData() async {
    buyerRankings.value = ['All', 'High To Low', 'Low to High'];
    await Future.wait([fetchCountries(), fetchProductCategories()]);
  }
  
  // Method to open filter sheet if data hasn't been loaded yet
  void openFilterSheetIfNeeded(BuildContext context) {
    if (!hasLoadedData.value && !isFilterSheetOpen.value) {
      showFilterBottomSheet(context);
    }
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
      final response = await apiService.getProductCategoriesListWithIds();
      if (response.status == 200 && response.data != null) {
        productCategoriesWithIds.value = response.data!;
        // Also populate the string list for dropdown display
        productCategories.value = response.data!
            .map((category) => category.name)
            .toList();
        productCategories.insert(0, 'All');
      } else {
        productCategories.value = ['All'];
        productCategoriesWithIds.value = [];
      }
    } catch (_) {
      productCategories.value = ['All'];
      productCategoriesWithIds.value = [];
    } finally {
      if (!productCategories.contains('All')) {
        productCategories.insert(0, 'All');
      }
      if (!productCategories.contains(selectedProductCategory.value)) {
        selectedProductCategory.value = 'All';
        selectedProductCategoryId.value = 'All';
      }
      isLoading.value = false;
    }
  }
  
  Future<void> fetchGarmentSocksKnittedData() async {
    try {
      isLoading.value = true;
      
      // Get the category ID - if "All" is selected, use "All", otherwise get the ID
      String pctId = 'All';
      if (selectedProductCategory.value != 'All') {
        final category = productCategoriesWithIds.firstWhere(
          (cat) => cat.name == selectedProductCategory.value,
          orElse: () => ProductCategoryModel(id: 'All', name: 'All', condition: ''),
        );
        pctId = category.id;
      }

      // Get country - if "All" is selected, we might need to handle it differently
      // Based on the API, it seems country is required, so we'll pass the selected country
      String country = selectedCountry.value == 'All' ? '' : selectedCountry.value;

      final apiService = ApiService();
      final response = await apiService.getGarmentSocksKnittedData(
        country: country,
        filterPct: pctId,
        filterBuyer: selectedBuyerRanking.value,
      );

      if (response.status == 200 && response.data != null) {
        // Map API response to BuyerModel
        buyers.value = response.data!.data.map((garmentData) {
          return BuyerModel(
            id: garmentData.id,
            importerName: garmentData.importerName,
            country: garmentData.country,
            productCategory: garmentData.pctCode,
            ranking: selectedBuyerRanking.value,
            buyersWorth: garmentData.totalValue,
          );
        }).toList();
        
        // Apply local filters (like search and sorting)
        applyFilters();
        
        // Mark that data has been loaded
        hasLoadedData.value = true;
        
        Get.snackbar(
          'Success',
          'Loaded ${buyers.length} records',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          response.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load data: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    filteredBuyers.value = buyers.where((buyer) {
      bool matchesName = importerNameFilter.value.isEmpty || 
                        buyer.importerName.toLowerCase().contains(importerNameFilter.value.toLowerCase());
      return matchesName;
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
      // Update the ID as well
      if (value == 'All') {
        selectedProductCategoryId.value = 'All';
      } else {
        final category = productCategoriesWithIds.firstWhere(
          (cat) => cat.name == value,
          orElse: () => ProductCategoryModel(id: 'All', name: 'All', condition: ''),
        );
        selectedProductCategoryId.value = category.id;
      }
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
    isFilterSheetOpen.value = true;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.95,
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
                      onPressed: () {
                        isFilterSheetOpen.value = false;
                        Navigator.pop(context);
                      },
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
    ).then((_) {
      isFilterSheetOpen.value = false;
    });
  }
  
  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}