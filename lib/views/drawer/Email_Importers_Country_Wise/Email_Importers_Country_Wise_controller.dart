import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/api_service/api_service.dart';
import 'package:textile/models/importers_country_wise_response.dart';
import 'package:textile/views/drawer/Email_Importers_Country_Wise/buyer_model.dart';

class EmailImportersCountryWiseController extends GetxController {
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
    await Future.wait([fetchCountryWiseData(), fetchCountries()]);
    applyFilters();
  }

  Future<void> fetchCountryWiseData() async {
    try {
      isLoading.value = true;
      final apiService = ApiService();
      final response = await apiService.importersCountryWise();
      if (response.status == 200 && response.data != null) {
        buyers.value = response.data!
            .map((item) => BuyerModel(
                  serialNumber: item.id,
                  city: item.city,
                  numberOfBuyers: item.noOfBuyerCountry,
                  country: item.country,
                ))
            .toList();
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

  void applyFilters() {
    filteredBuyers.value = buyers.where((buyer) {
      bool matchesCountry =
          selectedCountry.value == 'All' ||
          buyer.country.toLowerCase().contains(selectedCountry.value.toLowerCase());
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
