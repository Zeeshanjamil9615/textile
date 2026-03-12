import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Search_Exporters_by_Cities/buyer_model.dart';
import 'package:textile/api_service/api_service.dart';
import 'package:textile/models/exporter_city_wise_item.dart';

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

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final apiService = ApiService();
      final apiResponse = await apiService.exporterCityWise();

      if (apiResponse.status == 200 && apiResponse.data != null) {
        final List<ExporterCityItem> apiItems = apiResponse.data!;
        exporters.value = apiItems
            .map(
              (item) => BuyerModel(
                serialNumber: item.id,
                city: item.city,
                numberOfBuyers: item.noOfSellersCity,
                country: item.country,
              ),
            )
            .toList();
      } else {
        exporters.clear();
      }
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
    } catch (e) {
      countries.value = ['All'];
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
