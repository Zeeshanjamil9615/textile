import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Search_Exporters_by_Cities/buyer_model.dart';

class SearchExportersByCitiesController extends GetxController {
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
  
  void loadData() {
    // Load dummy city data matching the web interface
    buyers.value = [
      BuyerModel(serialNumber: 0, city: 'Beijing', numberOfBuyers: 1, country: 'CHINA'),
      BuyerModel(serialNumber: 1, city: 'AA Almere', numberOfBuyers: 1, country: 'Netherlands'),
      BuyerModel(serialNumber: 2, city: 'AL Amersfoort', numberOfBuyers: 1, country: 'Netherlands'),
      BuyerModel(serialNumber: 3, city: 'Álava', numberOfBuyers: 1, country: 'Spain'),
      BuyerModel(serialNumber: 4, city: 'Albino BG', numberOfBuyers: 1, country: 'Italy'),
      BuyerModel(serialNumber: 5, city: 'Alicante', numberOfBuyers: 1, country: 'Spain'),
      BuyerModel(serialNumber: 6, city: 'Athina', numberOfBuyers: 1, country: 'Greece'),
      BuyerModel(serialNumber: 7, city: 'Baška', numberOfBuyers: 1, country: 'Spain'),
      BuyerModel(serialNumber: 8, city: 'Biella BI', numberOfBuyers: 1, country: 'Italy'),
      BuyerModel(serialNumber: 9, city: 'Blumenau - SC', numberOfBuyers: 1, country: 'Brazil'),
      BuyerModel(serialNumber: 10, city: 'Branch, TX', numberOfBuyers: 1, country: 'United States'),
      BuyerModel(serialNumber: 11, city: 'Bulgaria', numberOfBuyers: 1, country: 'Greece'),
      BuyerModel(serialNumber: 12, city: 'London', numberOfBuyers: 3, country: 'United Kingdom'),
      BuyerModel(serialNumber: 13, city: 'Paris', numberOfBuyers: 2, country: 'France'),
      BuyerModel(serialNumber: 14, city: 'Berlin', numberOfBuyers: 1, country: 'Germany'),
      BuyerModel(serialNumber: 15, city: 'Brussels', numberOfBuyers: 5, country: 'Belgium'),
      BuyerModel(serialNumber: 16, city: 'Amsterdam', numberOfBuyers: 2, country: 'Netherlands'),
      BuyerModel(serialNumber: 17, city: 'Madrid', numberOfBuyers: 4, country: 'Spain'),
      BuyerModel(serialNumber: 18, city: 'Rome', numberOfBuyers: 2, country: 'Italy'),
      BuyerModel(serialNumber: 19, city: 'Milan', numberOfBuyers: 3, country: 'Italy'),
    ];
    
    // Extract unique countries
    countries.value = buyers.map((b) => b.country).toSet().toList()..sort();
    countries.insert(0, 'All');
    
    applyFilters();
  }
  
  void applyFilters() {
    filteredBuyers.value = buyers.where((buyer) {
      bool matchesCountry = selectedCountry.value == 'All' || 
                           buyer.country == selectedCountry.value;
      bool matchesCity = cityFilter.value.isEmpty || 
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