import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/api_service/api_service.dart';
import 'package:textile/api_service/local_storage_service.dart';
import 'package:textile/models/filtered_denim_list_response.dart';
import 'package:textile/views/drawer/search_danim/filter_section.dart';

class SearchDanimController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final selectedCountry = 'All'.obs;
  final importerNameFilter = ''.obs;
  final entriesPerPage = 50.obs;

  final denimList = <FilteredDenimListItem>[].obs;
  final filteredDenimList = <FilteredDenimListItem>[].obs;
  final countries = <String>[].obs;

  final isLoading = false.obs;
  final isFilterSheetOpen = false.obs;
  final hasShownInitialFilterSheet = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    await fetchCountries();
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

  Future<void> fetchDenimData() async {
    final user = await LocalStorageService.getUserData();
    if (user == null || user.id.isEmpty) {
      Get.snackbar(
        'Error',
        'Please log in to load data.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
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
      final response = await apiService.getFilteredDenimList(
        user.id,
        selectedCountry.value,
      );
      if (response.status == 200 && response.data != null) {
        denimList.value = response.data!;
        applyFilters();
        Get.snackbar(
          'Success',
          'Loaded ${denimList.length} records',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        denimList.clear();
        filteredDenimList.clear();
        Get.snackbar(
          'Error',
          response.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      denimList.clear();
      filteredDenimList.clear();
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
    filteredDenimList.value = denimList.where((item) {
      final matchesName = importerNameFilter.value.isEmpty ||
          item.importer
              .toLowerCase()
              .contains(importerNameFilter.value.toLowerCase());
      return matchesName;
    }).toList();
  }

  void updateCountryFilter(String? value) {
    if (value != null) {
      selectedCountry.value = value;
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
    selectedCountry.value = 'All';
    applyFilters();
  }

  /// Called from filter section Apply button: fetch data then close sheet.
  Future<void> applyFilterAndFetch(BuildContext context) async {
    if (isLoading.value) return;
    await fetchDenimData();
    if (context.mounted) {
      Navigator.pop(context);
    }
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
