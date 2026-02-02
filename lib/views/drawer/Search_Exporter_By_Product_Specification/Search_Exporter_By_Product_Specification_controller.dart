import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/api_service/api_service.dart';
import 'package:textile/models/cyf_products_response.dart';
import 'package:textile/models/product_category_model.dart';
import 'package:textile/views/drawer/Search_Exporter_By_Product_Specification/buyer_model.dart';
import 'package:textile/views/drawer/Search_Exporter_By_Product_Specification/filter_section.dart';

class SearchExporterByProductSpecificationController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final selectedCountry = 'All'.obs;
  final selectedProductCategory = 'All'.obs;
  final selectedProductCategoryId = '0'.obs;
  final exporterNameFilter = ''.obs;
  final entriesPerPage = 50.obs;

  final exporters = <BuyerModel>[].obs;
  final filteredExporters = <BuyerModel>[].obs;
  final countries = <String>[].obs;
  final productCategories = <String>[].obs;
  final productCategoriesWithIds = <ProductCategoryModel>[].obs;

  final isLoading = false.obs;
  final isFilterSheetOpen = false.obs;
  final hasShownInitialFilterSheet = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    await Future.wait([fetchCountries(), fetchProductCategories()]);
    applyFilters();
  }

  void openFilterSheetIfNeeded(BuildContext context) {
    if (!isFilterSheetOpen.value && !hasShownInitialFilterSheet.value) {
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
        productCategories.value = response.data!.map((c) => c.name).toList();
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

  Future<void> fetchCyfData() async {
    if (selectedCountry.value == 'All' || selectedCountry.value.isEmpty) {
      Get.snackbar(
        'Info',
        'Please select a country.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    try {
      isLoading.value = true;
      final apiService = ApiService();
      final response = await apiService.getCyfProducts(
        selectedProductCategoryId.value,
        selectedCountry.value,
      );
      if (response.status == 200 && response.data != null) {
        exporters.value = response.data!
            .map((item) => BuyerModel(
                  sr: item.sr,
                  productName: item.productName,
                  importerName: item.exporter,
                  country: item.country,
                  productCategory: selectedProductCategory.value,
                ))
            .toList();
        applyFilters();
      } else {
        exporters.clear();
        filteredExporters.clear();
        if (response.message.isNotEmpty) {
          Get.snackbar(
            'Error',
            response.message,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      exporters.clear();
      filteredExporters.clear();
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

  Future<void> applyFilterAndFetch() async {
    await fetchCyfData();
    Get.back();
  }

  void applyFilters() {
    filteredExporters.value = exporters.where((exporter) {
      bool matchesName =
          exporterNameFilter.value.isEmpty ||
          exporter.importerName.toLowerCase().contains(
                exporterNameFilter.value.toLowerCase(),
              ) ||
          exporter.productName.toLowerCase().contains(
                exporterNameFilter.value.toLowerCase(),
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
      selectedProductCategoryId.value = (value == 'All')
          ? '0'
          : (productCategoriesWithIds
                  .where((c) => c.name == value)
                  .firstOrNull
                  ?.id ??
              '0');
    }
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
    selectedCountry.value = 'All';
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
    ).whenComplete(() {
      isFilterSheetOpen.value = false;
    });
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}
