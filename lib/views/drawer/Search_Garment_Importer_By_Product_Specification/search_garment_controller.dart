import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/api_service/api_service.dart';
import 'package:textile/models/buyers_with_description_response.dart';
import 'package:textile/views/drawer/Search_Garment_Importer_By_Product_Specification/filter_section.dart';

class SearchGarmentImporterByProductSpecificationController
    extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final selectedCountry = 'All'.obs;
  final importerNameFilter = ''.obs;
  final entriesPerPage = 50.obs;

  final buyers = <BuyerWithDescriptionItem>[].obs;
  final filteredBuyers = <BuyerWithDescriptionItem>[].obs;
  final countries = <String>[].obs;

  final isLoading = false.obs;
  final isFilterSheetOpen = false.obs;
  final hasShownInitialFilterSheet = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void openFilterSheetIfNeeded(BuildContext context) {
    if (!isFilterSheetOpen.value && !hasShownInitialFilterSheet.value) {
      hasShownInitialFilterSheet.value = true;
      showFilterBottomSheet(context);
    }
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      buyers.value = [];
      filteredBuyers.value = [];
      await fetchCountries();
      applyFilters();
    } finally {
      isLoading.value = false;
    }
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
    }
    if (!countries.contains('All')) {
      countries.insert(0, 'All');
    }
    if (!countries.contains(selectedCountry.value)) {
      selectedCountry.value = 'All';
    }
  }

  Future<void> fetchBuyersWithDescription() async {
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
      final response = await apiService.getBuyersWithDescription(
        selectedCountry.value,
      );
      if (response.status == 200 && response.data != null) {
        buyers.value = response.data!;
        applyFilters();
      } else {
        buyers.clear();
        filteredBuyers.clear();
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
      buyers.clear();
      filteredBuyers.clear();
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
    if (selectedCountry.value == 'All' || selectedCountry.value.isEmpty) {
      Get.snackbar(
        'Info',
        'Please select a country.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    Get.back(); // Close filter sheet first so loader is visible on main screen
    await fetchBuyersWithDescription();
  }

  void applyFilters() {
    filteredBuyers.value = buyers.where((item) {
      bool matchesName =
          importerNameFilter.value.isEmpty ||
          item.importer.toLowerCase().contains(
                importerNameFilter.value.toLowerCase(),
              ) ||
          item.description.toLowerCase().contains(
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

  void addBuyer(String buyerId) {
    Get.snackbar(
      'Success',
      'Buyer $buyerId added',
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
