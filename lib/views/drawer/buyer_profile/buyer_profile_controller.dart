import 'package:get/get.dart';
import 'package:textile/api_service/api_service.dart';
import 'package:textile/api_service/local_storage_service.dart';
import 'package:textile/models/buyer_details_response.dart';
import 'package:textile/models/seller_details_model.dart';

class BuyerProfileController extends GetxController {
  final String buyerName;

  BuyerProfileController({required this.buyerName});

  final isLoading = true.obs;
  final details = Rxn<BuyerDetailsResponse>();
  final sellerDetails = Rxn<SellerDetails>();
  final errorMessage = ''.obs;

  static const String _sellerExportingCode = '7xaz4';

  @override
  void onInit() {
    super.onInit();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    isLoading.value = true;
    errorMessage.value = '';
    details.value = null;
    sellerDetails.value = null;

    final user = await LocalStorageService.getUserData();
    final importing = user?.id ?? '';
    final apiService = ApiService();

    bool buyerOk = false;
    try {
      final buyerResponse = await apiService.getBuyerDetails(
        buyer: buyerName,
        importing: importing,
        blatlong: '',
      );
      print('Buyer details API full response: $buyerResponse');
      print('Buyer details API data: ${buyerResponse.data}');
      if (buyerResponse.status == 200 && buyerResponse.data != null) {
        details.value = buyerResponse.data;
        buyerOk = true;
      }
    } catch (_) {
      buyerOk = false;
    }

    if (buyerOk) {
      isLoading.value = false;
      return;
    }

    bool sellerOk = false;
    try {
      final sellerResponse = await apiService.getSellerDetails(
        seller: buyerName.trim(),
        exporting: _sellerExportingCode,
        blatlong: '',
      );
      print('Seller details API full response: $sellerResponse');
      print('Seller details API data: ${sellerResponse.data}');
      if (sellerResponse.status == 200 && sellerResponse.data != null) {
        sellerDetails.value = sellerResponse.data;
        sellerOk = true;
      }
    } catch (_) {
      sellerOk = false;
    }

    if (!sellerOk) {
      details.value = null;
      sellerDetails.value = null;
      errorMessage.value = 'Data not found';
    }







    isLoading.value = false;
  }
}
