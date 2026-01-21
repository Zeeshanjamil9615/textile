import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Search_Exporters_by_Cities/buyer_model.dart';
import 'package:textile/widgets/dummy.dart';
import 'package:textile/views/drawer/Search_Exporters_by_Cities/filter_section.dart';
import 'package:textile/api_service/api_service.dart';

class SearchExportersByCitiesController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final selectedCountry = 'All'.obs;
  final cityFilter = ''.obs;
  final entriesPerPage = 50.obs;

  final exporters = <BuyerModel>[].obs;
  final filteredExporters = <BuyerModel>[].obs;
  final countries = <String>[].obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() async {
    // Load dummy city data
    exporters.value = [
      BuyerModel(
        serialNumber: 0,
        city: 'Beijing',
        numberOfBuyers: 1,
        country: 'CHINA',
      ),
      BuyerModel(
        serialNumber: 1,
        city: 'London',
        numberOfBuyers: 3,
        country: 'United Kingdom',
      ),
      BuyerModel(
        serialNumber: 2,
        city: 'Paris',
        numberOfBuyers: 2,
        country: 'France',
      ),
      BuyerModel(
        serialNumber: 3,
        city: 'Berlin',
        numberOfBuyers: 1,
        country: 'Germany',
      ),
      BuyerModel(
        serialNumber: 4,
        city: 'Brussels',
        numberOfBuyers: 5,
        country: 'Belgium',
      ),
    ];

    // Fetch countries from API
    await fetchCountries();
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
    } catch (e) {
      countries.value = ['All'];
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    filteredExporters.value = exporters.where((exporter) {
      bool matchesCountry =
          selectedCountry.value == 'All' ||
          exporter.country == selectedCountry.value;
      bool matchesCity =
          cityFilter.value.isEmpty ||
          exporter.city.toLowerCase().contains(cityFilter.value.toLowerCase());
      return matchesCountry && matchesCity;
    }).toList();
  }

  void updateCountryFilter(String? value) {
    if (value != null) {
      selectedCountry.value = value;
      applyFilters();
    }
  }

  void updateCityFilter(String value) {
    cityFilter.value = value;
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

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}
