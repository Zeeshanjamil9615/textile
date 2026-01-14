import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Search_Importer_By_Product_Specification/buyer_model.dart';

class SearchImporterByProductSpecificationController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  final selectedCountry = 'Albania'.obs;
  final selectedProductCategory = 'Bed Linen / Bed Sheet'.obs;
  final productNameFilter = ''.obs;
  final entriesPerPage = 50.obs;
  
  final buyers = <BuyerModel>[].obs;
  final filteredBuyers = <BuyerModel>[].obs;
  final countries = <String>[].obs;
  final productCategories = <String>[].obs;
  
  final isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadData();
  }
  
  void loadData() {
    // Dummy products list to match the web UI
    buyers.value = [
      BuyerModel(
        sr: 1,
        productName: '100% COTTON STOCK JERSEY FITTED SHEET DYED (DETAIL AS PER INVOICE)',
        importerName: 'RUNIS SHPK',
        country: 'Albania',
        productCategory: 'Bed Linen / Bed Sheet',
      ),
      BuyerModel(
        sr: 2,
        productName: '100% COTTON STOCK JERSEY FITTED SHEET DYED (UNDER EFS SRO 957)',
        importerName: 'RUNIS SHPK',
        country: 'Albania',
        productCategory: 'Bed Linen / Bed Sheet',
      ),
      BuyerModel(
        sr: 3,
        productName: '100% POLYESTER JACQUARD TERRY MATTRESS COVER',
        importerName: 'FLORIDJOR KONDI',
        country: 'Albania',
        productCategory: 'Bed Spreads / Comforters / Mattress Protectors',
      ),
      BuyerModel(
        sr: 4,
        productName: '100% POLYESTER JACQUARD TERRY MATTRESS COVER WHITE',
        importerName: 'SAS HOME COLLECTION',
        country: 'Albania',
        productCategory: 'Bed Spreads / Comforters / Mattress Protectors',
      ),
      BuyerModel(
        sr: 5,
        productName: '50% COTTON 50% POLYESTER DYED FITTED SHEET SIZE 120X200 CM',
        importerName: 'Nuka Homes',
        country: 'Albania',
        productCategory: 'Bed Linen / Bed Sheet',
      ),
    ];

    countries.value = ['Albania', 'Belgium', 'UK', 'Germany', 'France'];
    productCategories.value = [
      'Bed Linen / Bed Sheet',
      'Bed Spreads / Comforters / Mattress Protectors',
      'Blankets',
      'Bags',
      'Canvas Products',
      'Curtains',
      'Cushion / Sofa / Chair Covers',
      'Cleaning Clothes',
      'Cotton Yarn Waste',
      'Fabrics',
      'Grey Yarn',
      'Kitchen Aprons / Linen',
      'Miscellaneous Products',
      'Cotton',
      'Sewing Thread',
      'Sportswear / Sports Goods',
      'Terry Products Towel / Mats / Clothes',
      'Table Cover',
      'Yarn',
    ];
    applyFilters();
  }
  
  void applyFilters() {
    filteredBuyers.value = buyers.where((buyer) {
      final matchesCountry = buyer.country == selectedCountry.value;
      final matchesCategory = buyer.productCategory == selectedProductCategory.value;
      final matchesProductName = productNameFilter.value.isEmpty ||
          buyer.productName
              .toLowerCase()
              .contains(productNameFilter.value.toLowerCase());
      return matchesCountry && matchesCategory && matchesProductName;
    }).toList();
  }
  
  void updateCountryFilter(String? value) {
    if (value != null) {
      selectedCountry.value = value;
      applyFilters();
    }
  }
  
  void updateProductCategoryFilter(String? value) {
    if (value != null) {
      selectedProductCategory.value = value;
      applyFilters();
    }
  }

  void updateProductNameFilter(String value) {
    productNameFilter.value = value;
    applyFilters();
  }
  
  void updateEntriesPerPage(int? value) {
    if (value != null) {
      entriesPerPage.value = value;
    }
  }
  
  void clearCountryFilter() {
    // Match web chip behavior: reset to defaults
    selectedCountry.value = countries.isNotEmpty ? countries.first : 'Albania';
    applyFilters();
  }
  
  void addBuyer(int sr) {
    Get.snackbar(
      'Success',
      'Added item #$sr',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
  
  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}