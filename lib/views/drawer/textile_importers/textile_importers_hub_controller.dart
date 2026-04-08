import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/api_service/api_service.dart';
import 'package:textile/models/country_model.dart';

class TextileImportersHubController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final countries = <CountryModel>[].obs;

  final searchQuery = ''.obs;
  final selectedRegion = 'All'.obs;

  static const List<String> regionTabs = [
    'All',
    'Asia',
    'Europe',
    'Middle East',
    'North America',
    'South America',
    'Africa',
    'Oceania',
    'Other',
  ];

  @override
  void onInit() {
    super.onInit();
    loadCountries();
  }

  Future<void> loadCountries() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final api = ApiService();
      final res = await api.getCountriesWithTotals();
      if (res.status == 200 && res.data != null) {
        final list = List<CountryModel>.from(res.data!);
        list.sort((a, b) => b.totalRecords.compareTo(a.totalRecords));
        countries.assignAll(list);
      } else {
        countries.clear();
        errorMessage.value = res.message;
      }
    } catch (e) {
      countries.clear();
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void setSearch(String v) {
    searchQuery.value = v;
  }

  void setRegion(String v) {
    selectedRegion.value = v;
  }

  List<CountryModel> get filteredCountries {
    final q = searchQuery.value.trim().toLowerCase();
    final region = selectedRegion.value;

    return countries.where((c) {
      if (region != 'All') {
        if (_normRegion(c.region) != _normRegion(region)) return false;
      }
      if (q.isEmpty) return true;
      return c.country.toLowerCase().contains(q);
    }).toList();
  }

  String _normRegion(String r) {
    return r.replaceAll(RegExp(r'[\r\n]+'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}
