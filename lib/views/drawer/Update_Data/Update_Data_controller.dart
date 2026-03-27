import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Update_Data/buyer_model.dart';
import 'package:textile/api_service/api_service.dart';

class UpdateDataController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final selectedCountry = 'All'.obs;
  final cityFilter = ''.obs;
  final entriesPerPage = 50.obs;

  final buyers = <BuyerModel>[].obs;
  final filteredBuyers = <BuyerModel>[].obs;
  final countries = <String>[].obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    await fetchCountryStats();
  }

  Future<void> fetchCountryStats() async {
    try {
      isLoading.value = true;
      final apiService = ApiService();
      final response = await apiService.getCountryStats();

      if (response.status == 200 && response.data != null) {
        buyers.value = response.data!
            .asMap()
            .entries
            .map(
              (entry) => BuyerModel(
                serialNumber: entry.key + 1,
                city: entry.value.city,
                numberOfBuyers: entry.value.totalBuyers,
                country: entry.value.country,
              ),
            )
            .toList();
        final uniqueCountries = buyers
            .map((b) => b.country)
            .where((c) => c.trim().isNotEmpty)
            .toSet()
            .toList()
          ..sort();
        countries.value = ['All', ...uniqueCountries];
      } else {
        buyers.clear();
        countries.value = ['All'];
      }
    } catch (e) {
      buyers.clear();
      countries.value = ['All'];
    } finally {
      isLoading.value = false;
      applyFilters();
    }
  }

  void applyFilters() {
    filteredBuyers.value = buyers.where((buyer) {
      bool matchesCountry =
          selectedCountry.value == 'All' ||
          buyer.country == selectedCountry.value;
      bool matchesCity =
          cityFilter.value.isEmpty ||
          buyer.city.toLowerCase().contains(cityFilter.value.toLowerCase());
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
