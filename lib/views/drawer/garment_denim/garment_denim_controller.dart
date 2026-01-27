import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/models/garment_denim_data_model.dart';
import 'package:textile/models/product_category_model.dart';
import 'package:textile/views/drawer/garment_denim/filter_section.dart';
import 'package:textile/api_service/api_service.dart';

class GarmentDenimController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final selectedCountry = 'All'.obs;
  final selectedProductCategory = 'All'.obs;
  final selectedProductCategoryId = ''.obs; // Store category ID
  final importerNameFilter = ''.obs;
  final entriesPerPage = 50.obs;

  final buyers = <GarmentDenimDataModel>[].obs;
  final filteredBuyers = <GarmentDenimDataModel>[].obs;
  final countries = <String>[].obs;
  final productCategories = <String>[].obs;
  final productCategoriesWithIds = <ProductCategoryModel>[].obs;

  final isLoading = false.obs;
  final totalRecords = 0.obs;
  final shouldAutoOpenFilter = true.obs; // Flag to auto-open filter on first load

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    await Future.wait([fetchCountries(), fetchProductCategories()]);
  }

  Future<void> fetchCountries() async {
    try {
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
    }
  }

  Future<void> fetchProductCategories() async {
    try {
      final apiService = ApiService();
      final response = await apiService.getProductCategoriesListWithIds();
      if (response.status == 200 && response.data != null) {
        productCategoriesWithIds.value = response.data!;
        // Create list of category names for dropdown
        productCategories.value = ['All', ...response.data!.map((cat) => cat.name).toList()];
      } else {
        productCategories.value = ['All'];
        productCategoriesWithIds.value = [];
      }
    } catch (_) {
      productCategories.value = ['All'];
      productCategoriesWithIds.value = [];
    } finally {
      if (!productCategories.contains(selectedProductCategory.value)) {
        selectedProductCategory.value = 'All';
        selectedProductCategoryId.value = '';
      }
    }
  }

  Future<void> fetchDenimData() async {
    try {
      isLoading.value = true;
      final apiService = ApiService();
      
      // Prepare filter values
      String countryFilter = selectedCountry.value == 'All' ? '' : selectedCountry.value;
      String pctFilter = selectedProductCategoryId.value;
      
      final response = await apiService.getAllFilteredDenimData(
        filterCountry: countryFilter,
        filterPct: pctFilter,
      );

      if (response.status == 200 && response.data != null) {
        buyers.value = response.data!.data;
        totalRecords.value = response.data!.totalRecords;
        applyFilters();
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to load data',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        buyers.value = [];
        filteredBuyers.value = [];
        totalRecords.value = 0;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      buyers.value = [];
      filteredBuyers.value = [];
      totalRecords.value = 0;
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    filteredBuyers.value = buyers.where((buyer) {
      bool matchesName =
          importerNameFilter.value.isEmpty ||
          buyer.importer.toLowerCase().contains(
            importerNameFilter.value.toLowerCase(),
          );
      return matchesName;
    }).toList();
  }

  void updateCountryFilter(String? value) {
    if (value != null) {
      selectedCountry.value = value;
    }
  }

  void updateProductCategoryFilter(String? value) {
    if (value != null) {
      selectedProductCategory.value = value;
      // Find and store the category ID
      if (value == 'All') {
        selectedProductCategoryId.value = '';
      } else {
        final category = productCategoriesWithIds.firstWhere(
          (cat) => cat.name == value,
          orElse: () => ProductCategoryModel(id: '', name: '', condition: ''),
        );
        selectedProductCategoryId.value = category.id;
      }
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
    selectedCountry.value = 'All';
    applyFilters();
  }

  void applyFilterAndFetch(BuildContext context) {
    Navigator.pop(context); // Close the filter bottom sheet
    fetchDenimData(); // Fetch data with selected filters
  }

  void addBuyer(String buyerId) {
    Get.snackbar(
      'Success',
      'Buyer $buyerId added',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
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
