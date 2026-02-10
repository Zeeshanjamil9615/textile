import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/api_service/api_service.dart';
import 'package:textile/models/product_category_model.dart';
class BuyerModel {
  final String id; // serial number
  final String exporterName;
  final String country;
  final String productCategory;
  final String address;
  final String recordFound;

  BuyerModel({
    required this.id,
    required this.exporterName,
    required this.country,
    required this.productCategory,
    required this.address,
    required this.recordFound,
  });
}

class AllSellersController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final selectedCountry = 'All'.obs;
  final selectedProductCategory = 'All'.obs;
  final selectedProductCategoryId = '0'.obs; // Store the ID for API
  final exporterNameFilter = ''.obs;
  final entriesPerPage = 50.obs;

  final exporters = <BuyerModel>[].obs;
  final filteredExporters = <BuyerModel>[].obs;
  final countries = <String>[].obs;
  final productCategories = <String>[].obs;
  final productCategoriesWithIds = <ProductCategoryModel>[].obs;
  final buyerRankings = <String>[].obs;

  final isLoading = false.obs;
  final isFilterSheetOpen = false.obs;
  final hasLoadedData = false.obs; // Track if data has been loaded at least once
  final hasShownInitialFilterSheet = false
      .obs; // Prevent auto-opening the filter sheet on every rebuild

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() async {
    buyerRankings.value = ['All'];
    await Future.wait([fetchCountries(), fetchProductCategories()]);
  }
  
  // Method to open filter sheet if data hasn't been loaded yet
  void openFilterSheetIfNeeded(BuildContext context) {
    if (!hasLoadedData.value &&
        !isFilterSheetOpen.value &&
        !hasShownInitialFilterSheet.value) {
      hasShownInitialFilterSheet.value = true;
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
    } catch (e) {
      countries.value = ['All'];
    } finally {
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
        productCategories.value =
            response.data!.map((category) => category.name).toList();
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
        selectedProductCategoryId.value = '0';
      }
      isLoading.value = false;
    }
  }

  Future<void> fetchBuyersData() async {
    try {
      isLoading.value = true;
      final apiService = ApiService();
      // If "All" country is selected, default to Pakistan as in example
      final country =
          selectedCountry.value == 'All' ? 'Pakistan' : selectedCountry.value;

      final response = await apiService.getTextileNewExporters(
        country,
        selectedProductCategoryId.value,
      );

      if (response.status == 200 && response.data != null) {
        exporters.value = response.data!.map((item) {
          return BuyerModel(
            id: item.sr.toString(),
            exporterName: item.exporter,
            country: item.country,
            productCategory: item.productCategory,
            address: item.address,
            recordFound: item.recordFound,
          );
        }).toList();
        
        // Apply local filters (like search)
        applyFilters();
        
        // Mark that data has been loaded
        hasLoadedData.value = true;
        
        Get.snackbar(
          'Success',
          'Loaded ${exporters.length} records',
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

  /// Called from the filter bottom sheet "Apply" button to trigger the API
  /// and close the sheet once data is loaded.
  Future<void> applyFilterAndFetch(BuildContext context) async {
    if (isLoading.value) return;

    await fetchBuyersData();

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  void applyFilters() {
    filteredExporters.value = exporters.where((exporter) {
      bool matchesName =
          exporterNameFilter.value.isEmpty ||
          exporter.exporterName.toLowerCase().contains(
            exporterNameFilter.value.toLowerCase(),
          );
      return matchesName;
    }).toList();
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
        selectedProductCategoryId.value = '0';
      } else {
        final category = productCategoriesWithIds.firstWhere(
          (cat) => cat.name == value,
          orElse: () => ProductCategoryModel(id: '0', name: value, condition: ''),
        );
        selectedProductCategoryId.value = category.id;
      }
    }
  }

  /// Used by dashboard/top products navigation to pre-select a category by id and fetch data.
  Future<void> applyCategoryAndFetch({
    required String pctId,
    required String pctName,
    String country = 'All',
  }) async {
    if (productCategoriesWithIds.isEmpty) {
      await fetchProductCategories();
    }

    selectedCountry.value = country;
    selectedProductCategoryId.value = pctId;

    // Try to find the name from list; fallback to provided name
    final match = productCategoriesWithIds.firstWhere(
      (c) => c.id == pctId,
      orElse: () => ProductCategoryModel(id: pctId, name: pctName, condition: ''),
    );
    selectedProductCategory.value = match.name;

    // Prevent auto-opening the filter sheet since we're programmatically applying filters
    hasShownInitialFilterSheet.value = true;

    await fetchBuyersData();
  }

  void updateBuyerRankingFilter(String? value) {
    // Ranking filter not used for this screen; keep for compatibility.
  }

  void updateExporterNameFilter(String value) {
    exporterNameFilter.value = value;
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

  void addExporter(String exporterId) {
    Get.snackbar(
      'Success',
      'Exporter $exporterId added',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
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