import 'package:get/get.dart';
import 'package:textile/api_service/api_service.dart';
import 'package:textile/models/brand_buyer_item.dart';

class TopBrandBuyersController extends GetxController {
  final String apiBrandValue;

  TopBrandBuyersController({required this.apiBrandValue});

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final results = <BrandBuyerItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchResults();
  }

  Future<void> fetchResults() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final api = ApiService();
      final res = await api.searchBuyersByBrand(brandName: apiBrandValue);
      if (res.status == 200) {
        results.value = res.data ?? <BrandBuyerItem>[];
      } else {
        results.clear();
        errorMessage.value = res.message;
      }
    } catch (e) {
      results.clear();
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

