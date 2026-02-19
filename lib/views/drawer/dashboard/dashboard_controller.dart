import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/api_service/api_service.dart';
import 'package:textile/models/top_product_model.dart';
import 'package:textile/views/drawer/Buyer_Product_Wise/Buyer_Product_Wise.dart';
import 'package:textile/views/drawer/Buyer_Product_Wise/Buyer_Product_Wise_controller.dart';

class DashboardController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final importerCount = 0.obs;
  final exporterCount = 0.obs;
  final topProducts = <TopProduct>[].obs;
  final isLoadingCounts = false.obs;
  final isLoadingTopProducts = false.obs;
  final isLoadingProductWise = false.obs;
  final errorMessage = ''.obs;

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();        
  }

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    await Future.wait([
      fetchImporterCount(),
      fetchExporterCount(),
      fetchTopProducts(),
    ]);
  }
 
  Future<void> fetchImporterCount() async {
    try {
      isLoadingCounts.value = true;
      final api = ApiService();
      final res = await api.getTextileImportersCount();
      if (res.status == 200 && res.data != null) {
        importerCount.value = res.data?.totalCount ?? 0;
      } else {
        errorMessage.value = res.message;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoadingCounts.value = false;
    }
  }

  Future<void> fetchExporterCount() async {
    try {
      isLoadingCounts.value = true;
      final api = ApiService();
      final res = await api.getTextileExportersCount();
      if (res.status == 200 && res.data != null) {
        exporterCount.value = res.data?.totalCount ?? 0;
      } else {
        errorMessage.value = res.message;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoadingCounts.value = false;
    }
  }

  Future<void> fetchTopProducts() async {
    try {
      isLoadingTopProducts.value = true;
      final api = ApiService();
      final res = await api.getTopProducts();
      if (res.status == 200 && res.data != null) {
        topProducts.value = res.data!;
      } else {
        errorMessage.value = res.message;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoadingTopProducts.value = false;
    }
  }

  /// Navigate to Buyer Product Wise with this product pre-selected: pass id to API,
  /// do not open filter sheet, load data for the selected product.
  Future<void> goToProductWise(TopProduct product) async {
    isLoadingProductWise.value = true;
    try {
      final ctrl = Get.put(BuyerProductWiseController());
      await ctrl.applyCategoryAndFetch(
        pctId: product.id.toString(),
        pctName: product.name,
      );
      Get.to(() => const BuyerProductWise());
    } finally {
      isLoadingProductWise.value = false;
    }
  }
}


 







 





